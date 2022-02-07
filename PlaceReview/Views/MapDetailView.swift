//
//  MapDetailView.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//

import SwiftUI
import MapKit
import UIKit

struct MapDetailView: View {
    let place: Place
    @ObservedObject var viewModel: MapDetailViewModel
    
    @State var commentText: String = ""
    
    init(place: Place, viewModel: MapDetailViewModel = MapDetailViewModel()) {
        self.place = place
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            TextField("Add Your Comment Here...", text: $commentText).onSubmit {
                                viewModel.addComment(text: commentText, place: place, image: nil)
                                commentText = ""
                            }
                            Spacer()
                            Button(action: {
                                // TODO: Display Image Picker
                            }, label: {Image(systemName: "paperclip")}).buttonStyle(.borderless)
                        }
                        
                        // TODO: Display Selected Image
                        
                    }.padding()
                }
                Section {
                    ForEach(viewModel.comments) { comment in
                        VStack(alignment: .leading) {
                            Text(comment.text).padding()
                            // TODO: Display Uploaded Image   
                        }
                    }
                }
            }
            .navigationTitle(place.name)
            .onAppear(perform: {
                viewModel.fetchPlaceComment(place: place)
            })
            // TODO: Handle Display Image Picker
        }
    }
}

struct MapDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapDetailView(place: Place(id: UUID(), name: "Siam Center", description: "Siam", coordinate: CLLocationCoordinate2D(latitude: 13.7462845, longitude: 100.5304892), type: .place))
    }
}
