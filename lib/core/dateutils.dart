import 'package:intl/intl.dart';

class DateUtilsHelper {
  DateUtilsHelper._();

  /// Database format
  static const String dbPattern = 'yyyy-MM-dd';

  /// UI format
  static const String displayPattern = 'dd/MM/yyyy';

  // =========================
  // CURRENT DATE
  // =========================

  static String dbDate() {
    return DateFormat(dbPattern).format(DateTime.now());
  }

  static String displayToday() {
    return DateFormat(displayPattern).format(DateTime.now());
  }

  // =========================
  // FORMAT DATE
  // =========================

  static String formatDbDate(DateTime date) {
    return DateFormat(dbPattern).format(date);
  }

  static String formatDisplayDate(DateTime date) {
    return DateFormat(displayPattern).format(date);
  }

  // =========================
  // PARSE DATE
  // =========================

  static DateTime parseDbDate(String date) {
    return DateFormat(dbPattern).parse(date);
  }

  static DateTime parseDisplayDate(String date) {
    return DateFormat(displayPattern).parse(date);
  }

  // =========================
  // CONVERT FORMAT
  // =========================

  /// 2026-06-25 -> 25/06/2026
  static String dbToDisplay(String dbDate) {
    final date = parseDbDate(dbDate);
    return formatDisplayDate(date);
  }

  /// 25/06/2026 -> 2026-06-25
  static String displayToDb(String displayDate) {
    final date = parseDisplayDate(displayDate);
    return formatDbDate(date);
  }

  // =========================
  // TODAY / YESTERDAY / TOMORROW
  // =========================

  static String todayDb() {
    return formatDbDate(DateTime.now());
  }

  static String yesterdayDb() {
    return formatDbDate(DateTime.now().subtract(const Duration(days: 1)));
  }

  static String tomorrowDb() {
    return formatDbDate(DateTime.now().add(const Duration(days: 1)));
  }

  // =========================
  // COMPARISON
  // =========================

  static bool isSameDay(String date1, String date2) {
    return date1 == date2;
  }

  static bool isToday(String dbDate) {
    return dbDate == todayDb();
  }

  static bool isYesterday(String dbDate) {
    return dbDate == yesterdayDb();
  }

  // =========================
  // DIFFERENCE
  // =========================

  static int daysBetween(String startDate, String endDate) {
    final start = parseDbDate(startDate);
    final end = parseDbDate(endDate);

    return end.difference(start).inDays;
  }
}
