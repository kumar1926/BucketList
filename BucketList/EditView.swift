//
//  EditView.swift
//  BucketList
//
//  Created by BizMagnets on 16/07/25.
//

import SwiftUI

struct EditView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    @State private var name:String
    @State private var description:String
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()

    var onSave: (Location) -> Void
    var location:Location
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Name", text: $name)
                    TextField("Discription", text: $description)
                }
                Section("Nearby…") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar{
                Button("save"){
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                        onSave(newLocation)
                        dismiss()
                }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    init(location: Location,onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    func fetchNearbyPlaces() async{
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string:urlString) else{
            print("Invalid URL")
            return
        }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        }catch{
            loadingState = .failed
            print("Failed to fetch data: \(error)")
        }
    }
}

#Preview {
    EditView(location:.example){_ in}
}
