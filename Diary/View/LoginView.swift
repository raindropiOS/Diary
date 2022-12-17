//
//  LoginView.swift
//  Diary
//
//  Created by 박시현 on 2022/12/16.
//

import SwiftUI


import SwiftUI

struct LoginView: View {
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var isSingnInPresented: Bool = false
    @State private var inputID: String = "Please press Log-in"
    @State private var inputPassword: String = ""
    
    var body: some View {
        VStack {
            InputIDPW(inputID: $inputID, inputPassword: $inputPassword)
            
            Button(action: {
                
            }, label: {
                NavigationLink(destination: Text("temp")) {
                    Text("Log-in")
                }
            })
            
            Button("Sign-up") {
                isSingnInPresented.toggle()
            }
            .foregroundColor(.blue)
        }
        .sheet(isPresented: $isSingnInPresented) {
//            SignUp()
        }
    }
}

struct InputIDPW: View {
    @Binding var inputID: String
    @Binding var inputPassword: String
    var body: some View {
        VStack {
            HStack {
                Text("ID")
                TextField("", text: $inputID)
                    .border(.black)
            }
            
            HStack {
                Text("PW")
                TextField("", text: $inputPassword)
                    .border(.black)
            }
            
        }
        .frame(width: 200)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            //        LoginView().environmentObject(AuthenticationViewModel())
            LoginView()
        }
    }
}

