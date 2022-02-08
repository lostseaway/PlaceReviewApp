//
//  MainMap.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//


import SwiftUI
import MapKit

struct MainMapView: View {
    @ObservedObject var viewModel: MainMapViewModel
    @State var searchQuery: String = ""
    
    init(viewModel: MainMapViewModel = MainMapViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $viewModel.currentLocation, showsUserLocation: true, annotationItems: viewModel.mapPlaceMarker, annotationContent: { place in
                MapAnnotation(coordinate: place.coordinate, content: {
                    NavigationLink(destination: MapDetailView(place: place), label: {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 44))
                            .foregroundColor(.blue)
                    })
                })
                
            })
        }.searchable(text: $searchQuery, placement: .navigationBarDrawer, suggestions: {
            ForEach(viewModel.searchLocationResult) { place in
                Text(place.name).searchCompletion(place.name)
            }
        }).onChange(of: searchQuery, perform: { newValue in
            viewModel.searchLocation(query: newValue)
        }).onSubmit(of: .search, {
            viewModel.moveCenterToPlace(place: viewModel.searchLocationResult[0])
        })
        
    }
}

struct MainMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapView()
    }
}
