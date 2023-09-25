package pro.flown.dgis_maps_flutter

import android.content.Context
import android.util.Log
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.DGis
import ru.dgis.sdk.Duration
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.demo.CustomCompassManager
import ru.dgis.sdk.demo.CustomLocationManager
import ru.dgis.sdk.directory.SearchManager
import ru.dgis.sdk.directory.SearchQueryBuilder
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.positioning.registerPlatformLocationSource
import ru.dgis.sdk.positioning.registerPlatformMagneticSource
import ru.dgis.sdk.routing.*

class DgisMapController internal constructor(
        id: Int,
        context: Context,
        args: Any?,
        binaryMessenger: BinaryMessenger,
) : PlatformView, PluginHostApi {
    private val sdkContext: ru.dgis.sdk.Context
    private val flutterApi = PluginFlutterApi(binaryMessenger, id)
    private val mapView: MapView
    private var methodChannel: MethodChannel
    private lateinit var map: Map
    private lateinit var objectManager: MapObjectManager
    private lateinit var routeEditor: RouteEditor
    private var myLocationSource: MyLocationMapObjectSource? = null
    private lateinit var cameraStateConnection: AutoCloseable
    private lateinit var dataLoadingConnection: AutoCloseable

    init {
        sdkContext = DGis.initialize(context.applicationContext)
        val compassSource = CustomCompassManager(context.applicationContext)
        registerPlatformMagneticSource(sdkContext, compassSource)
        val locationSource = CustomLocationManager(context.applicationContext)
        registerPlatformLocationSource(sdkContext, locationSource)

        // Создаем канал для общения..
        methodChannel = MethodChannel(binaryMessenger, "fgis")
//        methodChannel.setMethodCallHandler(this)

        val params = DataCreationParams.fromList(args as List<Any?>)
        mapView = MapView(context, MapOptions().also {
            it.position = CameraPosition(
                    toGeoPoint(params.position), Zoom(params.zoom.toFloat())
            )
            val lightTheme = "day"
            val darkTheme = "night"
            when (params.mapTheme) {
                DataMapTheme.AUTO -> it.setTheme(lightTheme, darkTheme)
                DataMapTheme.DARK -> it.setTheme(darkTheme)
                DataMapTheme.LIGHT -> it.setTheme(lightTheme)
            }
        })
        PluginHostApi.setUp(binaryMessenger, id, this)

        mapView.getMapAsync { init(it) }

        mapView.setTouchEventsObserver(object : TouchEventsObserver {
            override fun onTap(point: ScreenPoint) {
                var isMarkerTapped = false;
                map.getRenderedObjects(point, ScreenDistance(1f)).onResult {
                    for (renderedObjectInfo in it) {
                        if (renderedObjectInfo.item.item.userData != null) {
                            val args = mapOf(
                                    "id" to renderedObjectInfo.item.item.userData
                            )

                            Log.d("DGIS", "нажатие на камеру")

                            methodChannel.invokeMethod(
                                    "ontap_marker",
                                    args
                            )
                            isMarkerTapped = true;
                        }
                    }
//                    if (!isMarkerTapped) {
//                        methodChannel.invokeMethod(
//                            "ontap_map",
//                            {},
//                        )
//                    }
                }
                super.onTap(point)
            }
        })
    }

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
        cameraStateConnection.close()
    }

    private fun init(map: Map) {
        this.map = map
        dataLoadingConnection = map.dataLoadingStateChannel.connect {
            if (it == MapDataLoadingState.LOADED) {
                flutterApi.onNativeMapReady { }
                dataLoadingConnection.close()
            }
        }
        cameraStateConnection = map.camera.stateChannel.connect {
            flutterApi.onCameraStateChanged(toDataCameraStateValue(it)) {}
        }
        routeEditor = RouteEditor(sdkContext)
        val routeEditorSource = RouteEditorSource(sdkContext, routeEditor)
        map.addSource(routeEditorSource)
        objectManager = MapObjectManager(map)
//        val searchManager = SearchManager.createOnlineManager(sdkContext)
//        searchManager.search(SearchQueryBuilder.fromQueryText("осенний").build()).onResult {
//            it.itemMarkerInfos.onResult { it ->
//                Log.v("searchMarkers", it.toString())
//            }
//            Log.v("onSearch", it.toString())
//        }
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

    override fun createRoute(startPoint: GeoPoint, endPoint: GeoPoint) {
        routeEditor.setRouteParams(
                RouteEditorRouteParams(
                        startPoint = RouteSearchPoint(
                                coordinates = toGeoPoint(startPoint)
                        ),
                        finishPoint = RouteSearchPoint(
                                coordinates = toGeoPoint(endPoint)
                        ),
                        routeSearchOptions = RouteSearchOptions(
                                car = CarRouteSearchOptions()
                        )
                )
        )
    }

    override fun updatePolylines(updates: DataPolylineUpdates) {
        objectManager.removeObjects(updates.toRemove.map { toPolyline(it!!) })
        objectManager.addObjects(updates.toAdd.map { toPolyline(it!!) })
    }
}