import 'package:intl/intl.dart' as intl;

bool isRTL(String text) {
  return intl.Bidi.detectRtlDirectionality(text);
}