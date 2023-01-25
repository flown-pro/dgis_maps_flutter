package pro.flown.dgis_maps_flutter

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.DGis
import ru.dgis.sdk.Duration
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.demo.CustomCompassManager
import ru.dgis.sdk.demo.CustomLocationManager
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
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
    private val flutterApi = PluginFlutterApi(binaryMessenger, id)
    private val mapView: MapView
    private lateinit var map: Map
    private lateinit var objectManager: MapObjectManager
    private var myLocationSource: MyLocationMapObjectSource? = null
    private lateinit var cameraStateConnection: AutoCloseable

    init {
        sdkContext = DGis.initialize(context.applicationContext)
        val compassSource = CustomCompassManager(context.applicationContext)
        registerPlatformMagneticSource(sdkContext, compassSource)
        val locationSource = CustomLocationManager(context.applicationContext)
        registerPlatformLocationSource(sdkContext, locationSource)

        val params = DataCreationParams.fromList(args as List<Any?>)
        mapView = MapView(context, MapOptions().also {
            it.position = CameraPosition(
                toGeoPoint(params.position), Zoom(params.zoom.toFloat())
            )
        })
        PluginHostApi.setUp(binaryMessenger, id, this)
        mapView.getMapAsync { init(it) }
    }

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
        cameraStateConnection.close()
    }

    private fun init(map: Map) {
        this.map = map
        objectManager = MapObjectManager(map)
        flutterApi.onNativeMapReady { }
        cameraStateConnection = map.camera.stateChannel.connect {
            flutterApi.onCameraStateChanged(cameraStateArg = toDataCameraStateValue(it)) {}
        }
    }

    override fun changeMyLocationLayerState(isVisible: Boolean) {
        myLocationSource = myLocationSource ?: MyLocationMapObjectSource(
            sdkContext,
            MyLocationDirectionBehaviour.FOLLOW_SATELLITE_HEADING,
            createSmoothMyLocationController()
        )
        val isMyLocationVisible = map.sources.contains(myLocationSource!!)
        if (isVisible && !isMyLocationVisible) {
            map.addSource(myLocationSource!!)
        } else if (!isVisible && isMyLocationVisible) {
            map.removeSource(myLocationSource!!)
        }
    }

    override fun getCameraPosition(): DataCameraPosition {
        return DataCameraPosition(
            target = toDataLatLng(map.camera.position.point),
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
                point = toGeoPoint(cameraPosition.target),
                zoom = Zoom(cameraPosition.zoom.toFloat()),
                tilt = Tilt(cameraPosition.tilt.toFloat()),
                bearing = Bearing(cameraPosition.bearing),
            ), time = Duration.ofMilliseconds(duration ?: 100),
            animationType = toAnimationType(cameraAnimationType)
        ).onResult { callback() }
    }

    override fun getVisibleArea(): DataLatLngBounds {
        return geoRectToBounds(map.camera.visibleArea.bounds);
    }

    override fun moveCameraToBounds(
        firstPoint: DataLatLng,
        secondPoint: DataLatLng,
        padding: DataPadding,
        duration: Long?,
        cameraAnimationType: DataCameraAnimationType,
        callback: () -> Unit,
    ) {
        val geometry = ComplexGeometry(
            listOf(
                PointGeometry(toGeoPoint(firstPoint)), PointGeometry(toGeoPoint(secondPoint))
            )
        )
        val position = calcPosition(
            map.camera, geometry, toPadding(padding)
        )
        map.camera.move(
            position, time = Duration.ofMilliseconds(duration ?: 100),
            animationType = toAnimationType(cameraAnimationType)
        ).onResult { callback() }
    }

    override fun updateMarkers(updates: DataMarkerUpdates) {
        objectManager.removeObjects(updates.toRemove.map { toMarker(sdkContext, it!!) })
        objectManager.addObjects(updates.toAdd.map { toMarker(sdkContext, it!!) })
    }

    override fun updatePolylines(updates: DataPolylineUpdates) {
        objectManager.removeObjects(updates.toRemove.map { toPolyline(it!!) })
        objectManager.addObjects(updates.toAdd.map { toPolyline(it!!) })
    }
}