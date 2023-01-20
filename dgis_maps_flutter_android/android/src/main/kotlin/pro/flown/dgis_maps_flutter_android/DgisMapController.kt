package pro.flown.dgis_maps_flutter_android

import android.content.Context
import android.util.Log
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map

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

    private fun init(map: Map?) {
        if (map == null) return
        this.map = map
        methodChannel.setMethodCallHandler(this)
        methodChannel.invokeMethod("blah", 1234)
        map.camera.stateChannel.connect {
            when(it){
                CameraState.BUSY -> TODO()
                CameraState.FLY -> TODO()
                CameraState.FOLLOW_POSITION -> TODO()
                CameraState.FREE -> TODO()
            }
        }
    }

    fun pubIdle() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "some" -> {

            }
        }
    }
}