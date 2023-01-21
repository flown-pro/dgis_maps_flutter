import 'package:flutter/foundation.dart';

import 'bitmap.dart';
import 'location.dart';
import 'maps_object.dart';

/// Уникальный идентификатор маркера
@immutable
class MarkerId extends MapsObjectId<Marker> {
  /// Creates an immutable identifier for a [Marker].
  const MarkerId(String value) : super(value);
}

@immutable
class Marker implements MapsObject<Marker> {
  const Marker({
    required this.markerId,
    required this.position,
    this.infoText,
    this.bitmap = BitmapDescriptor.defaultMarker,
  });

  /// Уникальный идентификатор маркера
  final MarkerId markerId;

  /// Изображение маркера
  final BitmapDescriptor bitmap;

  /// Позиция маркера
  final LatLng position;

  /// Текст под маркером
  final String? infoText;

  Marker copyWith({
    LatLng? position,
    String? infoText,
    BitmapDescriptor? bitmap,
  }) =>
      Marker(
        markerId: markerId,
        position: position ?? this.position,
        infoText: infoText ?? this.infoText,
        bitmap: bitmap ?? this.bitmap,
      );

  @override
  Marker clone() => copyWith();

  @override
  MapsObjectId<Marker> get mapsId => markerId;

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('markerId', markerId);
    addIfPresent('bitmap', bitmap.toJson());
    addIfPresent('position', position.toJson());
    addIfPresent('infoText', infoText);
    return json;
  }
}
