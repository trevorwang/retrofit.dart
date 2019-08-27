# Changelog

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
  Future<String>> myMethod();
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
