// Autogenerated from Pigeon (v7.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package pro.flown.dgis_maps_flutter

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any> {
  return listOf<Any>(
    exception.javaClass.simpleName,
    exception.toString(),
    "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
  )
}

/**
 * Состояние камеры
 * https://docs.2gis.com/ru/android/sdk/reference/5.1/ru.dgis.sdk.map.CameraState
 */
enum class DataCameraState(val raw: Int) {
  /** Камера управляется пользователем. */
  BUSY(0),
  /** Eсть активный перелёт. */
  FLY(1),
  /** Камера в режиме слежения за позицией. */
  FOLLOWPOSITION(2),
  /** Камера не управляется пользователем и нет активных перелётов. */
  FREE(3);

  companion object {
    fun ofRaw(raw: Int): DataCameraState? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/**
 * Тип анимации при перемещении камеры
 * https://docs.2gis.com/ru/android/sdk/reference/5.1/ru.dgis.sdk.map.CameraAnimationType
 */
enum class DataCameraAnimationType(val raw: Int) {
  /** Тип перелёта выбирается в зависимости от расстояния между начальной и конечной позициями */
  DEF(0),
  /** Линейное изменение параметров позиции камеры */
  LINEAR(1),
  /**
   * Zoom изменяется таким образом, чтобы постараться в какой-то момент перелёта отобразить начальную и конечную позиции.
   * Позиции могут быть не отображены, если текущие ограничения (см. ICamera::zoom_restrictions()) не позволяют установить столь малый zoom.
   */
  SHOWBOTHPOSITIONS(2);

  companion object {
    fun ofRaw(raw: Int): DataCameraAnimationType? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataCreationParams (
  val position: DataLatLng,
  val zoom: Double

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataCreationParams {
      val position = DataLatLng.fromList(list[0] as List<Any?>)
      val zoom = list[1] as Double
      return DataCreationParams(position, zoom)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      position?.toList(),
      zoom,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataLatLng (
  val latitude: Double,
  val longitude: Double

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataLatLng {
      val latitude = list[0] as Double
      val longitude = list[1] as Double
      return DataLatLng(latitude, longitude)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      latitude,
      longitude,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataMarkerBitmap (
  /** Байты изображения */
  val bytes: ByteArray,
  /**
   * Ширина изображения,
   * если null, используется значение по умолчанию,
   * которое зависит от нативной реализации
   */
  val width: Double? = null,
  /**
   * Высота изображения,
   * если null, используется значение по умолчанию,
   * которое зависит от нативной реализации
   */
  val height: Double? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataMarkerBitmap {
      val bytes = list[0] as ByteArray
      val width = list[1] as? Double
      val height = list[2] as? Double
      return DataMarkerBitmap(bytes, width, height)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      bytes,
      width,
      height,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataMarker (
  /** Уникальный идентификатор маркера */
  val markerId: DataMapObjectId,
  /**
   * Изображение маркера
   * Используется нативная реализация дефолтного маркера,
   * если null
   */
  val bitmap: DataMarkerBitmap? = null,
  /** Позиция маркера */
  val position: DataLatLng,
  /** Текст под маркером */
  val infoText: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataMarker {
      val markerId = DataMapObjectId.fromList(list[0] as List<Any?>)
      val bitmap: DataMarkerBitmap? = (list[1] as? List<Any?>)?.let {
        DataMarkerBitmap.fromList(it)
      }
      val position = DataLatLng.fromList(list[2] as List<Any?>)
      val infoText = list[3] as? String
      return DataMarker(markerId, bitmap, position, infoText)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      markerId?.toList(),
      bitmap?.toList(),
      position?.toList(),
      infoText,
    )
  }
}

/**
 * Позиция камеры
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class DataCameraPosition (
  /** Азимут камеры в градусах */
  val bearing: Double,
  /** Центр камеры */
  val target: DataLatLng,
  /** Угол наклона камеры (в градусах) */
  val tilt: Double,
  /** Зум камеры */
  val zoom: Double

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataCameraPosition {
      val bearing = list[0] as Double
      val target = DataLatLng.fromList(list[1] as List<Any?>)
      val tilt = list[2] as Double
      val zoom = list[3] as Double
      return DataCameraPosition(bearing, target, tilt, zoom)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      bearing,
      target?.toList(),
      tilt,
      zoom,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataMapObjectId (
  val value: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataMapObjectId {
      val value = list[0] as String
      return DataMapObjectId(value)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      value,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataMarkerUpdates (
  val toRemove: List<DataMarker?>,
  val toAdd: List<DataMarker?>

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataMarkerUpdates {
      val toRemove = list[0] as List<DataMarker?>
      val toAdd = list[1] as List<DataMarker?>
      return DataMarkerUpdates(toRemove, toAdd)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      toRemove,
      toAdd,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataPolylineUpdates (
  val toRemove: List<DataPolyline?>,
  val toAdd: List<DataPolyline?>

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataPolylineUpdates {
      val toRemove = list[0] as List<DataPolyline?>
      val toAdd = list[1] as List<DataPolyline?>
      return DataPolylineUpdates(toRemove, toAdd)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      toRemove,
      toAdd,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DataPolyline (
  /** Уникальный идентификатор маркера */
  val polylineId: DataMapObjectId,
  val points: List<DataLatLng?>,
  val width: Double,
  val color: Long,
  val erasedPart: Double

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DataPolyline {
      val polylineId = DataMapObjectId.fromList(list[0] as List<Any?>)
      val points = list[1] as List<DataLatLng?>
      val width = list[2] as Double
      val color = list[3].let { if (it is Int) it.toLong() else it as Long }
      val erasedPart = list[4] as Double
      return DataPolyline(polylineId, points, width, color, erasedPart)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      polylineId?.toList(),
      points,
      width,
      color,
      erasedPart,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object PluginHostApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataCameraPosition.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataLatLng.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataLatLng.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataMapObjectId.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataMarker.fromList(it)
        }
      }
      133.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataMarkerBitmap.fromList(it)
        }
      }
      134.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataMarkerUpdates.fromList(it)
        }
      }
      135.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataPolyline.fromList(it)
        }
      }
      136.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DataPolylineUpdates.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is DataCameraPosition -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is DataLatLng -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is DataLatLng -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is DataMapObjectId -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is DataMarker -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      is DataMarkerBitmap -> {
        stream.write(133)
        writeValue(stream, value.toList())
      }
      is DataMarkerUpdates -> {
        stream.write(134)
        writeValue(stream, value.toList())
      }
      is DataPolyline -> {
        stream.write(135)
        writeValue(stream, value.toList())
      }
      is DataPolylineUpdates -> {
        stream.write(136)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface PluginHostApi {
  /**
   * Получение текущей позиции камеры
   *
   * Возвращает [DataCameraPosition]
   * Позицию камеры в текущий момент времени
   */
  fun getCameraPosition(callback: (DataCameraPosition) -> Unit)
  /**
   * Перемещение камеры к заданной позиции [CameraPosition]
   * [duration] - длительность анимации в миллисекундах,
   * если не указана, используется нативное значение
   * [cameraAnimationType] - тип анимации
   */
  fun moveCamera(cameraPosition: DataCameraPosition, duration: Long?, cameraAnimationType: DataCameraAnimationType, callback: () -> Unit)
  /**
   * Обновление маркеров
   *
   * [markerUpdates] - объект с информацией об обновлении маркеров
   */
  fun updateMarkers(markerUpdates: DataMarkerUpdates)
  /**
   * Обновление полилайнов
   *
   * [polylineUpdates] - объект с информацией об обновлении полилайнов
   */
  fun updatePolylines(polylineUpdates: DataPolylineUpdates)

  companion object {
    /** The codec used by PluginHostApi. */
    val codec: MessageCodec<Any?> by lazy {
      PluginHostApiCodec
    }
    /** Sets up an instance of `PluginHostApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, id: Int, api: PluginHostApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "pro.flown.PluginHostApi_$id.getCameraPosition", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped = listOf<Any?>()
            try {
              api.getCameraPosition() {
                reply.reply(wrapResult(it))
              }
            } catch (exception: Error) {
              wrapped = wrapError(exception)
              reply.reply(wrapped)
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "pro.flown.PluginHostApi_$id.moveCamera", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            var wrapped = listOf<Any?>()
            try {
              val args = message as List<Any?>
              val cameraPositionArg = args[0] as DataCameraPosition
              val durationArg = args[1].let { if (it is Int) it.toLong() else it as? Long }
              val cameraAnimationTypeArg = DataCameraAnimationType.ofRaw(args[2] as Int)!!
              api.moveCamera(cameraPositionArg, durationArg, cameraAnimationTypeArg) {
                reply.reply(wrapResult(null))
              }
            } catch (exception: Error) {
              wrapped = wrapError(exception)
              reply.reply(wrapped)
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "pro.flown.PluginHostApi_$id.updateMarkers", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            var wrapped = listOf<Any?>()
            try {
              val args = message as List<Any?>
              val markerUpdatesArg = args[0] as DataMarkerUpdates
              api.updateMarkers(markerUpdatesArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Error) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "pro.flown.PluginHostApi_$id.updatePolylines", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            var wrapped = listOf<Any?>()
            try {
              val args = message as List<Any?>
              val polylineUpdatesArg = args[0] as DataPolylineUpdates
              api.updatePolylines(polylineUpdatesArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Error) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
@Suppress("UNCHECKED_CAST")
class PluginFlutterApi(private val binaryMessenger: BinaryMessenger, private val id: Int) {
  companion object {
    /** The codec used by PluginFlutterApi. */
    private val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }
  }
  /**
   * Коллбэк на изменение состояния камеры
   * [cameraState] - индекс в перечислении [CameraState]
   */
  fun onCameraStateChanged(cameraStateArg: DataCameraState, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "pro.flown.PluginFlutterApi_$id.onCameraStateChanged", codec)
    channel.send(listOf(cameraStateArg)) {
      callback()
    }
  }
}
