// Autogenerated from Pigeon (v7.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif



private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: FlutterError) -> [Any?] {
  return [
    error.code,
    error.message,
    error.details
  ]
}

/// Состояние камеры
/// https://docs.2gis.com/ru/android/sdk/reference/5.1/ru.dgis.sdk.map.CameraState
enum CameraState: Int {
  /// Камера управляется пользователем.
  case busy = 0
  /// Eсть активный перелёт.
  case fly = 1
  /// Камера в режиме слежения за позицией.
  case followPosition = 2
  /// Камера не управляется пользователем и нет активных перелётов.
  case free = 3
}

/// Тип анимации при перемещении камеры
/// https://docs.2gis.com/ru/android/sdk/reference/5.1/ru.dgis.sdk.map.CameraAnimationType
enum CameraAnimationType: Int {
  /// Тип перелёта выбирается в зависимости от расстояния между начальной и конечной позициями
  case def = 0
  /// Линейное изменение параметров позиции камеры
  case linear = 1
  /// Zoom изменяется таким образом, чтобы постараться в какой-то момент перелёта отобразить начальную и конечную позиции.
  /// Позиции могут быть не отображены, если текущие ограничения (см. ICamera::zoom_restrictions()) не позволяют установить столь малый zoom.
  case showBothPositions = 2
}

/// Generated class from Pigeon that represents data sent in messages.
struct CreationParams {
  var position: LatLng
  var zoom: Double

