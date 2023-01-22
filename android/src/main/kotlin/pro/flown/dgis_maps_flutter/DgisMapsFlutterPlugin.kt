package pro.flown.dgis_maps_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding

class DgisMapsFlutterPlugin : FlutterPlugin {

  private val VIEW_TYPE = "dgis_maps_flutter"

  // FlutterPlugin
  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    binding.platformViewRegistry.registerViewFactory(
        VIEW_TYPE,
        DgisMapFactory(binding.binaryMessenger, binding.applicationContext)
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}
}
