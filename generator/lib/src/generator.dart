import 'dart:ffi' as ffi;
import 'dart:io' as io;
import 'dart:typed_data' as typed_data;

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dio/dio.dart';
import 'package:protobuf/protobuf.dart'
    as protobuf
    show GeneratedMessage, ProtobufEnum;
import 'package:retrofit/retrofit.dart' as retrofit;
import 'package:source_gen/source_gen.dart';

const _analyzerIgnores =
    '// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main';

/// Factory for the Retrofit code generator used by build_runner.
Builder generatorFactoryBuilder(BuilderOptions options) {
  final retrofitOptions = RetrofitOptions.fromOptions(options);
  return SharedPartBuilder(
    [RetrofitGenerator(retrofitOptions)],
    'retrofit',
    formatOutput: (code, version) {
      final formattedCode = DartFormatter(
        languageVersion: version,
      ).format(code);
      // Only add format suppressing comments if format_output is true (default)
      if (retrofitOptions.formatOutput ?? true) {
        return '// dart format off\n\n$formattedCode\n// dart format on\n';
      }
      return formattedCode;
    },
  );
}

/// Global configuration options for the Retrofit generator.
class RetrofitOptions {
  RetrofitOptions({
    this.autoCastResponse,
    this.emptyRequestBody,
    this.className,
    this.useResult,
    this.formatOutput,
  });

  RetrofitOptions.fromOptions([BuilderOptions? options])
    : autoCastResponse =
          (options?.config['auto_cast_response']?.toString() ?? 'true') ==
          'true',
      emptyRequestBody =
          (options?.config['empty_request_body']?.toString() ?? 'false') ==
          'true',
      className = options?.config['class-name']?.toString(),
      useResult =
          (options?.config['use_result']?.toString() ?? 'false') == 'true',
      formatOutput =
          (options?.config['format_output']?.toString() ?? 'true') == 'true';

  final bool? autoCastResponse;
  final bool? emptyRequestBody;
  final String? className;
  final bool? useResult;
  final bool? formatOutput;
}

/// Main generator that processes @RestApi annotation and generates implementation code.
class RetrofitGenerator extends GeneratorForAnnotation<retrofit.RestApi> {
  RetrofitGenerator(this.globalOptions);

  final RetrofitOptions globalOptions;

  static const _baseUrlVar = 'baseUrl';
  static const _errorLoggerVar = 'errorLogger';
  static const _queryParamsVar = 'queryParameters';
  static const _optionsVar = '_options';
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
  static const _valueVar = '_value';
  bool hasCustomOptions = false;

  /// Global options specified in the `build.yaml`

  /// Annotation details for [retrofit.RestApi]
  late retrofit.RestApi clientAnnotation;

  ConstantReader? clientAnnotationConstantReader;

  @override
  /// Processes classes annotated with @RestApi and generates implementation.
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

  /// Generates the implementation class code as a string.
  String _implementClass(ClassElement element, ConstantReader annotation) {
    // Reset hasCustomOptions for each class to avoid state leaking between classes
    hasCustomOptions = false;
    final className = globalOptions.className ?? '_${element.name}';
    final enumString = annotation.peek('parser')?.revive().accessor;
    final parser = retrofit.Parser.values.firstWhereOrNull(
      (e) => e.toString() == enumString,
    );
    final headersMap = annotation.peek('headers')?.mapValue.map((k, v) {
      dynamic val;
      if (v == null) {
        val = null;
      } else if (v.type?.isDartCoreBool ?? false) {
        val = v.toBoolValue();
      } else if (v.type?.isDartCoreString ?? false) {
        val = v.toStringValue();
      } else if (v.type?.isDartCoreDouble ?? false) {
        val = v.toDoubleValue();
      } else if (v.type?.isDartCoreInt ?? false) {
        val = v.toIntValue();
      } else {
        val = v.toStringValue();
      }
      return MapEntry(k?.toStringValue() ?? 'null', val);
    });
    clientAnnotation = retrofit.RestApi(
      baseUrl: annotation.peek(_baseUrlVar)?.stringValue ?? '',
      parser: parser ?? retrofit.Parser.JsonSerializable,
      headers: headersMap,
    );
    clientAnnotationConstantReader = annotation;
    final baseUrl = clientAnnotation.baseUrl;
    final annotateClassConsts = element.constructors.where(
      (c) => !c.isFactory && !c.isDefaultConstructor,
    );
    final classBuilder = Class((c) {
      c
        ..name = className
        ..types.addAll(
          element.typeParameters.map((e) => e.name).nonNulls.map(refer),
        )
        ..fields.addAll([
          _buildDioField(),
          _buildBaseUrlField(baseUrl),
          _buildErrorLoggerFiled(),
        ])
        ..constructors.addAll(
          annotateClassConsts.map(
            (e) => _generateConstructor(baseUrl, superClassConst: e),
          ),
        )
        ..methods.addAll(_parseMethods(element));
      if (annotateClassConsts.isEmpty) {
        c.constructors.add(_generateConstructor(baseUrl));
        c.implements.add(refer(_generateTypeParameterizedName(element)));
      } else {
        c.extend = Reference(_generateTypeParameterizedName(element));
      }
      if (hasCustomOptions) {
        c.methods.add(_generateOptionsCastMethod());
      }
      c.methods.addAll([
        _generateTypeSetterMethod(),
        _generateCombineBaseUrlsMethod(),
      ]);
    });

    final emitter = DartEmitter(useNullSafetySyntax: true);
    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format([_analyzerIgnores, classBuilder.accept(emitter)].join('\n\n'));
  }

  /// Builds the Dio field.
  Field _buildDioField() => Field(
    (m) => m
      ..name = _dioVar
      ..type = refer('Dio')
      ..modifier = FieldModifier.final$,
  );

  /// Builds the baseUrl field.
  Field _buildBaseUrlField(String? url) => Field((m) {
    m
      ..name = _baseUrlVar
      ..type = refer('String?')
      ..modifier = FieldModifier.var$;
  });

  /// Builds the error logger field.
  Field _buildErrorLoggerFiled() => Field((m) {
    m
      ..name = _errorLoggerVar
      ..type = refer('ParseErrorLogger?')
      ..modifier = FieldModifier.final$;
  });

  /// Generates the constructor.
  Constructor _generateConstructor(
    String? url, {
    ConstructorElement? superClassConst,
  }) => Constructor((c) {
    c.requiredParameters.add(
      Parameter(
        (p) => p
          ..name = _dioVar
          ..toThis = true,
      ),
    );
    c.optionalParameters.addAll([
      Parameter(
        (p) => p
          ..named = true
          ..name = _baseUrlVar
          ..toThis = true,
      ),
      Parameter(
        (p) => p
          ..named = true
          ..name = _errorLoggerVar
          ..toThis = true,
      ),
    ]);
    if (superClassConst != null) {
      var superConstName = 'super';
      if (superClassConst.name?.isNotEmpty ?? false) {
        superConstName += '.${superClassConst.name}';
        c.name = superClassConst.name;
      }
      final constParams = superClassConst.formalParameters;
      for (final element in constParams) {
        if (!element.isOptional || element.isPrivate) {
          c.requiredParameters.add(
            Parameter((p) {
              p.type = refer(_displayString(element.type));
              if (element.name != null) {
                p.name = element.name!;
              }
            }),
          );
        } else {
          c.optionalParameters.add(
            Parameter((p) {
              p
                ..named = element.isNamed
                ..type = refer(_displayString(element.type));
              if (element.name != null) {
                p.name = element.name!;
              }
            }),
          );
        }
      }
      final paramList = constParams.map(
        (e) => '${e.isNamed ? '${e.name}: ' : ''}${e.name}',
      );
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

  /// Traverses a type to find a matching type argument
  /// e.g. given a type `List<List<User>>` and a key `User`, it will return the `DartType` "User"
  /// Finds a matching type argument by key in type parameters.
  DartType? findMatchingTypeArgument(DartType? type, String key) {
    if (type?.getDisplayString() == key) {
      return type;
    }

    if (type is InterfaceType) {
      for (final arg in type.typeArguments) {
        final match = findMatchingTypeArgument(arg, key);
        if (match != null) {
          return match;
        }
      }
    }
    return null;
  }

  /// retrieve CallAdapter from method annotation or class annotation
  /// Gets the CallAdapter annotation from method or class.
  ConstantReader? getCallAdapterInterface(MethodElement m) {
    final requestCallAdapterAnnotation = _typeChecker(
      retrofit.UseCallAdapter,
    ).firstAnnotationOf(m).toConstantReader();
    final rootCallAdapter = clientAnnotationConstantReader;

    final callAdapter = (requestCallAdapterAnnotation ?? rootCallAdapter)?.peek(
      'callAdapter',
    );

    final callAdapterTypeValue = callAdapter?.typeValue as InterfaceType?;
    if (callAdapterTypeValue != null) {
      final typeArg = callAdapterTypeValue.typeArguments.firstOrNull;
      if (typeArg == null) {
        throw InvalidGenerationSource(
          'your CallAdapter subclass must accept a generic type parameter \n'
          'e.g. "class ResultAdapter<T> extends CallAdapter..."',
        );
      }
    }
    return callAdapter;
  }

  /// get result type being adapted to e.g. `Future<Result<T>>`
  /// where T is supposed to be the wrapped result type
  /// Gets the return type adapted by CallAdapter.
  InterfaceType? getAdaptedReturnType(ConstantReader? callAdapter) {
    final callAdapterTypeVal = callAdapter?.typeValue as InterfaceType?;
    final adaptedType =
        callAdapterTypeVal?.superclass?.typeArguments.lastOrNull
            as InterfaceType?;
    return adaptedType;
  }

  /// extract the wrapped result type of an adapted call...
  /// Usage scenario:
  /// given the return type of the api method is `Future<Result<UserResponse>>`,
  /// and the second type parameter(T) on `CallAdapter<R, T>` is `Future<Result<T>>`,
  /// this method basically figures out the value of 'T' which will be "UserResponse"
  /// in this case
  /// Extracts the actual type wrapped by CallAdapter.
  String extractWrappedResultType(String template, String actual) {
    final regexPattern = RegExp(
      RegExp.escape(template).replaceAll('dynamic', r'([\w<>?]+)'),
    );
    final match = regexPattern.firstMatch(actual);

    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    }
    return '';
  }

  // parse methods in the Api class
  /// Parses methods in the API class and generates implementations.
  Iterable<Method> _parseMethods(ClassElement element) {
    final methods = <Method>[];
    final methodMembers = [
      ...element.methods,
      ...element.mixins.expand((i) => i.methods),
    ];
    for (final method in methodMembers) {
      final callAdapter = getCallAdapterInterface(method);
      final adaptedReturnType = getAdaptedReturnType(callAdapter);
      final resultTypeInString = extractWrappedResultType(
        adaptedReturnType != null ? _displayString(adaptedReturnType) : '',
        _displayString(method.returnType),
      );
      final typeArg = findMatchingTypeArgument(
        method.returnType,
        resultTypeInString,
      );
      final instantiatedCallAdapter = typeArg != null
          ? (callAdapter?.typeValue as InterfaceType?)?.element.instantiate(
              typeArguments: [typeArg],
              nullabilitySuffix: NullabilitySuffix.none,
            )
          : null;
      if (method.isAbstract) {
        methods.add(_generateApiCallMethod(method, instantiatedCallAdapter)!);
      }
      if (callAdapter != null) {
        methods.add(
          _generateAdapterMethod(
            method,
            instantiatedCallAdapter,
            resultTypeInString,
          ),
        );
      }
    }
    return methods;
  }

  /// Generates a method implementation wrapped by CallAdapter.
  Method _generateAdapterMethod(
    MethodElement m,
    InterfaceType? callAdapter,
    String resultType,
  ) {
    return Method((methodBuilder) {
      methodBuilder.returns = refer(
        _displayString(m.returnType, withNullability: true),
      );
      methodBuilder.requiredParameters.addAll(
        _generateParameters(m, (it) => it.isRequiredPositional),
      );
      methodBuilder.optionalParameters.addAll(
        _generateParameters(
          m,
          (it) => it.isOptional || it.isRequiredNamed,
          optional: true,
        ),
      );
      methodBuilder.name = m.displayName;
      methodBuilder.annotations.add(const CodeExpression(Code('override')));
      final positionalArgs = <String>[];
      final namedArgs = <String>[];
      for (final parameter in m.formalParameters) {
        if (parameter.isRequiredPositional || parameter.isOptionalPositional) {
          positionalArgs.add(parameter.displayName);
        }
        if (parameter.isNamed) {
          namedArgs.add('${parameter.displayName}: ${parameter.displayName}');
        }
      }
      final args =
          '${positionalArgs.map((e) => '$e,').join()} ${namedArgs.map((e) => '$e,').join()}';
      methodBuilder.body = Code('''
        return ${callAdapter?.element.name}<$resultType>().adapt(
          () => _${m.displayName}($args),
        );
      ''');
    });
  }

  /// Generates method parameters.
  Iterable<Parameter> _generateParameters(
    MethodElement m,
    bool Function(FormalParameterElement) filter, {
    bool optional = false,
  }) {
    return m.formalParameters
        .where(filter)
        .map(
          (it) => Parameter((p) {
            p
              ..named = it.isNamed
              ..type = refer(it.type.getDisplayString())
              ..required = optional && it.isRequiredNamed
              ..defaultTo = optional && it.defaultValueCode != null
                  ? Code(it.defaultValueCode!)
                  : null;
            if (it.name != null) {
              p.name = it.name!;
            }
          }),
        );
  }

  /// Generates a type name with generic parameters.
  String _generateTypeParameterizedName(TypeParameterizedElement element) =>
      element.displayName +
      (element.typeParameters.isNotEmpty
          ? '<${element.typeParameters.join(',')}>'
          : '');

  final _methodsAnnotations = const {
    retrofit.GET,
    retrofit.POST,
    retrofit.DELETE,
    retrofit.PUT,
    retrofit.PATCH,
    retrofit.HEAD,
    retrofit.OPTIONS,
    retrofit.Method,
  };

  /// Checks if the type is an interface type.
  bool _isInterfaceType(DartType? t) => t is InterfaceType;

  ///  `_typeChecker(T).isExactlyType(x)`
  bool _isExactly(Type t, DartType? x) =>
      _isInterfaceType(x) && _typeChecker(t).isExactlyType(x!);

  /// `_typeChecker(T).isAssignableFromType(x)`
  bool _isAssignable(Type t, DartType? x) =>
      _isInterfaceType(x) && _typeChecker(t).isAssignableFromType(x!);

  /// `_typeChecker(T).isSuperTypeOf(x)`
  bool _isSuperOf(Type t, DartType? x) {
    // Object is the root of the type hierarchy, nothing can be its supertype
    if (x?.isDartCoreObject ?? false) {
      return false;
    }
    return _isInterfaceType(x) && _typeChecker(t).isSuperTypeOf(x!);
  }

  /// Gets a type checker for the given type.
  TypeChecker _typeChecker(Type type) {
    const dartCoreTypes = {
      Object,
      num,
      int,
      double,
      bool,
      String,
      DateTime,
      Uri,
      BigInt,
      List,
      Map,
      Set,
      Iterable,
    };
    if (dartCoreTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'core', inSdk: true);
    }

    final dartAsyncTypes = {Future, Stream};
    if (dartAsyncTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'async', inSdk: true);
    }

    final dartFfiTypes = {ffi.Double, ffi.Long, ffi.Float};
    if (dartFfiTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'ffi', inSdk: true);
    }

