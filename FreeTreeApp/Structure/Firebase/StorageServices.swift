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
    private var storageRef: StorageReference? = nil
    
    
    init() {
        self.storageRef = storage.reference()
        let aux = storageRef?.child("asdad")
    }
}
