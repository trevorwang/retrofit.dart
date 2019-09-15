import 'dart:ffi';
import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dio/dio.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tuple/tuple.dart';

import 'package:retrofit/retrofit.dart' as retrofit;

class RetrofitGenerator extends GeneratorForAnnotation<retrofit.RestApi> {
  static const String _baseUrlVar = 'baseUrl';
  static const _queryParamsVar = "queryParameters";
  static const _optionsVar = "options";
  static const _dataVar = "data";
  static const _localDataVar = "_data";
  static const _dioVar = "_dio";
  static const _extraVar = 'extra';
  static const _localExtraVar = '_extra';
  static const _contentType = 'contentType';
  static const _resultVar = "_result";
  static const _cancelToken = "cancelToken";
  static const _onSendProgress = "onSendProgress";
  static const _onReceiveProgress = "onReceiveProgress";

  var _customBaseUrl = false;

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.displayName;
      throw new InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the [RestApi] annotation from `$name`.',
      );
    }
    return _implementClass(element, annotation);
  }

  String _implementClass(ClassElement element, ConstantReader annotation) {
    final className = element.name;
    final name = '_$className';
    final baseUrl = annotation?.peek(_baseUrlVar)?.stringValue ?? '';
    _customBaseUrl = _isValidBaseUrl(baseUrl);
    final classBuilder = new Class((c) {
      c
        ..name = name
        ..fields.addAll([
          _buildDioFiled(),
          if (_customBaseUrl) _buildBaseUrlFiled(baseUrl),
        ])
        ..constructors.addAll([_generateConstructor()])
        ..methods.addAll(_parseMethods(element))
        ..implements = ListBuilder([refer(className)]);
    });

    final emitter = new DartEmitter();
    return new DartFormatter().format('${classBuilder.accept(emitter)}');
  }

  Field _buildDioFiled() => Field((m) => m
    ..name = _dioVar
    ..type = refer("Dio")
    ..modifier = FieldModifier.final$);

  Field _buildBaseUrlFiled(String url) => Field((m) => m
    ..name = _baseUrlVar
    ..type = refer("String")
    ..assignment = (literal(url)).code
    ..modifier = FieldModifier.final$);

  bool _isValidBaseUrl(String baseUrl) => baseUrl != null && baseUrl.isNotEmpty;

  Constructor _generateConstructor() => Constructor((c) {
        c.requiredParameters.add(Parameter((p) => p
          ..name = _dioVar
          ..toThis = true));

        final block = [
          Code("ArgumentError.checkNotNull($_dioVar,'$_dioVar');"),
        ];

        c.body = Block.of(block);
      });

  Iterable<Method> _parseMethods(ClassElement element) =>
      element.methods.where((MethodElement m) {
        final methodAnnot = _getMethodAnnotation(m);
        return methodAnnot != null &&
            m.isAbstract &&
            m.returnType.isDartAsyncFuture;
      }).map((m) => _generateMethod(m));

  final _methodsAnnotations = const [
    retrofit.GET,
    retrofit.POST,
    retrofit.DELETE,
    retrofit.PUT,
    retrofit.PATCH,
    retrofit.Method
  ];

  TypeChecker _typeChecker(Type type) => new TypeChecker.fromRuntime(type);
  ConstantReader _getMethodAnnotation(MethodElement method) {
    for (final type in _methodsAnnotations) {
      final annot = _typeChecker(type)
          .firstAnnotationOf(method, throwOnUnresolved: false);
      if (annot != null) return new ConstantReader(annot);
    }
    return null;
  }

  ConstantReader _getHeadersAnnotation(MethodElement method) {
    final annot = _typeChecker(retrofit.Headers)
        .firstAnnotationOf(method, throwOnUnresolved: false);
    if (annot != null) return new ConstantReader(annot);
    return null;
  }

  ConstantReader _getFormUrlEncodedAnnotation(MethodElement method) {
    final annotation = _typeChecker(retrofit.FormUrlEncoded)
        .firstAnnotationOf(method, throwOnUnresolved: false);
    if (annotation != null) return new ConstantReader(annotation);
    return null;
  }

  Map<ParameterElement, ConstantReader> _getAnnotations(
      MethodElement m, Type type) {
    var annot = <ParameterElement, ConstantReader>{};
    for (final p in m.parameters) {
      final a = _typeChecker(type).firstAnnotationOf(p);
      if (a != null) {
        annot[p] = new ConstantReader(a);
      }
    }
    return annot;
  }

  Tuple2<ParameterElement, ConstantReader> _getAnnotation(
      MethodElement m, Type type) {
    for (final p in m.parameters) {
      final a = _typeChecker(type).firstAnnotationOf(p);
      if (a != null) {
        return Tuple2(p, ConstantReader(a));
      }
    }
    return null;
  }

  List<DartType> _genericListOf(DartType type) {
    return type is ParameterizedType && type.typeArguments.isNotEmpty
        ? type.typeArguments
        : null;
  }

  DartType _genericOf(DartType type) {
    return type is InterfaceType && type.typeArguments.isNotEmpty
        ? type.typeArguments.first
        : null;
  }

  DartType _getResponseType(DartType type) {
    return _genericOf(type);
  }

  /// get types for `Map<String, List<User>>`, `A<B,C,D>`
  List<DartType> _getResponseInnerTypes(DartType type) {
    final genericList = _genericListOf(type);
    return genericList;
  }

  DartType _getResponseInnerType(DartType type) {
    final generic = _genericOf(type);

    if (generic == null ||
        _typeChecker(Map).isExactlyType(type) ||
        _typeChecker(BuiltMap).isExactlyType(type)) return type;

    if (generic.isDynamic) return null;

    if (_typeChecker(List).isExactlyType(type) ||
        _typeChecker(BuiltList).isExactlyType(type)) return generic;

    return _getResponseInnerType(generic);
  }

  Method _generateMethod(MethodElement m) {
    final httpMehod = _getMethodAnnotation(m);

    return Method((mm) {
      mm
        ..name = m.displayName
        ..modifier = MethodModifier.async
        ..annotations = ListBuilder([CodeExpression(Code('override'))]);

      /// required parameters
      mm.requiredParameters.addAll(m.parameters
          .where((it) => it.isRequiredPositional || it.isRequiredNamed)
          .map((it) => Parameter((p) => p
            ..name = it.name
            ..named = it.isNamed)));

      /// optional positional or named parameters
      mm.optionalParameters.addAll(m.parameters.where((i) => i.isOptional).map(
          (it) => Parameter((p) => p
            ..name = it.name
            ..named = it.isNamed
            ..defaultTo = it.defaultValueCode == null
                ? null
                : Code(it.defaultValueCode))));
      mm.body = _generateRequest(m, httpMehod);
    });
  }

  Expression _generatePath(MethodElement m, ConstantReader method) {
    final paths = _getAnnotations(m, retrofit.Path);
    String definePath = method.peek("path").stringValue;
    paths.forEach((k, v) {
      final value = v.peek("value")?.stringValue ?? k.displayName;
      definePath = definePath.replaceFirst("{$value}", "\$${k.displayName}");
    });
    return literal(definePath);
  }

  Code _generateRequest(MethodElement m, ConstantReader httpMehod) {
    final path = _generatePath(m, httpMehod);
    final blocks = <Code>[];

    for (var parameter in m.parameters.where((p) =>
        p.isRequiredNamed ||
        p.isRequiredPositional ||
        // TODO: remove this after requried syntax is available https://github.com/dart-lang/language/issues/15
        // ignore: deprecated_member_use
        p.isRequired ||
        p.metadata.firstWhere((meta) => meta.isRequired, orElse: () => null) !=
            null)) {
      blocks.add(Code(
          "ArgumentError.checkNotNull(${parameter.displayName},'${parameter.displayName}');"));
    }

    _generateExtra(m, blocks, _localExtraVar);

    _generateQueries(m, blocks, _queryParamsVar);
    Map<Expression, Expression> headers = _generateHeaders(m);
    _generateRequestBody(blocks, _localDataVar, m);

    final extraOptions = {
      "method": literal(httpMehod.peek("method").stringValue),
      "headers": literalMap(headers, refer("String"), refer("dynamic")),
      _extraVar: refer(_localExtraVar),
    };
    final contentType = _getFormUrlEncodedAnnotation(m);
    if (contentType != null) {
      final lll = literal(contentType.peek("mime").stringValue);
      extraOptions[_contentType] = refer("ContentType.parse").call([lll]);
    }
    if (_customBaseUrl) {
      extraOptions[_baseUrlVar] = refer(_baseUrlVar);
    }

    final options = refer("RequestOptions").newInstance([], extraOptions);

    final namedArguments = <String, Expression>{};
    namedArguments[_queryParamsVar] = refer(_queryParamsVar);
    namedArguments[_optionsVar] = options;
    namedArguments[_dataVar] = refer(_localDataVar);

    final cancelToken = _getAnnotation(m, retrofit.CancelRequest);
    if (cancelToken != null)
      namedArguments[_cancelToken] = refer(cancelToken.item1.displayName);

    final sendProgress = _getAnnotation(m, retrofit.SendProgress);
    if (sendProgress != null)
      namedArguments[_onSendProgress] = refer(sendProgress.item1.displayName);

    final receiveProgress = _getAnnotation(m, retrofit.ReceiveProgress);
    if (receiveProgress != null)
      namedArguments[_onReceiveProgress] =
          refer(receiveProgress.item1.displayName);

    final returnType = _getResponseType(m.returnType);

    /// If autoCastResponse is false, return the response as it is
    if (!(httpMehod.peek('autoCastResponse')?.boolValue ?? false)) {
      blocks.add(
        refer("$_dioVar.request")
            .call([path], namedArguments)
            .returned
            .statement,
      );
      return Block.of(blocks);
    }

    if (returnType == null || "void" == returnType.toString()) {
      blocks.add(
        refer("await $_dioVar.request")
            .call([path], namedArguments)
            .assignFinal(_resultVar, refer("Response<void>"))
            .statement,
      );

      blocks.add(Code("return Future.value(null);"));
    } else {
      final innerReturnType = _getResponseInnerType(returnType);
      if (_typeChecker(List).isExactlyType(returnType) ||
          _typeChecker(BuiltList).isExactlyType(returnType)) {
        if (_isBasicType(innerReturnType)) {
          blocks.add(
            refer("await $_dioVar.request")
                .call([path], namedArguments)
                .assignFinal(_resultVar, refer("Response<List<dynamic>>"))
                .statement,
          );
          blocks.add(
              Code("final value = $_resultVar.data.cast<$innerReturnType>();"));
        } else {
          blocks.add(
            refer("await $_dioVar.request")
                .call([path], namedArguments)
                .assignFinal(_resultVar, refer("Response<List<dynamic>>"))
                .statement,
          );
          blocks.add(Code(
              "var value = $_resultVar.data.map((dynamic i) => $innerReturnType.fromJson(i as Map<String,dynamic>)).toList();"));
        }
      } else if (_typeChecker(Map).isExactlyType(returnType) ||
          _typeChecker(BuiltMap).isExactlyType(returnType)) {
        final types = _getResponseInnerTypes(returnType);
        blocks.add(
          refer("await $_dioVar.request")
              .call([path], namedArguments)
              .assignFinal(_resultVar, refer("Response<Map<String,dynamic>>"))
              .statement,
        );

        /// assume the first type is a basic type
        if (types.length > 1) {
          final secondType = types[1];
          if (_typeChecker(List).isExactlyType(secondType) ||
              _typeChecker(BuiltList).isExactlyType(secondType)) {
            final type = _getResponseType(secondType);
            blocks.add(Code("""
            var value = $_resultVar.data
              .map((k, dynamic v) =>
                MapEntry(
                  k, (v as List)
                    .map((i) => $type.fromJson(i as Map<String,dynamic>))
                    .toList()
                )
              );
            """));
          } else if (!_isBasicType(secondType)) {
            blocks.add(Code("""
            var value = $_resultVar.data
              .map((k, dynamic v) =>
                MapEntry(k, $secondType.fromJson(v as Map<String, dynamic>))
              );
            """));
          }
        } else {
          blocks.add(Code("final value = $_resultVar.data;"));
        }
      } else {
        if (_isBasicType(returnType)) {
          blocks.add(
            refer("await $_dioVar.request")
                .call([path], namedArguments)
                .assignFinal(_resultVar, refer("Response<$returnType>"))
                .statement,
          );
          blocks.add(Code("final value = $_resultVar.data;"));
        } else {
          blocks.add(
            refer("await $_dioVar.request")
                .call([path], namedArguments)
                .assignFinal(_resultVar, refer("Response<Map<String,dynamic>>"))
                .statement,
          );
          blocks.add(
              Code("final value = $returnType.fromJson($_resultVar.data);"));
        }
      }
      blocks.add(Code("return Future.value(value);"));
    }

    return Block.of(blocks);
  }

  bool _isBasicType(DartType returnType) {
    return _typeChecker(String).isExactlyType(returnType) ||
        _typeChecker(bool).isExactlyType(returnType) ||
        _typeChecker(int).isExactlyType(returnType) ||
        _typeChecker(double).isExactlyType(returnType) ||
        _typeChecker(Double).isExactlyType(returnType) ||
        _typeChecker(Float).isExactlyType(returnType);
  }

  void _generateQueries(
      MethodElement m, List<Code> blocks, String _queryParamsVar) {
    final queries = _getAnnotations(m, retrofit.Query);
    final queryParameters = queries.map((p, ConstantReader r) {
      final value = r.peek("value")?.stringValue ?? p.displayName;
      return MapEntry(literal(value), refer(p.displayName));
    });

    final queryMap = _getAnnotations(m, retrofit.Queries);
    blocks.add(literalMap(queryParameters, refer("String"), refer("dynamic"))
        .assignFinal(_queryParamsVar)
        .statement);
    if (queryMap.isNotEmpty) {
      blocks.add(refer('$_queryParamsVar.addAll').call(
        [refer("${queryMap.keys.first.displayName} ?? <String,dynamic>{}")],
      ).statement);
    }
  }

  void _generateRequestBody(
      List<Code> blocks, String _dataVar, MethodElement m) {
    final _bodyName = _getAnnotation(m, retrofit.Body)?.item1;
    if (_bodyName != null) {
      if (TypeChecker.fromRuntime(Map).isAssignableFromType(_bodyName.type)) {
        blocks.add(literalMap({}, refer("String"), refer("dynamic"))
            .assignFinal(_dataVar)
            .statement);

        blocks.add(refer("$_dataVar.addAll").call([
          refer("${_bodyName.displayName} ?? <String,dynamic>{}")
        ]).statement);
      } else if (_bodyName.type.element is ClassElement) {
        final ele = _bodyName.type.element as ClassElement;
        final toJson = ele.methods
            .firstWhere((i) => i.displayName == "toJson", orElse: () => null);
        if (toJson == null) {
          log.warning(
              "${_bodyName.type} must provide a `toJson()` method which return a Map.\n"
              "It is programmer's responsibility to make sure the ${_bodyName.type} is properly serialized");
          blocks.add(
              refer(_bodyName.displayName).assignFinal(_dataVar).statement);
        } else {
          blocks.add(literalMap({}, refer("String"), refer("dynamic"))
              .assignFinal(_dataVar)
              .statement);
          blocks.add(refer("$_dataVar.addAll").call([
            refer("${_bodyName.displayName}.toJson() ?? <String,dynamic>{}")
          ]).statement);
        }
      } else {
        /// @Body annotations with no type are assinged as is
        blocks
            .add(refer(_bodyName.displayName).assignFinal(_dataVar).statement);
      }

      return;
    }

    final fields = _getAnnotations(m, retrofit.Field).map((p, r) {
      final fieldName = r.peek("value")?.stringValue ?? p.displayName;

      final isFileField = _typeChecker(File).isAssignableFromType(p.type);
      final fileName = r.peek("fileName")?.stringValue != null
          ? literalString(r.peek("fileName")?.stringValue)
          : refer(p.displayName)
              .property('path.split(Platform.pathSeparator).last');

      final uploadFileInfo = refer('$UploadFileInfo')
          .newInstance([refer(p.displayName), fileName]);

      return MapEntry(literal(fieldName),
          isFileField ? uploadFileInfo : refer(p.displayName));
    });
    if (fields.isNotEmpty) {
      blocks.add(refer("FormData.from")
          .call([literalMap(fields, refer("String"), refer("dynamic"))])
          .assignFinal(_dataVar)
          .statement);
      return;
    }

    /// There is no body
    blocks.add(literalMap({}, refer("String"), refer("dynamic"))
        .assignFinal(_dataVar)
        .statement);
  }

  Map<Expression, Expression> _generateHeaders(MethodElement m) {
    final anno = _getHeadersAnnotation(m);
    final headersMap = anno?.peek("value")?.mapValue ?? {};
    final headers = headersMap.map((k, v) {
      return MapEntry(literal(k.toStringValue()), literal(v.toStringValue()));
    });

    final annosInParam = _getAnnotations(m, retrofit.Header);
    final headersInParams = annosInParam.map((k, v) {
      final value = v.peek("value")?.stringValue ?? k.displayName;
      return MapEntry(literal(value), refer(k.displayName));
    });
    headers.addAll(headersInParams);
    return headers;
  }

  void _generateExtra(
      MethodElement m, List<Code> blocks, String localExtraVar) {
    final extra = _typeChecker(retrofit.Extra)
        .firstAnnotationOf(m, throwOnUnresolved: false);

    if (extra != null) {
      final c = ConstantReader(extra);
      blocks.add(literalMap(
        c.peek('data')?.mapValue?.map((k, v) {
              return MapEntry(
                k.toStringValue() ??
                    (throw InvalidGenerationSourceError(
                      'Invalid key for extra Map, only `String` keys are supported',
                      element: m,
                      todo: 'Make sure all keys are of string type',
                    )),
                v.toBoolValue() ??
                    v.toDoubleValue() ??
                    v.toIntValue() ??
                    v.toStringValue() ??
                    v.toListValue() ??
                    v.toMapValue() ??
                    v.toSetValue() ??
                    v.toSymbolValue() ??
                    v.toTypeValue() ??
                    Code(revivedLiteral(v)),
              );
            }) ??
            {},
        refer('String'),
        refer('dynamic'),
      ).assignConst(localExtraVar).statement);
    } else {
      blocks.add(literalMap(
        {},
        refer('String'),
        refer('dynamic'),
      ).assignConst(localExtraVar).statement);
    }
  }
}

