import 'package:test/test.dart';
import 'package:retrofit/call_adapter.dart';

class TestCallAdapter extends CallAdapter<String, int> {
  @override
  int adapt(String Function() call) {
    final result = call();
    return int.tryParse(result) ?? 0;
  }
}

class DummyAdapter extends CallAdapter<int, String> {
  @override
  String adapt(int Function() call) {
    return call().toString();
  }
}

void main() {
  group('CallAdapter', () {
    test('adapts call correctly', () {
      final adapter = TestCallAdapter();
      final adapted = adapter.adapt(() => '42');
      expect(adapted, 42);
    });

    test('adapts int to string', () {
      final adapter = DummyAdapter();
      final adapted = adapter.adapt(() => 123);
      expect(adapted, '123');
    });
  });

  group('UseCallAdapter', () {
    test('annotation stores type', () {
      final use = UseCallAdapter(DummyAdapter);
      expect(use.callAdapter, DummyAdapter);
    });
  });
}
