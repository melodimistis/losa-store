import 'package:flutter_test/flutter_test.dart';
import 'package:losa_store/util/version.dart';

void main() {
  test(
    '1.0.10 lebih baru dari 1.0.9',
    () => expect(isNewerVersion('1.0.9', '1.0.10'), isTrue),
  );
  test(
    'versi sama bukan update',
    () => expect(isNewerVersion('1.0.6', '1.0.6'), isFalse),
  );
  test(
    'versi lebih lama bukan update',
    () => expect(isNewerVersion('1.0.6', '1.0.5'), isFalse),
  );
  test(
    'build number diabaikan',
    () => expect(isNewerVersion('1.0.6+7', '1.0.6'), isFalse),
  );
}
