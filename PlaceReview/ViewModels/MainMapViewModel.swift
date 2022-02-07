//
//  MainMapViewModel.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//

import Foundation

class MainMapViewModel: NSObject, ObservableObject {
    
    @Published var searchLocationResult = [Place]()
    @Published var mapPlaceMarker = [Place]()

    
    override init() {
        super.init()

    }
    
    func searchLocation(query: String) {
        // TODO: Implement this function
    }
    
    func moveCenterToPlace(place: Place) {
        // TODO: Implement this function
    }
}
