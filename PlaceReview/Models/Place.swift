//
//  Place.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//
import MapKit

enum PlaceType {
    case current
    case place
}

struct Place: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let type: PlaceType
}
