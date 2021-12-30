//
//  iModelLocationMapView.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/30/21.
//

import SwiftUI
import MapKit

struct iModelLocationMapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var mapRegion: MKCoordinateRegion? = nil
    @StateObject private var vm: ViewModel
    
    init(iModel: iModel) {
        self._vm = StateObject(wrappedValue: ViewModel(with: iModel))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $vm.coordinateRegion, showsUserLocation: false, annotationItems: [vm.centerPoint]) {
                    point in
                    MapMarker(coordinate: point.coord, tint: .teal)
                }
            }
            .navigationTitle(vm.iModel.displayName ?? "iModel Extents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}

struct iModelLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        // Previews don't work with the iTwin.js sdk yet, no sense in doing anything reasonable here.
        iModelLocationMapView(iModel: iModel(id: UUID().uuidString, displayName: "Test iModel", name: "Test name", description: "Not very descriptive", projectId: "1234", extent: iModel.Extent(southWest: iModel.Coordinate(latitude: 0, longitude: 0), northEast: iModel.Coordinate(latitude: 0, longitude: 0))))
    }
}
