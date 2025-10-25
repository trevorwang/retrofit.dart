import 'package:dio/dio.dart';
import 'package:retrofit_example/example.dart';

/// Example demonstrating how to use the onError parameter
/// to handle errors from API calls in a centralized way.
void main() async {
  final dio = Dio();
  
  // Create a custom error handler
  // Signature matches Future.catchError() for flexibility
  void customErrorHandler(Object error, StackTrace stackTrace) {
    print('Custom error handler called!');
    print('Stack trace: $stackTrace');
    
    if (error is DioException) {
      // Handle network errors
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          print('Timeout error: ${error.message}');
          break;
        case DioExceptionType.badResponse:
          print('Bad response: ${error.response?.statusCode}');
          break;
        case DioExceptionType.connectionError:
          print('Connection error: ${error.message}');
          break;
        default:
          print('Other Dio error: ${error.message}');
      }
    } else {
      // Handle other errors (parsing errors, etc.)
      print('Non-Dio error: $error');
    }
    
    // You could transform the error here if needed
    throw CustomApiException(error.toString());
  }
  
  // Create the REST client with the error handler
  final client = RestClient(
    dio,
    onError: customErrorHandler,
  );
  
  try {
    // This will automatically call customErrorHandler if an error occurs
    final tasks = await client.getTasks();
    print('Got ${tasks.length} tasks');
  } on CustomApiException catch (e) {
    print('Caught custom exception: ${e.message}');
  }
}

/// Custom exception that your business logic can work with
/// instead of dealing with DioError directly
class CustomApiException implements Exception {
  CustomApiException(this.message);
  
  final String message;
  
  @override
  String toString() => 'CustomApiException: $message';
}
