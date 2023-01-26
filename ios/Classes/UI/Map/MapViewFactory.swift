import SwiftUI
import DGis

struct MapViewFactory {
    private let mapFactory: IMapFactory

    internal init(mapFactory: IMapFactory) {
        self.mapFactory = mapFactory
    }

    func makeMapView(
        appearance: MapAppearance? = nil,
        alignment: CopyrightAlignment = .bottomRight,
        mapGesturesType: MapGesturesType = .default(.event),
        copyrightInsets: UIEdgeInsets = .zero,
        tapRecognizerCallback: MapView.TapRecognizerCallback? = nil,
        markerViewOverlay: IMarkerViewOverlay? = nil
    ) -> MapView {
        MapView(
            mapGesturesType: mapGesturesType,
            appearance: appearance,
            copyrightInsets: copyrightInsets,
            copyrightAlignment: alignment,
            tapRecognizerCallback: tapRecognizerCallback,
            mapUIViewFactory: { [mapFactory = self.mapFactory] in
                mapFactory.mapView
            },
            markerViewOverlay: markerViewOverlay
        )
    }
    
    func makeMapViewWithMarkerViewOverlay(
        tapRecognizerCallback: MapView.TapRecognizerCallback? = nil
    ) -> MapView {
        self.makeMapView(
            tapRecognizerCallback: tapRecognizerCallback,
            markerViewOverlay: mapFactory.markerViewOverlay
        )
    }

}
