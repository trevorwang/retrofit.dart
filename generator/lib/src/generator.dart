import 'package:dio/src/form_data.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tuple/tuple.dart';

import 'package:retrofit/http.dart' as http;

class RetrofitGenerator extends GeneratorForAnnotation<http.RestApi> {
  static const String _baseUrlVar = 'baseUrl';
  static const _queryParamsVar = "queryParameters";
  static const _optionsVar = "options";
  static const _dataVar = "data";
  static const _dioVar = "_dio";

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

    final classBuilder = new Class((c) {
      c
        ..name = name
        ..fields.add(_buildDefinitionTypeMethod(className))
        ..constructors.addAll([_generateConstructor(baseUrl)])
        ..methods.addAll(_parseMethods(element))
        ..extend = refer(className);
    });

    final emitter = new DartEmitter();
    return new DartFormatter().format('${classBuilder.accept(emitter)}');
  }

  Field _buildDefinitionTypeMethod(String superType) => Field((m) => m
    ..name = _dioVar
    ..type = refer("Dio"));

  Constructor _generateConstructor(String baseUrl) => Constructor((c) {
        c.optionalParameters.add(Parameter((p) => p
          ..name = "dio"
          ..type = refer("Dio")));
        c.body = Block.of([
          refer(_dioVar).assign(refer("dio")).statement,
          Code("if ($_dioVar == null) {"),
          refer(_dioVar).assign(refer("Dio").newInstance([])).statement,
          Code("}"),
          literal(baseUrl).assignFinal(_baseUrlVar).statement,
          Code("if ($_baseUrlVar != null && $_baseUrlVar.isNotEmpty) {"),
          refer("$_dioVar.options.baseUrl")
              .assign(refer(_baseUrlVar))
              .statement,
          Code("}"),
        ]);
      });

  Iterable<Method> _parseMethods(ClassElement element) =>
      element.methods.where((MethodElement m) {
        final methodAnnot = _getMethodAnnotation(m);
        return methodAnnot != null &&
            m.isAbstract &&
            m.returnType.isDartAsyncFuture;
      }).map((m) => _generateMethod(m));

  final _methodsAnnotations = const [
    http.GET,
    http.POST,
    http.DELETE,
    http.PUT,
    http.PATCH,
    http.Method
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
    final annot = _typeChecker(http.Headers)
        .firstAnnotationOf(method, throwOnUnresolved: false);
    if (annot != null) return new ConstantReader(annot);
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

  Method _generateMethod(MethodElement m) {
    final httpMehod = _getMethodAnnotation(m);

    return Method((mm) {
      mm
        ..name = m.displayName
        ..modifier = MethodModifier.async
        ..returns = refer(m.returnType.displayName);

      /// required parameters
      mm.requiredParameters.addAll(m.parameters
          .where((it) => it.isNotOptional)
          .map((it) => Parameter((p) => p
            ..name = it.name
            ..type = Reference(it.type.displayName))));

      /// optional & positional parameters
      mm.optionalParameters.addAll(m.parameters
          .where((i) => i.isOptionalPositional)
          .map((it) => Parameter((p) => p
            ..name = it.name
            ..type = Reference(it.type.displayName)
            ..defaultTo = Code(it.defaultValueCode))));

      /// named parameters
      mm.optionalParameters.addAll(
          m.parameters.where((i) => i.isNamed).map((it) => Parameter((p) => p
            ..named = true
            ..name = it.name
            ..type = Reference(it.type.displayName)
            ..defaultTo = Code(it.defaultValueCode))));

      mm.body = _generateRequest(m, httpMehod);
    });
  }

  Expression _generatePath(MethodElement m, ConstantReader method) {
    final paths = _getAnnotations(m, http.Path);
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
    _generateQueries(m, blocks, _queryParamsVar);
    Map<Expression, Expression> headers = _generateHeaders(m);
    _generateRequestBody(blocks, _dataVar, m);

    final options = refer("RequestOptions").newInstance([], {
      "method": literal(httpMehod.peek("method").stringValue),
      "headers": literalMap(headers)
    });
    final namedArguments = <String, Expression>{};
    namedArguments[_queryParamsVar] = refer(_queryParamsVar);
    namedArguments[_optionsVar] = options;
    namedArguments[_dataVar] = refer(_dataVar);

    final responseType = _getResponseType(m.returnType);
    final responseInnerType =
        _getResponseInnerType(m.returnType) ?? responseType;
    final typeArguments = <Reference>[];
    if (responseInnerType != null) {
      typeArguments.add(refer(responseInnerType.displayName));
    }
    blocks.add(
      refer("$_dioVar.request")
          .call([path], namedArguments, typeArguments)
          .returned
          .statement,
    );

    return Block.of(blocks);
  }

  void _generateQueries(
      MethodElement m, List<Code> blocks, String _queryParamsVar) {
    final queries = _getAnnotations(m, http.Query);
    final queryParameters = queries.map((p, ConstantReader r) {
      final value = r.peek("value")?.stringValue ?? p.displayName;
      return MapEntry(literal(value), refer(p.displayName));
    });

    final queryMap = _getAnnotations(m, http.QueryMap);
    blocks.add(literalMap(queryParameters, refer("String"), refer("dynamic"))
        .assignFinal(_queryParamsVar)
        .statement);
    if (queryMap.isNotEmpty) {
      blocks.add(refer('$_queryParamsVar.addAll').call(
        [refer("${queryMap.keys.first.displayName} ?? {}")],
      ).statement);
    }
  }

  void _generateRequestBody(
      List<Code> blocks, String _dataVar, MethodElement m) {
    final _bodyName = _getAnnotation(m, http.Body)?.item1?.displayName;
    if (_bodyName != null) {
      if (_bodyName is FormData) {
        blocks.add(refer("$_bodyName")
          .assignFinal(_dataVar)
          .statement);
      } else {
        blocks.add(literalMap({}, refer("String"), refer("dynamic"))
          .assignFinal(_dataVar)
          .statement);

        blocks.add(refer("$_dataVar.addAll")
            .call([refer("$_bodyName ?? {}")]).statement);
      }
    } else {
      blocks.add(literalMap({}, refer("String"), refer("dynamic"))
        .assignFinal(_dataVar)
        .statement);
    }

    final fields = _getAnnotations(m, http.Field).map((p, r) {
      final value = r.peek("value")?.stringValue ?? p.displayName;
      return MapEntry(literal(value), refer(p.displayName));
    });
    if (fields.isNotEmpty) {
      blocks
          .add(refer("$_dataVar.addAll").call([literalMap(fields)]).statement);
    }
  }

  Map<Expression, Expression> _generateHeaders(MethodElement m) {
    final anno = _getHeadersAnnotation(m);
    final headersMap = anno?.peek("value")?.mapValue ?? {};
    final headers = headersMap.map((k, v) {
      return MapEntry(literal(k.toStringValue()), literal(v.toStringValue()));
    });

    final annosInParam = _getAnnotations(m, http.Header);
    final headersInParams = annosInParam.map((k, v) {
      final value = v.peek("value")?.stringValue ?? k.displayName;
      return MapEntry(literal(value), refer(k.displayName));
    });
    headers.addAll(headersInParams);
    return headers;
  }

  DartType _genericOf(DartType type) {
    return type is InterfaceType && type.typeArguments.isNotEmpty
        ? type.typeArguments.first
        : null;
  }

  DartType _getResponseType(DartType type) {
    return _genericOf(_genericOf(type));
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
}

Builder generatorFactoryBuilder({String header}) =>
    new PartBuilder([new RetrofitGenerator()], ".retrofit.dart",
        header: header);
