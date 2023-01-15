package pro.flown.dgis_maps_flutter_android;

import android.content.Context;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import ru.dgis.sdk.map.Map;
import ru.dgis.sdk.map.MapView;

public class DgisMapController implements PlatformView {
    private final int id;
    private final MethodChannel methodChannel;
    @Nullable
    private MapView mapView;
    private Map dgisMap;
    private final Context context;

    DgisMapController(
            int id,
            Context context,
            BinaryMessenger binaryMessenger) {
        this.id = id;
        this.context = context;
        this.mapView = new MapView(context);
        methodChannel = new MethodChannel(binaryMessenger, "dgis_maps_flutter_" + id);
    }

    @Override
    public View getView() {
        return mapView;
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
    }

    void init() {
        mapView.getMapAsync((map) -> {
            dgisMap = map;
            return null;
        });
    }

}
