package pro.flown.dgis_maps_flutter_android

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.seconds

class DgisMapController internal constructor(
    id: Int,
    context: Context,
    binaryMessenger: BinaryMessenger?
) : PlatformView, MethodChannel.MethodCallHandler {
    private val methodChannel: MethodChannel =
        MethodChannel(binaryMessenger!!, "dgis_maps_flutter_$id")
    private val mapView: MapView =
        MapView(
            context,
            MapOptions().also {
                it.position = CameraPosition(
                    GeoPoint(30.0, 30.0),
                    Zoom(3f),
                )
            }
        )
    private lateinit var map: Map

    init {
        mapView.getMapAsync { init(it) }
    }

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
    }

    private fun init(map: Map) {
        this.map = map
        methodChannel.setMethodCallHandler(this)
        map.camera.stateChannel.connect {
            methodChannel.invokeMethod("cameraState", it.name.lowercase())
        }
        map.camera.positionChannel.connect {
            methodChannel.invokeMethod(
                "cameraPosition",
                listOf(
                    it.point.latitude,
                    it.point.longitude,
                    it.zoom.value,
                    it.tilt.value,
                    it.bearing.value
                )
            )
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "camera#animate" -> {
                map.camera.move(
                    Convert.toCameraPosition(call.arguments),
                    1.seconds,
                    CameraAnimationType.DEFAULT
                )
            }
        }
    }
}