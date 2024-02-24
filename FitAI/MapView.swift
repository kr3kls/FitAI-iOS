//
//  MapView.swift
//  maptest
//
//  Created by Craig Troop on 2/22/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    var restaurant: Restaurant
    @State private var position: MapCameraPosition
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: restaurant.lattitude, longitude: restaurant.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        self._position = State(initialValue: .region(region))
    }
    
    var body: some View {
        Map(position: $position, interactionModes: []) {
            Marker(restaurant.name, coordinate: CLLocationCoordinate2D(latitude: restaurant.lattitude, longitude: restaurant.longitude))
        }
    }
}

//#Preview {
//    MapView(latitude: 19, longitude: 19)
//}
