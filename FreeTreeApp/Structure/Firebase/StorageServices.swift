//
// StorageServices.swift
// FreeTreeApp
//
// Created by Luiz Gustavo Silva Aguiar on 05/07/22.
//
import Firebase
import FirebaseStorage
class StorageServices {
  private let collectionName = "images"
  private let storage = Storage.storage()
  private var group:DispatchGroup?
  public func upload(treeImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
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
        completion(.failure(error))
      } else {
        completion(.success(id))
      }
    }
  }
  public func download(imagesID: [String], completion: @escaping ([UIImage]) -> Void) {
    var images: [UIImage] = []
    group = DispatchGroup()
    for _ in imagesID {
      group?.enter()
    }
    let semaphore = DispatchSemaphore(value: 1)
    for id in imagesID {
      download(imageID: id) { [weak self] result in
        switch result {
        case let .success(image):
          semaphore.wait()
          images.append(image)
          semaphore.signal()
          self?.group?.leave()
        case .failure:
          print("Não foi possível baixar a foto da árvore atual")
          self?.group?.leave()
        }
      }
    }
    group?.notify(queue: DispatchQueue.global()) {
      print("Terminei todas as imagens!!!")
      completion(images)
    }
  }
  public func download(imageID: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
    let imageRef = storage.reference(withPath: "\(imageID).jpg")
    imageRef.getData(maxSize: 1024 * 1024) { (data, error) in
      if let error = error {
        completion(.failure(error))
      } else {
        let image = UIImage(data: data!)!
        completion(.success(image))
      }
    }
  }
}
extension StorageServices {
  func teste(images: [UIImage]) {
    for image in images {
      self.upload(treeImage: image) { result in
        switch result {
        case let .success(id):
          self.download(imageID: id) { result in
            switch result {
            case let .success(treeImage):
              print(treeImage)
            case let .failure(error):
              print("Não foi possível baixar a imagem \(error.localizedDescription)")
            }
          }
        case let .failure(error):
          print("Não foi possível subir a imagem \(error.localizedDescription)")
        }
      }
    }
  }
}
