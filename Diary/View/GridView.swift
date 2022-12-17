//
//  GridView.swift
//  Diary
//
//  Created by 박시현 on 2022/12/17.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var diaryStore: DiaryStore
    
    let columns = [
        GridItem(.fixed(125)),
        GridItem(.fixed(125)),
        GridItem(.fixed(125)),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(diaryStore.diaryPages) { diaryPage in
                if diaryPage.imageURL == "" {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView().environmentObject(DiaryStore())
    }
}
