//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by BizMagnets on 16/07/25.
//

import Foundation
import CoreLocation

extension ContentView{
    @Observable
    class ViewModel{
        private(set) var locations:[Location]
         var selectedPlace:Location?
        let savePath = URL.documentsDirectory.appending(path: "savedPlaces")
        func addLocation(at point: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location){
            guard let place = selectedPlace else { return }
            if let index = locations.firstIndex(of: place) {
                locations[index] = location
                save()
            }
        }
        init(){
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            }catch{
                locations = []
            }
        }
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options:  [.atomic, .completeFileProtection])
            }catch{
                print("unable to save")
            }
        }
    }
    
    
}
