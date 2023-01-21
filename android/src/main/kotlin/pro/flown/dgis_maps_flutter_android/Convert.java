package pro.flown.dgis_maps_flutter_android;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.util.Size;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ru.dgis.sdk.Context;
import ru.dgis.sdk.coordinates.Bearing;
import ru.dgis.sdk.coordinates.GeoPoint;
import ru.dgis.sdk.coordinates.Latitude;
import ru.dgis.sdk.coordinates.Longitude;
import ru.dgis.sdk.map.CameraPosition;
import ru.dgis.sdk.map.Image;
import ru.dgis.sdk.map.ImagesKt;
import ru.dgis.sdk.map.Tilt;
import ru.dgis.sdk.map.Zoom;

/**
 * Conversions between JSON-like values and GoogleMaps data types.
 */
class Convert {
    private static Image toBitmapDescriptor(Context context, Object o) {
        final List<?> data = toList(o);
        switch (toString(data.get(0))) {
            case "defaultMarker":
                return null;
            case "fromAsset":
                return ImagesKt.imageFromAsset(context, toString(data.get(1)), new Size(toInt(data.get(2)), toInt(data.get(3))));
            case "fromBytes":
                try {
                    Bitmap bitmap = toBitmap(data.get(1));
                    return ImagesKt.imageFromBitmap(context, bitmap);
                } catch (Exception e) {
                    throw new IllegalArgumentException("Unable to interpret bytes as a valid image.", e);
                }
            default:
                throw new IllegalArgumentException("Cannot interpret " + o + " as BitmapDescriptor");
        }
    }

    private static boolean toBoolean(Object o) {
        return (Boolean) o;
    }

    static CameraPosition toCameraPosition(Object o) {
        final Map<?, ?> data = toMap(o);
        return new CameraPosition(
                toLatLng(data.get("target")),
                new Zoom(toFloat(data.get("zoom"))),
                new Tilt(toFloat(data.get("tilt"))),
                new Bearing(toDouble(data.get("bearing")))
        );
    }

//    static CameraUpdate toCameraUpdate(Object o, float density) {
//        final List<?> data = toList(o);
//        switch (toString(data.get(0))) {
//            case "newCameraPosition":
//                return CameraUpdateFactory.newCameraPosition(toCameraPosition(data.get(1)));
//            case "newLatLng":
//                return CameraUpdateFactory.newLatLng(toLatLng(data.get(1)));
//            case "newLatLngBounds":
//                return CameraUpdateFactory.newLatLngBounds(
//                        toLatLngBounds(data.get(1)), toPixels(data.get(2), density));
//            case "newLatLngZoom":
//                return CameraUpdateFactory.newLatLngZoom(toLatLng(data.get(1)), toFloat(data.get(2)));
//            case "scrollBy":
//                return CameraUpdateFactory.scrollBy( //
//                        toFractionalPixels(data.get(1), density), //
//                        toFractionalPixels(data.get(2), density));
//            case "zoomBy":
//                if (data.size() == 2) {
//                    return CameraUpdateFactory.zoomBy(toFloat(data.get(1)));
//                } else {
//                    return CameraUpdateFactory.zoomBy(toFloat(data.get(1)), toPoint(data.get(2), density));
//                }
//            case "zoomIn":
//                return CameraUpdateFactory.zoomIn();
//            case "zoomOut":
//                return CameraUpdateFactory.zoomOut();
//            case "zoomTo":
//                return CameraUpdateFactory.zoomTo(toFloat(data.get(1)));
//            default:
//                throw new IllegalArgumentException("Cannot interpret " + o + " as CameraUpdate");
//        }
//    }

    private static double toDouble(Object o) {
        return ((Number) o).doubleValue();
    }

    private static float toFloat(Object o) {
        return ((Number) o).floatValue();
    }

    private static Float toFloatWrapper(Object o) {
        return (o == null) ? null : toFloat(o);
    }

    private static int toInt(Object o) {
        return ((Number) o).intValue();
    }

