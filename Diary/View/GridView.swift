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
        VStack {
            if diaryStore.diaryPages.isEmpty {
                Text("diaryPages are empty")
            } else {
                Text("total pages : \(diaryStore.diaryPages.count)")
            }
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(diaryStore.diaryPages) { diaryPage in
                        if diaryPage.imageURL == "" {
                            Image(systemName: "square.and.pencil")
                                .frame(width:125, height: 125)
                        } else {
                            AsyncImage(url: URL(string: diaryPage.imageURL)) { image in
                                image.resizable().frame(width:125, height: 125)
                                
                            } placeholder: {
                                Color.gray
                            }

                                
                        }
                    }
                }
            }
        }
        .onAppear {
            for dpage in diaryStore.diaryPages {
                diaryStore.readImage(diaryPage: dpage)
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView().environmentObject(DiaryStore())
    }
}
