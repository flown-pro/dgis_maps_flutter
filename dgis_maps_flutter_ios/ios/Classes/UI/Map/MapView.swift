import SwiftUI
import DGis

protocol IMapOverlayView: UIView {
    var visibleAreaEdgeInsets: UIEdgeInsets { get }
    var visibleAreaEdgeInsetsChangedCallback: ((UIEdgeInsets) -> Void)? { get set }
}

protocol IMapViewOverlayFactory {
    func makeOverlayView() -> IMapOverlayView
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = UIView
    typealias Context = UIViewRepresentableContext<Self>
    typealias URLOpener = (URL) -> Void
    typealias TapRecognizerCallback = (CGPoint) -> Void

    private var mapFactoryProvider: IMapFactoryProvider?
    private let urlOpener: URLOpener?
    private var mapGesturesType: MapGesturesType

    private let overlayFactory: IMapViewOverlayFactory?
    private let tapRecognizerCallback: TapRecognizerCallback?
    private let mapUIViewFactory: () -> UIView & IMapView
    private let appearance: MapAppearance?
    private var showsAPIVersion: Bool
    private var copyrightInsets: UIEdgeInsets
    private var copyrightAlignment: DGis.CopyrightAlignment

    init(
        mapGesturesType: MapGesturesType,
        urlOpener: URLOpener? = nil,
        appearance: MapAppearance?,
        copyrightInsets: UIEdgeInsets = .zero,
        copyrightAlignment: DGis.CopyrightAlignment = .bottomRight,
        showsAPIVersion: Bool = true,
        overlayFactory: IMapViewOverlayFactory? = nil,
        tapRecognizerCallback: TapRecognizerCallback? = nil,
        mapUIViewFactory: @escaping () -> UIView & IMapView
    ) {
        self.mapGesturesType = mapGesturesType
        self.urlOpener = urlOpener
        self.appearance = appearance
        self.copyrightInsets = copyrightInsets
        self.copyrightAlignment = copyrightAlignment
        self.showsAPIVersion = showsAPIVersion
        self.overlayFactory = overlayFactory
        self.tapRecognizerCallback = tapRecognizerCallback
        self.mapUIViewFactory = mapUIViewFactory
    }

    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(mapGesturesType: self.mapGesturesType)
    }

    func makeUIView(context: Context) -> UIView {
        let mapViewContainer = MapContainerView(
            overlayFactory: self.overlayFactory,
            mapUIViewFactory: self.mapUIViewFactory
            
        )
        mapViewContainer.mapTapRecognizerCallback = self.tapRecognizerCallback
        if let mapFactoryProvider = self.mapFactoryProvider {
            mapViewContainer.mapView.gestureView = mapFactoryProvider.makeGestureView(
                mapGesturesType: self.mapGesturesType
            )
        }

        self.updateMapView(mapViewContainer.mapView)
        return mapViewContainer
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.mapGesturesType = self.mapGesturesType
        guard let mapContainer = uiView as? MapContainerView else { return }
        let mapView = mapContainer.mapView
        self.updateMapView(mapView)
        context.coordinator.gesturesTypeChanged = {
            [weak mapView, weak mapFactoryProvider = self.mapFactoryProvider] type in
            if let mapFactoryProvider = mapFactoryProvider {
                mapView?.gestureView = mapFactoryProvider.makeGestureView(
                    mapGesturesType: type
                )
            }
        }
    }

 

    private func updateMapView(_ mapView: UIView & IMapView) {
        if let appearance = self.appearance, appearance != mapView.appearance {
            mapView.appearance = appearance
        }
        mapView.copyrightInsets = self.copyrightInsets
        mapView.showsAPIVersion = self.showsAPIVersion
        mapView.copyrightAlignment = self.copyrightAlignment
        mapView.urlOpener = self.urlOpener
    }
}

private final class MapContainerView: UIView {
    private let overlayFactory: IMapViewOverlayFactory?
    private let mapUIViewFactory: () -> UIView & IMapView
    

    var mapTapRecognizerCallback: ((CGPoint) -> Void)?

    private(set) lazy var mapView: IMapView = self.mapUIViewFactory()

    init(
        frame: CGRect = .zero,
        overlayFactory: IMapViewOverlayFactory?,
        mapUIViewFactory: @escaping () -> UIView & IMapView
    ) {
        self.overlayFactory = overlayFactory
        self.mapUIViewFactory = mapUIViewFactory
        super.init(frame: frame)

        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(frame:overlayFactory:mapUIViewFactory:markerViewOverlayFactory:)")
    }

    private func setupUI() {
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.mapViewTapped(_:))
        )
        self.mapView.addGestureRecognizer(tapRecognizer)
        self.addSubview(self.mapView)
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mapView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mapView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        if let overlayView = self.overlayFactory?.makeOverlayView() {
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(overlayView)
            NSLayoutConstraint.activate([
                overlayView.topAnchor.constraint(equalTo: self.topAnchor),
                overlayView.leftAnchor.constraint(equalTo: self.leftAnchor),
                overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                overlayView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
        }
        
    }

    @objc private func mapViewTapped(_ sender: UITapGestureRecognizer) {
        self.mapTapRecognizerCallback?(sender.location(in: self.mapView))
    }
}

class MapViewCoordinator {
    typealias GesturesTypeChangedCallback = (MapGesturesType) -> Void
    var mapGesturesType: MapGesturesType {
        didSet {
            if oldValue != self.mapGesturesType {
                self.gesturesTypeChanged?(self.mapGesturesType)
            }
        }
    }
    var gesturesTypeChanged: GesturesTypeChangedCallback?

    init(mapGesturesType: MapGesturesType) {
        self.mapGesturesType = mapGesturesType
    }
}

extension MapView {
    func showsAPIVersion(_ show: Bool) -> MapView {
        return self.modified { $0.showsAPIVersion = show }
    }

    func copyrightInsets(_ insets: UIEdgeInsets) -> MapView {
        return self.modified { $0.copyrightInsets = insets }
    }

    func copyrightAlignment(_ alignment: DGis.CopyrightAlignment) -> MapView {
        return self.modified { $0.copyrightAlignment = alignment }
    }
}

private extension MapView {
    func modified(with modifier: (inout MapView) -> Void) -> MapView {
        var view = self
        modifier(&view)
        return view
    }
}

extension MapView {
    init(
        mapFactoryProvider: IMapFactoryProvider,
        mapGesturesType: MapGesturesType,
        urlOpener: URLOpener? = nil,
        appearance: MapAppearance? = nil,
        copyrightInsets: UIEdgeInsets = .zero,
        copyrightAlignment: DGis.CopyrightAlignment = .bottomRight,
        showsAPIVersion: Bool = true,
        overlayFactory: IMapViewOverlayFactory? = nil,
        tapRecognizerCallback: TapRecognizerCallback? = nil,
        mapUIViewFactory: @escaping () -> UIView & IMapView
        
    ) {
        self.mapFactoryProvider = mapFactoryProvider
        self.mapGesturesType = mapGesturesType
        self.urlOpener = urlOpener
        self.appearance = appearance
        self.copyrightInsets = copyrightInsets
        self.copyrightAlignment = copyrightAlignment
        self.showsAPIVersion = showsAPIVersion
        self.overlayFactory = overlayFactory
        self.tapRecognizerCallback = tapRecognizerCallback
        self.mapUIViewFactory = mapUIViewFactory
        
    }
}
