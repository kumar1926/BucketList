//
//  ContentView.swift
//  BucketList
//
//  Created by BizMagnets on 14/07/25.
//

import SwiftUI
import MapKit
struct ContentView: View {
    @State var viewModel = ViewModel()
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    var body: some View {
        MapReader{ proxy in
            Map(initialPosition: startPosition){
                ForEach(viewModel.locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                            .onTapGesture {
                                viewModel.selectedPlace = location
                            }
                    }
                }
            }
            .onTapGesture { location in
                    if let coord = proxy.convert(location, from: .local){
                        viewModel.addLocation(at: coord)
                    }
                    
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) {
                    viewModel.update(location: $0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
