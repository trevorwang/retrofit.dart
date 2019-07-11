# Changelog

## 0.3.0

Added support for generic serilization. 
> Please note:
>
> It doesn't support nested generics.

## 0.2.3

* Added support for `File` form fields. See example in `retrofit.dart` readme.

## 0.2.2

* bump to 0.2.2

## 0.2.1

* Fixed pub upload issue

## 0.2.0

* Added `@Extra` to pass extra options to dio requests, response, transformer and interceptors.

    Example :

    ```dart
    @http.POST('/path/')
    @dio.Extra({'my_key':'my_value'})
    Future<String>> myMethod();
    ```

* Fixed general dart style and code conventions

* Automatically `null` check with `ArgumentError.checkNotNull` for required parameters

* Now SuperClasses can use forwarding/redirecting constructors instead of static `instance()` method

    Example :

    ```dart
    @RestApi(baseUrl: "https://httpbin.org/")
    abstract class RestClient {
        /// Forwarding constructor
        factory RestClient([Dio dio]) = _RestClient;
    }
    ```

## 0.1.0

* fix health issues

## 0.0.1

* init
