package pro.flown.dgis_maps_flutter

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.DGis
import ru.dgis.sdk.Duration
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.demo.CustomCompassManager
import ru.dgis.sdk.demo.CustomLocationManager
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.positioning.registerPlatformLocationSource
import ru.dgis.sdk.positioning.registerPlatformMagneticSource

class DgisMapController internal constructor(
    id: Int,
    context: Context,
    args: Any?,
    binaryMessenger: BinaryMessenger,
) : PlatformView, PluginHostApi {
    private val sdkContext: ru.dgis.sdk.Context
    private val mapView: MapView
    private lateinit var map: Map
    private lateinit var objectManager: MapObjectManager
    private lateinit var myLocationSource: MyLocationMapObjectSource
    private val flutterApi = PluginFlutterApi(binaryMessenger, id)

    init {
        sdkContext = DGis.initialize(context.applicationContext)
        val compassSource = CustomCompassManager(context.applicationContext)
        registerPlatformMagneticSource(sdkContext, compassSource)
        val locationSource = CustomLocationManager(context.applicationContext)
        registerPlatformLocationSource(sdkContext, locationSource)

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
        objectManager = MapObjectManager(map)
        initLocationSource()
//        map.camera.stateChannel.connect {
//            flutterApi.onCameraStateChanged(cameraStateArg = toDataCameraState(it)) {}
//        }
    }


    private fun initLocationSource() {
        myLocationSource = MyLocationMapObjectSource(
            sdkContext,
            MyLocationDirectionBehaviour.FOLLOW_SATELLITE_HEADING,
            createSmoothMyLocationController()
        )
    }

    override fun changeMyLocationLayerState(isVisible: Boolean) {
        val isMyLocationVisible = map.sources.contains(myLocationSource);
        if (isVisible && !isMyLocationVisible) {
            map.addSource(myLocationSource);
        } else if (!isVisible && isMyLocationVisible) {
            map.removeSource(myLocationSource);
        }
    }

    override fun getCameraPosition(): DataCameraPosition {
        return DataCameraPosition(
            target = DataLatLng(
                map.camera.position.point.latitude.value,
                map.camera.position.point.longitude.value
            ),
            zoom = map.camera.position.zoom.value.toDouble(),
            bearing = map.camera.position.bearing.value,
            tilt = map.camera.position.tilt.value.toDouble(),
        )
    }

    override fun moveCamera(
        cameraPosition: DataCameraPosition,
        duration: Long?,
        cameraAnimationType: DataCameraAnimationType,
        callback: () -> Unit,
    ) {
        map.camera.move(
            CameraPosition(
                point = GeoPoint(cameraPosition.target.latitude, cameraPosition.target.longitude),
                zoom = Zoom(cameraPosition.zoom.toFloat()),
                tilt = Tilt(cameraPosition.tilt.toFloat()),
                bearing = Bearing(cameraPosition.bearing),
            ),
            time = Duration.ofMilliseconds(duration!!),
            animationType = toAnimationType(cameraAnimationType)
        ).onResult { callback() }
    }

    override fun updateMarkers(markerUpdates: DataMarkerUpdates) {
        objectManager.removeObjects(markerUpdates.toRemove.map {
            dataMarker2Marker(
                sdkContext,
                it!!
            )
        })
        objectManager.addObjects(markerUpdates.toAdd.map { dataMarker2Marker(sdkContext, it!!) })
    }

    override fun updatePolylines(polylineUpdates: DataPolylineUpdates) {
        objectManager.removeObjects(polylineUpdates.toRemove.map {
            dataPolyline2Polyline(
                sdkContext,
                it!!
            )
        })
        objectManager.addObjects(polylineUpdates.toAdd.map {
            dataPolyline2Polyline(
                sdkContext,
                it!!
            )
        })
    }

}