//
//  LoginView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("Login") var Login = false
    @AppStorage("LoginUser") var LoginUser = Data()
    @AppStorage("cookie") var cookie = ""
    
    @State private var decodedUser:User = User(id: -1, username: "", role: "", coins: -1)
    
    enum ActiveAlert{
        case success, fail
    }
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showsAlert = false
    @State private var activeAlert: ActiveAlert = .fail
    
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
                        return Alert(title: Text("Login successfully"), message: Text("Welcome back, \(decodedUser.username)"),
                                     dismissButton: Alert.Button.default(Text("Ok"),
                                                                         action:{
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        )
                    case .fail:
                        return Alert(title: Text("Error"), message: Text("Invalid username or password"), dismissButton: .default(Text("Ok")))
                    }
                }
            
            Spacer()
        }
        .padding(.all, 20.0)
        .onAppear{
            guard let decode = try? JSONDecoder().decode(User.self, from: LoginUser) else {return }
            
            decodedUser = decode
            
        }
        
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
                group.leave()
                return
            }
            
            guard let httpResponse = response as?
                    HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else{
                      
                      print("\(String(describing: response))")
                      group.leave()
                      return
                  }
//            print("httpResponse: \(httpResponse.allHeaderFields)")
            
//            var cookieField = httpResponse.value(forHTTPHeaderField: "Set-Cookie")
//
//            print("cookieField: \(cookieField)")
//
//            if(cookieField != nil){
//                cookie = (cookieField?.components(separatedBy: ";")[0])!
//            }
            
            if let data = data, let user = try?
                JSONDecoder().decode(User.self, from: data){
                guard let encodedUser = try? JSONEncoder().encode(user) else {return}
                LoginUser = encodedUser
                decodedUser = user
                Login = true
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
        //        print("updateRecord()")
        //        print("LoginView LoginUser: \(LoginUser)")
        //        print("LoginView Login: \(Login)")
        if(decodedUser.username == ""){
            //Login = false
            self.activeAlert = .fail
            self.showsAlert = true
        }else {
            // Login = true
            self.activeAlert = .success
            self.showsAlert = true
        }
        
        let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: "\(baseURL)/login")!)
        let LoginCookie = cookies![0]
        
        print("LOGIN COOKIE: \(LoginCookie)")
        
        print("\(LoginCookie.name)=\(LoginCookie.value)")
        
        cookie = "\(LoginCookie.name)=\(LoginCookie.value)"
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

extension User: Decodable, Encodable{}

