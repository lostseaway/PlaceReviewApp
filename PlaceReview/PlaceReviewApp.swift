//
//  PlaceReviewApp.swift
//  PlaceReview
//
//  Created by Thunyathon  Jaruchotrattanasakul on 7/2/2565 BE.
//

import SwiftUI
import Firebase

@main
struct PlaceReviewApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainMapView()
        }
    }
}
