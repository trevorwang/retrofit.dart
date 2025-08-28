import 'package:test/test.dart';
import 'package:retrofit/call_adapter.dart';

class TestCallAdapter extends CallAdapter<String, int> {
  @override
  int adapt(String Function() call) {
    final result = call();
    return int.tryParse(result) ?? 0;
  }
}

void main() {
  group('CallAdapter', () {
    test('adapts call correctly', () {
      final adapter = TestCallAdapter();
      final adapted = adapter.adapt(() => '42');
      expect(adapted, 42);
    });
  });
}
