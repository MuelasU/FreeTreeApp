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
    
    let storage = StorageServices()

    init() {
        collectionRef = db.collection(collectionName)
    }
    
    func create(tree: TreeFB, treeImages: [UIImage], completion: @escaping (Error?) -> Void) {
        do {
            let dictionary = try Firestore.Encoder().encode(tree)
            docRef = collectionRef?.addDocument(data: dictionary) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    var curTree = tree
                    curTree.id = self.docRef?.documentID
                    self.addImage(tree: curTree, treeImages: treeImages)
                    completion(nil)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    public func read(completion: @escaping (Result<[TreeFB], Error>) -> Void ) {
        collectionRef?.getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let querySnapshot = querySnapshot else { return }
                var trees: [TreeFB] = []
                for document in querySnapshot.documents {
                    guard let tree: TreeFB = try? document.toObject() else { continue }
                    trees.append(tree)
                }
                print("Documentos carregados")
                completion(.success(trees))
            }
        }
    }
    
    public func read(treeFB: TreeFB, completion: @escaping (Tree) -> Void) {
        
        var treeImages: [UIImage] = []
        storage.download(imagesID: treeFB.imagesID) { images in
            treeImages = images
            let tree = Tree(tree: treeFB, images: treeImages)
            completion(tree)
        }
    }

    func update(tree: TreeFB, data: [String: Any], completion: @escaping (Error?) -> Void) {
        let document = collectionRef?.document(tree.id ?? "None")
        document?.updateData(data) { error in
            completion(error)
        }
    }
    
    private func addImageID(tree: TreeFB, imageID: String, completion: @escaping(Error?) -> Void) {
        let document = collectionRef?.document(tree.id ?? "None")
        document?.updateData([
            "imagesID" : FieldValue.arrayUnion([imageID])
        ]) { error in
            completion(error)
        }
    }
    
    
    private func addImage(tree: TreeFB, treeImages: [UIImage]) {
        if treeImages.count == 0 {
            return
        }
        
        let image = treeImages[0]
        let newImages = Array(treeImages[1...])
        let storage = StorageServices()
        storage.upload(treeImage: image) { result in
            switch result {
            case let .success(id):
                self.addImageID(tree: tree, imageID: id) { error in
                    if error != nil {
                        print("addImageID: Não foi possível atualizar o id da imagem na árvore \(tree.name)")
                    } else {
                        print("addImageID: Imagem adicionada a árvore \(tree.name)")
                    }
                }
            case .failure(_):
                print("addImageID: Não foi possível dar upload na imagem da árvore \(tree.name)")
            }
            self.addImage(tree: tree, treeImages: newImages)
        }
    }
    
    func delete(tree: TreeFB, completion: @escaping (Error?) -> Void) {
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
    func testes(tree: TreeFB) {
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


