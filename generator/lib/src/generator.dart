import 'dart:ffi';
import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import 'package:source_gen/source_gen.dart';
import 'package:tuple/tuple.dart';

const _analyzerIgnores =
    '// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers';

class RetrofitOptions {
  RetrofitOptions({this.autoCastResponse});

  RetrofitOptions.fromOptions([BuilderOptions? options])
      : autoCastResponse =
            (options?.config['auto_cast_response']?.toString() ?? 'true') ==
                'true';

  final bool? autoCastResponse;
}

class RetrofitGenerator extends GeneratorForAnnotation<retrofit.RestApi> {
  RetrofitGenerator(this.globalOptions);

  final RetrofitOptions globalOptions;

  static const String _baseUrlVar = 'baseUrl';
  static const _queryParamsVar = 'queryParameters';
  static const _localHeadersVar = '_headers';
  static const _headersVar = 'headers';
  static const _dataVar = 'data';
  static const _localDataVar = '_data';
  static const _dioVar = '_dio';
  static const _extraVar = 'extra';
  static const _localExtraVar = '_extra';
  static const _contentType = 'contentType';
  static const _resultVar = '_result';
  static const _cancelToken = 'cancelToken';
  static const _onSendProgress = 'onSendProgress';
  static const _onReceiveProgress = 'onReceiveProgress';
  static const _path = 'path';
  static const _valueVar = 'value';
  bool hasCustomOptions = false;

  /// Global options specified in the `build.yaml`

