package pro.flown.dgis_maps_flutter

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import ru.dgis.sdk.Context
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.*


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

fun dataMarker2Marker(context: Context, marker: DataMarker): Marker {
    return Marker(
        MarkerOptions(
            position = GeoPointWithElevation(
                latitude = marker.position.latitude,
                longitude = marker.position.longitude,
            ),
            icon = dataBitmap2Icon(context, marker.bitmap)?: imageFromResource(context,R.drawable.dgis_ic_road_event_marker_comment),
            text = marker.infoText ?: ""
        )
    )
}