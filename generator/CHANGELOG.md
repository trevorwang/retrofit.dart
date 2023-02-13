# Changelog

## 5.0.0

- Update dio to ^5.0.0

## 4.1.2

- add recommended dart lints to project

## 4.1.1

- fix error with code_builder version above 4.3.x

## 4.1.0+1

- use dart doc instead of dartdoc

## 4.1.0

- [BREAKING CHANGE] update analyzer to 4.7.x and Dart version to 2.17

## 4.0.3

- fix null compatibility

## 4.0.1

- fix: Code generation will fail if you use the DioResponseType annotation. #452

## 4.0.0

- [BREAKING CHANGE] update analyzer to 3.x and dart to 2.14

## 3.0.1

- Generate code for Multipart mime-type

## 3.0.0

- Support `Parser.FlutterCompute` for generating data on separate isolates (#408)

## 2.2.0

- rollback to dio from dip_http

## 2.1.0

- replace dio by dio_http

- fix generic use toJson method in Post @Body

- nullable list of int was added to generator

## 2.0.1

- add CacheControl

## 2.0.0-beta3

- Fixed CancelRequest generating invalid code (#322)
- Fixed onSendProgress generating invalid code (#325)

## 2.0.0-beta2

- Update to dio-prev3
- Update to source_gen 1.0.0

## 2.0.0-beta1

- Nullsafety support

## 1.4.1

- Add support for json serializable generic types

## 1.4.0

- compatible with analyzer 0.40.0

## 1.3.8

- Send list params duplicative in multipart

## 1.3.7

- Add support for abstract classes with `toJson` defined in mixin/interface/superclass.
  This approach is used in [freezed](https://pub.dev/packages/freezed) package

## 1.3.6

- Add support of Stream return type.

## 1.3.5

- Add multiple `@Queries` decorators support
- Add serializable objects with `@Queries` decorator support

## 1.3.4

- Add dart json mapper deserialize support

## 1.3.3

- Add content type support to `Part`

## 1.3.1+4

- add workaround for [#143]

## 1.3.1

- Add custom options support to each request
- fix [#132](https://github.com/trevorwang/retrofit.dart/issues/132)

## 1.3.0+1

- Add support to post file as request body

## 1.3.0

- Bumped retrofit_generator's SDK requirement to >=2.6.0

## 1.2.3

- remove query parameter which is null

## 1.2.2

- stringify models in FormData #111

## 1.2.1

- Add `List<File>` support

## 1.2.0

- Add `HttpReposne` to handle the original response

## 1.1.0

- fix `FormUrlEncoded` issue

## 1.0.2

- Add `baseUrl` as a parameter of `RestClient`'s conductor
- Add base test for task api

## 1.0.1

- Add dio response type support

## 1.0.0

- Support dio 3.0

## 0.6.3+1

- Fix #53, Pin version of `dio` to `2.1.16`

## 0.6.3

- [BREAKING CHANGE] Requires `retrofit: ^0.6.3`
- Respect user option `autoCastResponse` (this will skip `.fromJson`)
- Allow custom classes without `.toJson` method (generator will throw warning)

## 0.6.2

- fix: fix bad cast exception (#47)
- add CancelToken, SendProgress, and ReceiveProgress (#46)

## 0.6.1

- Fixed inner type parsing [#44](https://github.com/trevorwang/retrofit.dart/issues/44)

## 0.6.0

- [BREAKING CHANGE] only works dart 2.2.2 and above
- Added support to multiple clients with different base urls.

## 0.5.0

## 0.4.3

- Minor fix

## 0.4.2

- Added support to generate strong mode compatible source code

## 0.4.1

- Added generic auto casting for `Map<String, List<Model>>` or `Map<String, Model>`

## 0.4.0

Added bean class support for `@Body()` annotation.

Here's the example.

```
    Future<String> createUser(@Body() User user);
```

```
    class User {
        Map<String, dynamic> toJson() => {};
    }
```

> please notice that:
> You have to provide a `toJson()` method to the bean classes to return a `Map<String, dynamic>`.

## 0.3.0

Added support for generic serialization.

> Please note:
>
> It doesn't support nested generics.

## 0.2.3

- Added support for `File` form fields. See example in `retrofit.dart` readme.

## 0.2.2

- bump to 0.2.2

## 0.2.1

- Fixed pub upload issue

## 0.2.0

- Added `@Extra` to pass extra options to dio requests, response, transformer and interceptors.

  Example :

  ```dart
  @http.POST('/path/')
  @dio.Extra({'my_key':'my_value'})
  Future<String> myMethod();
  ```

- Fixed general dart style and code conventions

- Automatically `null` check with `ArgumentError.checkNotNull` for required parameters

- Now SuperClasses can use forwarding/redirecting constructors instead of static `instance()` method

  Example :

  ```dart
  @RestApi(baseUrl: "https://httpbin.org/")
  abstract class RestClient {
      /// Forwarding constructor
      factory RestClient([Dio dio]) = _RestClient;
  }
  ```

## 0.1.0

- fix health issues

## 0.0.1

- init
