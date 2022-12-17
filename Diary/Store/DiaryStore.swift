//
//  DiaryStore.swift
//  Diary
//
//  Created by 박시현 on 2022/12/17.
//

import Foundation
import FirebaseFirestore

class DiaryStore: ObservableObject {
    
    private let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    @Published var diaryArticles: [DiaryPage] = []
    
    init() {
        readData()
    }
    
    func create(diary: DiaryPage) {
        ref = db.collection("diary").addDocument(data: [
            "title" : diary.title,
            "content" : diary.content,
            "pictureURL" : diary.pictureURL,
            "date" : diary.date
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    func readData() {
        db.collection("diary").getDocuments { querySnapshot, err in
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
                        pictureURL: pictureURL,
                        date: date
                    )
                    
                    self.diaryArticles.append(diaryArticle)
                    
                }
                print("read Diary Data")
            }
        }
    }
    
    func update(_ diaryPage: DiaryPage) {
        let title = diaryPage.title
        let content = diaryPage.content
        let pictureURL = diaryPage.pictureURL
        let date = diaryPage.date
        
        db.collection("diary")
            .document(diaryPage.id)
            .updateData([
                "title": diaryPage.title,
                "content": diaryPage.content,
                "pictureURL": diaryPage.pictureURL,
                "date": diaryPage.date
            ])
    }
    
    func delete(_ diaryPage: DiaryPage) {
        db.collection("diary")
            .document(diaryPage.id)
            .delete()
    }
}