    final dartIoTypes = {io.File};
    if (dartIoTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'io', inSdk: true);
    }

    final dartTypedDataTypes = {typed_data.Uint8List};
    if (dartTypedDataTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'typed_data', inSdk: true);
    }

    final dioTypes = {MultipartFile, ResponseType};
    if (dioTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'dio');
    }

    const retrofitTypes = {
      retrofit.GET,
      retrofit.POST,
      retrofit.DELETE,
      retrofit.PUT,
      retrofit.PATCH,
      retrofit.HEAD,
      retrofit.OPTIONS,
      retrofit.Method,
      retrofit.Body,
      retrofit.BodyExtra,
      retrofit.Query,
      retrofit.Queries,
      retrofit.Path,
      retrofit.Part,
      retrofit.PartMap,
      retrofit.Field,
      retrofit.Header,
      retrofit.Headers,
      retrofit.MultiPart,
      retrofit.FormUrlEncoded,
      retrofit.CacheControl,
      retrofit.PreventNullToAbsent,
      retrofit.TypedExtras,
      retrofit.Extra,
      retrofit.Extras,
      retrofit.CancelRequest,
      retrofit.HttpResponse,
      retrofit.DioOptions,
    };
    if (retrofitTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'retrofit');
    }

    const builtCollectionTypes = {BuiltList, BuiltMap, BuiltSet};
    if (builtCollectionTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'built_collection');
    }

    const protobufTypes = {protobuf.GeneratedMessage, protobuf.ProtobufEnum};
    if (protobufTypes.contains(type)) {
      return TypeChecker.typeNamed(type, inPackage: 'protobuf');
    }

    return TypeChecker.typeNamed(type);
  }

  /// Gets the HTTP annotation on the method.
  ConstantReader? _getMethodAnnotation(MethodElement method) {
    for (final type in _methodsAnnotations) {
      final annotation = _getMethodAnnotationByType(method, type);
      if (annotation != null) {
        return annotation;
      }
    }
    return null;
  }

  /// Gets the annotation of the specified type on the method.
  ConstantReader? _getMethodAnnotationByType(MethodElement method, Type type) {
    final annotation = _typeChecker(
      type,
    ).firstAnnotationOf(method, throwOnUnresolved: false);
    if (annotation != null) {
      return ConstantReader(annotation);
    }
    return null;
  }

  /// Gets the cache annotation on the method.
  ConstantReader? _getCacheAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.CacheControl);

  /// Gets the Content-Type annotation on the method.
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

  /// Gets the MultiPart annotation on the method.
  ConstantReader? _getMultipartAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.MultiPart);

  /// Gets the FormUrlEncoded annotation on the method.
  ConstantReader? _getFormUrlEncodedAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.FormUrlEncoded);

  /// Gets the ResponseType annotation on the method.
  ConstantReader? _getResponseTypeAnnotation(MethodElement method) =>
      _getMethodAnnotationByType(method, retrofit.DioResponseType);

  /// Gets all annotations of the specified type on the method.
  Iterable<ConstantReader> _getMethodAnnotations(
    MethodElement method,
    Type type,
  ) => _typeChecker(
    type,
  ).annotationsOf(method, throwOnUnresolved: false).map(ConstantReader.new);

  /// Gets the specified type annotation on method parameters.
  Map<FormalParameterElement, ConstantReader> _getAnnotations(
    MethodElement m,
    Type type,
  ) {
    final annotation = <FormalParameterElement, ConstantReader>{};
    for (final p in m.formalParameters) {
      final a = _typeChecker(type).firstAnnotationOf(p);
      if (a != null) {
        annotation[p] = ConstantReader(a);
      }
    }
    return annotation;
  }

  /// Gets the specified type annotation on a single method parameter.
  ({FormalParameterElement element, ConstantReader reader})? _getAnnotation(
    MethodElement m,
    Type type,
  ) {
    for (final p in m.formalParameters) {
      final a = _typeChecker(type).firstAnnotationOf(p);
      if (a != null) {
        return (element: p, reader: ConstantReader(a));
      }
    }
    return null;
  }

  /// Gets the list of generic type arguments for a type.
  List<DartType>? _genericListOf(DartType type) =>
      type is ParameterizedType && type.typeArguments.isNotEmpty
      ? type.typeArguments
      : null;

  /// Gets the first generic type argument for a type.
  DartType? _genericOf(DartType type) =>
      type is InterfaceType && type.typeArguments.isNotEmpty
      ? type.typeArguments.first
      : null;

  /// Gets the generic type argument for a response type.
  DartType? _getResponseType(DartType type) => _genericOf(type);

  /// get types for `Map<String, List<User>>`, `A<B,C,D>`
  /// Gets all generic type arguments for a response type.
  List<DartType>? _getResponseInnerTypes(DartType type) {
    final genericList = _genericListOf(type);
    return genericList;
  }

  /// Gets the innermost generic type argument for a response type.
  DartType? _getResponseInnerType(DartType type) {
    final generic = _genericOf(type);
    if (generic == null ||
        _isExactly(Map, type) ||
        _isExactly(BuiltMap, type)) {
      return type;
    }

    if (generic is DynamicType) {
      return null;
    }

    if (_isExactly(List, type) || _isExactly(BuiltList, type)) {
      return generic;
    }

    return _getResponseInnerType(generic);
  }

  /// Configures method metadata.
  void _configureMethodMetadata(
    MethodBuilder mm,
    MethodElement m,
    String returnType,
    bool hasCallAdapter,
  ) {
    mm
      ..returns = refer(returnType)
      ..name = hasCallAdapter ? '_${m.displayName}' : m.displayName
      ..types.addAll(m.typeParameters.map((e) => e.name).nonNulls.map(refer))
      ..modifier = _isReturnTypeFuture(returnType)
          ? MethodModifier.async
          : MethodModifier.asyncStar;
  }

  /// Adds method parameters.
  void _addParameters(MethodBuilder mm, MethodElement m) {
    mm.requiredParameters.addAll(
      _generateParameters(m, (it) => it.isRequiredPositional),
    );
    mm.optionalParameters.addAll(
      _generateParameters(
        m,
        (it) => it.isOptional || it.isRequiredNamed,
        optional: true,
      ),
    );
  }

  /// Adds method annotations.
  void _addAnnotations(
    MethodBuilder mm,
    DartType? returnType,
    bool hasCallAdapter,
  ) {
    if (!hasCallAdapter) {
      mm.annotations.add(const CodeExpression(Code('override')));
    }
    if (globalOptions.useResult ?? false) {
      if (returnType is ParameterizedType &&
          returnType.typeArguments.first is! VoidType) {
        mm.annotations.add(const CodeExpression(Code('useResult')));
      }
    }
  }

  // generate the method that makes the http request
  /// Generates the API call method implementation.
  Method? _generateApiCallMethod(MethodElement m, InterfaceType? callAdapter) {
    final hasCallAdapter = callAdapter != null;

    if (hasCallAdapter) {
      return _generatePrivateApiCallMethod(m, callAdapter);
    }

    final httpMethod = _getMethodAnnotation(m);
    if (httpMethod == null) {
      return null;
    }

    final returnType = m.returnType;
    return Method((methodBuilder) {
      _configureMethodMetadata(
        methodBuilder,
        m,
        _displayString(returnType, withNullability: true),
        false,
      );
      _addParameters(methodBuilder, m);
      _addAnnotations(methodBuilder, returnType, false);
      methodBuilder.body = _generateRequest(m, httpMethod, null);
    });
  }

  /// Generates the private API call method implementation (with CallAdapter).
  Method? _generatePrivateApiCallMethod(
    MethodElement m,
    InterfaceType? callAdapter,
  ) {
    final callAdapterOriginalReturnType =
        callAdapter?.superclass?.typeArguments.firstOrNull as InterfaceType?;

    final httpMethod = _getMethodAnnotation(m);
    if (httpMethod == null) {
      return null;
    }

    return Method((methodBuilder) {
      _configureMethodMetadata(
        methodBuilder,
        m,
        _displayString(callAdapterOriginalReturnType),
        true,
      );
      _addParameters(methodBuilder, m);
      _addAnnotations(methodBuilder, m.returnType, true);
      methodBuilder.body = _generateRequest(m, httpMethod, callAdapter);
    });
  }

  /// Generates the request path expression.
  Expression _generatePath(MethodElement m, ConstantReader method) {
    final paths = _getAnnotations(m, retrofit.Path);
    var definePath = method.peek('path')?.stringValue;
    paths.forEach((k, v) {
      final value = v.peek('value')?.stringValue ?? k.displayName;
      definePath = definePath?.replaceAll(
        '{$value}',
        "\${${k.displayName}${k.type.element?.kind == ElementKind.ENUM
            ? _hasToJson(k.type)
                  ? '.toJson()'
                  : ''
            : ''}}",
      );
    });
    return literal(definePath);
  }

  /// Checks if the return type is Future.
  bool _isReturnTypeFuture(String type) => type.startsWith('Future<');

  /// Generates the HTTP request code block.
  Code _generateRequest(
    MethodElement m,
    ConstantReader httpMethod,
    InterfaceType? callAdapter,
  ) {
    var returnAsyncWrapper = m.returnType.isDartAsyncFuture
        ? 'return'
        : 'yield';
    if (callAdapter != null) {
      final callAdapterOriginalReturnType =
          callAdapter.superclass?.typeArguments.firstOrNull as InterfaceType?;
      returnAsyncWrapper =
          _isReturnTypeFuture(
            callAdapterOriginalReturnType?.getDisplayString() ?? '',
          )
          ? 'return'
          : 'yield';
    }
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

    final preventNullToAbsent = _getMethodAnnotationByType(
      m,
      retrofit.PreventNullToAbsent,
    );

    if (preventNullToAbsent == null && headers.isNotEmpty) {
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
      extraOptions[_contentType] = literal(
        contentType.peek('mime')?.stringValue,
      );
    }

    /// gen code for request body for content-type on Protobuf body
    final annotation = _getAnnotation(m, retrofit.Body);
    final bodyName = annotation?.element;
    if (bodyName != null) {
      if (_isAssignable(protobuf.GeneratedMessage, bodyName.type)) {
        extraOptions[_contentType] = literal(
          'application/x-protobuf; \${${bodyName.displayName}.info_.qualifiedMessageName == "" ? "" :"messageType=\${${bodyName.displayName}.info_.qualifiedMessageName}"}',
        );
      }
    }

    extraOptions[_baseUrlVar] = refer(_baseUrlVar);

    final responseTypeAnnotation = _getResponseTypeAnnotation(m);
    ResponseType? parsedResponseType;
    if (responseTypeAnnotation != null) {
      final v = responseTypeAnnotation.peek('responseType')?.objectValue;
      log.info('ResponseType  :  ${v?.getField('index')?.toIntValue()}');
      final rsType = ResponseType.values.firstWhere(
        (it) =>
            responseTypeAnnotation
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

      parsedResponseType = rsType;
      extraOptions['responseType'] = refer(rsType.toString());

      // Validate that ResponseType.stream requires Stream<Uint8List> or Stream<String> return type
      if (rsType == ResponseType.stream) {
        if (!_isValidStreamResponseType(m.returnType)) {
          throw InvalidGenerationSourceError(
            'When using @DioResponseType(ResponseType.stream), the return type must be Stream<Uint8List> or Stream<String>. '
            'Got: ${_displayString(m.returnType)}',
            element: m,
            todo:
                'Change the return type to Stream<Uint8List> or Stream<String> when using ResponseType.stream',
          );
        }
      }
    }
    final namedArguments = <String, Expression>{};
    namedArguments[_queryParamsVar] = refer(_queryParamsVar);
    namedArguments[_path] = path;
    namedArguments[_dataVar] = refer(_localDataVar);

    final cancelToken = _getAnnotation(m, retrofit.CancelRequest);
    if (cancelToken != null) {
      namedArguments[_cancelToken] = refer(cancelToken.element.displayName);
    }

    final sendProgress = _getAnnotation(m, retrofit.SendProgress);
    if (sendProgress != null) {
      namedArguments[_onSendProgress] = refer(sendProgress.element.displayName);
    }

    final receiveProgress = _getAnnotation(m, retrofit.ReceiveProgress);
    if (receiveProgress != null) {
      namedArguments[_onReceiveProgress] = refer(
        receiveProgress.element.displayName,
      );
    }

    blocks.add(
      declareFinal(_optionsVar)
          .assign(_parseOptions(m, namedArguments, blocks, extraOptions))
          .statement,
    );

    final options = refer(_optionsVar).expression;

    final wrappedReturnType = _getResponseType(
      callAdapter != null
          ? callAdapter.superclass!.typeArguments.first
          : m.returnType,
    );
    final isWrappedWithHttpResponseWrapper =
        wrappedReturnType != null &&
        _isExactly(retrofit.HttpResponse, wrappedReturnType);

    final returnType = isWrappedWithHttpResponseWrapper
        ? _getResponseType(wrappedReturnType)
        : wrappedReturnType;
    if (returnType == null || 'void' == returnType.toString()) {
      if (isWrappedWithHttpResponseWrapper) {
        blocks
          ..add(
            refer(
              'final $_resultVar = await $_dioVar.fetch',
            ).call([options], {}, [refer('void')]).statement,
          )
          ..add(
            Code('''
final httpResponse = HttpResponse(null, $_resultVar);
$returnAsyncWrapper httpResponse;
'''),
          );
      } else {
        blocks.add(
          refer(
            'await $_dioVar.fetch',
          ).call([options], {}, [refer('void')]).statement,
        );
      }
    } else if (parsedResponseType == ResponseType.stream &&
        _isValidStreamResponseType(m.returnType)) {
      // Handle Stream<Uint8List> or Stream<String> return type with ResponseType.stream
      // Dio returns ResponseBody when ResponseType.stream is used,
      // we extract the stream from it
      blocks.add(
        declareFinal(_resultVar)
            .assign(refer('await $_dioVar.fetch<ResponseBody>').call([options]))
            .statement,
      );

      if (_isStreamOfString(m.returnType)) {
        // For Stream<String>, decode the bytes to strings using utf8.decode
        blocks.add(
          Code('''
final $_valueVar = $_resultVar.data!.stream.map(utf8.decode);
$returnAsyncWrapper* $_valueVar;
'''),
        );
      } else {
        // For Stream<Uint8List>, return the raw stream
        blocks.add(
          Code('''
final $_valueVar = $_resultVar.data!.stream;
$returnAsyncWrapper* $_valueVar;
'''),
        );
      }
    } else {
      final innerReturnType = _getResponseInnerType(returnType);
      if (_isUint8List(returnType)) {
        // Handle Uint8List return type (typically used with ResponseType.bytes)
        // Dio returns Uint8List directly when ResponseType.bytes is used,
        // so we can avoid wasteful casting
        blocks.add(
          declareFinal(_resultVar)
              .assign(
                refer(
                  'await $_dioVar.fetch<${_displayString(returnType)}>',
                ).call([options]),
              )
              .statement,
        );

        _wrapInTryCatch(
          blocks,
          options,
          returnType,
          refer(_valueVar)
              .assign(
                refer(
                  '$_resultVar.data',
                ).asNoNullIf(returnNullable: returnType.isNullable),
              )
              .statement,
        );
      } else if (_isExactly(List, returnType) ||
          _isExactly(BuiltList, returnType)) {
        if (_isBasicType(innerReturnType)) {
          blocks.add(
            declareFinal(_resultVar)
                .assign(
                  refer('await $_dioVar.fetch<List<dynamic>>').call([options]),
                )
                .statement,
          );

          _wrapInTryCatch(
            blocks,
            options,
            returnType,
            refer(_valueVar)
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
                            withNullability:
                                innerReturnType?.isNullable ?? false,
                          ),
                        ),
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
            _wrapInTryCatch(
              blocks,
              options,
              returnType,
              refer(_valueVar)
                  .assign(
                    refer('$_resultVar.data').conditionalIsNullIf(
                      thisNullable: returnType.isNullable,
                      whenFalse: refer('await compute').call([
                        refer(
                          'deserialize${_displayString(innerReturnType)}List',
                        ),
                        refer('$_resultVar.data!.cast<Map<String, dynamic>>()'),
                      ]),
                    ),
                  )
                  .statement,
            );
          } else {
            final castType = _isEnum(innerReturnType)
                ? 'String'
                : 'Map<String, dynamic>';

            final Reference mapperCode;
            switch (clientAnnotation.parser) {
              case retrofit.Parser.MapSerializable:
                mapperCode = refer(
                  '(dynamic i) => ${_displayString(innerReturnType)}.fromMap(i as $castType)',
                );
              case retrofit.Parser.JsonSerializable:
                if (innerReturnType?.isNullable ?? false) {
                  mapperCode = refer(
                    '(dynamic i) => i == null ? null : ${_displayString(innerReturnType)}.fromJson(i as $castType)',
                  );
                } else {
                  mapperCode = refer(
                    '(dynamic i) => ${_displayString(innerReturnType)}.fromJson(i as $castType)',
                  );
                }
              case retrofit.Parser.DartJsonMapper:
                mapperCode = refer(
                  '(dynamic i) => JsonMapper.fromMap<${_displayString(innerReturnType)}>(i as $castType)!',
                );
              case retrofit.Parser.DartMappable:
                mapperCode = refer(
                  '(dynamic i) => ${_displayString(innerReturnType)}Mapper.fromMap(i as $castType)',
                );
              case retrofit.Parser.FlutterCompute:
                throw Exception('Unreachable code');
            }

            _wrapInTryCatch(
              blocks,
              options,
              returnType,
              refer(_valueVar)
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
      } else if (_isExactly(Map, returnType) ||
          _isExactly(BuiltMap, returnType)) {
        final types = _getResponseInnerTypes(returnType)!;
        blocks.add(
          declareFinal(_resultVar)
              .assign(
                refer(
                  'await $_dioVar.fetch<Map<String, dynamic>>',
                ).call([options]),
              )
              .statement,
        );

        /// assume the first type is a basic type
        if (types.length > 1) {
          final firstType = types[0];
          final secondType = types[1];
          if (_isExactly(List, secondType) ||
              _isExactly(BuiltList, secondType)) {
            final type = _getResponseType(secondType);
            final Reference mapperCode;
            var future = false;
            switch (clientAnnotation.parser) {
              case retrofit.Parser.MapSerializable:
                final hasGenericArgs = _hasGenericArguments(type);
                final fromMapCall = hasGenericArgs
                    ? '${_displayString(type)}.fromMap(i as Map<String, dynamic>, ${_getInnerJsonSerializableMapperFn(type!)})'
                    : '${_displayString(type)}.fromMap(i as Map<String, dynamic>)';
                mapperCode = refer('''
(k, dynamic v) =>
    MapEntry(
      k, (v as List)
        .map((i) => $fromMapCall)
        .toList()
    )
''');
              case retrofit.Parser.JsonSerializable:
                final hasGenericArgs = _hasGenericArguments(type);
                final fromJsonCall = hasGenericArgs
                    ? '${_displayString(type)}.fromJson(i as Map<String, dynamic>, ${_getInnerJsonSerializableMapperFn(type!)})'
                    : '${_displayString(type)}.fromJson(i as Map<String, dynamic>)';
                mapperCode = refer('''
(k, dynamic v) =>
    MapEntry(
      k, (v as List)
        .map((i) => $fromJsonCall)
        .toList()
    )
''');
              case retrofit.Parser.DartJsonMapper:
                mapperCode = refer('''
(k, dynamic v) =>
    MapEntry(
      k, (v as List)
        .map((i) => JsonMapper.fromMap<${_displayString(type)}>(i as Map<String, dynamic>)!)
        .toList()
    )
''');
              case retrofit.Parser.DartMappable:
                mapperCode = refer('''
(k, dynamic v) =>
    MapEntry(
      k, (v as List)
        .map((i) => ${_displayString(type)}Mapper.fromMap(i as Map<String, dynamic>))
        .toList()
    )
''');
              case retrofit.Parser.FlutterCompute:
                log.warning('''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''');
                future = true;
                mapperCode = refer(
                  '(e) async => MapEntry( e.key, await compute(deserialize${_displayString(type)}List, (e.value as List).cast<Map<String, dynamic>>()))',
                );
            }
            if (future) {
              _wrapInTryCatch(
                blocks,
                options,
                returnType,
                refer(_valueVar)
                    .assign(
                      refer('Map.fromEntries').call([
                        refer('await Future.wait').call([
                          refer(
                            '$_resultVar.data!.entries.map',
                          ).call([mapperCode]),
                        ]),
                      ]),
                    )
                    .statement,
              );
            } else {
              _wrapInTryCatch(
                blocks,
                options,
                returnType,
                refer(_valueVar)
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
                final hasGenericArgs = _hasGenericArguments(secondType);
                final fromMapCall = hasGenericArgs
                    ? '${_displayString(secondType)}.fromMap(v as Map<String, dynamic>, ${_getInnerJsonSerializableMapperFn(secondType)})'
                    : '${_displayString(secondType)}.fromMap(v as Map<String, dynamic>)';
                mapperCode = refer(
                  '(k, dynamic v) => MapEntry(k, $fromMapCall)',
                );
              case retrofit.Parser.JsonSerializable:
                final hasGenericArgs = _hasGenericArguments(secondType);
                final fromJsonCall = hasGenericArgs
                    ? '${_displayString(secondType)}.fromJson(v as Map<String, dynamic>, ${_getInnerJsonSerializableMapperFn(secondType)})'
                    : '${_displayString(secondType)}.fromJson(v as Map<String, dynamic>)';
                mapperCode = refer(
                  '(k, dynamic v) => MapEntry(k, $fromJsonCall)',
                );

              case retrofit.Parser.DartJsonMapper:
                mapperCode = refer(
                  '(k, dynamic v) => MapEntry(k, JsonMapper.fromMap<${_displayString(secondType)}>(v as Map<String, dynamic>)!)',
                );
              case retrofit.Parser.DartMappable:
                mapperCode = refer(
                  '(k, dynamic v) => MapEntry(k, ${_displayString(secondType)}Mapper.fromMap(v as Map<String, dynamic>))',
                );
              case retrofit.Parser.FlutterCompute:
                log.warning('''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''');
                future = true;
                mapperCode = refer(
                  '(e) async => MapEntry(e.key, await compute(deserialize${_displayString(secondType)}, e.value as Map<String, dynamic>))',
                );
            }
            if (future) {
              _wrapInTryCatch(
                blocks,
                options,
                returnType,
                refer(_valueVar)
                    .assign(
                      refer('$_resultVar.data').conditionalIsNullIf(
                        thisNullable: returnType.isNullable,
                        whenFalse: refer('Map.fromEntries').call([
                          refer('await Future.wait').call([
                            refer(
                              '$_resultVar.data!.entries.map',
                            ).call([mapperCode]),
                          ]),
                        ]),
                      ),
                    )
                    .statement,
              );
            } else {
              _wrapInTryCatch(
                blocks,
                options,
                returnType,
                refer(_valueVar)
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
            _wrapInTryCatch(
              blocks,
              options,
              returnType,
              refer(_valueVar)
                  .assign(
                    refer('$_resultVar.data')
                        .propertyIf(
                          thisNullable: returnType.isNullable,
                          name: 'cast',
                        )
                        .call([], {}, [
                          refer(
                            _displayString(firstType, withNullability: true),
                          ),
                          refer(
                            _displayString(secondType, withNullability: true),
                          ),
                        ]),
                  )
                  .statement,
            );
          }
        } else {
          blocks.add(const Code('final $_valueVar = $_resultVar.data!;'));
        }
      } else {
        if (_isBasicType(returnType)) {
          blocks.add(
            declareFinal(_resultVar)
                .assign(
                  refer(
                    'await $_dioVar.fetch<${_displayString(returnType)}>',
                  ).call([options]),
                )
                .statement,
          );

          _wrapInTryCatch(
            blocks,
            options,
            returnType,
            refer(_valueVar)
                .assign(
                  refer(
                    '$_resultVar.data',
                  ).asNoNullIf(returnNullable: returnType.isNullable),
                )
                .statement,
          );
        } else if (returnType is DynamicType || returnType.isDartCoreObject) {
          blocks
            ..add(
              declareFinal(
                _resultVar,
              ).assign(refer('await $_dioVar.fetch').call([options])).statement,
            )
            ..add(const Code('final $_valueVar = $_resultVar.data;'));
        } else if (returnType is TypeParameterType) {
          // Handle bare type parameters like Future<T> get<T>()
          // Since we don't know the concrete type at code generation time,
          // we cast the data to the type parameter
          log.warning(
            'Using a bare type parameter (${_displayString(returnType, withNullability: true)}) as return type. '
            'The response data will be cast to ${_displayString(returnType, withNullability: true)} without deserialization. '
            'For complex types, consider using a wrapper class with @JsonSerializable(genericArgumentFactories: true). '
            'See https://github.com/trevorwang/retrofit.dart/blob/master/example/lib/api_result.dart for an example.',
          );
          blocks
            ..add(
              declareFinal(
                _resultVar,
              ).assign(refer('await $_dioVar.fetch').call([options])).statement,
            )
            ..add(
              Code(
                'final $_valueVar = $_resultVar.data as ${_displayString(returnType, withNullability: true)};',
              ),
            );
        } else if (_isSuperOf(protobuf.GeneratedMessage, returnType)) {
          blocks
            ..add(
              declareFinal(_resultVar)
                  .assign(
                    refer('await $_dioVar.fetch<List<int>>').call([options]),
                  )
                  .statement,
            )
            ..add(
              Code(
                'final $_valueVar = await compute(${_displayString(returnType)}.fromBuffer, $_resultVar.data!);',
              ),
            );
        } else {
          final fromJsonParamType = _getFromJsonParameterType(returnType);
          final baseFetchType =
              fromJsonParamType ??
              (_isEnum(returnType) ? 'String' : 'Map<String, dynamic>');
          final fetchType = returnType.isNullable
              ? '$baseFetchType?'
              : baseFetchType;
          blocks.add(
            declareFinal(_resultVar)
                .assign(
                  refer(
                    'await $_dioVar'
                    '.fetch<$fetchType>',
                  ).call([options]),
                )
                .statement,
          );
          Expression mapperCode;
          switch (clientAnnotation.parser) {
            case retrofit.Parser.MapSerializable:
              mapperCode = refer(
                '${_displayString(returnType)}.fromMap($_resultVar.data!)',
              );
            case retrofit.Parser.JsonSerializable:
              final genericArgumentFactories = isGenericArgumentFactories(
                returnType,
              );
              final typeArgs = returnType is ParameterizedType
                  ? returnType.typeArguments
                  : <DartType>[];

              if (typeArgs.isNotEmpty && genericArgumentFactories) {
                // Remove the outermost nullable modifier
                // see NullableDynamicNullableInnerGenericTypeShouldBeCastedAsMap from generator/test/src/generator_test_src.dart:2139
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
                if (_isEnum(returnType) && !_hasFromJson(returnType)) {
                  mapperCode = refer(
                    '${_displayString(returnType)}.values.firstWhere((e) => e.name == _result.data, '
                    'orElse: () => throw ArgumentError( '
                    "'${_displayString(returnType)} does not contain value \${_result.data}', "
                    '),'
                    ')',
                  );
                } else {
                  mapperCode = refer(
                    '${_displayString(returnType)}.fromJson($_resultVar.data!)',
                  );
                }
              }
            case retrofit.Parser.DartJsonMapper:
              mapperCode = refer(
                'JsonMapper.fromMap<${_displayString(returnType)}>($_resultVar.data!)!',
              );
            case retrofit.Parser.DartMappable:
              mapperCode = refer(
                '${_displayString(returnType)}Mapper.fromMap($_resultVar.data!)',
              );
            case retrofit.Parser.FlutterCompute:
              mapperCode = refer(
                'await compute(deserialize${_displayString(returnType).replaceFirst('<', '').replaceFirst('>', '')}, $_resultVar.data!)',
              );
          }
          _wrapInTryCatch(
            blocks,
            options,
            returnType,
            refer(_valueVar)
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
      if (isWrappedWithHttpResponseWrapper) {
        blocks.add(
          Code('''
final httpResponse = HttpResponse($_valueVar, $_resultVar);
$returnAsyncWrapper httpResponse;
'''),
        );
      } else {
        blocks.add(Code('$returnAsyncWrapper $_valueVar;'));
      }
    }

    return Block.of(blocks);
  }

  /// Checks if a type has generic arguments and requires generic argument factories.
  bool _hasGenericArguments(DartType? type) {
    if (type == null) {
      return false;
    }
    final typeArgs = type is ParameterizedType
        ? type.typeArguments
        : <DartType>[];
    return typeArgs.isNotEmpty && isGenericArgumentFactories(type);
  }

  /// Checks if the type requires generic argument factories.
  bool isGenericArgumentFactories(DartType? dartType) {
    final metaData = dartType?.element?.firstFragment is ClassFragment
        ? (dartType!.element!.firstFragment as ClassFragment)
              .metadata
              .annotations
        : null;
    if (metaData == null || dartType == null) {
      return false;
    }
    final constDartObj = metaData.isNotEmpty
        ? metaData.first.computeConstantValue()
        : null;
    var genericArgumentFactories = false;
    if (constDartObj != null &&
        (!_isExactly(List, dartType) && !_isExactly(BuiltList, dartType))) {
      try {
        final annotation = ConstantReader(constDartObj);
        final obj = annotation.peek('genericArgumentFactories');
        genericArgumentFactories = obj?.boolValue ?? false;
      } on Object {
        //
      }
    }

    return genericArgumentFactories ||
        hasGenericArgumentFactoriesCompatibleSignature(dartType);
  }

  /// Checks for a compatible fromJson signature for generic argument factories
  /// Checks if the type has a compatible fromJson generic argument factory signature.
  bool hasGenericArgumentFactoriesCompatibleSignature(DartType? dartType) {
    if (dartType == null) {
      return false;
    }
    final element = dartType.element;
    if (element is! InterfaceElement) {
      return false;
    }

    final typeParameters = element.typeParameters;
    if (typeParameters.isEmpty) {
      return false;
    }

    final constructors = element.constructors;
    if (constructors.isEmpty) {
      return false;
    }
    final fromJson = constructors.firstWhereOrNull(
      (constructor) => constructor.name == 'fromJson',
    );

    if (fromJson == null || fromJson.formalParameters.length == 1) {
      return false;
    }

    final fromJsonArguments = fromJson.formalParameters;

    if (typeParameters.length != (fromJsonArguments.length - 1)) {
      return false;
    }
    return true;
  }

  /// Gets the mapping function for JsonSerializable generic arguments.
  String _getInnerJsonSerializableMapperFn(DartType dartType) {
    final typeArgs = dartType is ParameterizedType
        ? dartType.typeArguments
        : <DartType>[];
    if (typeArgs.isNotEmpty) {
      if (_isExactly(List, dartType) || _isExactly(BuiltList, dartType)) {
        final genericType = _getResponseType(dartType);
        final typeArgs = genericType is ParameterizedType
            ? genericType.typeArguments
            : <DartType>[];
        String mapperVal;

        final genericTypeString = _displayString(genericType);

        if (typeArgs.isNotEmpty &&
            isGenericArgumentFactories(genericType) &&
            genericType != null) {
          mapperVal =
              '''
(json) => json is List<dynamic>
    ? json
          .map<$genericTypeString>((i) => $genericTypeString.fromJson(i as Map<String, dynamic>,${_getInnerJsonSerializableMapperFn(genericType)}))
          .toList()
    : List.empty(),
''';
        } else {
          if (_isBasicType(genericType)) {
            mapperVal =
                '''
(json) => json is List<dynamic>
  ? json.map<$genericTypeString>((i) => i as $genericTypeString).toList()
  : List.empty(),
    ''';
          } else {
            mapperVal =
                '''
(json) => json is List<dynamic>
      ? json.map<$genericTypeString>((i) => ${genericTypeString == 'dynamic' ? 'i' : '$genericTypeString.fromJson(i as Map<String, dynamic>)'}).toList()
      : List.empty(),
''';
          }
        }
        return mapperVal;
      } else {
        var mappedVal = '';
        for (final arg in typeArgs) {
          final typeArgs = arg is ParameterizedType
              ? arg.typeArguments
              : <DartType>[];
          if (typeArgs.isNotEmpty) {
            if (_isExactly(List, arg) || _isExactly(BuiltList, arg)) {
              mappedVal += _getInnerJsonSerializableMapperFn(arg);
            } else {
              if (isGenericArgumentFactories(arg)) {
                mappedVal +=
                    '(json) => ${_displayString(arg)}.fromJson(json as Map<String, dynamic>, ${_getInnerJsonSerializableMapperFn(arg)}),';
              } else {
                mappedVal +=
                    '(json) => ${_displayString(arg)}.fromJson(json as Map<String, dynamic>),';
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
        return '(json) => json as ${_displayString(dartType, withNullability: dartType.isNullable)},';
      } else {
        if (_displayString(dartType) == 'void') {
          return '(json) => (){}(),';
        } else {
          if (dartType.isNullable) {
            return '(json) => json == null ? null : ${_displayString(dartType)}.fromJson(json as Map<String, dynamic>),';
          } else {
            return '(json) => ${_displayString(dartType)}.fromJson(json as Map<String, dynamic>),';
          }
        }
      }
    }
  }

  /// Gets the deserialization mapping function for JsonSerializable generic arguments.
  String _getInnerJsonDeSerializableMapperFn(DartType dartType) {
    final typeArgs = dartType is ParameterizedType
        ? dartType.typeArguments
        : <DartType>[];
    if (typeArgs.isNotEmpty) {
      if (_isExactly(List, dartType) || _isExactly(BuiltList, dartType)) {
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
          final typeArgs = arg is ParameterizedType
              ? arg.typeArguments
              : <DartType>[];
          if (typeArgs.isNotEmpty) {
            if (_isExactly(List, arg) || _isExactly(BuiltList, arg)) {
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

  /// Parses the request Options.
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

      final type = refer(
        _displayString(_getResponseType(m.returnType), withNullability: true),
      );

      final composeArguments = <String, Expression>{
        _queryParamsVar: queryParams,
        _dataVar: dataVar,
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

      return refer('_setStreamType').call(
        [
          refer('Options')
              .newInstance([], args)
              .property('compose')
              .call([
                refer(_dioVar).property('options'),
                path,
              ], composeArguments)
              .property('copyWith')
              .call([], {
                _baseUrlVar: refer('_combineBaseUrls').call([
                  refer(_dioVar).property('options').property('baseUrl'),
                  baseUrl,
                ]),
              }),
        ],
        {},
        [type],
      );
    } else {
      hasCustomOptions = true;
      blocks.add(
        declareFinal('newOptions')
            .assign(
              refer(
                'newRequestOptions',
              ).call([refer(annoOptions.element.displayName)]),
            )
            .statement,
      );
      final newOptions = refer('newOptions');
      blocks
        ..add(
          newOptions.property(_extraVar).property('addAll').call([
            extraOptions.remove(_extraVar)!,
          ]).statement,
        )
        ..add(
          newOptions.property('headers').property('addAll').call([
            refer(_dioVar).property('options').property('headers'),
          ]).statement,
        )
        ..add(
          newOptions.property('headers').property('addAll').call([
            extraOptions.remove('headers')!,
          ]).statement,
        );
      return newOptions
          .property('copyWith')
          .call(
            [],
            Map.from(extraOptions)
              ..[_queryParamsVar] = namedArguments[_queryParamsVar]!
              ..[_path] = namedArguments[_path]!
              ..[_baseUrlVar] = refer('_combineBaseUrls').call([
                refer(_dioVar).property('options').property('baseUrl'),
                extraOptions.remove(_baseUrlVar)!,
              ]),
          )
          .cascade('data')
          .assign(namedArguments[_dataVar]!);
    }
  }

  /// Generates the Options cast method.
  Method _generateOptionsCastMethod() => Method((m) {
    m
      ..name = 'newRequestOptions'
      ..returns = refer('RequestOptions')
      /// required parameters
      ..requiredParameters.add(
        Parameter((p) {
          p
            ..name = 'options'
            ..type = refer('Object?');
        }),
      )
      /// add method body
      ..body = const Code('''
if (options is RequestOptions) {
  return options;
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

  /// Generates the BaseUrl combine method.
  Method _generateCombineBaseUrlsMethod() => Method((m) {
    final dioBaseUrlParam = Parameter((p) {
      p
        ..name = 'dioBaseUrl'
        ..type = refer('String');
    });
    final baseUrlParam = Parameter((p) {
      p
        ..name = 'baseUrl'
        ..type = refer('String?');
    });

    m
      ..name = '_combineBaseUrls'
      ..returns = refer('String')
      ..requiredParameters = ListBuilder(<Parameter>[
        dioBaseUrlParam,
        baseUrlParam,
      ])
      ..body = const Code('''
if (baseUrl == null || baseUrl.trim().isEmpty) {
  return dioBaseUrl;
}

final url = Uri.parse(baseUrl);

if (url.isAbsolute) {
  return url.toString();
}

return Uri.parse(dioBaseUrl).resolveUri(url).toString();
''');
  });

  /// Generates the type setter method.
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
        !(requestOptions.responseType == ResponseType.bytes || requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
''');
  });

  /// Checks if the type is a basic type.
  bool _isBasicType(DartType? t) {
    if (!_isInterfaceType(t)) {
      return false;
    }
    return _isExactly(String, t) ||
        _isExactly(bool, t) ||
        _isExactly(int, t) ||
        _isExactly(double, t) ||
        _isExactly(num, t) ||
        _isExactly(ffi.Double, t) ||
        _isExactly(ffi.Float, t) ||
        _isExactly(BigInt, t) ||
        _isExactly(ffi.Long, t) ||
        _isExactly(Object, t);
  }

  /// Checks if the type is an enum.
  bool _isEnum(DartType? dartType) {
    if (dartType == null || dartType.element == null) {
      return false;
    }
    return dartType.element is EnumElement;
  }

  /// Checks if the type is an extension type.
  bool _isExtensionType(DartType? dartType) {
    if (dartType is! InterfaceType) {
      return false;
    }
    final element = dartType.element;
    return element is ExtensionTypeElement;
  }

  /// Gets the representation type (underlying type) of an extension type.
  /// Returns null if the type is not an extension type.
  DartType? _getExtensionTypeRepresentation(DartType? dartType) {
    if (dartType is! InterfaceType) {
      return null;
    }

    if (dartType.element case final ExtensionTypeElement element) {
      return element.representation.type;
    }

    return null;
  }

  /// Checks if the type is MultipartFile.
  bool _isMultipartFile(DartType? t) => _isAssignable(MultipartFile, t);

  /// Checks if the type is Uint8List.
  bool _isUint8List(DartType? t) => _isExactly(typed_data.Uint8List, t);

  /// Checks if the type is `Stream<Uint8List>`.
  bool _isStreamOfUint8List(DartType? t) {
    if (t == null || !_isExactly(Stream, t)) {
      return false;
    }
    final innerType = _genericOf(t);
    return _isUint8List(innerType);
  }

  /// Checks if the type is `Stream<String>`.
  bool _isStreamOfString(DartType? t) {
    if (t == null || !_isExactly(Stream, t)) {
      return false;
    }
    final innerType = _genericOf(t);
    return _isExactly(String, innerType);
  }

  /// Checks if the type is a valid stream type for ResponseType.stream.
  /// Valid types are `Stream<Uint8List>` or `Stream<String>`.
  bool _isValidStreamResponseType(DartType? t) {
    return _isStreamOfUint8List(t) || _isStreamOfString(t);
  }

  /// Checks if the type is DateTime.
  bool _isDateTime(DartType? t) => _isExactly(DateTime, t);

  /// Checks if the inner type of the return type is a basic type.
  bool _isBasicInnerType(DartType returnType) {
    final innerType = _genericOf(returnType);
    return _isBasicType(innerType);
  }

  /// Checks if the type has a fromJson method.
  bool _hasFromJson(DartType? dartType) {
    if (dartType is! InterfaceType) {
      return false;
    }
    return dartType.element.getNamedConstructor('fromJson') != null;
  }

  /// Gets the parameter type of fromJson constructor.
  /// Returns the type of the first parameter of fromJson, or null if not found.
  String? _getFromJsonParameterType(DartType? dartType) {
    if (dartType is! InterfaceType) {
      return null;
    }
    final fromJsonConstructor = dartType.element.getNamedConstructor(
      'fromJson',
    );
    if (fromJsonConstructor == null) {
      return null;
    }
    final parameters = fromJsonConstructor.formalParameters;
    if (parameters.isEmpty) {
      return null;
    }
    return _displayString(parameters.first.type);
  }

  /// Checks if the type has a toJson method.
  bool _hasToJson(DartType? dartType) {
    if (dartType is! InterfaceType) {
      return false;
    }
    // Use lookUpMethod to check the class hierarchy including mixins
    // This is important for Freezed-generated classes where toJson is in a mixin
    return dartType.element.lookUpMethod(
          name: 'toJson',
          library: dartType.element.library,
        ) !=
        null;
  }

  /// Gets the expression for serializing an enum value in FormData as a string.
  /// Uses toJson() if available, otherwise uses .name.
  String _getEnumValueExpression(DartType enumType, String variableName) {
    return _hasToJson(enumType)
        ? '$variableName.toJson()'
        : '$variableName.name';
  }

  /// Gets the Reference for serializing an enum value in FormData.
  /// Uses toJson() if available, otherwise uses .name.
  Expression _getEnumValueReference(DartType enumType, String variableName) {
    return _hasToJson(enumType)
        ? refer(variableName).property('toJson').call([])
        : refer(variableName).property('name');
  }

  /// Generates the query parameters code block.
  void _generateQueries(
    MethodElement m,
    List<Code> blocks,
    String queryParamsVar,
  ) {
    final queries = _getAnnotations(m, retrofit.Query);
    final queryParameters = queries.map((p, r) {
      final key = r.peek('value')?.stringValue ?? p.displayName;
      final Expression value;

      // Handle extension types
      if (_isExtensionType(p.type)) {
        final hasToJson = _hasToJson(p.type);
        if (hasToJson) {
          // Extension type with toJson method - use toJson
          value = p.type.nullabilitySuffix == NullabilitySuffix.question
              ? refer(p.displayName).nullSafeProperty('toJson').call([])
              : refer(p.displayName).property('toJson').call([]);
        } else {
          // Extension type without toJson - use the underlying representation type
          final representationType = _getExtensionTypeRepresentation(p.type);
          if (representationType != null &&
              (_isBasicType(representationType) ||
                  representationType.isDartCoreList ||
                  representationType.isDartCoreMap)) {
            // If the representation type is basic, use the value directly
            value = refer(p.displayName);
          } else {
            // Otherwise, follow the normal serialization logic for the representation type
            switch (clientAnnotation.parser) {
              case retrofit.Parser.JsonSerializable:
                value = p.type.nullabilitySuffix == NullabilitySuffix.question
                    ? refer(p.displayName).nullSafeProperty('toJson').call([])
                    : refer(p.displayName).property('toJson').call([]);
              case retrofit.Parser.MapSerializable:
                value = p.type.nullabilitySuffix == NullabilitySuffix.question
                    ? refer(p.displayName).nullSafeProperty('toMap').call([])
                    : refer(p.displayName).property('toMap').call([]);
              case retrofit.Parser.DartJsonMapper:
                value = refer(p.displayName);
              case retrofit.Parser.DartMappable:
                value = p.type.nullabilitySuffix == NullabilitySuffix.question
                    ? refer(p.displayName).nullSafeProperty('toMap').call([])
                    : refer(p.displayName).property('toMap').call([]);
              case retrofit.Parser.FlutterCompute:
                value = refer(
                  'await compute(serialize${_displayString(p.type)}, ${p.displayName})',
                );
            }
          }
        }
      } else if (_isBasicType(p.type) ||
          p.type.isDartCoreList ||
          p.type.isDartCoreMap) {
        value = refer(p.displayName);
      } else if (_isSuperOf(protobuf.ProtobufEnum, p.type)) {
        value = p.type.nullabilitySuffix == NullabilitySuffix.question
            ? refer(p.displayName).nullSafeProperty('value')
            : refer(p.displayName).property('value');
      } else {
        switch (clientAnnotation.parser) {
          case retrofit.Parser.JsonSerializable:
            if (_isDateTime(p.type)) {
              value = p.type.nullabilitySuffix == NullabilitySuffix.question
                  ? refer(
                      p.displayName,
                    ).nullSafeProperty('toIso8601String').call([])
                  : refer(p.displayName).property('toIso8601String').call([]);
            } else if (_isEnum(p.type) && !_hasToJson(p.type)) {
              value = p.type.nullabilitySuffix == NullabilitySuffix.question
                  ? refer(p.displayName)
                  : refer(p.displayName);
            } else {
              value = p.type.nullabilitySuffix == NullabilitySuffix.question
                  ? refer(p.displayName).nullSafeProperty('toJson').call([])
                  : refer(p.displayName).property('toJson').call([]);
            }
          case retrofit.Parser.MapSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(p.displayName).nullSafeProperty('toMap').call([])
                : refer(p.displayName).property('toMap').call([]);
          case retrofit.Parser.DartJsonMapper:
            value = refer(p.displayName);
          case retrofit.Parser.DartMappable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(p.displayName).nullSafeProperty('toMap').call([])
                : refer(p.displayName).property('toMap').call([]);
          case retrofit.Parser.FlutterCompute:
            value = refer(
              'await compute(serialize${_displayString(p.type)}, ${p.displayName})',
            );
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

      // Handle extension types
      if (_isExtensionType(type)) {
        final hasToJson = _hasToJson(type);
        if (hasToJson) {
          // Extension type with toJson method - use toJson
          value = type.nullabilitySuffix == NullabilitySuffix.question
              ? refer(displayName).nullSafeProperty('toJson').call([])
              : refer(displayName).property('toJson').call([]);
        } else {
          // Extension type without toJson - use the underlying representation type
          final representationType = _getExtensionTypeRepresentation(type);
          if (representationType != null &&
              (_isBasicType(representationType) ||
                  representationType.isDartCoreList ||
                  representationType.isDartCoreMap)) {
            // If the representation type is basic, use the value directly
            value = refer(displayName);
          } else {
            // Otherwise, follow the normal serialization logic
            switch (clientAnnotation.parser) {
              case retrofit.Parser.JsonSerializable:
                value = type.nullabilitySuffix == NullabilitySuffix.question
                    ? refer(displayName).nullSafeProperty('toJson').call([])
                    : refer(displayName).property('toJson').call([]);
              case retrofit.Parser.MapSerializable:
                value = type.nullabilitySuffix == NullabilitySuffix.question
                    ? refer(displayName).nullSafeProperty('toMap').call([])
                    : refer(displayName).property('toMap').call([]);
              case retrofit.Parser.DartJsonMapper:
                value = refer(displayName);
              case retrofit.Parser.DartMappable:
                value = type.nullabilitySuffix == NullabilitySuffix.question
                    ? refer(displayName).nullSafeProperty('toMap').call([])
                    : refer(displayName).property('toMap').call([]);
              case retrofit.Parser.FlutterCompute:
                value = refer(
                  'await compute(serialize${_displayString(type)}, $displayName)',
                );
            }
          }
        }
      } else if (_isBasicType(type) ||
          type.isDartCoreList ||
          type.isDartCoreMap) {
        value = refer(displayName);
      } else if (_isSuperOf(protobuf.ProtobufEnum, type)) {
        value = type.nullabilitySuffix == NullabilitySuffix.question
            ? refer(p.displayName).nullSafeProperty('value')
            : refer(p.displayName).property('value');
      } else {
        switch (clientAnnotation.parser) {
          case retrofit.Parser.JsonSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toJson').call([])
                : refer(displayName).property('toJson').call([]);
          case retrofit.Parser.MapSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toMap').call([])
                : refer(displayName).property('toMap').call([]);
          case retrofit.Parser.DartJsonMapper:
            value = refer(displayName);
          case retrofit.Parser.DartMappable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toMap').call([])
                : refer(displayName).property('toMap').call([]);
          case retrofit.Parser.FlutterCompute:
            value = refer(
              'await compute(serialize${_displayString(p.type)}, ${p.displayName})',
            );
        }
      }

      final emitter = DartEmitter(useNullSafetySyntax: true);
      final buffer = StringBuffer();
      value.accept(emitter, buffer);
      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        refer('?? <String, dynamic>{}').accept(emitter, buffer);
      }
      final expression = refer(buffer.toString());

      blocks.add(refer('$queryParamsVar.addAll').call([expression]).statement);
    }

    final preventNullToAbsent = _getMethodAnnotationByType(
      m,
      retrofit.PreventNullToAbsent,
    );

    final anyNullable = m.formalParameters.any(
      (p) => p.type.nullabilitySuffix == NullabilitySuffix.question,
    );

    if (preventNullToAbsent == null && anyNullable) {
      blocks.add(Code('$queryParamsVar.removeWhere((k, v) => v == null);'));
    }
  }

  /// Generates the request body code block.
  void _generateRequestBody(
    List<Code> blocks,
    String dataVar,
    MethodElement m,
  ) {
    final noBody = _getMethodAnnotationByType(m, retrofit.NoBody);
    if (noBody != null) {
      blocks.add(
        declareFinal(
          dataVar,
          type: refer('String?'),
        ).assign(refer('null')).statement,
      );
      return;
    }
    var anyNullable = false;

    final preventNullToAbsent = _getMethodAnnotationByType(
      m,
      retrofit.PreventNullToAbsent,
    );

    final annotation = _getAnnotation(m, retrofit.Body);
    final bodyName = annotation?.element;

    final bodyExtraAnnotations = _getAnnotations(m, retrofit.BodyExtra);
    final bodyExtras = <Expression, Reference>{};
    final expandBodyExtras = <FormalParameterElement, ConstantReader>{};
    for (final item in bodyExtraAnnotations.entries) {
      final expand = item.value.peek('expand')?.boolValue ?? false;
      anyNullable |=
          item.key.type.nullabilitySuffix == NullabilitySuffix.question;
      final fieldName =
          item.value.peek('value')?.stringValue ?? item.key.displayName;
      if (expand) {
        expandBodyExtras[item.key] = item.value;
      } else {
        bodyExtras[literal(fieldName)] = refer(item.key.displayName);
      }
    }

    if (expandBodyExtras.length !=
        expandBodyExtras.keys.map((e) => e.displayName).toSet().length) {
      log.warning(
        'Multiple BodyExtra parameters with expand=true have the same type, which may cause field conflicts.',
      );
    }

    if (bodyName != null) {
      final nullToAbsent =
          annotation!.reader.peek('nullToAbsent')?.boolValue ?? false;
      if (_isAssignable(Map, bodyName.type)) {
        blocks.add(
          declareFinal(dataVar)
              .assign(literalMap(bodyExtras, refer('String'), refer('dynamic')))
              .statement,
        );
        if (bodyName.type.nullabilitySuffix == NullabilitySuffix.question) {
          blocks
            ..add(Code('if (${bodyName.displayName} != null) {'))
            ..add(
              refer(
                '$dataVar.addAll',
              ).call([refer('${bodyName.displayName}!')]).statement,
            )
            ..add(const Code('}'));
        } else {
          blocks.add(
            refer(
              '$dataVar.addAll',
            ).call([refer(bodyName.displayName)]).statement,
          );
        }
        if (preventNullToAbsent == null && nullToAbsent) {
          blocks.add(Code('$dataVar.removeWhere((k, v) => v == null);'));
        }
      } else if ((_isExactly(List, bodyName.type) ||
              _isExactly(BuiltList, bodyName.type)) &&
          !_isBasicInnerType(bodyName.type)) {
        final nullabilitySuffix =
            bodyName.type.nullabilitySuffix == NullabilitySuffix.question
            ? '?'
            : '';
        switch (clientAnnotation.parser) {
          case retrofit.Parser.JsonSerializable:
          case retrofit.Parser.DartJsonMapper:
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    refer('''
            ${bodyName.displayName}$nullabilitySuffix.map((e) => e.toJson()).toList()
            '''),
                  )
                  .statement,
            );
          case retrofit.Parser.MapSerializable:
          case retrofit.Parser.DartMappable:
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    refer('''
            ${bodyName.displayName}$nullabilitySuffix.map((e) => e.toMap()).toList()
            '''),
                  )
                  .statement,
            );
          case retrofit.Parser.FlutterCompute:
            final compute =
                'await compute(serialize${_displayString(_genericOf(bodyName.type))}List, ${bodyName.displayName})';
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    refer(
                      bodyName.type.nullabilitySuffix ==
                              NullabilitySuffix.question
                          ? '${bodyName.displayName} == null ? null: $compute'
                          : compute,
                    ),
                  )
                  .statement,
            );
        }
      } else if (_isSuperOf(protobuf.GeneratedMessage, bodyName.type)) {
        if (bodyName.type.nullabilitySuffix != NullabilitySuffix.none) {
          log.warning(
            'GeneratedMessage body ${_displayString(bodyName.type)} can not be nullable.',
          );
        }
        blocks.add(
          declareFinal(
            dataVar,
          ).assign(refer('${bodyName.displayName}.writeToBuffer()')).statement,
        );
      } else if (_isExactly(io.File, bodyName.type)) {
        blocks.add(
          declareFinal(
            dataVar,
          ).assign(refer('${bodyName.displayName}.openRead()')).statement,
        );
      } else if (bodyName.type.element is ClassElement) {
        final ele = bodyName.type.element! as ClassElement;
        if (clientAnnotation.parser == retrofit.Parser.MapSerializable) {
          final toMap = ele.lookUpMethod(name: 'toMap', library: ele.library);
          if (toMap == null) {
            log.warning(
              '${_displayString(bodyName.type)} must provide a `toMap()` method which return a Map.\n'
              "It is programmer's responsibility to make sure the ${bodyName.type} is properly serialized",
            );
            blocks.add(
              declareFinal(
                dataVar,
              ).assign(refer(bodyName.displayName)).statement,
            );
          } else {
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    literalMap(bodyExtras, refer('String'), refer('dynamic')),
                  )
                  .statement,
            );
            for (final item in expandBodyExtras.entries) {
              _generateParameterElement(item.key, blocks, dataVar);
            }
            blocks.add(
              refer('$dataVar.addAll').call([
                refer(
                  '${bodyName.displayName}?.toMap() ?? <String, dynamic>{}',
                ),
              ]).statement,
            );
          }
        } else {
          if (_missingToJson(ele)) {
            log.warning(
              '${_displayString(bodyName.type)} must provide a `toJson()` method which return a Map.\n'
              "It is programmer's responsibility to make sure the ${_displayString(bodyName.type)} is properly serialized",
            );
            blocks.add(
              declareFinal(
                dataVar,
              ).assign(refer(bodyName.displayName)).statement,
            );
          } else if (_missingSerialize(
            ele.enclosingElement.firstFragment,
            bodyName.type,
          )) {
            log.warning(
              '${_displayString(bodyName.type)} must provide a `serialize${_displayString(bodyName.type)}()` method which returns a Map.\n'
              "It is programmer's responsibility to make sure the ${_displayString(bodyName.type)} is properly serialized",
            );
            blocks.add(
              declareFinal(
                dataVar,
              ).assign(refer(bodyName.displayName)).statement,
            );
          } else {
            blocks.add(
              declareFinal(dataVar)
                  .assign(
                    literalMap(bodyExtras, refer('String'), refer('dynamic')),
                  )
                  .statement,
            );

            for (final item in expandBodyExtras.entries) {
              _generateParameterElement(item.key, blocks, dataVar);
            }

            final bodyType = bodyName.type;
            final genericArgumentFactories = isGenericArgumentFactories(
              bodyType,
            );

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
                      refer('${bodyName.displayName}.toJson($toJsonCode)'),
                    ]).statement,
                  );
                } else {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer(
                        '${bodyName.displayName}?.toJson($toJsonCode) ?? <String, dynamic>{}',
                      ),
                    ]).statement,
                  );
                }
              case retrofit.Parser.MapSerializable:
              case retrofit.Parser.DartMappable:
                if (bodyName.type.nullabilitySuffix !=
                    NullabilitySuffix.question) {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer('${bodyName.displayName}.toMap()'),
                    ]).statement,
                  );
                } else {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer(
                        '${bodyName.displayName}?.toMap() ?? <String, dynamic>{}',
                      ),
                    ]).statement,
                  );
                }
              case retrofit.Parser.FlutterCompute:
                if (bodyName.type.nullabilitySuffix !=
                    NullabilitySuffix.question) {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer(
                        'await compute(serialize${_displayString(bodyName.type)}, ${bodyName.displayName})',
                      ),
                    ]).statement,
                  );
                } else {
                  blocks.add(
                    refer('$dataVar.addAll').call([
                      refer(
                        '${bodyName.displayName} == null ? <String, dynamic>{} : await compute(serialize${_displayString(bodyName.type)}, ${bodyName.displayName})',
                      ),
                    ]).statement,
                  );
                }
            }

            if (preventNullToAbsent == null && nullToAbsent) {
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

    if (bodyExtras.isNotEmpty || expandBodyExtras.isNotEmpty) {
      blocks.add(
        declareFinal(dataVar)
            .assign(literalMap(bodyExtras, refer('String'), refer('dynamic')))
            .statement,
      );
      for (final item in expandBodyExtras.entries) {
        _generateParameterElement(item.key, blocks, dataVar);
      }
      if (preventNullToAbsent == null && anyNullable) {
        blocks.add(Code('$dataVar.removeWhere((k, v) => v == null);'));
      }
      return;
    }

    anyNullable = false;

    final fields = _getAnnotations(m, retrofit.Field).map((p, r) {
      anyNullable |= p.type.nullabilitySuffix == NullabilitySuffix.question;
      final fieldName = r.peek('value')?.stringValue ?? p.displayName;
      final isFileField = _isAssignable(io.File, p.type);
      if (isFileField) {
        log.severe(
          'File is not support by @Field(). Please use @Part() instead.',
        );
      }
      return MapEntry(literal(fieldName), refer(p.displayName));
    });

    if (fields.isNotEmpty) {
      blocks.add(declareFinal(dataVar).assign(literalMap(fields)).statement);
      if (preventNullToAbsent == null && anyNullable) {
        blocks.add(Code('$dataVar.removeWhere((k, v) => v == null);'));
      }
      return;
    }

    final parts = _getAnnotations(m, retrofit.Part);
    if (parts.isNotEmpty) {
      if (parts.length == 1 && parts.keys.first.type.isDartCoreMap) {
        final mapParam = parts.keys.first;
        final mapValueType = _genericListOf(mapParam.type)?[1];

        // Check if Map value type is File, MultipartFile, or List<int>
        final isFileMap =
            mapValueType != null && _isAssignable(io.File, mapValueType);
        final isMultipartFileMap =
            mapValueType != null && _isMultipartFile(mapValueType);
        final isByteListMap =
            mapValueType != null && _displayString(mapValueType) == 'List<int>';

        if (isFileMap || isMultipartFileMap || isByteListMap) {
          // Handle Map<String, File>, Map<String, MultipartFile>, or Map<String, List<int>>
          blocks.add(
            declareFinal(
              dataVar,
            ).assign(refer('FormData').newInstance([])).statement,
          );

          final nullableCheck =
              mapParam.type.nullabilitySuffix == NullabilitySuffix.question;

          if (nullableCheck) {
            blocks.add(Code('if (${mapParam.displayName} != null) {'));
          }

          if (isFileMap) {
            // Generate code for Map<String, File>
            blocks.add(
              Code('''
    ${mapParam.displayName}.forEach((key, value) {
      $dataVar.files.add(
        MapEntry(
          key,
          MultipartFile.fromFileSync(
            value.path,
            filename: value.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    });
'''),
            );
          } else if (isMultipartFileMap) {
            // Generate code for Map<String, MultipartFile>
            blocks.add(
              Code('''
    ${mapParam.displayName}.forEach((key, value) {
      $dataVar.files.add(MapEntry(key, value));
    });
'''),
            );
          } else if (isByteListMap) {
            // Generate code for Map<String, List<int>>
            blocks.add(
              Code('''
    ${mapParam.displayName}.forEach((key, value) {
      $dataVar.files.add(
        MapEntry(
          key,
          MultipartFile.fromBytes(value),
        ),
      );
    });
'''),
            );
          }

          if (nullableCheck) {
            blocks.add(const Code('}'));
          }

          return;
        } else {
          // Default behavior for Map<String, dynamic> - use FormData.fromMap
          blocks.add(
            declareFinal(dataVar)
                .assign(
                  refer('FormData').newInstanceNamed('fromMap', [
                    CodeExpression(Code(mapParam.displayName)),
                  ]),
                )
                .statement,
          );
          return;
        }
      }

      blocks.add(
        declareFinal(
          dataVar,
        ).assign(refer('FormData').newInstance([])).statement,
      );

      // Get PartMap parameter if it exists
      final partMapAnnotation = _getAnnotation(m, retrofit.PartMap);
      final partMapParam = partMapAnnotation?.element;

      parts.forEach((p, r) {
        final fieldName =
            r.peek('name')?.stringValue ??
            r.peek('value')?.stringValue ??
            p.displayName;
        final isFileField = _isAssignable(io.File, p.type);
        final contentType = r.peek('contentType')?.stringValue;

        if (isFileField) {
          final fileNameValue = r.peek('fileName')?.stringValue;

          // Build the code for creating MultipartFile with runtime metadata support
          if (partMapParam != null) {
            // Generate variables for runtime values
            final fileNameVar = '_${fieldName}_fileName';
            final contentTypeVar = '_${fieldName}_contentType';

            // Generate code to extract runtime fileName
            if (fileNameValue != null) {
              blocks.add(
                Code(
                  "final $fileNameVar = (${partMapParam.displayName}?['${fieldName}_fileName'] as String?) ?? ${literalString(fileNameValue)};",
                ),
              );
            } else {
              blocks.add(
                Code(
                  "final $fileNameVar = (${partMapParam.displayName}?['${fieldName}_fileName'] as String?) ?? ${p.displayName}.path.split(Platform.pathSeparator).last;",
                ),
              );
            }

            // Generate code to extract runtime contentType
            if (contentType != null) {
              blocks.add(
                Code(
                  "final $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : DioMediaType.parse(${literal(contentType)});",
                ),
              );
            } else {
              blocks.add(
                Code(
                  "final DioMediaType? $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : null;",
                ),
              );
            }

            // Build MultipartFile with runtime values
            final uploadFileInfo = refer('$MultipartFile.fromFileSync').call(
              [refer(p.displayName).property('path')],
              {
                'filename': refer(fileNameVar),
                'contentType': refer(contentTypeVar),
              },
            );

            final optionalFile =
                m.formalParameters
                    .firstWhereOrNull((pp) => pp.displayName == p.displayName)
                    ?.isOptional ??
                false;

            final returnCode = refer(dataVar)
                .property('files')
                .property('add')
                .call([
                  refer(
                    'MapEntry',
                  ).newInstance([literal(fieldName), uploadFileInfo]),
                ])
                .statement;

            if (p.type.isNullable || optionalFile) {
              final condition = refer(
                p.displayName,
              ).notEqualTo(literalNull).code;
              blocks.addAll([
                const Code('if('),
                condition,
                const Code(') {'),
                returnCode,
                const Code('}'),
              ]);
            } else {
              blocks.add(returnCode);
            }
          } else {
            // No PartMap - use original static approach
            final fileName = fileNameValue != null
                ? literalString(fileNameValue)
                : refer(
                    p.displayName,
                  ).property('path.split(Platform.pathSeparator).last');

            final uploadFileInfo = refer('$MultipartFile.fromFileSync').call(
              [refer(p.displayName).property('path')],
              {
                'filename': fileName,
                if (contentType != null)
                  'contentType': refer(
                    'DioMediaType',
                    'package:dio/dio.dart',
                  ).property('parse').call([literal(contentType)]),
              },
            );

            final optionalFile =
                m.formalParameters
                    .firstWhereOrNull((pp) => pp.displayName == p.displayName)
                    ?.isOptional ??
                false;

            final returnCode = refer(dataVar)
                .property('files')
                .property('add')
                .call([
                  refer(
                    'MapEntry',
                  ).newInstance([literal(fieldName), uploadFileInfo]),
                ])
                .statement;

            if (p.type.isNullable || optionalFile) {
              final condition = refer(
                p.displayName,
              ).notEqualTo(literalNull).code;
              blocks.addAll([
                const Code('if('),
                condition,
                const Code(') {'),
                returnCode,
                const Code('}'),
              ]);
            } else {
              blocks.add(returnCode);
            }
          }
        } else if (_isMultipartFile(p.type)) {
          if (p.type.isNullable) {
            blocks.add(Code('if (${p.displayName} != null){'));
          }
          blocks.add(
            refer(dataVar).property('files').property('add').call([
              refer(
                'MapEntry',
              ).newInstance([literal(fieldName), refer(p.displayName)]),
            ]).statement,
          );
          if (p.type.isNullable) {
            blocks.add(const Code('}'));
          }
        } else if (_displayString(p.type) == 'List<int>') {
          final optionalFile =
              m.formalParameters
                  .firstWhereOrNull((pp) => pp.displayName == p.displayName)
                  ?.isOptional ??
              false;
          final fileName = r.peek('fileName')?.stringValue;

          if (partMapParam != null) {
            // Support runtime metadata for List<int>
            final fileNameVar = '_${fieldName}_fileName';
            final contentTypeVar = '_${fieldName}_contentType';

            // Generate code to extract runtime fileName
            if (fileName != null) {
              blocks.add(
                Code(
                  "final $fileNameVar = (${partMapParam.displayName}?['${fieldName}_fileName'] as String?) ?? ${literal(fileName)};",
                ),
              );
            } else {
              blocks.add(
                Code(
                  "final $fileNameVar = ${partMapParam.displayName}?['${fieldName}_fileName'] as String?;",
                ),
              );
            }

            // Generate code to extract runtime contentType
            if (contentType != null) {
              blocks.add(
                Code(
                  "final $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : DioMediaType.parse(${literal(contentType)});",
                ),
              );
            } else {
              blocks.add(
                Code(
                  "final DioMediaType? $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : null;",
                ),
              );
            }

            final returnCode =
                refer(dataVar).property('files').property('add').call([
                  refer('''
MapEntry(
'$fieldName',
MultipartFile.fromBytes(${p.displayName},
filename: $fileNameVar,
contentType: $contentTypeVar,
))
'''),
                ]).statement;
            if (optionalFile) {
              final condition = refer(
                p.displayName,
              ).notEqualTo(literalNull).code;
              blocks.addAll([
                const Code('if('),
                condition,
                const Code(') {'),
                returnCode,
                const Code('}'),
              ]);
            } else {
              blocks.add(returnCode);
            }
          } else {
            // No PartMap - use original static approach
            final conType = contentType == null
                ? ''
                : 'contentType: DioMediaType.parse(${literal(contentType)}),';
            final returnCode =
                refer(dataVar).property('files').property('add').call([
                  refer('''
MapEntry(
'$fieldName',
MultipartFile.fromBytes(${p.displayName},

filename:${literal(fileName)},
    $conType
    ))
'''),
                ]).statement;
            if (optionalFile) {
              final condition = refer(
                p.displayName,
              ).notEqualTo(literalNull).code;
              blocks.addAll([
                const Code('if('),
                condition,
                const Code(') {'),
                returnCode,
                const Code('}'),
              ]);
            } else {
              blocks.add(returnCode);
            }
          }
        } else if (_isExactly(List, p.type) || _isExactly(BuiltList, p.type)) {
          final innerType = _genericOf(p.type);

          if (_displayString(innerType) == 'List<int>') {
            final fileName = r.peek('fileName')?.stringValue;

            if (partMapParam != null) {
              // Support runtime metadata for List<List<int>>
              final fileNameVar = '_${fieldName}_fileName';
              final contentTypeVar = '_${fieldName}_contentType';

              if (fileName != null) {
                blocks.add(
                  Code(
                    "final $fileNameVar = (${partMapParam.displayName}?['${fieldName}_fileName'] as String?) ?? ${literal(fileName)};",
                  ),
                );
              } else {
                blocks.add(
                  Code(
                    "final $fileNameVar = ${partMapParam.displayName}?['${fieldName}_fileName'] as String?;",
                  ),
                );
              }

              if (contentType != null) {
                blocks.add(
                  Code(
                    "final $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : DioMediaType.parse(${literal(contentType)});",
                  ),
                );
              } else {
                blocks.add(
                  Code(
                    "final DioMediaType? $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : null;",
                  ),
                );
              }

              blocks.add(
                refer(dataVar).property('files').property('addAll').call([
                  refer('''
${p.displayName}.map((i) => MapEntry(
'$fieldName',
MultipartFile.fromBytes(i,
    filename: $fileNameVar,
    contentType: $contentTypeVar,
    )))
'''),
                ]).statement,
              );
            } else {
              // No PartMap - use original static approach
              final conType = contentType == null
                  ? ''
                  : 'contentType: DioMediaType.parse(${literal(contentType)}),';
              blocks.add(
                refer(dataVar).property('files').property('addAll').call([
                  refer('''
${p.displayName}.map((i) => MapEntry(
'$fieldName',
MultipartFile.fromBytes(i,
    filename:${literal(fileName)},
    $conType
    )))
'''),
                ]).statement,
              );
            }
          } else if (_isBasicType(innerType) ||
              ((innerType != null) &&
                  (_isEnum(innerType) ||
                      _isExactly(Map, innerType) ||
                      _isExactly(BuiltMap, innerType) ||
                      _isExactly(List, innerType) ||
                      _isExactly(BuiltList, innerType)))) {
            var value = '';
            if (innerType != null && _isEnum(innerType)) {
              value = _getEnumValueExpression(innerType, 'i');
            } else if (_isBasicType(innerType)) {
              value = 'i';
              if (innerType != null && !_isExactly(String, innerType)) {
                value += '.toString()';
              }
            } else {
              value = 'jsonEncode(i)';
            }
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
          } else if (innerType != null && _isAssignable(io.File, innerType)) {
            if (partMapParam != null) {
              // Support runtime metadata for List<File>
              final contentTypeVar = '_${fieldName}_contentType';

              if (contentType != null) {
                blocks.add(
                  Code(
                    "final $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : DioMediaType.parse(${literal(contentType)});",
                  ),
                );
              } else {
                blocks.add(
                  Code(
                    "final DioMediaType? $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : null;",
                  ),
                );
              }

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
    contentType: $contentTypeVar,
    )))
'''),
                ]).statement,
              );
              if (p.type.isNullable) {
                blocks.add(const Code('}'));
              }
            } else {
              // No PartMap - use original static approach
              final conType = contentType == null
                  ? ''
                  : 'contentType: DioMediaType.parse(${literal(contentType)}),';
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
'''),
                ]).statement,
              );
              if (p.type.isNullable) {
                blocks.add(const Code('}'));
              }
            }
          } else if (innerType != null && _isMultipartFile(innerType)) {
            if (p.type.isNullable) {
              blocks.add(Code('if (${p.displayName} != null) {'));
            }
            blocks.add(
              refer(dataVar).property('files').property('addAll').call([
                refer('''
                  ${p.displayName}.map((i) => MapEntry(
                '$fieldName',
                i))
                  '''),
              ]).statement,
            );
            if (p.type.isNullable) {
              blocks.add(const Code('}'));
            }
          } else if (innerType?.element is ClassElement) {
            final ele = innerType!.element! as ClassElement;
            if (_missingToJson(ele)) {
              if (_isDateTime(p.type)) {
                final expr = [
                  if (p.type.nullabilitySuffix == NullabilitySuffix.question)
                    refer(
                      p.displayName,
                    ).nullSafeProperty('toIso8601String').call([])
                  else
                    refer(p.displayName).property('toIso8601String').call([]),
                ];
                refer(dataVar).property('fields').property('add').call(expr);
              } else {
                throw Exception('toJson() method have to add to ${p.type}');
              }
            } else {
              blocks.add(
                refer(dataVar).property('fields').property('add').call([
                  refer('MapEntry').newInstance([
                    literal(fieldName),
                    refer('jsonEncode(${p.displayName})'),
                  ]),
                ]).statement,
              );
            }
          } else {
            throw Exception('Unknown error!');
          }
        } else if (_isBasicType(p.type) || _isEnum(p.type)) {
          if (p.type.nullabilitySuffix == NullabilitySuffix.question) {
            blocks.add(Code('if (${p.displayName} != null) {'));
          }
          blocks.add(
            refer(dataVar).property('fields').property('add').call([
              refer('MapEntry').newInstance([
                literal(fieldName),
                if (_isExactly(String, p.type))
                  refer(p.displayName)
                else if (_isEnum(p.type))
                  _getEnumValueReference(p.type, p.displayName)
                else
                  refer(p.displayName).property('toString').call([]),
              ]),
            ]).statement,
          );
          if (p.type.nullabilitySuffix == NullabilitySuffix.question) {
            blocks.add(const Code('}'));
          }
        } else if (_isExactly(Map, p.type) || _isExactly(BuiltMap, p.type)) {
          blocks.add(
            refer(dataVar).property('fields').property('add').call([
              refer('MapEntry').newInstance([
                literal(fieldName),
                refer('jsonEncode(${p.displayName})'),
              ]),
            ]).statement,
          );
        } else if (p.type.element is ClassElement) {
          final ele = p.type.element! as ClassElement;
          if (_missingToJson(ele)) {
            if (_isDateTime(p.type)) {
              if (p.type.nullabilitySuffix == NullabilitySuffix.question) {
                blocks.add(Code('if (${p.displayName} != null) {'));
              }
              blocks.add(
                refer(dataVar).property('fields').property('add').call([
                  refer('MapEntry').newInstance([
                    literal(fieldName),
                    refer(p.displayName).property('toIso8601String').call([]),
                  ]),
                ]).statement,
              );
              if (p.type.nullabilitySuffix == NullabilitySuffix.question) {
                blocks.add(const Code('}'));
              }
            } else {
              throw Exception('toJson() method have to add to ${p.type}');
            }
          } else {
            if (contentType != null || partMapParam != null) {
              if (partMapParam != null) {
                // Support runtime metadata for class types with contentType
                final contentTypeVar = '_${fieldName}_contentType';

                if (contentType != null) {
                  blocks.add(
                    Code(
                      "final $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : DioMediaType.parse(${literal(contentType)});",
                    ),
                  );
                } else {
                  blocks.add(
                    Code(
                      "final DioMediaType? $contentTypeVar = (${partMapParam.displayName}?['${fieldName}_contentType'] as String?) != null ? DioMediaType.parse(${partMapParam.displayName}!['${fieldName}_contentType'] as String) : null;",
                    ),
                  );
                }

                blocks.add(Code('if ($contentTypeVar != null) {'));

                final uploadFileInfo = refer('$MultipartFile.fromString').call(
                  [
                    refer(
                      "jsonEncode(${p.displayName}${p.type.nullabilitySuffix == NullabilitySuffix.question ? ' ?? <String, dynamic>{}' : ''})",
                    ),
                  ],
                  {'contentType': refer(contentTypeVar)},
                );

                final optionalFile =
                    m.formalParameters
                        .firstWhereOrNull(
                          (pp) => pp.displayName == p.displayName,
                        )
                        ?.isOptional ??
                    false;

                final returnCode = refer(dataVar)
                    .property('files')
                    .property('add')
                    .call([
                      refer(
                        'MapEntry',
                      ).newInstance([literal(fieldName), uploadFileInfo]),
                    ])
                    .statement;

                if (optionalFile) {
                  final condition = refer(
                    p.displayName,
                  ).notEqualTo(literalNull).code;
                  blocks.addAll([
                    const Code('if('),
                    condition,
                    const Code(') {'),
                    returnCode,
                    const Code('}'),
                  ]);
                } else {
                  blocks.add(returnCode);
                }

                blocks
                  ..add(const Code('} else {'))
                  ..add(
                    refer(dataVar).property('fields').property('add').call([
                      refer('MapEntry').newInstance([
                        literal(fieldName),
                        refer(
                          'jsonEncode(${p.displayName}${p.type.nullabilitySuffix == NullabilitySuffix.question ? ' ?? <String, dynamic>{}' : ''})',
                        ),
                      ]),
                    ]).statement,
                  )
                  ..add(const Code('}'));
              } else {
                // No PartMap - use original static approach
                final uploadFileInfo = refer('$MultipartFile.fromString').call(
                  [
                    refer(
                      "jsonEncode(${p.displayName}${p.type.nullabilitySuffix == NullabilitySuffix.question ? ' ?? <String, dynamic>{}' : ''})",
                    ),
                  ],
                  {
                    'contentType': refer(
                      'DioMediaType',
                      'package:dio/dio.dart',
                    ).property('parse').call([literal(contentType)]),
                  },
                );

                final optionalFile =
                    m.formalParameters
                        .firstWhereOrNull(
                          (pp) => pp.displayName == p.displayName,
                        )
                        ?.isOptional ??
                    false;

                final returnCode = refer(dataVar)
                    .property('files')
                    .property('add')
                    .call([
                      refer(
                        'MapEntry',
                      ).newInstance([literal(fieldName), uploadFileInfo]),
                    ])
                    .statement;
                if (optionalFile) {
                  final condition = refer(
                    p.displayName,
                  ).notEqualTo(literalNull).code;
                  blocks.addAll([
                    const Code('if('),
                    condition,
                    const Code(') {'),
                    returnCode,
                    const Code('}'),
                  ]);
                } else {
                  blocks.add(returnCode);
                }
              }
            } else {
              blocks.add(
                refer(dataVar).property('fields').property('add').call([
                  refer('MapEntry').newInstance([
                    literal(fieldName),
                    refer(
                      'jsonEncode(${p.displayName}${p.type.nullabilitySuffix == NullabilitySuffix.question ? ' ?? <String, dynamic>{}' : ''})',
                    ),
                  ]),
                ]).statement,
              );
            }
          }
        } else {
          blocks.add(
            refer(dataVar).property('fields').property('add').call([
              refer(
                'MapEntry',
              ).newInstance([literal(fieldName), refer(p.displayName)]),
            ]).statement,
          );
        }
      });
      return;
    }

    /// There is no body
    if (globalOptions.emptyRequestBody ?? false) {
      blocks.add(
        declareFinal(
          dataVar,
        ).assign(literalMap({}, refer('String'), refer('dynamic'))).statement,
      );
    } else {
      blocks.add(
        declareConst(
          dataVar,
          type: refer('Map<String, dynamic>?'),
        ).assign(literalNull).statement,
      );
    }
  }

  /// Generates the request headers.
  Map<String, Expression> _generateHeaders(MethodElement m) {
    // Start with global headers from @RestApi annotation
    final headers = <String, Expression>{};
    final globalHeaders = clientAnnotation.headers;
    if (globalHeaders != null) {
      for (final entry in globalHeaders.entries) {
        headers[entry.key] = literal(entry.value);
      }
    }

    // Method-level @Headers annotations override global headers
    final methodHeaders = _getMethodAnnotations(m, retrofit.Headers)
        .map((e) => e.peek('value'))
        .map(
          (value) => value?.mapValue.map((k, v) {
            dynamic val;
            if (v == null) {
              val = null;
            } else if (v.type?.isDartCoreBool ?? false) {
              val = v.toBoolValue();
            } else if (v.type?.isDartCoreString ?? false) {
              val = v.toStringValue();
            } else if (v.type?.isDartCoreDouble ?? false) {
              val = v.toDoubleValue();
            } else if (v.type?.isDartCoreInt ?? false) {
              val = v.toIntValue();
            } else {
              val = v.toStringValue();
            }
            return MapEntry(k?.toStringValue() ?? 'null', literal(val));
          }),
        )
        .fold<Map<String, Expression>>({}, (p, e) => p..addAll(e ?? {}));
    headers.addAll(methodHeaders);

    final annotationsInParam = _getAnnotations(m, retrofit.Header);
    final headersInParams = annotationsInParam.map((k, v) {
      final value = v.peek('value')?.stringValue ?? k.displayName;
      return MapEntry(value, refer(k.displayName));
    });
    headers.addAll(headersInParams);

    final cacheMap = _generateCache(m);
    headers.addAll(cacheMap);

    /// gen code for request Accept for Protobuf
    final returnType = _getResponseType(m.returnType);

    if (returnType != null &&
        _isAssignable(protobuf.GeneratedMessage, returnType)) {
      headers
        ..removeWhere(
          (key, value) => 'accept'.toLowerCase() == key.toLowerCase(),
        )
        ..addAll({
          'accept': literal(
            'application/x-protobuf; \${${_displayString(returnType)}.getDefault().info_.qualifiedMessageName == "" ? "" :"messageType=\${${_displayString(returnType)}.getDefault().info_.qualifiedMessageName}"}',
          ),
        });
    }

    return headers;
  }

  /// Generates cache-related request headers.
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
      final other = (cache.peek('other')?.listValue ?? const []).map(
        (e) => e.toStringValue(),
      );
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
        ...otherResult,
      ];

      final value = values.where((element) => element != '').join(', ');

      result.putIfAbsent(
        io.HttpHeaders.cacheControlHeader,
        () => literal(value),
      );
    }
    return result;
  }

  /// Gets the value of an annotation field.
  Object? _getFieldValue(ConstantReader? value) {
    if (value?.isBool ?? false) {
      return value?.boolValue;
    }
    if (value?.isDouble ?? false) {
      return value?.doubleValue;
    }
    if (value?.isInt ?? false) {
      return value?.intValue;
    }
    if (value?.isString ?? false) {
      return value?.stringValue;
    }
    if (value?.objectValue.isEnum ?? false) {
      return value?.objectValue.variable?.displayName;
    }
    if (value?.isList ?? false) {
      return value?.listValue
          .map((item) => _getFieldValue(ConstantReader(item)))
          .toList();
    }
    if (value?.isMap ?? false) {
      final mapValue = value?.mapValue.map((key, val) {
        return MapEntry(
          _getFieldValue(ConstantReader(key)),
          _getFieldValue(ConstantReader(val)),
        );
      });
      return mapValue;
    }
    if (value?.isSet ?? false) {
      return value?.setValue.map((item) {
        return _getFieldValue(ConstantReader(item));
      }).toSet();
    }
    if (value?.objectValue.type != null) {
      final fields = <String, Object?>{};
      final type = value!.objectValue.type;
      if (type is InterfaceType) {
        for (final field in type.element.fields) {
          if (!field.isStatic) {
            final name = field.name;
            if (name == null) {
              continue;
            }
            final fieldValue = value.peek(name);
            fields[name] = _getFieldValue(fieldValue);
          }
        }
      }
      return fields;
    }
    return null;
  }

  /// Gets the TypedExtras annotation on the method.
  Map<String, Object> _getMapFromTypedExtras(MethodElement m) {
    final annotations = _getMethodAnnotations(m, retrofit.TypedExtras);
    final allTypedExtras = <String, Object>{};

    for (final annotation in annotations) {
      final fields = annotation.objectValue.type?.element?.children
          .whereType<FieldElement>();
      for (final field in (fields ?? <FieldElement>[])) {
        final name = field.name;
        if (name == null) {
          continue;
        }
        final value = annotation.peek(name);
        final fieldValue = _getFieldValue(value);
        if (fieldValue != null) {
          allTypedExtras[name] = fieldValue;
        }
      }
    }

    return allTypedExtras;
  }

  /// Generates serialization code for a parameter element.
  void _generateParameterElement(
    FormalParameterElement paramElement,
    List<Code> blocks,
    String dataVar,
  ) {
    final bodyType = paramElement.type;
    final genericArgumentFactories = isGenericArgumentFactories(bodyType);

    final typeArgs = bodyType is ParameterizedType
        ? bodyType.typeArguments
        : <DartType>[];

    var toJsonCode = '';
    if (typeArgs.isNotEmpty && genericArgumentFactories) {
      toJsonCode = _getInnerJsonDeSerializableMapperFn(bodyType);
    }
    if (paramElement.type.nullabilitySuffix != NullabilitySuffix.question) {
      blocks.add(
        refer('$dataVar.addAll').call([
          refer('${paramElement.displayName}.toJson($toJsonCode)'),
        ]).statement,
      );
    } else {
      blocks.add(
        refer('$dataVar.addAll').call([
          refer(
            '${paramElement.displayName}?.toJson($toJsonCode) ?? <String, dynamic>{}',
          ),
        ]).statement,
      );
    }
  }

  /// Generates code block for Extra annotation.
  void _generateExtra(
    MethodElement m,
    List<Code> blocks,
    String localExtraVar,
  ) {
    blocks.add(
      declareFinal(localExtraVar)
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
                  .fold<Map<String, Object>>({}, (p, e) {
                    return p..addAll(e ?? {});
                  })
                ..addAll(_getMapFromTypedExtras(m)),
              refer('String'),
              refer('dynamic'),
            ),
          )
          .statement,
    );

    final extraMap = _getAnnotations(m, retrofit.Extras);
    for (final p in extraMap.keys) {
      final type = p.type;
      final displayName = p.displayName;
      final Expression value;
      if (_isBasicType(type) || type.isDartCoreList || type.isDartCoreMap) {
        value = refer(displayName);
      } else if (_isSuperOf(protobuf.ProtobufEnum, type)) {
        value = type.nullabilitySuffix == NullabilitySuffix.question
            ? refer(p.displayName).nullSafeProperty('value')
            : refer(p.displayName).property('value');
      } else {
        switch (clientAnnotation.parser) {
          case retrofit.Parser.JsonSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toJson').call([])
                : refer(displayName).property('toJson').call([]);
          case retrofit.Parser.MapSerializable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toMap').call([])
                : refer(displayName).property('toMap').call([]);
          case retrofit.Parser.DartJsonMapper:
            value = refer(displayName);
          case retrofit.Parser.DartMappable:
            value = p.type.nullabilitySuffix == NullabilitySuffix.question
                ? refer(displayName).nullSafeProperty('toMap').call([])
                : refer(displayName).property('toMap').call([]);
          case retrofit.Parser.FlutterCompute:
            value = refer(
              'await compute(serialize${_displayString(p.type)}, ${p.displayName})',
            );
        }
      }

      final emitter = DartEmitter(useNullSafetySyntax: true);
      final buffer = StringBuffer();
      value.accept(emitter, buffer);
      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        refer('?? <String, dynamic>{}').accept(emitter, buffer);
      }
      final expression = refer(buffer.toString());

      blocks.add(refer('$localExtraVar.addAll').call([expression]).statement);
    }
  }

  /// Checks if the class is missing a toJson method.
  bool _missingToJson(ClassElement ele) {
    switch (clientAnnotation.parser) {
      case retrofit.Parser.JsonSerializable:
      case retrofit.Parser.DartJsonMapper:
        // Use lookUpMethod to check the class hierarchy including mixins
        // This is important for Freezed-generated classes where toJson is in a mixin
        final toJson = ele.lookUpMethod(name: 'toJson', library: ele.library);
        return toJson == null;
      case retrofit.Parser.MapSerializable:
      case retrofit.Parser.DartMappable:
      case retrofit.Parser.FlutterCompute:
        return false;
    }
  }

  /// Checks if the type is missing a serialize method.
  bool _missingSerialize(LibraryFragment ele, DartType type) {
    switch (clientAnnotation.parser) {
      case retrofit.Parser.JsonSerializable:
      case retrofit.Parser.DartJsonMapper:
      case retrofit.Parser.MapSerializable:
      case retrofit.Parser.DartMappable:
        return false;
      case retrofit.Parser.FlutterCompute:
        return !ele.functions.any(
          (element) =>
              element.name == 'serialize${_displayString(type)}' &&
              element.formalParameters.length == 1 &&
              _displayString(element.formalParameters[0].element.type) ==
                  _displayString(type),
        );
    }
  }

  /// Wraps a code block in try-catch.
  void _wrapInTryCatch(
    List<Code> blocks,
    Expression options,
    DartType? returnType,
    Code child,
  ) {
    blocks.addAll([
      declareVar(
        _valueVar,
        type: refer(_displayString(returnType, withNullability: true)),
        late: true,
      ).statement,
      const Code('try {'),
      child,
      const Code('} on Object catch (e, s) {'),
      const Code(
        '$_errorLoggerVar?.logError(e, s, $_optionsVar, response: $_resultVar);',
      ),
      const Code('rethrow;'),
      const Code('}'),
    ]);
  }
}

