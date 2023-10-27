class GeoPoint {
  GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  /// Координата долготы
  double latitude;

  /// Координата широты
  double longitude;

  Object encode() {
    return <Object?>[
      latitude,
      longitude,
    ];
  }

  static GeoPoint decode(Object result) {
    result as List<Object?>;
    return GeoPoint(
      latitude: result[0]! as double,
      longitude: result[1]! as double,
    );
  }
}
