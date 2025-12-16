import 'package:intl/intl.dart';

fileNameCreator(String prefix, String companyId) {
  String ts = DateFormat("yyyy-MM-dd_HH_mm_ss").format(DateTime.now());
  return "${prefix}_${companyId}_$ts.csv";
}

dateStringCreator(DateTime date) {
  return DateFormat("yyyy-MM-dd HH:mm").format(date);
}
