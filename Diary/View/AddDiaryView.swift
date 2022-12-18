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
                if selectedImage == nil {
                    Button {
                        imagePickerPresented.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
                
                if selectedImage != nil {
                    HStack {
                        Spacer()
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .foregroundColor(.gray)
                        Spacer()
                    }
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
        .sheet(isPresented: $imagePickerPresented, content: { ImagePicker(imagePickerVisible: $imagePickerPresented, selectedImage: $selectedImage) })
    }
    
    
    func addNewDiary() {
        //selectedImage가 존재 시 Storage에 이미지 저장
        if let _ = selectedImage {
            diaryStore.uploadImage(image: selectedImage!) { URL in
                if let imageURL = URL {
                    print("diaryStore imageURL updated")
                    diaryStore.imageURL = imageURL.absoluteString
                }
                let newDiaryPage = DiaryPage(
                    id: UUID().uuidString,
                    title: inputTitle,
                    content: inputContent,
                    imageURL: diaryStore.imageURL,
                    date: Date.now.timeIntervalSince1970
                )
                diaryStore.create(diary: newDiaryPage)
            }
        } else {
            //selectedImage가 없을 때, imageURL은 ""로 저장
            let newDiaryPage = DiaryPage(
                id: UUID().uuidString,
                title: inputTitle,
                content: inputContent,
                imageURL: diaryStore.imageURL,
                date: Date.now.timeIntervalSince1970
            )
            diaryStore.create(diary: newDiaryPage)
        }
        
        
        
        //현재 imageURL은 이미지를 storage애 저장후 diaryStore의 프라퍼티 imageURL에 저장되는 구조
       
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

