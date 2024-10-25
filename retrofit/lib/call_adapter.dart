/// Note that T must be the same as the type of `Future` for the method this is applied to
abstract class CallAdapterInterface<T> {
  void onError(dynamic error) {}

  T? onResponse(dynamic data) {
    return null;
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
/// class MyCallAdapter extends CallAdapterInterface<MyResponseType> {
///   @override
///   MyResponseType? onResponse(dynamic data) {
///     // Transform or adapt `data`
///     return MyResponseType.fromJson(data);
///   }
///
///   @override
///   void onError(dynamic error) {
///     // Custom error handling
///     logger.log("Error occurred: $error");
///   }
/// }
/// ```
///
/// 2. Set the adapter on an API method or the entire API interface:
///
/// - To apply the adapter to an individual method, use `@CallAdapter`:
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
