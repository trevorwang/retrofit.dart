import 'package:test/test.dart';
import 'package:retrofit/dio.dart';

void main() {
  group('Dio Annotations', () {
    test('Extra stores data', () {
      final extra = Extra({'foo': 'bar'});
      expect(extra.data['foo'], 'bar');
    });

    test('TypedExtras and Extras are const', () {
      const typed = TypedExtras();
      const extras = Extras();
      expect(typed, isA<TypedExtras>());
      expect(extras, isA<Extras>());
    });

    test('CancelRequest and ReceiveProgress are const', () {
      const cancel = CancelRequest();
      const receive = ReceiveProgress();
      expect(cancel, isA<CancelRequest>());
      expect(receive, isA<ReceiveProgress>());
    });
  });
}
