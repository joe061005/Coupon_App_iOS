//
//  LoginView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct LoginView: View {
    
    enum ActiveAlert{
        case success, fail
    }
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showsAlert = false
    @State private var activeAlert: ActiveAlert = .fail
    
    //let dispatchGroup = DispatchGroup()
    
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
                
                updateRecord()
                
                
                
            }){
                Text("Login")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal, 40.0)
                    .foregroundColor(.black)
                
            }.padding(.vertical, 10.0).border(Color.black, width: 2)
                .alert(isPresented: self.$showsAlert){
                    switch (activeAlert) {
                    case .success:
                        return Alert(title: Text("Login successfully"), message: Text("Welcome back, \(LoginUser.username)"), dismissButton: .default(Text("Ok")))
                    case .fail:
                        return Alert(title: Text("Error"), message: Text("Invalid username or password"), dismissButton: .default(Text("Ok")))
                    }
                }
            
            Spacer()
        }
        .padding(.all, 20.0)
        
    }
    
    func checkLogin(username: String, password: String){
        
        let group = DispatchGroup()
        
         group.enter()
        
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
                      
                      print("\(String(describing: response))")
                      return
                  }
            
            if let data = data, let user = try?
                JSONDecoder().decode(User.self, from: data){
                LoginUser = user
                print("data")
                print("After Data:  \(LoginUser)")
                group.leave()
                return
            }
        }
        task.resume()
        
        group.notify(queue: .main){
            updateRecord()
        }
    }
    
    func updateRecord(){
        print("updateRecord()")
        print("LoginUser: \(LoginUser)")
        if(LoginUser.username == ""){
            self.activeAlert = .fail
            self.showsAlert = true
        }else {
            self.activeAlert = .success
            self.showsAlert = true
            self.presentationMode.wrappedValue.dismiss()
        }
        self.showsAlert = true
    }
    
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

