//
//  StorageServices.swift
//  FreeTreeApp
//
//  Created by Luiz Gustavo Silva Aguiar on 05/07/22.
//

import Firebase
import FirebaseStorage

class StorageServices {
    private let collectionName = "images"
    private let storage = Storage.storage()
    
    func upload(treeImage: UIImage, completion: @escaping (Error?) -> Void) {
        let id = UUID.init().uuidString
        let uploadRef = storage.reference(withPath: "\(id).jpg")
        guard let imageData = treeImage.jpegData(compressionQuality: 0.75) else {
            print("Não foi possível pegar os dados da imagem")
            return
        }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetaData, error) in
            if let error = error {
                completion(error)
            }
        }
    }
}

extension StorageServices {
    func teste() {
        let image = UIImage(systemName: "circle.fill")
        upload(treeImage: image!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Deu bom brasil")
            }
        }
    }
}
