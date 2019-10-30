# Changelog
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
