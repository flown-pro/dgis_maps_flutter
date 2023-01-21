package pro.flown.dgis_maps_flutter_android

import android.app.Application
import ru.dgis.sdk.Context
import ru.dgis.sdk.DGis
import ru.dgis.sdk.LogLevel
import ru.dgis.sdk.LogOptions

class DgisApplication : Application() {
    lateinit var sdkContext: Context

    override fun onCreate() {
        super.onCreate()
        DGis.initialize(this, logOptions = LogOptions(customLevel = LogLevel.VERBOSE))
    }
}
