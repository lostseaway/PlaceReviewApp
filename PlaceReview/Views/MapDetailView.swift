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
    @State var isImagePickerDisplay: Bool = false
    @State var selectedImage: UIImage? = nil
    
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
                                viewModel.addComment(text: commentText, place: place, image: selectedImage)
                                commentText = ""
                                selectedImage = nil
                            }
                            Spacer()
                            Button(action: {
                                isImagePickerDisplay = true
                            }, label: {Image(systemName: "paperclip")}).buttonStyle(.borderless)
                        }
                        
                        if let image = selectedImage {
                            Image(uiImage: image).resizable().scaledToFit().padding()
                        }
                        
                    }.padding()
                }
                Section {
                    ForEach(viewModel.comments) { comment in
                        VStack(alignment: .leading) {
                            Text(comment.text).padding()
                            if comment.imageURL != nil {
                                AsyncImage(url: comment.imageURL,
                                           content: { image in
                                                    image.resizable()
                                                         .aspectRatio(contentMode: .fit)
                                                },
                                                placeholder: {
                                                    ProgressView()
                                                }
                                ).padding()
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle(place.name)
            .onAppear(perform: {
                viewModel.fetchPlaceComment(place: place)
            })
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: .photoLibrary)
            }
        }
    }
}

struct MapDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapDetailView(place: Place(id: UUID(), name: "Siam Center", description: "Siam", coordinate: CLLocationCoordinate2D(latitude: 13.7462845, longitude: 100.5304892), type: .place))
    }
}