  /// Annotation details for [retrofit.RestApi]
  late retrofit.RestApi clientAnnotation;

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      final name = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the [RestApi] annotation from `$name`.',
      );
    }
    return _implementClass(element, annotation);
  }

  String _implementClass(ClassElement element, ConstantReader? annotation) {
    final className = element.name;
    final enumString = annotation?.peek('parser')?.revive().accessor;
    final parser = retrofit.Parser.values
        .firstWhereOrNull((e) => e.toString() == enumString);
    clientAnnotation = retrofit.RestApi(
      baseUrl: annotation?.peek(_baseUrlVar)?.stringValue ?? '',
      parser: parser ?? retrofit.Parser.JsonSerializable,
    );
    final baseUrl = clientAnnotation.baseUrl;
    final annotClassConsts = element.constructors
        .where((c) => !c.isFactory && !c.isDefaultConstructor);
    final classBuilder = Class((c) {
      c
        ..name = '_$className'
        ..types.addAll(element.typeParameters.map((e) => refer(e.name)))
        ..fields.addAll([_buildDioFiled(), _buildBaseUrlFiled(baseUrl)])
        ..constructors.addAll(
          annotClassConsts.map(
            (e) => _generateConstructor(baseUrl, superClassConst: e),
          ),
        )
        ..methods.addAll(_parseMethods(element));
      if (annotClassConsts.isEmpty) {
        c.constructors.add(_generateConstructor(baseUrl));
        c.implements.add(refer(_generateTypeParameterizedName(element)));
      } else {
        c.extend = Reference(_generateTypeParameterizedName(element));
      }
      if (hasCustomOptions) {
        c.methods.add(_generateOptionsCastMethod());
      }
      c.methods.add(_generateTypeSetterMethod());
    });

    final emitter = DartEmitter(useNullSafetySyntax: true);
    return DartFormatter()
        .format([_analyzerIgnores, classBuilder.accept(emitter)].join('\n\n'));
  }

  Field _buildDioFiled() => Field(
        (m) => m
          ..name = _dioVar
          ..type = refer('Dio')
          ..modifier = FieldModifier.final$,
      );

  Field _buildBaseUrlFiled(String? url) => Field((m) {
        m
          ..name = _baseUrlVar
          ..type = refer('String?')
          ..modifier = FieldModifier.var$;
      });

  Constructor _generateConstructor(
    String? url, {
    ConstructorElement? superClassConst,
  }) =>
      Constructor((c) {
        c.requiredParameters.add(
          Parameter(
            (p) => p
              ..name = _dioVar
              ..toThis = true,
          ),
        );
        c.optionalParameters.add(
          Parameter(
            (p) => p
              ..named = true
              ..name = _baseUrlVar
              ..toThis = true,
          ),
        );
        if (superClassConst != null) {
          var superConstName = 'super';
          if (superClassConst.name.isNotEmpty) {
            superConstName += '.${superClassConst.name}';
            c.name = superClassConst.name;
          }
          final constParams = superClassConst.parameters;
          for (final element in constParams) {
            if (!element.isOptional || element.isPrivate) {
              c.requiredParameters.add(
                Parameter(
                  (p) => p
                    ..type = refer(_displayString(element.type))
                    ..name = element.name,
                ),
              );
            } else {
              c.optionalParameters.add(
                Parameter(
                  (p) => p
                    ..named = element.isNamed
                    ..type = refer(_displayString(element.type))
                    ..name = element.name,
                ),
              );
            }
          }
          final paramList = constParams
              .map((e) => '${e.isNamed ? '${e.name}: ' : ''}${e.name}');
          c.initializers.add(Code('$superConstName(${paramList.join(',')})'));
        }
        final block = [
          if (url != null && url.isNotEmpty)
            Code('$_baseUrlVar ??= ${literal(url)};'),
        ];

        if (block.isNotEmpty) {
          c.body = Block.of(block);
        }
      });

  Iterable<Method> _parseMethods(ClassElement element) => <MethodElement>[
        ...element.methods,
        ...element.mixins.expand((i) => i.methods)
      ].where((m) {
        final methodAnnot = _getMethodAnnotation(m);
        return methodAnnot != null &&
            m.isAbstract &&
            (m.returnType.isDartAsyncFuture || m.returnType.isDartAsyncStream);
      }).map((m) => _generateMethod(m)!);

  String _generateTypeParameterizedName(TypeParameterizedElement element) =>
      element.displayName +
      (element.typeParameters.isNotEmpty
          ? '<${element.typeParameters.join(',')}>'
          : '');

  final _methodsAnnotations = const [
    retrofit.GET,
    retrofit.POST,
    retrofit.DELETE,
    retrofit.PUT,
    retrofit.PATCH,
    retrofit.HEAD,
    retrofit.OPTIONS,
    retrofit.Method,
  ];

  TypeChecker _typeChecker(Type type) => TypeChecker.fromRuntime(type);

  ConstantReader? _getMethodAnnotation(MethodElement method) {
    for (final type in _methodsAnnotations) {
      final annot = _getMethodAnnotationByType(method, type);
      if (annot != null) {
        return annot;
      }
    }
    return null;
  }

  ConstantReader? _getMethodAnnotationByType(MethodElement method, Type type) {
    final annot =
        _typeChecker(type).firstAnnotationOf(method, throwOnUnresolved: false);
    if (annot != null) {
      return ConstantReader(annot);
    }
    return null;
  }

  ConstantReader? _getCacheAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.CacheControl);

  ConstantReader? _getContentTypeAnnotation(MethodElement method) {
    final multipart = _getMultipartAnnotation(method);
    final formUrlEncoded = _getFormUrlEncodedAnnotation(method);

    if (multipart != null && formUrlEncoded != null) {
      throw InvalidGenerationSourceError(
        'Two content-type annotation on one request ${method.name}',
      );
    }

    return multipart ?? formUrlEncoded;
  }

  ConstantReader? _getMultipartAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.MultiPart);

  ConstantReader? _getFormUrlEncodedAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.FormUrlEncoded);

  ConstantReader? _getResponseTypeAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.DioResponseType);

  Iterable<ConstantReader> _getMethodAnnotations(
    MethodElement method,
    Type type,
  ) =>
      _typeChecker(type)
          .annotationsOf(method, throwOnUnresolved: false)
          .map(ConstantReader.new);

  Map<ParameterElement, ConstantReader> _getAnnotations(
    MethodElement m,
    Type type,
  ) {
    final annot = <ParameterElement, ConstantReader>{};
    for (final p in m.parameters) {
      final a = _typeChecker(type).firstAnnotationOf(p);
      if (a != null) {
        annot[p] = ConstantReader(a);
      }
    }
    return annot;
  }

  Tuple2<ParameterElement, ConstantReader>? _getAnnotation(
    MethodElement m,
    Type type,
  ) {
    for (final p in m.parameters) {
      final a = _typeChecker(type).firstAnnotationOf(p);
      if (a != null) {
        return Tuple2(p, ConstantReader(a));
      }
    }
    return null;
  }

  List<DartType>? _genericListOf(DartType type) =>
      type is ParameterizedType && type.typeArguments.isNotEmpty
          ? type.typeArguments
          : null;

  DartType? _genericOf(DartType type) =>
      type is InterfaceType && type.typeArguments.isNotEmpty
          ? type.typeArguments.first
          : null;

  DartType? _getResponseType(DartType type) => _genericOf(type);

  /// get types for `Map<String, List<User>>`, `A<B,C,D>`
  List<DartType>? _getResponseInnerTypes(DartType type) {
    final genericList = _genericListOf(type);
    return genericList;
  }

  DartType? _getResponseInnerType(DartType type) {
    final generic = _genericOf(type);
    if (generic == null ||
        _typeChecker(Map).isExactlyType(type) ||
        _typeChecker(BuiltMap).isExactlyType(type)) {
      return type;
    }

    if (generic.isDynamic) {
      return null;
    }

    if (_typeChecker(List).isExactlyType(type) ||
        _typeChecker(BuiltList).isExactlyType(type)) {
      return generic;
    }

    return _getResponseInnerType(generic);
  }

  Method? _generateMethod(MethodElement m) {
    final httpMethod = _getMethodAnnotation(m);
    if (httpMethod == null) {
      return null;
    }

    return Method((mm) {
      mm
        ..returns =
            refer(_displayString(m.type.returnType, withNullability: true))
        ..name = m.displayName
        ..types.addAll(m.typeParameters.map((e) => refer(e.name)))
        ..modifier = m.returnType.isDartAsyncFuture
            ? MethodModifier.async
            : MethodModifier.asyncStar
        ..annotations.add(const CodeExpression(Code('override')));

      /// required parameters
      mm.requiredParameters.addAll(
        m.parameters.where((it) => it.isRequiredPositional).map(
              (it) => Parameter(
                (p) => p
                  ..name = it.name
                  ..named = it.isNamed,
              ),
            ),
      );

      /// optional positional or named parameters
      mm.optionalParameters.addAll(
        m.parameters.where((i) => i.isOptional || i.isRequiredNamed).map(
              (it) => Parameter(
                (p) => p
                  ..required = (it.isNamed &&
                      it.type.nullabilitySuffix == NullabilitySuffix.none &&
                      !it.hasDefaultValue)
                  ..name = it.name
                  ..named = it.isNamed
                  ..defaultTo = it.defaultValueCode == null
                      ? null
                      : Code(it.defaultValueCode!),
              ),
            ),
      );
      mm.body = _generateRequest(m, httpMethod);
    });
  }

  Expression _generatePath(MethodElement m, ConstantReader method) {
    final paths = _getAnnotations(m, retrofit.Path);
    var definePath = method.peek('path')?.stringValue;
    paths.forEach((k, v) {
      final value = v.peek(_valueVar)?.stringValue ?? k.displayName;
      definePath = definePath?.replaceFirst(
        '{$value}',
        "\${${k.displayName}${k.type.element2?.kind == ElementKind.ENUM ? '.name' : ''}}",
      );
    });
    return literal(definePath);
  }

  Code _generateRequest(MethodElement m, ConstantReader httpMethod) {
    final returnAsyncWrapper =
        m.returnType.isDartAsyncFuture ? 'return' : 'yield';
    final path = _generatePath(m, httpMethod);
    final blocks = <Code>[];

    _generateExtra(m, blocks, _localExtraVar);

    _generateQueries(m, blocks, _queryParamsVar);
    final headers = _generateHeaders(m);
    blocks.add(
      declareFinal(_localHeadersVar)
          .assign(
            literalMap(
              headers.map((k, v) => MapEntry(literalString(k, raw: true), v)),
              refer('String'),
              refer('dynamic'),
            ),
          )
          .statement,
    );

    if (headers.isNotEmpty) {
      blocks.add(
        const Code('$_localHeadersVar.removeWhere((k, v) => v == null);'),
      );
    }

    _generateRequestBody(blocks, _localDataVar, m);

    final extraOptions = {
      'method': literal(httpMethod.peek('method')?.stringValue),
      _headersVar: refer(_localHeadersVar),
      _extraVar: refer(_localExtraVar),
    };

    final contentTypeInHeader = headers.entries
        .firstWhereOrNull(
          (i) => 'Content-Type'.toLowerCase() == i.key.toLowerCase(),
        )
        ?.value;
    if (contentTypeInHeader != null) {
      extraOptions[_contentType] = contentTypeInHeader;
    }

    final contentType = _getContentTypeAnnotation(m);
    if (contentType != null) {
      extraOptions[_contentType] =
          literal(contentType.peek('mime')?.stringValue);
    }

    extraOptions[_baseUrlVar] = refer(_baseUrlVar);

    final responseType = _getResponseTypeAnnotation(m);
    if (responseType != null) {
      final v = responseType.peek('responseType')?.objectValue;
      log.info("ResponseType  :  ${v?.getField("index")?.toIntValue()}");
      final rsType = ResponseType.values.firstWhere(
        (it) =>
            responseType
                .peek('responseType')
                ?.objectValue
                .getField('index')
                ?.toIntValue() ==
            it.index,
        orElse: () {
          log.warning('responseType cast error!!!!');
          return ResponseType.json;
        },
      );

      extraOptions['responseType'] = refer(rsType.toString());
    }
    final namedArguments = <String, Expression>{};
    namedArguments[_queryParamsVar] = refer(_queryParamsVar);
    namedArguments[_path] = path;
    namedArguments[_dataVar] = refer(_localDataVar);

    final cancelToken = _getAnnotation(m, retrofit.CancelRequest);
    if (cancelToken != null) {
      namedArguments[_cancelToken] = refer(cancelToken.item1.displayName);
    }

    final sendProgress = _getAnnotation(m, retrofit.SendProgress);
    if (sendProgress != null) {
      namedArguments[_onSendProgress] = refer(sendProgress.item1.displayName);
    }

    final receiveProgress = _getAnnotation(m, retrofit.ReceiveProgress);
    if (receiveProgress != null) {
      namedArguments[_onReceiveProgress] =
          refer(receiveProgress.item1.displayName);
    }

    final wrappedReturnType = _getResponseType(m.returnType);

    final options = _parseOptions(m, namedArguments, blocks, extraOptions);

    if (wrappedReturnType == null || 'void' == wrappedReturnType.toString()) {
      blocks.add(
        refer('await $_dioVar.fetch')
            .call([options], {}, [refer('void')]).statement,
      );
      return Block.of(blocks);
    }

    final isWrapped =
        _typeChecker(retrofit.HttpResponse).isExactlyType(wrappedReturnType);
    final returnType =
        isWrapped ? _getResponseType(wrappedReturnType) : wrappedReturnType;
    if (returnType == null || 'void' == returnType.toString()) {
      if (isWrapped) {
        blocks
          ..add(
            refer('final $_resultVar = await $_dioVar.fetch')
                .call([options], {}, [refer('void')]).statement,
          )
          ..add(
            Code('''
      final httpResponse = HttpResponse(null, $_resultVar);
      $returnAsyncWrapper httpResponse;
      '''),
          );
      } else {
        blocks.add(
          refer('await $_dioVar.fetch')
              .call([options], {}, [refer('void')]).statement,
        );
      }
    } else {
      final innerReturnType = _getResponseInnerType(returnType);
      if (_typeChecker(List).isExactlyType(returnType) ||
          _typeChecker(BuiltList).isExactlyType(returnType)) {
        if (_isBasicType(innerReturnType)) {
          blocks
            ..add(
              declareFinal(_resultVar)
                  .assign(
                    refer('await $_dioVar.fetch<List<dynamic>>')
                        .call([options]),
                  )
                  .statement,
            )
            ..add(
              declareFinal(_valueVar)
                  .assign(
                    refer('$_resultVar.data')
                        .propertyIf(
                      thisNullable: returnType.isNullable,
                      name: 'cast',
                    )
                        .call([], {}, [
                      refer(
                        _displayString(
                          innerReturnType,
                          withNullability: innerReturnType?.isNullable ?? false,
                        ),
                      )
                    ]),
                  )
                  .statement,
            );
        } else {
          blocks.add(
            declareFinal(_resultVar)
                .assign(
                  refer('await $_dioVar.fetch<List<dynamic>>').call([options]),
                )
                .statement,
          );
          if (clientAnnotation.parser == retrofit.Parser.FlutterCompute) {
            blocks.add(
              declareVar(_valueVar)
                  .assign(
                    refer('$_resultVar.data').conditionalIsNullIf(
                      thisNullable: returnType.isNullable,
                      whenFalse: refer('await compute').call([
                        refer(
                          'deserialize${_displayString(innerReturnType)}List',
                        ),
                        refer('$_resultVar.data!.cast<Map<String,dynamic>>()')
                      ]),
                    ),
                  )
                  .statement,
            );
          } else {
            final Reference mapperCode;
            switch (clientAnnotation.parser) {
              case retrofit.Parser.MapSerializable:
                mapperCode = refer(
                  '(dynamic i) => ${_displayString(innerReturnType)}.fromMap(i as Map<String,dynamic>)',
                );
                break;
              case retrofit.Parser.JsonSerializable:
                if (innerReturnType?.isNullable ?? false) {
                  mapperCode = refer(
                    '(dynamic i) => i == null ? null : ${_displayString(innerReturnType)}.fromJson(i as Map<String,dynamic>)',
                  );
                } else {
                  mapperCode = refer(
                    '(dynamic i) => ${_displayString(innerReturnType)}.fromJson(i as Map<String,dynamic>)',
                  );
                }
                break;
              case retrofit.Parser.DartJsonMapper:
                mapperCode = refer(
                  '(dynamic i) => JsonMapper.fromMap<${_displayString(innerReturnType)}>(i as Map<String,dynamic>)!',
                );
                break;
              case retrofit.Parser.FlutterCompute:
                throw Exception('Unreachable code');
            }
            blocks.add(
              declareVar(_valueVar)
                  .assign(
                    refer('$_resultVar.data')
                        .propertyIf(
                          thisNullable: returnType.isNullable,
                          name: 'map',
                        )
                        .call([mapperCode])
                        .property('toList')
                        .call([]),
                  )
                  .statement,
            );
          }
        }
      } else if (_typeChecker(Map).isExactlyType(returnType) ||
          _typeChecker(BuiltMap).isExactlyType(returnType)) {
        final types = _getResponseInnerTypes(returnType)!;
        blocks.add(
          declareFinal(_resultVar)
              .assign(
                refer('await $_dioVar.fetch<Map<String,dynamic>>')
                    .call([options]),
              )
              .statement,
        );

        /// assume the first type is a basic type
        if (types.length > 1) {
          final firstType = types[0];
          final secondType = types[1];
          if (_typeChecker(List).isExactlyType(secondType) ||
              _typeChecker(BuiltList).isExactlyType(secondType)) {
            final type = _getResponseType(secondType);
            final Reference mapperCode;
            var future = false;
            switch (clientAnnotation.parser) {
              case retrofit.Parser.MapSerializable:
                mapperCode = refer('''
            (k, dynamic v) =>
                MapEntry(
                  k, (v as List)
                    .map((i) => ${_displayString(type)}.fromMap(i as Map<String,dynamic>))
                    .toList()
                )
            ''');
                break;
              case retrofit.Parser.JsonSerializable:
                mapperCode = refer('''
            (k, dynamic v) =>
                MapEntry(
                  k, (v as List)
                    .map((i) => ${_displayString(type)}.fromJson(i as Map<String,dynamic>))
                    .toList()
                )
            ''');
                break;
              case retrofit.Parser.DartJsonMapper:
                mapperCode = refer('''
            (k, dynamic v) =>
                MapEntry(
                  k, (v as List)
                    .map((i) => JsonMapper.fromMap<${_displayString(type)}>(i as Map<String,dynamic>)!)
                    .toList()
                )
            ''');
                break;
              case retrofit.Parser.FlutterCompute:
                log.warning('''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''');
                future = true;
                mapperCode = refer('''
                (e) async => MapEntry(
                    e.key,
                    await compute(deserialize${_displayString(type)}List,
                        (e.value as List).cast<Map<String, dynamic>>()))
            ''');
                break;
            }
            if (future) {
              blocks.add(
                declareVar(_valueVar)
                    .assign(
                      refer('Map.fromEntries').call([
                        refer('await Future.wait').call([
                          refer('$_resultVar.data!.entries.map')
                              .call([mapperCode])
                        ])
                      ]),
                    )
                    .statement,
              );
            } else {
              blocks.add(
                declareVar(_valueVar)
                    .assign(
                      refer('$_resultVar.data')
                          .propertyIf(
                        thisNullable: returnType.isNullable,
                        name: 'map',
                      )
                          .call([mapperCode]),
                    )
                    .statement,
              );
            }
          } else if (!_isBasicType(secondType)) {
            final Reference mapperCode;
            var future = false;
            switch (clientAnnotation.parser) {
              case retrofit.Parser.MapSerializable:
                mapperCode = refer(
                  '(k, dynamic v) => MapEntry(k, ${_displayString(secondType)}.fromMap(v as Map<String, dynamic>))',
                );
                break;
              case retrofit.Parser.JsonSerializable:
                mapperCode = refer(
                  '(k, dynamic v) => MapEntry(k, ${_displayString(secondType)}.fromJson(v as Map<String, dynamic>))',
                );

                break;
              case retrofit.Parser.DartJsonMapper:
                mapperCode = refer(
                  '(k, dynamic v) => MapEntry(k, JsonMapper.fromMap<${_displayString(secondType)}>(v as Map<String, dynamic>)!)',
                );
                break;
              case retrofit.Parser.FlutterCompute:
                log.warning('''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''');
                future = true;
                mapperCode = refer('''
                (e) async => MapEntry(
                    e.key, await compute(deserialize${_displayString(secondType)}, e.value as Map<String, dynamic>))
            ''');
                break;
            }
            if (future) {
              blocks.add(
                declareVar(_valueVar)
                    .assign(
                      refer('$_resultVar.data').conditionalIsNullIf(
                        thisNullable: returnType.isNullable,
                        whenFalse: refer('Map.fromEntries').call([
                          refer('await Future.wait').call([
                            refer('$_resultVar.data!.entries.map')
                                .call([mapperCode])
                          ])
                        ]),
                      ),
                    )
                    .statement,
              );
            } else {
              blocks.add(
                declareVar(_valueVar)
                    .assign(
                      refer('$_resultVar.data')
                          .propertyIf(
                        thisNullable: returnType.isNullable,
                        name: 'map',
                      )
                          .call([mapperCode]),
                    )
                    .statement,
              );
            }
          } else {
            blocks.add(
              declareFinal(_valueVar)
                  .assign(
                    refer('$_resultVar.data')
                        .propertyIf(
                      thisNullable: returnType.isNullable,
                      name: 'cast',
                    )
                        .call([], {}, [
                      refer(_displayString(firstType)),
                      refer(_displayString(secondType)),
                    ]),
                  )
                  .statement,
            );
          }
        } else {
          blocks.add(const Code('final value = $_resultVar.data!;'));
        }
      } else {
        if (_isBasicType(returnType)) {
          blocks
            ..add(
              declareFinal(_resultVar)
                  .assign(
                    refer('await $_dioVar.fetch<${_displayString(returnType)}>')
                        .call([options]),
                  )
                  .statement,
            )
            ..add(
              declareFinal(_valueVar)
                  .assign(
                    refer('$_resultVar.data')
                        .asNoNullIf(returnNullable: returnType.isNullable),
                  )
                  .statement,
            );
        } else if (returnType.toString() == 'dynamic') {
          blocks
            ..add(
              declareFinal(_resultVar)
                  .assign(refer('await $_dioVar.fetch').call([options]))
                  .statement,
            )
            ..add(const Code('final value = $_resultVar.data;'));
        } else {
          final fetchType = returnType.isNullable
              ? 'Map<String,dynamic>?'
              : 'Map<String,dynamic>';
          blocks.add(
            declareFinal(_resultVar)
                .assign(
                  refer('await $_dioVar'
                          '.fetch<$fetchType>')
                      .call([options]),
                )
                .statement,
          );
          Expression mapperCode;
          switch (clientAnnotation.parser) {
            case retrofit.Parser.MapSerializable:
              mapperCode = refer(
                '${_displayString(returnType)}.fromMap($_resultVar.data!)',
              );
              break;
            case retrofit.Parser.JsonSerializable:
              final genericArgumentFactories =
                  isGenericArgumentFactories(returnType);

              final typeArgs = returnType is ParameterizedType
                  ? returnType.typeArguments
                  : <DartType>[];

              if (typeArgs.isNotEmpty && genericArgumentFactories) {
                //Remove the outermost nullable modifier
                //see NullableDynamicNullableInnerGenericTypeShouldBeCastedAsMap from generator/test/src/generator_test_src.dart:1529
                var displayString = _displayString(
                  returnType,
                  withNullability: innerReturnType?.isNullable ?? false,
                );
                displayString = displayString.endsWith('?')
                    ? displayString.substring(0, displayString.length - 1)
                    : displayString;
                mapperCode = refer(
                  '$displayString.fromJson($_resultVar.data!,${_getInnerJsonSerializableMapperFn(returnType)})',
                );
              } else {
                mapperCode = refer(
                  '${_displayString(returnType)}.fromJson($_resultVar.data!)',
                );
              }
              break;
            case retrofit.Parser.DartJsonMapper:
              mapperCode = refer(
                'JsonMapper.fromMap<${_displayString(returnType)}>($_resultVar.data!)!',
              );
              break;
            case retrofit.Parser.FlutterCompute:
              mapperCode = refer(
                'await compute(deserialize${_displayString(returnType)}, $_resultVar.data!)',
              );
              break;
          }
          blocks.add(
            declareFinal(_valueVar)
                .assign(
                  refer('$_resultVar.data').conditionalIsNullIf(
                    thisNullable: returnType.isNullable,
                    whenFalse: mapperCode,
                  ),
                )
                .statement,
          );
        }
      }
      if (isWrapped) {
        blocks.add(
          Code('''
      final httpResponse = HttpResponse(value, $_resultVar);
      $returnAsyncWrapper httpResponse;
      '''),
        );
      } else {
        blocks.add(Code('$returnAsyncWrapper value;'));
      }
    }

    return Block.of(blocks);
  }

  bool isGenericArgumentFactories(DartType? dartType) {
    final metaData = dartType?.element2?.metadata;
    if (metaData == null || dartType == null) {
      return false;
    }
    final constDartObj =
        metaData.isNotEmpty ? metaData.first.computeConstantValue() : null;
    var genericArgumentFactories = false;
    if (constDartObj != null &&
        (!_typeChecker(List).isExactlyType(dartType) &&
            !_typeChecker(BuiltList).isExactlyType(dartType))) {
      try {
        final annotation = ConstantReader(constDartObj);
        final obj = annotation.peek('genericArgumentFactories');
        // ignore: invalid_null_aware_operator
        genericArgumentFactories = obj?.boolValue ?? false;
      } catch (_) {}
    }

    return genericArgumentFactories;
  }

  String _getInnerJsonSerializableMapperFn(DartType dartType) {
    final typeArgs =
        dartType is ParameterizedType ? dartType.typeArguments : <DartType>[];
    if (typeArgs.isNotEmpty) {
      if (_typeChecker(List).isExactlyType(dartType) ||
          _typeChecker(BuiltList).isExactlyType(dartType)) {
        final genericType = _getResponseType(dartType);
        final typeArgs = genericType is ParameterizedType
            ? genericType.typeArguments
            : <DartType>[];
        String mapperVal;

        final genericTypeString = _displayString(genericType);

        if (typeArgs.isNotEmpty &&
            isGenericArgumentFactories(genericType) &&
            genericType != null) {
          mapperVal = '''
    (json)=> (json as List<dynamic>)
            .map<$genericTypeString>((i) => $genericTypeString.fromJson(
                  i as Map<String, dynamic>,${_getInnerJsonSerializableMapperFn(genericType)}
                ))
            .toList(),
    ''';
        } else {
          if (_isBasicType(genericType)) {
            mapperVal = '''
    (json)=>(json as List<dynamic>)
            .map<$genericTypeString>((i) => 
                  i as $genericTypeString
                )
            .toList(),
    ''';
          } else {
            mapperVal = """
    (json)=>(json as List<dynamic>)
            .map<$genericTypeString>((i) =>
            ${genericTypeString == 'dynamic' ? ' i as Map<String, dynamic>' : '$genericTypeString.fromJson(  i as Map<String, dynamic> )  '}
    )
            .toList(),
    """;
          }
        }
        return mapperVal;
      } else {
        var mappedVal = '';
        for (final arg in typeArgs) {
          // print(arg);
          final typeArgs =
              arg is ParameterizedType ? arg.typeArguments : <DartType>[];
          if (typeArgs.isNotEmpty) {
            if (_typeChecker(List).isExactlyType(arg) ||
                _typeChecker(BuiltList).isExactlyType(arg)) {
              mappedVal += _getInnerJsonSerializableMapperFn(arg);
            } else {
              if (isGenericArgumentFactories(arg)) {
                mappedVal +=
                    '(json)=>${_displayString(arg)}.fromJson(json as Map<String, dynamic>,${_getInnerJsonSerializableMapperFn(arg)}),';
              } else {
                mappedVal +=
                    '(json)=>${_displayString(arg)}.fromJson(json as Map<String, dynamic>),';
              }
            }
          } else {
            mappedVal += _getInnerJsonSerializableMapperFn(arg);
          }
        }
        return mappedVal;
      }
    } else {
      if (_displayString(dartType) == 'dynamic' || _isBasicType(dartType)) {
        return '(json)=>json as ${_displayString(dartType, withNullability: dartType.isNullable)},';
      } else {
        if (dartType.isNullable) {
          return '(json)=> json == null ? null : ${_displayString(dartType)}.fromJson(json as Map<String, dynamic>),';
        } else {
          return '(json)=>${_displayString(dartType)}.fromJson(json as Map<String, dynamic>),';
        }
      }
    }
  }

  String _getInnerJsonDeSerializableMapperFn(DartType dartType) {
    final typeArgs =
        dartType is ParameterizedType ? dartType.typeArguments : <DartType>[];
    if (typeArgs.isNotEmpty) {
      if (_typeChecker(List).isExactlyType(dartType) ||
          _typeChecker(BuiltList).isExactlyType(dartType)) {
        final genericType = _getResponseType(dartType);
        final typeArgs = genericType is ParameterizedType
            ? genericType.typeArguments
            : <DartType>[];
        String mapperVal;

        if (typeArgs.isNotEmpty &&
            isGenericArgumentFactories(genericType) &&
            genericType != null) {
          mapperVal =
              '(value) => value.map((value) => ${_getInnerJsonDeSerializableMapperFn(genericType)}).toList()';
        } else {
          if (_isBasicType(genericType)) {
            mapperVal = '(value) => value';
          } else {
            mapperVal =
                '(value) => value.map((value) => value.toJson()).toList()';
          }
        }
        return mapperVal;
      } else {
        var mappedVal = '';
        for (final arg in typeArgs) {
          final typeArgs =
              arg is ParameterizedType ? arg.typeArguments : <DartType>[];
          if (typeArgs.isNotEmpty) {
            if (_typeChecker(List).isExactlyType(arg) ||
                _typeChecker(BuiltList).isExactlyType(arg)) {
              mappedVal = _getInnerJsonDeSerializableMapperFn(arg);
            } else {
              if (isGenericArgumentFactories(arg)) {
                mappedVal =
                    '(value) => value.toJson(${_getInnerJsonDeSerializableMapperFn(arg)})';
              } else {
                mappedVal = '(value) => value';
              }
            }
          } else {
            mappedVal = _getInnerJsonDeSerializableMapperFn(arg);
          }
        }
        return mappedVal;
      }
    } else {
      if (_displayString(dartType) == 'dynamic' || _isBasicType(dartType)) {
        return '(value) => value';
      } else {
        return '(value) => value.toJson()';
      }
    }
  }

  Expression _parseOptions(
    MethodElement m,
    Map<String, Expression> namedArguments,
    List<Code> blocks,
    Map<String, Expression> extraOptions,
  ) {
    final annoOptions = _getAnnotation(m, retrofit.DioOptions);
    if (annoOptions == null) {
      final args = Map<String, Expression>.from(extraOptions)
        ..addAll(namedArguments);
      final path = args.remove(_path)!;
      final dataVar = args.remove(_dataVar)!;
      final queryParams = args.remove(_queryParamsVar)!;
      final baseUrl = args.remove(_baseUrlVar)!;
      final cancelToken = args.remove(_cancelToken);
      final sendProgress = args.remove(_onSendProgress);
      final receiveProgress = args.remove(_onReceiveProgress);

      final type = refer(_displayString(_getResponseType(m.returnType)));

      final composeArguments = <String, Expression>{
        _queryParamsVar: queryParams,
        _dataVar: dataVar
      };
      if (cancelToken != null) {
        composeArguments[_cancelToken] = cancelToken;
      }
      if (sendProgress != null) {
        composeArguments[_onSendProgress] = sendProgress;
      }
      if (receiveProgress != null) {
        composeArguments[_onReceiveProgress] = receiveProgress;
      }

      return refer('_setStreamType').call([
        refer('Options')
            .newInstance([], args)
            .property('compose')
            .call(
              [refer(_dioVar).property('options'), path],
              composeArguments,
            )
            .property('copyWith')
            .call([], {
              _baseUrlVar: baseUrl.ifNullThen(
                refer(_dioVar).property('options').property('baseUrl'),
              )
            })
      ], {}, [
        type
      ]);
    } else {
      hasCustomOptions = true;
      blocks.add(
        declareFinal('newOptions')
            .assign(
              refer('newRequestOptions')
                  .call([refer(annoOptions.item1.displayName)]),
            )
            .statement,
      );
      final newOptions = refer('newOptions');
      blocks
        ..add(
          newOptions
              .property(_extraVar)
              .property('addAll')
              .call([extraOptions.remove(_extraVar)!]).statement,
        )
        ..add(
          newOptions.property('headers').property('addAll').call(
            [refer(_dioVar).property('options').property('headers')],
          ).statement,
        )
        ..add(
          newOptions
              .property('headers')
              .property('addAll')
              .call([extraOptions.remove('headers')!]).statement,
        );
      return newOptions
          .property('copyWith')
          .call(
            [],
            Map.from(extraOptions)
              ..[_queryParamsVar] = namedArguments[_queryParamsVar]!
              ..[_path] = namedArguments[_path]!
              ..[_baseUrlVar] = extraOptions.remove(_baseUrlVar)!.ifNullThen(
                    refer(_dioVar).property('options').property('baseUrl'),
                  ),
          )
          .cascade('data')
          .assign(namedArguments[_dataVar]!);
    }
  }

  Method _generateOptionsCastMethod() => Method((m) {
        m
          ..name = 'newRequestOptions'
          ..returns = refer('RequestOptions')

          /// required parameters
          ..requiredParameters.add(
            Parameter((p) {
              p
                ..name = 'options'
                ..type = refer('Object?').type;
            }),
          )

          /// add method body
          ..body = const Code('''
         if (options is RequestOptions) {
            return options as RequestOptions;
          }
          if (options is Options) {
            return RequestOptions(
              method: options.method,
              sendTimeout: options.sendTimeout,
              receiveTimeout: options.receiveTimeout,
              extra: options.extra,
              headers: options.headers,
              responseType: options.responseType,
              contentType: options.contentType.toString(),
              validateStatus: options.validateStatus,
              receiveDataWhenStatusError: options.receiveDataWhenStatusError,
              followRedirects: options.followRedirects,
              maxRedirects: options.maxRedirects,
              requestEncoder: options.requestEncoder,
              responseDecoder: options.responseDecoder,
              path: '',
            );
          }
          return RequestOptions(path: '');
        ''');
      });

  Method _generateTypeSetterMethod() => Method((m) {
        final t = refer('T');
        final optionsParam = Parameter((p) {
          p
            ..name = 'requestOptions'
            ..type = refer('RequestOptions');
        });
        m
          ..name = '_setStreamType'
          ..types = ListBuilder(<Reference>[t])
          ..returns = refer('RequestOptions')
          ..requiredParameters = ListBuilder(<Parameter>[optionsParam])
          ..body = const Code('''
if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;''');
      });

  bool _isBasicType(DartType? returnType) {
    if (returnType == null) {
      return false;
    }
    return _typeChecker(String).isExactlyType(returnType) ||
        _typeChecker(bool).isExactlyType(returnType) ||
        _typeChecker(int).isExactlyType(returnType) ||
        _typeChecker(double).isExactlyType(returnType) ||
        _typeChecker(num).isExactlyType(returnType) ||
        _typeChecker(Double).isExactlyType(returnType) ||
        _typeChecker(Float).isExactlyType(returnType);
  }

  bool _isBasicInnerType(DartType returnType) {
    final innerType = _genericOf(returnType);
    return _isBasicType(innerType);
  }

  void _generateQueries(
    MethodElement m,
    List<Code> blocks,
    String queryParamsVar,
  ) {
    final queries = _getAnnotations(m, retrofit.Query);
    final queryParameters = queries.map((p, r) {
      final key = r.peek(_valueVar)?.stringValue ?? p.displayName;
      final Expression value;
      if (_isBasicType(p.type) ||
          p.type.isDartCoreList ||
          p.type.isDartCoreMap) {
        value = refer(p.displayName);
      } else {
        switch (clientAnnotation.parser) {
          case retrofit.Parser.JsonSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(p.displayName).nullSafeProperty('toJson').call([])
                : refer(p.displayName).property('toJson').call([]);
            break;
          case retrofit.Parser.MapSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(p.displayName).nullSafeProperty('toMap').call([])
                : refer(p.displayName).property('toMap').call([]);
            break;
          case retrofit.Parser.DartJsonMapper:
            value = refer(p.displayName);
            break;
          case retrofit.Parser.FlutterCompute:
            value = refer(
              'await compute(serialize${_displayString(p.type)}, ${p.displayName})',
            );
            break;
        }
      }
      return MapEntry(literalString(key, raw: true), value);
    });

    final queryMap = _getAnnotations(m, retrofit.Queries);
    blocks.add(
      declareFinal(queryParamsVar)
          .assign(
            literalMap(queryParameters, refer('String'), refer('dynamic')),
          )
          .statement,
    );
    for (final p in queryMap.keys) {
      final type = p.type;
      final displayName = p.displayName;
      final Expression value;
      if (_isBasicType(type) || type.isDartCoreList || type.isDartCoreMap) {
        value = refer(displayName);
      } else {
        switch (clientAnnotation.parser) {
          case retrofit.Parser.JsonSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toJson').call([])
                : refer(displayName).property('toJson').call([]);
            break;
          case retrofit.Parser.MapSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toMap').call([])
                : refer(displayName).property('toMap').call([]);
            break;
          case retrofit.Parser.DartJsonMapper:
            value = refer(displayName);
            break;
          case retrofit.Parser.FlutterCompute:
            value = refer(
              'await compute(serialize${_displayString(p.type)}, ${p.displayName})',
            );
            break;
        }
      }

      /// workaround until this is merged in code_builder
      /// https://github.com/dart-lang/code_builder/pull/269
      final emitter = DartEmitter(useNullSafetySyntax: true);
      final buffer = StringBuffer();
      value.accept(emitter, buffer);
      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        refer('?? <String,dynamic>{}').accept(emitter, buffer);
      }
      final expression = refer(buffer.toString());

      blocks.add(refer('$queryParamsVar.addAll').call([expression]).statement);
    }

    if (m.parameters
        .any((p) => p.type.nullabilitySuffix == NullabilitySuffix.question)) {
      blocks.add(Code('$queryParamsVar.removeWhere((k, v) => v == null);'));
    }
  }

  void _generateRequestBody(
    List<Code> blocks,
    String dataVar,
    MethodElement m,
  ) {
    final noBody = _getMethodAnnotationByType(m, retrofit.NoBody);
    if (noBody != null) {
      blocks.add(
        declareFinal(dataVar, type: refer('String?'))
            .assign(refer('null'))
            .statement,
      );
      return;
    }

    final annotation = _getAnnotation(m, retrofit.Body);
    final bodyName = annotation?.item1;
    if (bodyName != null) {
      final nullToAbsent =
          annotation!.item2.peek('nullToAbsent')?.boolValue ?? false;
      final bodyTypeElement = bodyName.type.element2;
      if (const TypeChecker.fromRuntime(Map)
          .isAssignableFromType(bodyName.type)) {
        blocks
          ..add(
            declareFinal(dataVar)
                .assign(literalMap({}, refer('String'), refer('dynamic')))
                .statement,
          )
          ..add(
            refer('$dataVar.addAll').call([
              refer(
                "${bodyName.displayName}${m.type.nullabilitySuffix == NullabilitySuffix.question ? ' ?? <String,dynamic>{}' : ''}",
              )
            ]).statement,
          );
        if (nullToAbsent) {
          blocks.add(Code('$dataVar.removeWhere((k, v) => v == null);'));
        }
      } else if (bodyTypeElement != null &&
          ((_typeChecker(List).isExactly(bodyTypeElement) ||
                  _typeChecker(BuiltList).isExactly(bodyTypeElement)) &&
              !_isBasicInnerType(bodyName.type))) {
        switch (clientAnnotation.parser) {
          case retrofit.Parser.JsonSerializable:
          case retrofit.Parser.DartJsonMapper:
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    refer('''
            ${bodyName.displayName}.map((e) => e.toJson()).toList()
            '''),
                  )
                  .statement,
            );
            break;
          case retrofit.Parser.MapSerializable:
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    refer('''
            ${bodyName.displayName}.map((e) => e.toMap()).toList()
            '''),
                  )
                  .statement,
            );
            break;
          case retrofit.Parser.FlutterCompute:
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    refer('''
            await compute(serialize${_displayString(_genericOf(bodyName.type))}List, ${bodyName.displayName})
            '''),
                  )
                  .statement,
            );
            break;
        }
      } else if (bodyTypeElement != null &&
          _typeChecker(File).isExactly(bodyTypeElement)) {
        blocks.add(
          declareFinal(dataVar)
              .assign(
                refer('Stream').property('fromIterable').call([
                  refer(
                    '${bodyName.displayName}.readAsBytesSync().map((i)=>[i])',
                  )
                ]),
              )
              .statement,
        );
      } else if (bodyName.type.element2 is ClassElement) {
        final ele = bodyName.type.element2! as ClassElement;
        if (clientAnnotation.parser == retrofit.Parser.MapSerializable) {
          final toMap = ele.lookUpMethod('toMap', ele.library);
          if (toMap == null) {
            log.warning(
                '${_displayString(bodyName.type)} must provide a `toMap()` method which return a Map.\n'
                "It is programmer's responsibility to make sure the ${bodyName.type} is properly serialized");
            blocks.add(
              declareFinal(dataVar)
                  .assign(refer(bodyName.displayName))
                  .statement,
            );
          } else {
            blocks
              ..add(
                declareFinal(dataVar)
                    .assign(literalMap({}, refer('String'), refer('dynamic')))
                    .statement,
              )
              ..add(
                refer('$dataVar.addAll').call(
                  [
                    refer(
                      '${bodyName.displayName}?.toMap() ?? <String,dynamic>{}',
                    )
                  ],
                ).statement,
              );
          }
        } else {
          if (_missingToJson(ele)) {
            log.warning(
                '${_displayString(bodyName.type)} must provide a `toJson()` method which return a Map.\n'
                "It is programmer's responsibility to make sure the ${_displayString(bodyName.type)} is properly serialized");
            blocks.add(
              declareFinal(dataVar)
                  .assign(refer(bodyName.displayName))
                  .statement,
            );
          } else if (_missingSerialize(ele.enclosingElement3, bodyName.type)) {
            log.warning(
                '${_displayString(bodyName.type)} must provide a `serialize${_displayString(bodyName.type)}()` method which returns a Map.\n'
                "It is programmer's responsibility to make sure the ${_displayString(bodyName.type)} is properly serialized");
            blocks.add(
              declareFinal(dataVar)
                  .assign(refer(bodyName.displayName))
                  .statement,
            );
          } else {
            blocks.add(
              declareFinal(dataVar)
                  .assign(literalMap({}, refer('String'), refer('dynamic')))
                  .statement,
            );

            final bodyType = bodyName.type;
            final genericArgumentFactories =
                isGenericArgumentFactories(bodyType);

            final typeArgs = bodyType is ParameterizedType
                ? bodyType.typeArguments
                : <DartType>[];

            var toJsonCode = '';
            if (typeArgs.isNotEmpty && genericArgumentFactories) {
              toJsonCode = _getInnerJsonDeSerializableMapperFn(bodyType);
            }

            switch (clientAnnotation.parser) {
              case retrofit.Parser.JsonSerializable:
              case retrofit.Parser.DartJsonMapper:
                if (bodyName.type.nullabilitySuffix !=
                    NullabilitySuffix.question) {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer('${bodyName.displayName}.toJson($toJsonCode)')
                    ]).statement,
                  );
                } else {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer(
                        '${bodyName.displayName}?.toJson($toJsonCode) ?? <String,dynamic>{}',
                      )
                    ]).statement,
                  );
                }
                break;
              case retrofit.Parser.FlutterCompute:
                if (bodyName.type.nullabilitySuffix !=
                    NullabilitySuffix.question) {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer(
                        'await compute(serialize${_displayString(bodyName.type)}, ${bodyName.displayName})',
                      )
                    ]).statement,
                  );
                } else {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer('''
${bodyName.displayName} == null
                      ? <String, dynamic>{}
                      : await compute(serialize${_displayString(bodyName.type)}, ${bodyName.displayName})
                  ''')
                    ]).statement,
                  );
                }
                break;
              case retrofit.Parser.MapSerializable:
                // Unreachable code
                break;
            }

            if (nullToAbsent) {
              blocks.add(Code('$dataVar.removeWhere((k, v) => v == null);'));
            }
          }
        }
      } else {
        /// @Body annotations with no type are assigned as is
        blocks.add(
          declareFinal(dataVar).assign(refer(bodyName.displayName)).statement,
        );
      }

      return;
    }

    var anyNullable = false;
    final fields = _getAnnotations(m, retrofit.Field).map((p, r) {
      anyNullable |= p.type.nullabilitySuffix == NullabilitySuffix.question;
      final fieldName = r.peek(_valueVar)?.stringValue ?? p.displayName;
      final isFileField = _typeChecker(File).isAssignableFromType(p.type);
      if (isFileField) {
        log.severe(
          'File is not support by @Field(). Please use @Part() instead.',
        );
      }
      return MapEntry(literal(fieldName), refer(p.displayName));
    });

    if (fields.isNotEmpty) {
      blocks.add(declareFinal(dataVar).assign(literalMap(fields)).statement);
      if (anyNullable) {
        blocks.add(Code('$dataVar.removeWhere((k, v) => v == null);'));
      }
      return;
    }

    final parts = _getAnnotations(m, retrofit.Part);
    if (parts.isNotEmpty) {
      if (m.parameters.length == 1 && m.parameters.first.type.isDartCoreMap) {
        blocks.add(
          declareFinal(dataVar)
              .assign(
                refer('FormData').newInstanceNamed(
                  'fromMap',
                  [CodeExpression(Code(m.parameters.first.displayName))],
                ),
              )
              .statement,
        );
        return;
      } else if (m.parameters.length == 2 &&
          m.parameters[1].type.isDartCoreMap) {
        blocks.add(
          declareFinal(dataVar)
              .assign(
                refer('FormData').newInstanceNamed(
                  'fromMap',
                  [CodeExpression(Code(m.parameters[1].displayName))],
                ),
              )
              .statement,
        );
        return;
      }
      blocks.add(
        declareFinal(dataVar)
            .assign(refer('FormData').newInstance([]))
            .statement,
      );

      parts.forEach((p, r) {
        final fieldName = r.peek('name')?.stringValue ??
            r.peek(_valueVar)?.stringValue ??
            p.displayName;
        final isFileField = _typeChecker(File).isAssignableFromType(p.type);
        final contentType = r.peek('contentType')?.stringValue;

        if (isFileField) {
          final fileNameValue = r.peek('fileName')?.stringValue;
          final fileName = fileNameValue != null
              ? literalString(fileNameValue)
              : refer(p.displayName)
                  .property('path.split(Platform.pathSeparator).last');

          final uploadFileInfo = refer('$MultipartFile.fromFileSync').call([
            refer(p.displayName).property('path')
          ], {
            'filename': fileName,
            if (contentType != null)
              'contentType':
                  refer('MediaType', 'package:http_parser/http_parser.dart')
                      .property('parse')
                      .call([literal(contentType)])
          });

          final optionalFile = m.parameters
                  .firstWhereOrNull((pp) => pp.displayName == p.displayName)
                  ?.isOptional ??
              false;

          final returnCode =
              refer(dataVar).property('files').property('add').call([
            refer('MapEntry').newInstance([literal(fieldName), uploadFileInfo])
          ]).statement;
          if (optionalFile) {
            final condition = refer(p.displayName).notEqualTo(literalNull).code;
            blocks.addAll(
              [
                const Code('if('),
                condition,
                const Code(') {'),
                returnCode,
                const Code('}')
              ],
            );
          } else {
            blocks.add(returnCode);
          }
        } else if (_displayString(p.type) == 'List<int>') {
          final optionalFile = m.parameters
                  .firstWhereOrNull((pp) => pp.displayName == p.displayName)
                  ?.isOptional ??
              false;
          final fileName = r.peek('fileName')?.stringValue;
          final conType = contentType == null
              ? ''
              : 'contentType: MediaType.parse(${literal(contentType)}),';
          final returnCode =
              refer(dataVar).property('files').property('add').call([
            refer('''
                  MapEntry(
                '$fieldName',
                MultipartFile.fromBytes(${p.displayName},

                filename:${literal(fileName)},
                    $conType
                    ))
                  ''')
          ]).statement;
          if (optionalFile) {
            final condition = refer(p.displayName).notEqualTo(literalNull).code;
            blocks.addAll(
              [
                const Code('if('),
                condition,
                const Code(') {'),
                returnCode,
                const Code('}')
              ],
            );
          } else {
            blocks.add(returnCode);
          }
        } else if (_typeChecker(List).isExactlyType(p.type) ||
            _typeChecker(BuiltList).isExactlyType(p.type)) {
          final innerType = _genericOf(p.type);

          if (_displayString(innerType) == 'List<int>') {
            final fileName = r.peek('fileName')?.stringValue;
            final conType = contentType == null
                ? ''
                : 'contentType: MediaType.parse(${literal(contentType)}),';
            blocks.add(
              refer(dataVar).property('files').property('addAll').call([
                refer('''
                  ${p.displayName}.map((i) => MapEntry(
                '$fieldName',
                MultipartFile.fromBytes(i,
                    filename:${literal(fileName)},
                    $conType
                    )))
                  ''')
              ]).statement,
            );
          } else if (_isBasicType(innerType) ||
              ((innerType != null) &&
                  (_typeChecker(Map).isExactlyType(innerType) ||
                      _typeChecker(BuiltMap).isExactlyType(innerType) ||
                      _typeChecker(List).isExactlyType(innerType) ||
                      _typeChecker(BuiltList).isExactlyType(innerType)))) {
            final value = _isBasicType(innerType) ? 'i' : 'jsonEncode(i)';
            final nullableInfix =
                (p.type.nullabilitySuffix == NullabilitySuffix.question)
                    ? '?'
                    : '';
            blocks.add(
              refer('''
            ${p.displayName}$nullableInfix.forEach((i){
              $dataVar.fields.add(MapEntry(${literal(fieldName)},$value));
            })
            ''').statement,
            );
          } else if (innerType != null &&
              _typeChecker(File).isExactlyType(innerType)) {
            final conType = contentType == null
                ? ''
                : 'contentType: MediaType.parse(${literal(contentType)}),';
            if (p.type.isNullable) {
              blocks.add(Code('if (${p.displayName} != null) {'));
            }
            blocks.add(
              refer(dataVar).property('files').property('addAll').call([
                refer('''
                  ${p.displayName}.map((i) => MapEntry(
                '$fieldName',
                MultipartFile.fromFileSync(i.path,
                    filename: i.path.split(Platform.pathSeparator).last,
                    $conType
                    )))
                  ''')
              ]).statement,
            );
            if (p.type.isNullable) {
              blocks.add(const Code('}'));
            }
          } else if (innerType != null &&
              _typeChecker(MultipartFile).isExactlyType(innerType)) {
            if (p.type.isNullable) {
              blocks.add(Code('if (${p.displayName} != null) {'));
            }
            blocks.add(
              refer(dataVar).property('files').property('addAll').call([
                refer('''
                  ${p.displayName}.map((i) => MapEntry(
                '$fieldName',
                i))
                  ''')
              ]).statement,
            );
            if (p.type.isNullable) {
              blocks.add(const Code('}'));
            }
          } else if (innerType?.element2 is ClassElement) {
            final ele = innerType!.element2! as ClassElement;
            if (_missingToJson(ele)) {
              throw Exception('toJson() method have to add to ${p.type}');
            } else {
              blocks.add(
                refer(dataVar).property('fields').property('add').call([
                  refer('MapEntry').newInstance([
                    literal(fieldName),
                    refer('jsonEncode(${p.displayName})')
                  ])
                ]).statement,
              );
            }
          } else {
            throw Exception('Unknown error!');
          }
        } else if (_isBasicType(p.type)) {
          if (p.type.nullabilitySuffix == NullabilitySuffix.question) {
            blocks.add(Code('if (${p.displayName} != null) {'));
          }
          blocks.add(
            refer(dataVar).property('fields').property('add').call([
              refer('MapEntry').newInstance([
                literal(fieldName),
                if (_typeChecker(String).isExactlyType(p.type))
                  refer(p.displayName)
                else
                  refer(p.displayName).property('toString').call([])
              ])
            ]).statement,
          );
          if (p.type.nullabilitySuffix == NullabilitySuffix.question) {
            blocks.add(const Code('}'));
          }
        } else if (_typeChecker(Map).isExactlyType(p.type) ||
            _typeChecker(BuiltMap).isExactlyType(p.type)) {
          blocks.add(
            refer(dataVar).property('fields').property('add').call([
              refer('MapEntry').newInstance(
                [literal(fieldName), refer('jsonEncode(${p.displayName})')],
              )
            ]).statement,
          );
        } else if (p.type.element2 is ClassElement) {
          final ele = p.type.element2! as ClassElement;
          if (_missingToJson(ele)) {
            throw Exception('toJson() method have to add to ${p.type}');
          } else {
            blocks.add(
              refer(dataVar).property('fields').property('add').call([
                refer('MapEntry').newInstance([
                  literal(fieldName),
                  refer(
                    "jsonEncode(${p.displayName}${p.type.nullabilitySuffix == NullabilitySuffix.question ? ' ?? <String,dynamic>{}' : ''})",
                  )
                ])
              ]).statement,
            );
          }
        } else {
          blocks.add(
            refer(dataVar).property('fields').property('add').call([
              refer('MapEntry')
                  .newInstance([literal(fieldName), refer(p.displayName)])
            ]).statement,
          );
        }
      });
      return;
    }

    /// There is no body
    blocks.add(
      declareFinal(dataVar, type: refer('Map<String, dynamic>?'))
          .assign(literalNull)
          .statement,
    );
  }

  Map<String, Expression> _generateHeaders(MethodElement m) {
    final headers = _getMethodAnnotations(m, retrofit.Headers)
        .map((e) => e.peek(_valueVar))
        .map(
          (value) => value?.mapValue.map(
            (k, v) => MapEntry(
              k?.toStringValue() ?? 'null',
              literal(v?.toStringValue()),
            ),
          ),
        )
        .fold<Map<String, Expression>>({}, (p, e) => p..addAll(e ?? {}));

    final annotationsInParam = _getAnnotations(m, retrofit.Header);
    final headersInParams = annotationsInParam.map((k, v) {
      final value = v.peek(_valueVar)?.stringValue ?? k.displayName;
      return MapEntry(value, refer(k.displayName));
    });
    headers.addAll(headersInParams);

    final cacheMap = _generateCache(m);
    headers.addAll(cacheMap);

    return headers;
  }

  Map<String, Expression> _generateCache(MethodElement m) {
    final cache = _getCacheAnnotation(m);
    final result = <String, Expression>{};
    if (cache != null && cache.toString() != '') {
      final maxAge = cache.peek('maxAge')?.intValue;
      final maxStale = cache.peek('maxStale')?.intValue;
      final minFresh = cache.peek('minFresh')?.intValue;
      final noCache = cache.peek('noCache')?.boolValue;
      final noStore = cache.peek('noStore')?.boolValue;
      final noTransform = cache.peek('noTransform')?.boolValue;
      final onlyIfCached = cache.peek('onlyIfCached')?.boolValue;
      final other = (cache.peek('other')?.listValue ?? const [])
          .map((e) => e.toStringValue());
      final otherResult = <String>[];

      for (final element in other) {
        if (element != null) {
          otherResult.add(element);
        }
      }

      final values = <String>[
        if (maxAge != null) 'max-age=$maxAge' else '',
        if (maxStale != null) 'max-stale=$maxStale' else '',
        if (minFresh != null) 'max-fresh=$minFresh' else '',
        if (noCache ?? false) 'no-cache' else '',
        if (noStore ?? false) 'no-store' else '',
        if (noTransform ?? false) 'no-transform' else '',
        if (onlyIfCached ?? false) 'only-if-cached' else '',
        ...otherResult
      ];

      final value = values.where((element) => element != '').join(', ');

      result.putIfAbsent(HttpHeaders.cacheControlHeader, () => literal(value));
    }
    return result;
  }

  void _generateExtra(
    MethodElement m,
    List<Code> blocks,
    String localExtraVar,
  ) {
    blocks.add(
      declareConst(localExtraVar)
          .assign(
            literalMap(
              _getMethodAnnotations(m, retrofit.Extra)
                  .map((e) => e.peek('data'))
                  .map(
                    (data) => data?.mapValue.map(
                      (k, v) => MapEntry(
                        k?.toStringValue() ??
                            (throw InvalidGenerationSourceError(
                              'Invalid key for extra Map, only `String` keys are supported',
                              element: m,
                              todo: 'Make sure all keys are of string type',
                            )),
                        v?.toBoolValue() ??
                            v?.toDoubleValue() ??
                            v?.toIntValue() ??
                            v?.toStringValue() ??
                            v?.toListValue() ??
                            v?.toMapValue() ??
                            v?.toSetValue() ??
                            v?.toSymbolValue() ??
                            (v?.toTypeValue() ??
                                (v != null
                                    ? Code(revivedLiteral(v))
                                    : const Code('null'))),
                      ),
                    ),
                  )
                  .fold<Map<String, Object>>({}, (p, e) => p..addAll(e ?? {})),
              refer('String'),
              refer('dynamic'),
            ),
          )
          .statement,
    );
  }

  bool _missingToJson(ClassElement ele) {
    switch (clientAnnotation.parser) {
      case retrofit.Parser.JsonSerializable:
      case retrofit.Parser.DartJsonMapper:
        final toJson = ele.lookUpMethod('toJson', ele.library);
        return toJson == null;
      case retrofit.Parser.MapSerializable:
      case retrofit.Parser.FlutterCompute:
        return false;
    }
  }

  bool _missingSerialize(CompilationUnitElement ele, DartType type) {
    switch (clientAnnotation.parser) {
      case retrofit.Parser.JsonSerializable:
      case retrofit.Parser.DartJsonMapper:
      case retrofit.Parser.MapSerializable:
        return false;
      case retrofit.Parser.FlutterCompute:
        return !ele.functions.any(
          (element) =>
              element.name == 'serialize${_displayString(type)}' &&
              element.parameters.length == 1 &&
              _displayString(element.parameters[0].type) ==
                  _displayString(type),
        );
    }
  }
}

