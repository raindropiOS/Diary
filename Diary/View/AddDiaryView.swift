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
    @StateObject var photoPickerModel: PhotoPickerModel = PhotoPickerModel()
    @State var selectedImage: UIImage?
    @State var inputTitle: String = ""
    @State var inputContent: String = ""
    @State private var imagePickerPresented = false
    
    var body: some View {
        Form {
            Section(header: Text("New Diary")) {
                HStack {
                    Spacer()
//                    PhotoPickerView(photoUploadModel: photoPickerModel, selectedImage: $selectedImage)
                    ImagePicker(imagePickerVisible: $imagePickerPresented, selectedImage: $selectedImage)
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
        
        //selectedImage가 존재 시 Storage에 이미지 저장
        if let _ = selectedImage {
            diaryStore.uploadImage(image: selectedImage!) { URL in
                
            }
        }

        //현재 imageURL은 이미지를 storage애 저장후 diaryStore의 프라퍼티 imageURL에 저장되는 구조
        let imageURL = diaryStore.imageURL
        let newDiaryPage = DiaryPage(
            id: UUID().uuidString,
            title: inputTitle,
            content: inputContent,
            imageURL: imageURL,
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
