class NumCast {
  const NumCast._();

  static double toDouble(dynamic v, {double fallback = 0}) {
    if (v is num) return v.toDouble();
    final s = v?.toString();
    return s == null ? fallback : (double.tryParse(s) ?? fallback);
  }

  static int toInt(dynamic v, {int fallback = 0}) {
    if (v is num) return v.toInt();
    final s = v?.toString();
    return s == null ? fallback : (int.tryParse(s) ?? fallback);
  }
}