//
//  AddDiaryView.swift
//  Diary
//
//  Created by 박시현 on 2022/12/17.
//

import SwiftUI

struct AddDiaryView: View {
    @EnvironmentObject var diaryStore: DiaryStore
    @Environment(\.dismiss) private var dismiss
    @State var inputTitle: String = ""
    @State var inputContent: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("New Diary")) {
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: 200)
                        .padding(10)
                    Spacer()
                }
                DataInput(title: "Title", userInput: $inputTitle)
                DataInput(title: "Content", userInput: $inputContent)
            }
            
            Button(action: addNewDiary) {
                HStack {
                    Spacer()
                    Text("Complete")
                    Spacer()
                }
            }
        }
    }
    
    func addNewDiary() {
        let newDiaryPage = DiaryPage(
            id: UUID().uuidString,
            title: inputTitle,
            content: inputContent,
            pictureURL: "",
            date: Date.now.timeIntervalSince1970
        )
        
        diaryStore.create(diary: newDiaryPage)
        dismiss()
    }
}

struct AddDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        AddDiaryView().environmentObject(DiaryStore())
    }
}

struct DataInput: View {
    var title: String
    @Binding var userInput: String
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            Text(title)
                .font(.headline)
            TextField("Enter \(title)", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }

    }
}
