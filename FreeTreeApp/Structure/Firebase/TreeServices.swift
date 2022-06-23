//
//  TreeServices.swift
//  FreeTreeApp
//
//  Created by Luiz Gustavo Silva Aguiar on 22/06/22.
//

import Firebase
import FirebaseFirestore
import CoreLocation

private let collectionName = "trees"
private var docRef: DocumentReference? = nil
private var collectionRef: CollectionReference? = nil
private let db = Firestore.firestore()
class TreeServices {
    
    init() {
        collectionRef = db.collection(collectionName)
    }
    func create(name: String) {
        let dataToSave: [String: Any] = [
            "name" : name
        ]
        docRef = collectionRef?.addDocument(data: dataToSave) { (error) in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }

        }
    }
}

