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
    private let storage = Storage.storage()
    
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
        print("start readData")
        db.collection("diary")
//            .order(by: "createdAt", descending: true) 적용시 데이터 못가져옴;;
            .getDocuments { querySnapshot, err in
                self.diaryPages.removeAll()
                
                    for document in querySnapshot!.documents {
                        
                        let docData = document.data()
                        
                        let id: String = document.documentID
                        let title = docData["title"] as? String ?? ""
                        let content = docData["content"] as? String ?? ""
                        let imageURL = docData["imageURL"] as? String ?? ""
                        let date = docData["date"] as? Double ?? 0.0
                        
                        let diaryPage = DiaryPage(
                            id: id,
                            title: title,
                            content: content,
                            imageURL: imageURL,
                            date: date
                        )
                        self.diaryPages.append(diaryPage)
                    }
                
            }
    }
    
    func update(_ diaryPage: DiaryPage) {
        db.collection("diary")
            .document(diaryPage.id)
            .updateData([
                "title": diaryPage.title,
                "content": diaryPage.content,
                "imageURL": diaryPage.imageURL,
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
//        let storage = Storage.storage()
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
    
    func readImageCompletionHandler(image: UIImage, diaryPage: DiaryPage) {
        
    }
    
    func readImage(diaryPage: DiaryPage) {
        // Create a reference from an HTTPS URL
        // Note that in the URL, characters are URL escaped!
        let httpsReference = storage.reference(forURL: diaryPage.imageURL)
        
        httpsReference.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                print("readImage error", "\(error)")
                let image = UIImage(systemName: "exclamationmark")!
                self.readImageCompletionHandler(image: image, diaryPage: diaryPage)
            } else {
                let image = UIImage(data: data!)!
                self.readImageCompletionHandler(image: image, diaryPage: diaryPage)
            }
            
            print("readImage finish")
        }
        
        
    }
}