    static Object cameraPositionToJson(CameraPosition position) {
        if (position == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>();
        data.put("bearing", position.getBearing());
        data.put("target", latLngToJson(position.getPoint()));
        data.put("tilt", position.getTilt());
        data.put("zoom", position.getZoom());
        return data;
    }

    static Object markerIdToJson(String markerId) {
        if (markerId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("markerId", markerId);
        return data;
    }

    static Object polylineIdToJson(String polylineId) {
        if (polylineId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("polylineId", polylineId);
        return data;
    }


    static Object latLngToJson(GeoPoint latLng) {
        return Arrays.asList(latLng.getLatitude().getValue(), latLng.getLongitude().getValue());
    }

    static GeoPoint toLatLng(Object o) {
        final List<?> data = toList(o);
        return new GeoPoint(new Latitude(toDouble(data.get(0))), new Longitude(toDouble(data.get(1))));
    }

    static Point toPoint(Object o) {
        Object x = toMap(o).get("x");
        Object y = toMap(o).get("y");
        return new Point((int) x, (int) y);
    }

    static Map<String, Integer> pointToJson(Point point) {
        final Map<String, Integer> data = new HashMap<>(2);
        data.put("x", point.x);
        data.put("y", point.y);
        return data;
    }

    private static List<?> toList(Object o) {
        return (List<?>) o;
    }

    private static Map<?, ?> toMap(Object o) {
        return (Map<?, ?>) o;
    }

    private static Map<String, Object> toObjectMap(Object o) {
        Map<String, Object> hashMap = new HashMap<>();
        Map<?, ?> map = (Map<?, ?>) o;
        for (Object key : map.keySet()) {
            Object object = map.get(key);
            if (object != null) {
                hashMap.put((String) key, object);
            }
        }
        return hashMap;
    }

    private static float toFractionalPixels(Object o, float density) {
        return toFloat(o) * density;
    }

    private static int toPixels(Object o, float density) {
        return (int) toFractionalPixels(o, density);
    }

    private static Bitmap toBitmap(Object o) {
        byte[] bmpData = (byte[]) o;
        Bitmap bitmap = BitmapFactory.decodeByteArray(bmpData, 0, bmpData.length);
        if (bitmap == null) {
            throw new IllegalArgumentException("Unable to decode bytes as a valid bitmap.");
        } else {
            return bitmap;
        }
    }

    private static Point toPoint(Object o, float density) {
        final List<?> data = toList(o);
        return new Point(toPixels(data.get(0), density), toPixels(data.get(1), density));
    }

    private static String toString(Object o) {
        return (String) o;
    }

//    static void interpretGoogleMapOptions(Object o, GoogleMapOptionsSink sink) {
//        final Map<?, ?> data = toMap(o);
//        final Object cameraTargetBounds = data.get("cameraTargetBounds");
//        if (cameraTargetBounds != null) {
//            final List<?> targetData = toList(cameraTargetBounds);
//            sink.setCameraTargetBounds(toLatLngBounds(targetData.get(0)));
//        }
//        final Object compassEnabled = data.get("compassEnabled");
//        if (compassEnabled != null) {
//            sink.setCompassEnabled(toBoolean(compassEnabled));
//        }
//        final Object mapToolbarEnabled = data.get("mapToolbarEnabled");
//        if (mapToolbarEnabled != null) {
//            sink.setMapToolbarEnabled(toBoolean(mapToolbarEnabled));
//        }
//        final Object mapType = data.get("mapType");
//        if (mapType != null) {
//            sink.setMapType(toInt(mapType));
//        }
//        final Object minMaxZoomPreference = data.get("minMaxZoomPreference");
//        if (minMaxZoomPreference != null) {
//            final List<?> zoomPreferenceData = toList(minMaxZoomPreference);
//            sink.setMinMaxZoomPreference( //
//                    toFloatWrapper(zoomPreferenceData.get(0)), //
//                    toFloatWrapper(zoomPreferenceData.get(1)));
//        }
//        final Object padding = data.get("padding");
//        if (padding != null) {
//            final List<?> paddingData = toList(padding);
//            sink.setPadding(
//                    toFloat(paddingData.get(0)),
//                    toFloat(paddingData.get(1)),
//                    toFloat(paddingData.get(2)),
//                    toFloat(paddingData.get(3)));
//        }
//        final Object rotateGesturesEnabled = data.get("rotateGesturesEnabled");
//        if (rotateGesturesEnabled != null) {
//            sink.setRotateGesturesEnabled(toBoolean(rotateGesturesEnabled));
//        }
//        final Object scrollGesturesEnabled = data.get("scrollGesturesEnabled");
//        if (scrollGesturesEnabled != null) {
//            sink.setScrollGesturesEnabled(toBoolean(scrollGesturesEnabled));
//        }
//        final Object tiltGesturesEnabled = data.get("tiltGesturesEnabled");
//        if (tiltGesturesEnabled != null) {
//            sink.setTiltGesturesEnabled(toBoolean(tiltGesturesEnabled));
//        }
//        final Object trackCameraPosition = data.get("trackCameraPosition");
//        if (trackCameraPosition != null) {
//            sink.setTrackCameraPosition(toBoolean(trackCameraPosition));
//        }
//        final Object zoomGesturesEnabled = data.get("zoomGesturesEnabled");
//        if (zoomGesturesEnabled != null) {
//            sink.setZoomGesturesEnabled(toBoolean(zoomGesturesEnabled));
//        }
//        final Object liteModeEnabled = data.get("liteModeEnabled");
//        if (liteModeEnabled != null) {
//            sink.setLiteModeEnabled(toBoolean(liteModeEnabled));
//        }
//        final Object myLocationEnabled = data.get("myLocationEnabled");
//        if (myLocationEnabled != null) {
//            sink.setMyLocationEnabled(toBoolean(myLocationEnabled));
//        }
//        final Object zoomControlsEnabled = data.get("zoomControlsEnabled");
//        if (zoomControlsEnabled != null) {
//            sink.setZoomControlsEnabled(toBoolean(zoomControlsEnabled));
//        }
//        final Object myLocationButtonEnabled = data.get("myLocationButtonEnabled");
//        if (myLocationButtonEnabled != null) {
//            sink.setMyLocationButtonEnabled(toBoolean(myLocationButtonEnabled));
//        }
//        final Object indoorEnabled = data.get("indoorEnabled");
//        if (indoorEnabled != null) {
//            sink.setIndoorEnabled(toBoolean(indoorEnabled));
//        }
//        final Object trafficEnabled = data.get("trafficEnabled");
//        if (trafficEnabled != null) {
//            sink.setTrafficEnabled(toBoolean(trafficEnabled));
//        }
//        final Object buildingsEnabled = data.get("buildingsEnabled");
//        if (buildingsEnabled != null) {
//            sink.setBuildingsEnabled(toBoolean(buildingsEnabled));
//        }
//    }
//
//    /**
//     * Returns the dartMarkerId of the interpreted marker.
//     */
//    static String interpretMarkerOptions(Context context, Object o, MarkerOptionsSink sink) {
//        final Map<?, ?> data = toMap(o);
//        final Object alpha = data.get("alpha");
//        if (alpha != null) {
//            sink.setAlpha(toFloat(alpha));
//        }
//        final Object anchor = data.get("anchor");
//        if (anchor != null) {
//            final List<?> anchorData = toList(anchor);
//            sink.setAnchor(toFloat(anchorData.get(0)), toFloat(anchorData.get(1)));
//        }
//        final Object consumeTapEvents = data.get("consumeTapEvents");
//        if (consumeTapEvents != null) {
//            sink.setConsumeTapEvents(toBoolean(consumeTapEvents));
//        }
//        final Object draggable = data.get("draggable");
//        if (draggable != null) {
//            sink.setDraggable(toBoolean(draggable));
//        }
//        final Object flat = data.get("flat");
//        if (flat != null) {
//            sink.setFlat(toBoolean(flat));
//        }
//        final Object icon = data.get("icon");
//        if (icon != null) {
//            sink.setIcon(toBitmapDescriptor(context, icon));
//        }
//
//        final Object position = data.get("position");
//        if (position != null) {
//            sink.setPosition(toLatLng(position));
//        }
//        final Object rotation = data.get("rotation");
//        if (rotation != null) {
//            sink.setRotation(toFloat(rotation));
//        }
//        final Object visible = data.get("visible");
//        if (visible != null) {
//            sink.setVisible(toBoolean(visible));
//        }
//        final Object zIndex = data.get("zIndex");
//        if (zIndex != null) {
//            sink.setZIndex(toFloat(zIndex));
//        }
//        final String markerId = (String) data.get("markerId");
//        if (markerId == null) {
//            throw new IllegalArgumentException("markerId was null");
//        } else {
//            return markerId;
//        }
//    }
//
//    static String interpretPolylineOptions(Object o, PolylineOptionsSink sink) {
//        final Map<?, ?> data = toMap(o);
//        final Object consumeTapEvents = data.get("consumeTapEvents");
//        if (consumeTapEvents != null) {
//            sink.setConsumeTapEvents(toBoolean(consumeTapEvents));
//        }
//        final Object color = data.get("color");
//        if (color != null) {
//            sink.setColor(toInt(color));
//        }
//        final Object endCap = data.get("endCap");
//        if (endCap != null) {
//            sink.setEndCap(toCap(endCap));
//        }
//        final Object geodesic = data.get("geodesic");
//        if (geodesic != null) {
//            sink.setGeodesic(toBoolean(geodesic));
//        }
//        final Object jointType = data.get("jointType");
//        if (jointType != null) {
//            sink.setJointType(toInt(jointType));
//        }
//        final Object startCap = data.get("startCap");
//        if (startCap != null) {
//            sink.setStartCap(toCap(startCap));
//        }
//        final Object visible = data.get("visible");
//        if (visible != null) {
//            sink.setVisible(toBoolean(visible));
//        }
//        final Object width = data.get("width");
//        if (width != null) {
//            sink.setWidth(toInt(width));
//        }
//        final Object zIndex = data.get("zIndex");
//        if (zIndex != null) {
//            sink.setZIndex(toFloat(zIndex));
//        }
//        final Object points = data.get("points");
//        if (points != null) {
//            sink.setPoints(toPoints(points));
//        }
//        final String polylineId = (String) data.get("polylineId");
//        if (polylineId == null) {
//            throw new IllegalArgumentException("polylineId was null");
//        } else {
//            return polylineId;
//        }
//    }

    private static List<GeoPoint> toPoints(Object o) {
        final List<?> data = toList(o);
        final List<GeoPoint> points = new ArrayList<>(data.size());
        for (Object rawPoint : data) {
            points.add(toLatLng(rawPoint));
        }
        return points;
    }

}