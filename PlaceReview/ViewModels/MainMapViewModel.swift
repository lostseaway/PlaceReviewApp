//
//  MainMapViewModel.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//

import Foundation
import MapKit

class MainMapViewModel: NSObject, ObservableObject {
    
    @Published var searchLocationResult = [Place]()
    @Published var mapPlaceMarker: [Place] = [
        Place(id: UUID(), name: "KU Beef", description: "", coordinate: CLLocationCoordinate2D(latitude: 13.8473265, longitude: 100.5664376), type: .place)
    ]
    
    @Published var currentLocation: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 13.8473265,
                                       longitude: 100.5664376),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )
    
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

    }
    
    func searchLocation(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = .pointOfInterest
        
        request.region = MKCoordinateRegion(center: self.currentLocation.center,
                                            latitudinalMeters: self.currentLocation.span.latitudeDelta,
                                            longitudinalMeters: self.currentLocation.span.longitudeDelta)
        
        
        let search = MKLocalSearch(request: request)

        search.start { [unowned self](response, _) in
            guard let response = response else {
                return
            }
            
            self.searchLocationResult = response.mapItems.map{ (item) -> Place in
                return Place(id: UUID(), name: item.name ?? "", description: item.placemark.title ?? "", coordinate: item.placemark.coordinate, type: .place)
            }
        }
    }
    
    func moveCenterToPlace(place: Place) {
        self.currentLocation = MKCoordinateRegion(
            center: place.coordinate,
            latitudinalMeters: 750,
            longitudinalMeters: 750)
        
        self.mapPlaceMarker = [place]
    }
}

extension MainMapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 750,
                longitudinalMeters: 750)
        }
    }
}
