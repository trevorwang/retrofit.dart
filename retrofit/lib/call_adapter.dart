/// Where T is supposed to be the return type of your request,
/// While E is the type you want to convert your `error` to
abstract class CallAdapterInterface<T, E> {
  Future<E> onError(dynamic error) {
    return error;
  }

  Future<T> onResponse(dynamic data) {
    return data;
  }
}

/// Annotation to enable call adaptation by linking a
/// custom [CallAdapterInterface].
///
/// By annotating a method with `@CallAdapter`, you can specify a custom adapter
/// class that intercepts and adapts responses or handles errors before they
/// reach the caller.
///
/// ### Usage
///
/// 1. Create a custom adapter by extending [CallAdapterInterface]:
/// ```dart
/// class MyCallAdapter extends CallAdapterInterface<MyResponseType, CustomException> {
///   @override
///   Future<MyResponseType> onResponse(dynamic data) async {
///     // Transform or adapt `data`
///     return MyResponseType.fromJson(data);
///   }
///
///   @override
///   Future<CustomException> onError(dynamic error) async {
///     // Custom error handling / error transformation
///     logger.log("Error occurred: $error");
///     return CustomException(message: error.toString);
///   }
/// }
/// ```
///
/// 2. Set the adapter on an API method or the entire API interface:
///
/// - To apply the adapter to an individual method, use `@CallAdapter` on the method:
/// ```dart
/// @CallAdapter(MyCallAdapter)
/// Future<MyResponseType> fetchData();
/// ```
///
/// - To apply it to all methods in an Api interface, pass the adapter to `@RestApi`:
/// ```dart
/// @RestApi(callAdapterInterface: MyCallAdapter)
/// abstract class MyApiService {
///   @GET('/data')
///   Future<MyResponseType> fetchData();
/// }
/// ```
class CallAdapter {
  const CallAdapter(this.callAdapterInterface);
  final Type callAdapterInterface;
}
