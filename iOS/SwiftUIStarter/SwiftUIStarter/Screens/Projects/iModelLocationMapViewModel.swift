//
//  iModelLocationMapViewModel.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/30/21.
//

import Foundation
import MapKit

extension iModelLocationMapView {
    class ViewModel: ObservableObject {
        
        struct MapMarkerLocation: Identifiable {
            let id = UUID()
            let coord: CLLocationCoordinate2D
        }
        
        var iModel: iModel
        @Published var coordinateRegion: MKCoordinateRegion
        var centerPoint: MapMarkerLocation
        
        init(with iModel: iModel) {
            self.iModel = iModel
            coordinateRegion = MKCoordinateRegion(.world)
            centerPoint = MapMarkerLocation(coord:CLLocationCoordinate2D(latitude: 0, longitude: 0))
            
            setCoordinateRegion()
        }
        
        private func setCoordinateRegion() {
            guard let extents = iModel.extent else {
                coordinateRegion = MKCoordinateRegion(.world)
                return
            }
            
            let x = extents.southWest.longitude ?? 0.0
            let y = extents.southWest.latitude ?? 0.0
            
            let height = abs(((extents.northEast.longitude ?? 0.0) - (extents.southWest.longitude ?? 0.0)))
            let width = abs(((extents.northEast.latitude ?? 0.0) - (extents.southWest.latitude ?? 0.0)))
            
            let center = CLLocationCoordinate2D(latitude: y + width / 2.0, longitude: x + height / 2.0)
            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            
            let mapRegion = MKCoordinateRegion(center: center, span: span)
            
            self.centerPoint = MapMarkerLocation(coord: center)
            self.coordinateRegion = mapRegion
        }
    }
}
