import 'package:test/test.dart';
import 'package:retrofit/dio.dart';
import 'package:dio/dio.dart';

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
      const myExtras = MyExtras();
      expect(myExtras, isA<TypedExtras>());
    });

    test('Extras is const and type', () {
      const extras = Extras();
      expect(extras, isA<Extras>());
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
    test('SendProgress is const and type', () {
      const send = SendProgress();
      expect(send, isA<SendProgress>());
    });

    test('DioResponseType stores responseType', () {
      final dioType = DioResponseType(ResponseType.json);
      expect(dioType.responseType, ResponseType.json);
    });

    test('HttpResponse stores data and response', () {
      final fakeResponse =
          Response(requestOptions: RequestOptions(path: '/foo'));
      final httpResponse = HttpResponse<String>('data', fakeResponse);
      expect(httpResponse.data, 'data');
      expect(httpResponse.response, fakeResponse);
    });

    test('DioOptions is const and type', () {
      const options = DioOptions();
      expect(options, isA<DioOptions>());
    });
  });
}
