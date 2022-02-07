//
//  Comment.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//
import Foundation

struct Comment: Identifiable, Codable {
    let id: String
    let text: String
    let createDate: Date
    let imageURL: URL?
}
