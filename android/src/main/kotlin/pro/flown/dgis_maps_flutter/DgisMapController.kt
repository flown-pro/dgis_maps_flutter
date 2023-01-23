package pro.flown.dgis_maps_flutter

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.DGis
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
        val params = CreationParams.fromList(args as List<Any?>);
        mapView = MapView(context, MapOptions().also {
            it.position = CameraPosition(
                GeoPoint(params.position.latitude, params.position.longitude),
                Zoom(params.zoom.toFloat()),
            )
        })
        PluginHostApi.setUp(binaryMessenger, this, id)
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

    override fun asy(msg: LatLng, callback: (LatLng) -> Unit) {
        val newPos = LatLng(
            map.camera.position.point.latitude.value + msg.latitude,
            map.camera.position.point.longitude.value + msg.longitude
        )
        map.camera.move(
            map.camera.position.copy(
                point = GeoPoint(
                    newPos.latitude,
                    newPos.longitude
                )
            )
        ).onResult {
            val pos = LatLng(
                map.camera.position.point.latitude.value,
                map.camera.position.point.longitude.value
            )
            callback(pos)
        }

    }

    override fun sy(msg: LatLng): LatLng {
//        TODO("Not yet implemented")
        return LatLng(0.0, 0.0)
    }
}