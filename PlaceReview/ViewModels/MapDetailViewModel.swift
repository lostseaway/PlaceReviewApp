//
//  MapDetailViewModel.swift
//  WongNongPOC
//
//  Created by Thunyathon  Jaruchotrattanasakul on 6/2/2565 BE.
//

import FirebaseDatabase
import FirebaseStorage
import CodableFirebase
import UIKit

class MapDetailViewModel: ObservableObject {
    
    private let databaseRef: DatabaseReference
    
    @Published var comments = [Comment]()
    
    init() {
        self.databaseRef = Database.database().reference()
    }
    
    func fetchPlaceComment(place: Place) {
        let placeId = "\(place.coordinate.latitude)-\(place.coordinate.longitude)".replacingOccurrences(of: ".", with: "-")
        self.databaseRef.child("places/\(placeId)/comments").observe(.value) { snapshot in
            guard let value = snapshot.value else { return }
            print(value)
            do {
                let models = try FirebaseDecoder().decode(Dictionary<String, Comment>.self, from: value)
                self.comments = models.keys.compactMap { key in
                    return models[key]
                }.sorted(by: { a, b in
                    a.createDate > b.createDate
                })
            } catch let error {
                print(error)
            }
            
        }
    }
    
    func uploadImage(image: UIImage, path: String, completion: @escaping (_ url: String?, _ error: Error?) -> Void) {
        // TODO: Implement this function
    }
    
    func addComment(text: String, place: Place, image: UIImage?) {
        let placeId = "\(place.coordinate.latitude)-\(place.coordinate.longitude)".replacingOccurrences(of: ".", with: "-")
        guard let autoId = self.databaseRef.child("places/\(placeId)/comments").childByAutoId().key else {
            return
        }
        
        let comment = Comment(id: autoId, text: text, createDate: Date(), imageURL: nil)
        self.databaseRef.child("places/\(placeId)/comments/\(autoId)").setValue(try! FirebaseEncoder().encode(comment))
        
        // TODO: Handle upload imange
    }
}
