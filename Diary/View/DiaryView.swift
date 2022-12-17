//
//  DiaryView.swift
//  Diary
//
//  Created by 박시현 on 2022/12/16.
//

import SwiftUI

struct DiaryView: View {
    @StateObject var diaryStore: DiaryStore = DiaryStore()
    @State var addDiaryViewIsPresented: Bool = false
    
    var body: some View {
        GridView().environmentObject(diaryStore)
            .navigationTitle("My diary")
            .onAppear(perform: readData)
        Spacer()
        Button {
            self.addDiaryViewIsPresented.toggle()
        } label: {
            Text("Add diary")
        }
        .sheet(isPresented: $addDiaryViewIsPresented) {
            AddDiaryView().environmentObject(diaryStore)
        }
        
    }
    
    func readData() {
        diaryStore.readData()
    }
    
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiaryView()
        }
    }
}
