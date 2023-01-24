package pro.flown.dgis_maps_flutter

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.DGis
import ru.dgis.sdk.Duration
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map

class DgisMapController internal constructor(
    id: Int,
    context: Context,
    args: Any?,
    binaryMessenger: BinaryMessenger,
) : PlatformView, PluginHostApi {
    private val sdkContext: ru.dgis.sdk.Context
    private val mapView: MapView
    private lateinit var map: Map
    private val flutterApi = PluginFlutterApi(binaryMessenger, id)

    init {
        sdkContext = DGis.initialize(context.applicationContext)
        val params = DataCreationParams.fromList(args as List<Any?>);
        mapView = MapView(context, MapOptions().also {
            it.position = CameraPosition(
                GeoPoint(params.position.latitude, params.position.longitude),
                Zoom(params.zoom.toFloat()),
            )
        })
        PluginHostApi.setUp(binaryMessenger, id, this)
        mapView.getMapAsync { init(it) }
    }

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
//        TODO("Not yet implemented")
    }

    private fun init(map: Map) {
        this.map = map
//
//        imageFromAsset(sdkContext, "")
//
//        methodChannel.setMethodCallHandler(this)
//        map.camera.stateChannel.connect {
//            methodChannel.invokeMethod("cameraState", it.name.lowercase())
//        }
//        map.camera.positionChannel.connect {
//            methodChannel.invokeMethod(
//                "cameraPosition", listOf(
//                    it.point.latitude.value,
//                    it.point.longitude.value,
//                    it.zoom.value,
//                    it.tilt.value,
//                    it.bearing.value
//                )
//            )
//        }
    }

    override fun getCameraPosition(callback: (DataCameraPosition) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun moveCamera(
        cameraPosition: DataCameraPosition,
        duration: Long?,
        cameraAnimationType: DataCameraAnimationType,
        callback: () -> Unit
    ) {
        map.camera.move(
            CameraPosition(
                point = GeoPoint(cameraPosition.target.latitude, cameraPosition.target.longitude),
                zoom = Zoom(cameraPosition.zoom.toFloat()),
                tilt = Tilt(cameraPosition.tilt.toFloat()),
                bearing = Bearing(cameraPosition.bearing),
            ),
            time = Duration.ofMilliseconds(duration!!),
            animationType = CameraAnimationType.valueOf(cameraAnimationType.name)
        ).onResult { callback() }
    }

    override fun updateMarkers(markerUpdates: DataMarkerUpdates) {
//        val source = MapObjectManager(map)
//
//        source.removeObjects(
//            markerUpdates.toRemove.map { toMarker(it!!) }
//        )
    }

//    private fun toMarker(marker: DataMarker): Marker {
//
//        return Marker(
//            MarkerOptions(
//                position = GeoPointWithElevation(
//                    latitude = marker.position.latitude,
//                    longitude = marker.position.longitude,
//                ),
//                icon = icon
//            )
//        )
//    }
}