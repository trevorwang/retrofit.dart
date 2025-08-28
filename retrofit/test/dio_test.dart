import 'package:test/test.dart';
import 'package:retrofit/dio.dart';
class MyExtras extends TypedExtras {
  const MyExtras();
}

void main() {
  group('Dio Annotations', () {
    test('Extra stores data and equality', () {
      final extra1 = Extra({'foo': 'bar'});
      final extra2 = Extra({'foo': 'bar'});
      expect(extra1.data['foo'], 'bar');
      expect(extra1, isA<Extra>());
      expect(extra1.data, isA<Map<String, Object>>());
      // Not equal because different instances
      expect(extra1 == extra2, isFalse);
    });
    test('TypedExtras subclass', () {
      class MyExtras extends TypedExtras {
        const MyExtras();
      }
      const myExtras = MyExtras();
      expect(myExtras, isA<TypedExtras>());
    });
    test('Extras is const and type', () {
      const extras = Extras();
      expect(extras, isA<Extras>());
    });

    test('TypedExtras and Extras are const', () {
      const typed = TypedExtras();
    test('TypedExtras subclass', () {
      const myExtras = MyExtras();
      expect(myExtras, isA<TypedExtras>());
    });
      const receive = ReceiveProgress();
      expect(cancel, isA<CancelRequest>());
      expect(receive, isA<ReceiveProgress>());
    });
  });
}
