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
    
    func create(tree: Tree, treeImages: [UIImage], completion: @escaping (Error?) -> Void) {
        do {
            let dictionary = try Firestore.Encoder().encode(tree)
            docRef = collectionRef?.addDocument(data: dictionary) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    print("Documento adicionado com o ID: \(self.docRef!.documentID)")
                    for image in treeImages {
                        var treeAux = tree
                        treeAux.id = self.docRef!.documentID
                        self.addImage(tree: treeAux, treeImage: image)
                    }
                    completion(nil)
                }
            }
        } catch {
            print(error)
        }
    }

    func read(completion: @escaping (Result<[Tree], Error>) -> Void ) {
        collectionRef?.getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let querySnapshot = querySnapshot else { return }
                var trees: [Tree] = []
                for document in querySnapshot.documents {
                    guard let tree: Tree = try? document.toObject() else { continue }
                    trees.append(tree)
                }
                print("Documentos carregados")
                completion(.success(trees))
            }
        }
    }
    
    func update(tree: Tree, data: [String: Any], completion: @escaping (Error?) -> Void) {
        let document = collectionRef?.document(tree.id ?? "None")
        document?.updateData(data) { error in
            if let error = error {
                completion(error)
            } else {
                print("Documento atualizado")
            }
        }
        
    }
    
    private func addImageID(tree: Tree, imageID: String, completion: @escaping(Error?) -> Void) {
        let document = collectionRef?.document(tree.id ?? "None")
        print(document?.documentID)
        document?.updateData([
            "imagesID" : FieldValue.arrayUnion([imageID])
        ]) { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    private func addImage(tree: Tree, treeImage: UIImage) {
        let storage = StorageServices()
        storage.upload(treeImage: treeImage) { result in
            switch result {
            case let .success(id):
                self.addImageID(tree: tree, imageID: id) { error in
                    if let error = error {
                        print("Não foi possível atualizar o id da imagem na árvore \(tree.name) \(error.localizedDescription)")
                    } else {
                        print("Imagem adicionada a árvore \(tree.name)")
                    }
                }
            case let .failure(error):
                print("Não foi possível dar upload na imagem da árvore \(tree.name) \(error.localizedDescription)")
            }
        }
    }
    
    func delete(tree: Tree, completion: @escaping (Error?) -> Void) {
        collectionRef?.document(tree.id ?? "None").delete() { (error) in
            if let error = error {
                completion(error)
            } else {
                print("\(tree.name) deletada")
                completion(nil)
            }
        }
    }
    
}

extension TreeServices {
    //Use essa função para testar o firebase
    func testes(tree: Tree) {
        self.create(tree: tree, treeImages: []) { error in
            if let error = error {
                print("Não foi possível criar a árvore \(error.localizedDescription)")
            } else {
                self.read() { result in
                    switch result {
                    case let .success(trees):
                        for tree in trees {
                            self.update(tree: tree, data: ["name" : "balinha \(tree.name)"]) { error in
                                if let error = error {
                                    print("Não foi possível atualizar os campos da árvore \(error.localizedDescription)")
                                }
                            }
                        }
                        for tree in trees {
                            self.delete(tree: tree) { error in
                                if let error = error {
                                    print("Não foi possível deletar a árvore \(error.localizedDescription)")
                                }
                            }
                        }
                    case let .failure(error):
                        print("Não foi possível ler as árvores do banco \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension QueryDocumentSnapshot {
    func toObject<T: Decodable>() throws -> T  where T:UpdatableIdentifiable, T.ID == String? {
        do {
            var object = try Firestore.Decoder().decode(T.self, from: data())
            object.id = self.documentID
            return object
        } catch {
            print("Não foi possível decodificar o documento")
            throw error
        }
    }
}


