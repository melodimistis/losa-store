bool isNewerVersion(String current, String latest) {
  List<int> parse(String v) =>
      v.split('+').first.split('.').map((e) => int.tryParse(e) ?? 0).toList();

  final c = parse(current), l = parse(latest);
  final len = c.length > l.length ? c.length : l.length;
  for (var i = 0; i < len; i++) {
    final a = i < c.length ? c[i] : 0;
    final b = i < l.length ? l[i] : 0;
    if (b != a) return b > a;
  }

  return false;
}