Builder generatorFactoryBuilder({String header}) =>
    new SharedPartBuilder([new RetrofitGenerator()], "retrofit");

/// Returns `$revived($args $kwargs)`, this won't have ending semi-colon (`;`).
/// [object] must not be null.
/// [object] is assumed to be a constant.
String revivedLiteral(
  Object object, {
  DartEmitter dartEmitter,
}) {
  dartEmitter ??= DartEmitter();

  ArgumentError.checkNotNull(object, 'object');

  Revivable revived;
  if (object is Revivable) {
    revived = object;
  }
  if (object is DartObject) {
    revived = ConstantReader(object).revive();
  }
  if (object is ConstantReader) {
    revived = object.revive();
  }
  if (revived == null) {
    throw ArgumentError.value(object, 'object',
        'Only `Revivable`, `DartObject`, `ConstantReader` are supported values');
  }

  String instantiation = '';
  final location = revived.source.toString().split('#');

  /// If this is a class instantiation then `location[1]` will be populated
  /// with the class name
  if (location.length > 1) {
    instantiation = location[1] +
        (revived.accessor.isNotEmpty ? '.${revived.accessor}' : '');
  } else {
    /// Getters, Setters, Methods can't be declared as constants so this
    /// literal must either be a top-level constant or a static constant and
    /// can be directly accessed by `revived.accessor`
    return revived.accessor;
  }

  final args = StringBuffer();
  final kwargs = StringBuffer();
  Spec objectToSpec(DartObject object) {
    final constant = ConstantReader(object);
    if (constant.isNull) {
      return literalNull;
    }

    if (constant.isBool) {
      return literal(constant.boolValue);
    }

    if (constant.isDouble) {
      return literal(constant.doubleValue);
    }

    if (constant.isInt) {
      return literal(constant.intValue);
    }

    if (constant.isString) {
      return literal(constant.stringValue);
    }

    if (constant.isList) {
      return literalList(constant.listValue.map(objectToSpec));
      // return literal(constant.listValue);
    }

    if (constant.isMap) {
      return literalMap(Map.fromIterables(
          constant.mapValue.keys.map(objectToSpec),
          constant.mapValue.values.map(objectToSpec)));
      // return literal(constant.mapValue);
    }

    if (constant.isSymbol) {
      return Code('Symbol(${constant.symbolValue.toString()})');
      // return literal(constant.symbolValue);
    }

    if (constant.isNull) {
      return literalNull;
    }

    if (constant.isType) {
      return refer(constant.typeValue.name);
    }

    if (constant.isLiteral) {
      return literal(constant.literalValue);
    }

    /// Perhaps an object instantiation?
    /// In that case, try initializing it and remove `const` to reduce noise
    final revived = revivedLiteral(constant.revive(), dartEmitter: dartEmitter)
        .replaceFirst('const ', '');
    return Code(revived);
  }

  for (var arg in revived.positionalArguments) {
    final literalValue = objectToSpec(arg);

    args.write('${literalValue.accept(dartEmitter)},');
  }

  for (var arg in revived.namedArguments.keys) {
    final literalValue = objectToSpec(revived.namedArguments[arg]);

    kwargs.write('$arg:${literalValue.accept(dartEmitter)},');
  }

  return '$instantiation($args $kwargs)';
}
