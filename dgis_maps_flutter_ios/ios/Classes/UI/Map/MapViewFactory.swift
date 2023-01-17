import SwiftUI
import DGis

struct MapViewFactory {
    private let sdk: DGis.Container
    private let mapFactory: IMapFactory
    private let settingsService: ISettingsService

    internal init(
        sdk: DGis.Container,
        mapFactory: IMapFactory,
        settingsService: ISettingsService
    ) {
        self.sdk = sdk
        self.mapFactory = mapFactory
        self.settingsService = settingsService
    }

    func makeMapView(
        appearance: MapAppearance? = nil,
        alignment: CopyrightAlignment = .bottomRight,
        mapGesturesType: MapGesturesType = .default(.event),
        copyrightInsets: UIEdgeInsets = .zero,
        showsAPIVersion: Bool = true,
        overlayFactory: IMapViewOverlayFactory? = nil,
        tapRecognizerCallback: MapView.TapRecognizerCallback? = nil

    ) -> MapView {
        MapView(
            mapGesturesType: mapGesturesType,
            appearance: appearance,
            copyrightInsets: copyrightInsets,
            copyrightAlignment: alignment,
            showsAPIVersion: showsAPIVersion,
            overlayFactory: overlayFactory,
            tapRecognizerCallback: tapRecognizerCallback,
            mapUIViewFactory: { [mapFactory = self.mapFactory] in
                mapFactory.mapView
            }

        )
    }

}
