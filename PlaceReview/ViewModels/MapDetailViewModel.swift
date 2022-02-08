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
    private let storageRef: StorageReference
    
    @Published var comments = [Comment]()
    
    init() {
        self.databaseRef = Database.database().reference()
        self.storageRef = Storage.storage().reference()
    }
    
    func fetchPlaceComment(place: Place) {
        let placeId = "\(place.coordinate.latitude)-\(place.coordinate.longitude)".replacingOccurrences(of: ".", with: "-")
        self.databaseRef.child("places/\(placeId)/comments").observe(.value) { snapshot in
            guard let value = snapshot.value else { return }
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
        let storeRef = self.storageRef.child(path)
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        storeRef.putData(uploadData, metadata: nil, completion: { metaData, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                storeRef.downloadURL(completion: { url, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        completion(url?.absoluteString, nil)
                    }
                })
            }
        })
    }
    
    func addComment(text: String, place: Place, image: UIImage?) {
        let placeId = "\(place.coordinate.latitude)-\(place.coordinate.longitude)".replacingOccurrences(of: ".", with: "-")
        guard let autoId = self.databaseRef.child("places/\(placeId)/comments").childByAutoId().key else {
            return
        }
        
        if let image = image {
            uploadImage(image: image, path: "\(placeId)/\(autoId).png", completion: { url, error in
                let comment = Comment(id: autoId, text: text, createDate: Date(), imageURL: URL(string: url!))
                self.databaseRef.child("places/\(placeId)/comments/\(autoId)").setValue(try! FirebaseEncoder().encode(comment))
            })
        }
        else {
            let comment = Comment(id: autoId, text: text, createDate: Date(), imageURL: nil)
            self.databaseRef.child("places/\(placeId)/comments/\(autoId)").setValue(try! FirebaseEncoder().encode(comment))
        }
        
    }
}
