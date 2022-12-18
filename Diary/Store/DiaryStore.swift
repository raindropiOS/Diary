//
//  DiaryStore.swift
//  Diary
//
//  Created by 박시현 on 2022/12/17.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class DiaryStore: ObservableObject {
    
    private let db = Firestore.firestore()
    @Published var diaryPages: [DiaryPage] = []
    // 현재 Storage 저장 시 imageURL을 여기에 임시저장하는 구조
    var imageURL: String = ""
    
    init() {
        readData()
    }
    
    func create(diary: DiaryPage) {
        db.collection("diary")
            .document(diary.id)
            .setData([
                "title" : diary.title,
                "content" : diary.content,
                "imageURL" : diary.imageURL,
                "date" : diary.date
            ])
        
        self.imageURL = ""
    }
    
    func readData() {
        db.collection("diary")
            .order(by: "createdAt", descending: true)
            .getDocuments { querySnapshot, err in
                self.diaryPages.removeAll()
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docData = document.data()
                        
                        let id: String = document.documentID
                        let title = docData["title"] as? String ?? ""
                        let content = docData["content"] as? String ?? ""
                        let pictureURL = docData["picturURL"] as? String ?? ""
                        let date = docData["date"] as? Double ?? 0.0
                        
                        let diaryArticle = DiaryPage(
                            id: id,
                            title: title,
                            content: content,
                            imageURL: pictureURL,
                            date: date
                        )
                        
                        self.diaryPages.append(diaryArticle)
                    }
                }
            }
    }
    
    func update(_ diaryPage: DiaryPage) {
        db.collection("diary")
            .document(diaryPage.id)
            .updateData([
                "title": diaryPage.title,
                "content": diaryPage.content,
                "pictureURL": diaryPage.imageURL,
                "date": diaryPage.date
            ])
    }
    
    func delete(_ diaryPage: DiaryPage) {
        db.collection("diary")
            .document(diaryPage.id)
            .delete()
    }
    
    
    //FireStorage
    func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Create a child reference
        // imagesRef now points to "images"
//        let imagesRef = storageRef.child("images")
        
        // Child references can also take paths delimited by '/'
        let imageURL = UUID().uuidString
        let imageSaveRef = storageRef.child("images/" + "\(imageURL)")
        
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        
        let metadata: StorageMetadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageSaveRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            
            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            // You can also access to download URL after upload.
            imageSaveRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("could not get downloadURL")
                    
                    return
                }
                
                completion(downloadURL)
//                    self.imageURL = try! String(contentsOf: downloadURL)
               
               
                
                
            }
        }
        print("function upload images complete")
    }
}
