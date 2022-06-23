//
//  TreeServices.swift
//  FreeTreeApp
//
//  Created by Luiz Gustavo Silva Aguiar on 22/06/22.
//

import Firebase
import FirebaseFirestore
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
            let JSONTree = try JSONEncoder().encode(tree)
            guard let dictionary = try JSONSerialization.jsonObject(with: JSONTree, options:.allowFragments) as? [String : Any] else {
                print("Não foi possível transformar em dicionário")
                return
            }
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

    func read() -> [Tree] {
        var trees: [Tree] = []
        collectionRef?.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    //TODO
                    let readTrees = document.data().mapValues { (tree) -> Tree? in
                        let data = try? JSONSerialization.data(withJSONObject: tree, options: .prettyPrinted)
                        let json = try? JSONDecoder().decode(Tree.self, from: data!)
                        trees.append(json!)
                        return json
                    }
                }
            }
        }
        return trees
    }
}

