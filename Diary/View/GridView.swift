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
        GridItem(.fixed(30)),
        GridItem(.fixed(30)),
        GridItem(.fixed(30)),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(diaryStore.diaryPages) { value in
                
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView().environmentObject(DiaryStore())
    }
}
