package pro.flown.dgis_maps_flutter_android;

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.List;
import java.util.Map;

public class DgisMapFactory extends PlatformViewFactory {

    private final BinaryMessenger binaryMessenger;

    DgisMapFactory(BinaryMessenger binaryMessenger, Context context) {
        super(StandardMessageCodec.INSTANCE);
        this.binaryMessenger = binaryMessenger;
    }

    @NonNull
    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        final DgisMapController controller = new DgisMapController(id, context, binaryMessenger);
        controller.init();
        return controller;
    }
}
