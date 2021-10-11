//
//  LoginView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack(spacing: 40){
            Spacer()
            TextField(
              "Username",
              text: $username
            )
                .padding(.all, 20.0)
                .disableAutocorrection(true)
                .border(Color.black, width: 2)
            
            SecureField(
              "Password",
              text: $password
            )
                .padding(.all, 20.0)
                .disableAutocorrection(true)
                .border(Color.black, width: 2)
            
            
            Button(action : {
                checkLogin(username: username, password: password)
            }){
                Text("Login")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal, 40.0)
                    .foregroundColor(.black)
                
            }.padding(.vertical, 10.0).border(Color.black, width: 2)
            
            Spacer()
        }
        .padding(.all, 20.0)
            
    }
}

func checkLogin(username: String, password: String){

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct User: Identifiable{
    let id: Int
    let username: String
    let role: String
    let coins: Int
}
