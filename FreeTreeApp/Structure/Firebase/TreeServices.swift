//
//  TreeServices.swift
//  FreeTreeApp
//
//  Created by Luiz Gustavo Silva Aguiar on 22/06/22.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

class TreeServices {

    private let collectionName = "trees"
    private var docRef: DocumentReference? = nil
    private var collectionRef: CollectionReference? = nil
    private let db = Firestore.firestore()

    init() {
        collectionRef = db.collection(collectionName)
    }
    
    func create(tree: Tree) {
        do {
            var dictionary = try Firestore.Encoder().encode(tree)
            print(dictionary)
//            JSONTree = try JSONEncoder().encode(tree)
//            guard let dictionary = try JSONSerialization.jsonObject(with: JSONTree, options:.allowFragments) as? [String : Any] else {
//                print("Não foi possível transformar em dicionário")
//                return
//            }
            docRef = collectionRef?.addDocument(data: dictionary) { (error) in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added with ID: \(self.docRef!.documentID)")
                }

            }
        } catch {
            print(error)
        }
    }

    func read(completion: @escaping (Result<[Tree], Error>) -> Void ) {
        
        collectionRef?.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                guard let querySnapshot = querySnapshot else { return }
                var trees: [Tree] = []
                for document in querySnapshot.documents {
                    guard var tree: Tree = try? document.toObject() else { continue }
                    //tree.id = document.documentID
                    trees.append(tree)
                }
                completion(.success(trees))
            }
        }

    }
    
    func delete(tree: Tree) {
        collectionRef?.document(tree.id!).delete() { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Tree deleted")
            }
            
        }
    }
}

extension QueryDocumentSnapshot {
    func toObject<T: Decodable>() throws -> T  where T:UpdatableIdentifiable, T.ID == String? {
        //let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
        do {
            var object = try Firestore.Decoder().decode(T.self, from: data())
                object.id = self.documentID
            return object
        } catch {
            print(error)
            throw error
        }
    }
}


