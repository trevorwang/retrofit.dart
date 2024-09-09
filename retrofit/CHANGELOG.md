# Changelog

## 4.4.0

- Added `@TypedExtras` to pass extra options to dio requests using custom annotations.

  Example :

  ```dart
  @TypedExtrasSubClass(
    id: 'abcd',
    count: 5,
    shouldProceed: true,
  )
  @http.POST('/path/')
  Future<String> myMethod(@Extras() Map<String, dynamic> extras);
  ```

## 4.3.0

- Required Dart 2.19
- Update README

## 4.1.0

- Added `@Extras` to pass extra options to dio requests, response, transformer and interceptors.

  Example :

  ```dart
  @http.POST('/path/')
  Future<String> myMethod(@Extras() Map<String, dynamic> extras);
  ```

## 4.0.0

- Update dio to ^5.0.0

## 3.3.0

- remove autoCastResponse annotation

## 3.0.2

- add recommended dart lints to project

## 3.0.1+1

- fix pub warning

## 3.0.1

- add multipart mime type (#437)

## 3.0.0

- add `compute` support

## 2.2.0

- rollback to dio
- update dio to 4.0.1

## 2.0.1

- add CacheControl

## 2.0.0

## 2.0.0-beta1

- Nullsafety support

## 1.3.4

- Add dart json mapper deserialize support

## 1.3.3

- [BREAKING CHANGE] Change `Part`'s params to named parameters from optional ones.

## 1.3.2

- Add `contentType` to `Part` annotation

## 1.3.1

- Add custom options support to each request
- fix [#132](https://github.com/trevorwang/retrofit.dart/issues/132)

## 1.3.0

- Bumped retrofit's SDK requirement to >=2.6.0

## 1.2.0

- Add `HttpReponse` to handle original response

## 1.1.0

- [BREAKING CHANGE] Add new `Part` annotation to send `multipart/form-data` request. `Field` will not be used in the future, please use `Part` instead.

## 1.0.1

- Add dio response type support

## 1.0.0

- Support dio 3.0

## 0.6.3

- Added `autoCastResponse` option to `RestApi` and all `Method` annotations (default : `true`)
- Added `auto_cast_response` to builder options.

  - Users can specify this in `build.yaml` as global default

    ```yaml
    targets:
      $default:
        sources: ["lib/**"]
        builders:
          retrofit_generator|retrofit:
            enabled: true
            options:
              auto_cast_response: true
    ```

## 0.6.2

- fix: fix bad cast exception (#47)
- add CancelToken, SendProgress, and ReceiveProgress (#46)

## 0.6.0

- [BREAKING CHANGE] only works dart 2.2.2 and above
- Added support to multiple clients with different base urls.

## 0.5.0

- Fixed analysis report
  use `retrofit.dart` instead of `http.dart` and `dio.dart` to import classes

## 0.4.3

- Updated docs and sample code

## 0.2.3

- Added optional parameter `fileName` in `@Field` annotation for custom file name

## 0.2.2

- add example

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
