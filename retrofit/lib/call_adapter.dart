/// Adapts a Call with return type R into the type of T.
/// e.g. `Future<User>` to `Future<Result<User>>`
abstract class CallAdapter<R, T> {
  T adapt(R Function() call);
}


/// By annotating a method with `@UseCallAdapter`, you can specify a custom adapter
/// class where you can adapt a call to another response wrapper
///
/// ### Usage
///
/// 1. Create the call adapter by extending [CallAdapter]:
/// pass in type parameters for the original call return type and adapted call return type.
/// Note: your adapter subclass must accept a single type parameter(T), where T is
/// the type of the unwrapped response from the original call. e.g. 
/// `UserResponse` in `Future<UserResponse>`
/// 
/// ```dart
/// class ResultCallAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
///   @override
///   Future<Result<T>> adapt(Future<T> Function() call) async {
///     try {
///       final response = await call();
///       return Success<T>(response);
///     } catch (e) {
///       return Error(e);
///     }
///   } 
/// }

/// ```
///
/// 2. Set the adapter on an API method or the entire API interface:
///
/// - To apply the adapter to an individual method, use `@UseCallAdapter` on the method:
/// ```dart
/// @UseCallAdapter(ResultCallAdapter)
/// Future<Result<UserResponse>> fetchData();
/// ```
///
/// - To apply it to all methods in an Api interface, pass the adapter to `@RestApi`:
/// ```dart
/// @RestApi(callAdapter: ResultCallAdapter)
/// abstract class MyApiService {
///   @GET('/data')
///   Future<Result<UserResponse>> fetchData();
/// }
/// ```
class UseCallAdapter {
  const UseCallAdapter(this.callAdapter);
  final Type callAdapter;
}