  static func fromList(_ list: [Any?]) -> CreationParams? {
    let position = LatLng.fromList(list[0] as! [Any?])!
    let zoom = list[1] as! Double

    return CreationParams(
      position: position,
      zoom: zoom
    )
  }
  func toList() -> [Any?] {
    return [
      position.toList(),
      zoom,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct LatLng {
  var latitude: Double
  var longitude: Double

  static func fromList(_ list: [Any?]) -> LatLng? {
    let latitude = list[0] as! Double
    let longitude = list[1] as! Double

    return LatLng(
      latitude: latitude,
      longitude: longitude
    )
  }
  func toList() -> [Any?] {
    return [
      latitude,
      longitude,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MarkerBitmap {
  /// Байты изображения
  var bytes: FlutterStandardTypedData
  /// Ширина изображения,
  /// если null, используется значение по умолчанию,
  /// которое зависит от нативной реализации
  var width: Double? = nil
  /// Высота изображения,
  /// если null, используется значение по умолчанию,
  /// которое зависит от нативной реализации
  var height: Double? = nil

  static func fromList(_ list: [Any?]) -> MarkerBitmap? {
    let bytes = list[0] as! FlutterStandardTypedData
    let width = list[1] as? Double 
    let height = list[2] as? Double 

    return MarkerBitmap(
      bytes: bytes,
      width: width,
      height: height
    )
  }
  func toList() -> [Any?] {
    return [
      bytes,
      width,
      height,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct Marker {
  /// Уникальный идентификатор маркера
  var markerId: MarkerId
  /// Изображение маркера
  /// Используется нативная реализация дефолтного маркера,
  /// если null
  var bitmap: MarkerBitmap? = nil
  /// Позиция маркера
  var position: LatLng
  /// Текст под маркером
  var infoText: String? = nil

  static func fromList(_ list: [Any?]) -> Marker? {
    let markerId = MarkerId.fromList(list[0] as! [Any?])!
    var bitmap: MarkerBitmap? = nil
    if let bitmapList = list[1] as? [Any?] {
      bitmap = MarkerBitmap.fromList(bitmapList)
    }
    let position = LatLng.fromList(list[2] as! [Any?])!
    let infoText = list[3] as? String 

    return Marker(
      markerId: markerId,
      bitmap: bitmap,
      position: position,
      infoText: infoText
    )
  }
  func toList() -> [Any?] {
    return [
      markerId.toList(),
      bitmap?.toList(),
      position.toList(),
      infoText,
    ]
  }
}

/// Позиция камеры
///
/// Generated class from Pigeon that represents data sent in messages.
struct CameraPosition {
  /// Азимут камеры в градусах
  var bearing: Double
  /// Центр камеры
  var target: LatLng
  /// Угол наклона камеры (в градусах)
  var tilt: Double
  /// Зум камеры
  var zoom: Double

  static func fromList(_ list: [Any?]) -> CameraPosition? {
    let bearing = list[0] as! Double
    let target = LatLng.fromList(list[1] as! [Any?])!
    let tilt = list[2] as! Double
    let zoom = list[3] as! Double

    return CameraPosition(
      bearing: bearing,
      target: target,
      tilt: tilt,
      zoom: zoom
    )
  }
  func toList() -> [Any?] {
    return [
      bearing,
      target.toList(),
      tilt,
      zoom,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MarkerId {
  var value: String

  static func fromList(_ list: [Any?]) -> MarkerId? {
    let value = list[0] as! String

    return MarkerId(
      value: value
    )
  }
  func toList() -> [Any?] {
    return [
      value,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MarkerUpdates {
  var toRemove: [Marker?]
  var toChange: [Marker?]
  var toAdd: [Marker?]

  static func fromList(_ list: [Any?]) -> MarkerUpdates? {
    let toRemove = list[0] as! [Marker?]
    let toChange = list[1] as! [Marker?]
    let toAdd = list[2] as! [Marker?]

    return MarkerUpdates(
      toRemove: toRemove,
      toChange: toChange,
      toAdd: toAdd
    )
  }
  func toList() -> [Any?] {
    return [
      toRemove,
      toChange,
      toAdd,
    ]
  }
}

private class PluginHostApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return CameraPosition.fromList(self.readValue() as! [Any])
      case 129:
        return LatLng.fromList(self.readValue() as! [Any])
      case 130:
        return Marker.fromList(self.readValue() as! [Any])
      case 131:
        return MarkerBitmap.fromList(self.readValue() as! [Any])
      case 132:
        return MarkerId.fromList(self.readValue() as! [Any])
      case 133:
        return MarkerUpdates.fromList(self.readValue() as! [Any])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class PluginHostApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? CameraPosition {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? LatLng {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? Marker {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? MarkerBitmap {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else if let value = value as? MarkerId {
      super.writeByte(132)
      super.writeValue(value.toList())
    } else if let value = value as? MarkerUpdates {
      super.writeByte(133)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class PluginHostApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return PluginHostApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return PluginHostApiCodecWriter(data: data)
  }
}

class PluginHostApiCodec: FlutterStandardMessageCodec {
  static let shared = PluginHostApiCodec(readerWriter: PluginHostApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol PluginHostApi {
  /// Получение текущей позиции камеры
  ///
  /// Возвращает [CameraPosition]
  /// Позицию камеры в текущий момент времени
  func getCameraPosition(completion: @escaping (CameraPosition) -> Void)
  /// Перемещение камеры к заданной позиции [CameraPosition]
  /// [duration] - длительность анимации в миллисекундах,
  /// если не указана, используется нативное значение
  /// [cameraAnimationType] - тип анимации
  func moveCamera(cameraPosition: CameraPosition, duration: Int32?, cameraAnimationType: CameraAnimationType, completion: @escaping () -> Void)
  /// Обновление маркеров
  ///
  /// [markerUpdates] - объект с информацией об обновлении маркеров
  func updateMarkers(markerUpdates: MarkerUpdates)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class PluginHostApiSetup {
  /// The codec used by PluginHostApi.
  static var codec: FlutterStandardMessageCodec { PluginHostApiCodec.shared }
  /// Sets up an instance of `PluginHostApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: PluginHostApi?, id: Int64?) {
    /// Получение текущей позиции камеры
    ///
    /// Возвращает [CameraPosition]
    /// Позицию камеры в текущий момент времени
    let getCameraPositionChannel = FlutterBasicMessageChannel(name: "pro.flown.PluginHostApi_\(id ?? 0).getCameraPosition", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getCameraPositionChannel.setMessageHandler { _, reply in
        api.getCameraPosition() { result in
          reply(wrapResult(result))
        }
      }
    } else {
      getCameraPositionChannel.setMessageHandler(nil)
    }
    /// Перемещение камеры к заданной позиции [CameraPosition]
    /// [duration] - длительность анимации в миллисекундах,
    /// если не указана, используется нативное значение
    /// [cameraAnimationType] - тип анимации
    let moveCameraChannel = FlutterBasicMessageChannel(name: "pro.flown.PluginHostApi_\(id ?? 0).moveCamera", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      moveCameraChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let cameraPositionArg = args[0] as! CameraPosition
        let durationArg = args[1] as? Int32
        let cameraAnimationTypeArg = CameraAnimationType(rawValue: args[2] as! Int)!
        api.moveCamera(cameraPosition: cameraPositionArg, duration: durationArg, cameraAnimationType: cameraAnimationTypeArg) {
          reply(wrapResult(nil))
        }
      }
    } else {
      moveCameraChannel.setMessageHandler(nil)
    }
    /// Обновление маркеров
    ///
    /// [markerUpdates] - объект с информацией об обновлении маркеров
    let updateMarkersChannel = FlutterBasicMessageChannel(name: "pro.flown.PluginHostApi_\(id ?? 0).updateMarkers", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      updateMarkersChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let markerUpdatesArg = args[0] as! MarkerUpdates
        api.updateMarkers(markerUpdates: markerUpdatesArg)
        reply(wrapResult(nil))
      }
    } else {
      updateMarkersChannel.setMessageHandler(nil)
    }
  }
}
/// Generated class from Pigeon that represents Flutter messages that can be called from Swift.
class PluginFlutterApi {
  private let binaryMessenger: FlutterBinaryMessenger
  private let id: Int64?
  init(binaryMessenger: FlutterBinaryMessenger, id: Int64?){
    self.binaryMessenger = binaryMessenger
    self.id = id
  }
  /// Коллбэк на изменение состояния камеры
  /// [cameraState] - индекс в перечислении [CameraState]
  /// TODO(kit): Изменить на enum после фикса
  /// https://github.com/flutter/flutter/issues/87307
  func onCameraStateChanged(cameraState cameraStateArg: CameraState, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "pro.flown.PluginFlutterApi_\(id ?? 0).onCameraStateChanged", binaryMessenger: binaryMessenger)
    channel.sendMessage([cameraStateArg] as [Any?]) { _ in
      completion()
    }
  }
}
