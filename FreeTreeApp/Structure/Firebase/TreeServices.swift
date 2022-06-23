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
    func create(tree: Tree) {
        do {
            let JSONTree = try JSONEncoder().encode(tree)
            guard let dictionary = try JSONSerialization.jsonObject(with: JSONTree, options:.allowFragments) as? [String:Any] else {
                print("Não foi possível transformar em dicionário")
                return
            }
            docRef = collectionRef?.addDocument(data: dictionary) { (error) in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added with ID: \(docRef!.documentID)")
                }

            }
        } catch {
            print(error)
        }
    }
}

