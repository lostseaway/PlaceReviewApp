//
//  MainMap.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//


import SwiftUI

struct MainMapView: View {
    @ObservedObject var viewModel: MainMapViewModel
    @State var searchQuery: String = ""
    
    init(viewModel: MainMapViewModel = MainMapViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            // TODO: Add Map View Here
            Text("Map Here!!")
        }.searchable(text: $searchQuery, placement: .navigationBarDrawer, suggestions: {
            // TODO: Show Search Result
        }).onChange(of: searchQuery, perform: { newValue in
            // TODO: Query Places from text
        }).onSubmit(of: .search, {
            // TODO: Perform select place
        })
        
    }
}

struct MainMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapView()
    }
}