/// Returns `$revived($args $kwargs)`, this won't have ending semi-colon (`;`).
/// [object] must not be null.
/// [object] is assumed to be a constant.
String revivedLiteral(Object object, {DartEmitter? dartEmitter}) {
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
    instantiation =
        location[1] +
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
    }

    if (constant.isMap) {
      return literalMap(
        Map.fromIterables(
          constant.mapValue.keys.map(objectToSpec),
          constant.mapValue.values.map(objectToSpec),
        ),
      );
    }

    if (constant.isSymbol) {
      return Code('Symbol(${constant.symbolValue})');
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
    final revived = revivedLiteral(
      constant.revive(),
      dartEmitter: dartEmitter,
    ).replaceFirst('const ', '');
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

String _displayString(DartType? e, {bool withNullability = false}) {
  try {
    if (!withNullability) {
      return e!.toStringNonNullable();
    } else {
      return e!.getDisplayString();
    }
  } on Object {
    if (!withNullability) {
      return e!.toStringNonNullable();
    } else {
      return e!.getDisplayString();
    }
  }
}

extension _DartTypeX on DartType {
  bool get isNullable => nullabilitySuffix == NullabilitySuffix.question;

  String toStringNonNullable() {
    final val = getDisplayString();
    if (val.endsWith('?')) {
      return val.substring(0, val.length - 1);
    }
    return val;
  }
}

extension _DartObjectX on DartObject? {
  bool get isEnum => this?.type?.element?.kind.name == 'ENUM';

  ConstantReader? toConstantReader() {
    if (this == null) {
      return null;
    }
    return ConstantReader(this);
  }
}

extension _ReferenceX on Reference {
  Reference asNoNull() => refer('$symbol!');

  Reference asNoNullIf({required bool returnNullable}) =>
      returnNullable ? this : asNoNull();

  Expression propertyIf({required bool thisNullable, required String name}) =>
      thisNullable ? nullSafeProperty(name) : asNoNull().property(name);

  Expression conditionalIsNullIf({
    required bool thisNullable,
    required Expression whenFalse,
  }) => thisNullable
      ? equalTo(literalNull).conditional(literalNull, whenFalse)
      : whenFalse;
}

extension _IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
