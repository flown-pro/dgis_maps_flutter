package pro.flown.dgis_maps_flutter

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import ru.dgis.sdk.Context
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.*


fun toAnimationType(cameraAnimationType: DataCameraAnimationType): CameraAnimationType {
    return when (cameraAnimationType) {
        DataCameraAnimationType.DEF -> CameraAnimationType.DEFAULT
        DataCameraAnimationType.LINEAR -> CameraAnimationType.LINEAR
        DataCameraAnimationType.SHOWBOTHPOSITIONS -> CameraAnimationType.SHOW_BOTH_POSITIONS
    }
}

fun toDataCameraStateValue(cameraState: CameraState): DataCameraStateValue {
    return DataCameraStateValue(
        when (cameraState) {
            CameraState.BUSY -> DataCameraState.BUSY
            CameraState.FLY -> DataCameraState.FLY
            CameraState.FOLLOW_POSITION -> DataCameraState.FOLLOWPOSITION
            CameraState.FREE -> DataCameraState.FREE
        }
    )
}

private fun toBitmap(o: Any): Bitmap? {
    val bmpData = o as ByteArray
    val bitmap = BitmapFactory.decodeByteArray(bmpData, 0, bmpData.size)
    return bitmap ?: throw IllegalArgumentException("Unable to decode bytes as a valid bitmap.")
}

fun dataBitmap2Icon(context: Context, data: DataMarkerBitmap?): Image? {
    if (data == null) return null;
    val bitmap = toBitmap(data.bytes) ?: return null
    return imageFromBitmap(context, bitmap)
}

@SuppressLint("PrivateResource")
fun dataMarker2Marker(context: Context, marker: DataMarker): Marker {
    return Marker(
        MarkerOptions(
            position = GeoPointWithElevation(
                latitude = marker.position.latitude,
                longitude = marker.position.longitude,
            ),
            icon = dataBitmap2Icon(context, marker.bitmap) ?: imageFromResource(
                context,
                R.drawable.dgis_ic_road_event_marker_comment
            ),
            text = marker.infoText ?: ""
        )
    )
}

fun dataPolyline2Polyline(context: Context, polyline: DataPolyline): Polyline {
    return Polyline(
        PolylineOptions(
            points = polyline.points.map { GeoPoint(it!!.latitude, it.longitude) }.toList(),
            color = Color(polyline.color.toInt()),
            erasedPart = polyline.erasedPart,
            width = LogicalPixel(polyline.width.toFloat()),
        )
    )
}