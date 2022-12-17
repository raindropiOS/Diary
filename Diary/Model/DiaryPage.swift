//
//  DiaryModel.swift
//  Diary
//
//  Created by 박시현 on 2022/12/16.
//

import Foundation

struct DiaryPage {
    
    var id: String
    var title: String
    var content: String
    var pictureURL: String
    var date: Double
    
    var createdDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_kr")
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // "yyyy-MM-dd HH:mm:ss"

            let dateCreatedAt = Date(timeIntervalSince1970: date)

            return dateFormatter.string(from: dateCreatedAt)
        }
}
