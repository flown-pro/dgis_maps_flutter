package pro.flown.dgis_maps_flutter_android

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class DgisMapFactory internal constructor(
    private val binaryMessenger: BinaryMessenger,
    context: Context?
) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        return DgisMapController(id, context, binaryMessenger)
    }
}