import 'package:logging/logging.dart';

bool isTypeOf<ThisType, OfType>() => _Instance<ThisType>() is _Instance<OfType>;

class _Instance<T> {}

final logger = Logger("retrofit");