Builder generatorFactoryBuilder(BuilderOptions options) => SharedPartBuilder(
      [RetrofitGenerator(RetrofitOptions.fromOptions(options))],
      'retrofit',
    );

/// Returns `$revived($args $kwargs)`, this won't have ending semi-colon (`;`).
/// [object] must not be null.
/// [object] is assumed to be a constant.
String revivedLiteral(
  Object object, {
  DartEmitter? dartEmitter,
}) {
  dartEmitter ??= DartEmitter(useNullSafetySyntax: true);

  ArgumentError.checkNotNull(object, 'object');

  Revivable? revived;
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
    throw ArgumentError.value(
      object,
      'object',
      'Only `Revivable`, `DartObject`, `ConstantReader` are supported values',
    );
  }

  var instantiation = '';
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
  Spec objectToSpec(DartObject? object) {
    if (object == null) {
      return literalNull;
    }
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
      return literalMap(
        Map.fromIterables(
          constant.mapValue.keys.map(objectToSpec),
          constant.mapValue.values.map(objectToSpec),
        ),
      );
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
      return refer(_displayString(constant.typeValue));
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

  for (final arg in revived.positionalArguments) {
    final literalValue = objectToSpec(arg);

    args.write('${literalValue.accept(dartEmitter)},');
  }

  for (final arg in revived.namedArguments.keys) {
    final literalValue = objectToSpec(revived.namedArguments[arg]);

    kwargs.write('$arg:${literalValue.accept(dartEmitter)},');
  }

  return '$instantiation($args $kwargs)';
}

extension DartTypeStreamAnnotation on DartType {
  bool get isDartAsyncStream {
    final element = element2 != null ? null : element2! as ClassElement;
    if (element == null) {
      return false;
    }
    return element.name == 'Stream' && element.library.isDartAsync;
  }
}

String _displayString(DartType? e, {bool withNullability = false}) {
  try {
    return e!.getDisplayString(withNullability: withNullability);
  } on TypeError {
    return e!.getDisplayString(withNullability: withNullability);
  } on Object {
    rethrow;
  }
}

extension DartTypeExt on DartType {
  bool get isNullable => nullabilitySuffix == NullabilitySuffix.question;
}

extension ReferenceExt on Reference {
  Reference asNoNull() => refer('$symbol!');

  Reference asNoNullIf({required bool returnNullable}) =>
      returnNullable ? this : asNoNull();

  Expression propertyIf({
    required bool thisNullable,
    required String name,
  }) =>
      thisNullable ? nullSafeProperty(name) : asNoNull().property(name);

  Expression conditionalIsNullIf({
    required bool thisNullable,
    required Expression whenFalse,
  }) =>
      thisNullable
          ? equalTo(literalNull).conditional(literalNull, whenFalse)
          : whenFalse;
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
