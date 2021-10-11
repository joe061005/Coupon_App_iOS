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
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showsAlert = false
    
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
                .autocapitalization(.none)
            
            SecureField(
                "Password",
                text: $password
            )
                .padding(.all, 20.0)
                .disableAutocorrection(true)
                .border(Color.black, width: 2)
                .autocapitalization(.none)
            
            
            Button(action : {
                checkLogin(username: username, password: password)
                if(LoginUser.username != ""){
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
                
            }){
                Text("Login")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal, 40.0)
                    .foregroundColor(.black)
                
            }.padding(.vertical, 10.0).border(Color.black, width: 2)
                .alert(isPresented: self.$showsAlert){
                    Alert
                }
            
            Spacer()
        }
        .padding(.all, 20.0)
        
    }
}

func checkLogin(username: String, password: String){
    print("\(username) \(password)")
    
    guard let url = URL(string: "\(baseURL)/login") else{
        print("URL error")
        return
    }
    
    let body: [String: String] = ["username": username, "password": password]
    
    guard let finalBody = try? JSONEncoder().encode(body) else {
        print("Body error")
        return
    }
    
    var request = URLRequest(url: url)
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = finalBody
    
    print("request")
    
    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        
        if let error = error{
            print("\(error)")
            return
        }
        
        guard let httpResponse = response as?
                HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else{
                  Alert(title: Text("Error"), message: Text("Invalid username or password"), dismissButton: .default(Text("Ok")))
                  print("\(response)")
                  return
              }
        
        if let data = data, let user = try?
            JSONDecoder().decode(User.self, from: data){
            LoginUser = user
            Alert(title: Text("Login successfully"), message: Text("Welcome back, \(LoginUser.username)"), dismissButton: .default(Text("Ok")))
            print("data")
            return
        }
    }
    task.resume()
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

extension User: Decodable{}

