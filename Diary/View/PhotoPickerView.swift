//
//  PhotoUploadView.swift
//  Diary
//
//  Created by 박시현 on 2022/12/17.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @ObservedObject var photoUploadModel: PhotoPickerModel
    @Binding var selectedImage: UIImage?
    @Binding var imagePickerPresented: Bool
    var imageState: PhotoPickerModel.ImageState {
        photoUploadModel.imageState
    }
    
    var body: some View {
        VStack {
            if selectedImage == nil {
                Button {
                    imagePickerPresented.toggle()
                } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .foregroundColor(.gray)
                }
            } else {
            }
                

        }
        .sheet(isPresented: $imagePickerPresented, onDismiss: loadImage, content: {
            ImagePicker(imagePickerVisible: $imagePickerPresented, selectedImage: $selectedImage) })
        
        
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imagePickerVisible: Bool
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(
        context: Context
    ) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {
        // ...
    }
    
    // 이벤트가 발생하면 알려주는 함수
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(imagePickerVisible: $imagePickerVisible, selectedImage: $selectedImage)
        return coordinator
    }
    
    class Coordinator:
        NSObject,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate {
        // 값을 바꿔주는 건 실제로 Coordinator에서 하기 때문에 여기에 Binding 변수를 써준다.
        // imagePickerVisible 상태와 선택한 이미지에 대한 정보를 받기 위한 Binding
        // 왜냐하면 ContentView에서 MyImagePicker를 사용할 예정이기 때문에
        @Binding var imagePickerVisible: Bool
        @Binding var selectedImage: UIImage?
        
        init(
            imagePickerVisible: Binding<Bool>,
            selectedImage: Binding<UIImage?>
        ) {
            _imagePickerVisible = imagePickerVisible
            _selectedImage = selectedImage
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            imagePickerVisible = false
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                selectedImage = image
                imagePickerVisible = false
            }
    }
}



struct PhotoUploadView_Previews: PreviewProvider {
    @State static var imagePickerPresented = false
    @State static var selectedImage: UIImage? = nil
    static var previews: some View {
        PhotoPickerView(photoUploadModel: PhotoPickerModel(), selectedImage: $selectedImage, imagePickerPresented: $imagePickerPresented)
    }
}
