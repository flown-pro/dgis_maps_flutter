package pro.flown.dgis_maps_flutter_android

import android.app.Application
import ru.dgis.sdk.Context
import ru.dgis.sdk.DGis

class DgisApplication : Application() {
    lateinit var sdkContext: Context
    override fun onCreate() {
        super.onCreate()
        sdkContext = DGis.initialize(this)
    }
}
