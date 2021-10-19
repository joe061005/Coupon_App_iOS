//
//  UserView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct UserView: View {
    @AppStorage("Login") var Login = false
    @AppStorage("LoginUser") var LoginUser = Data()
    @AppStorage("cookie") var cookie = ""
    
    @State private var decodedUser:User = User(id: -1, username: "", role: "", coins: -1)
    @State private var isLogin = false
    
    @State private var showsLogoutAlert = false
    @State private var showsCouponAlert = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                HStack(alignment: .center){
                    RemoteImageView(urlString: "https://support.logmeininc.com/assets/images/care/topnav/default-user-avatar.jpg")
                        .frame(width: 200.0, height: 200.0)
                    
                    if(decodedUser.username == ""){
                        Text("guest")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20.0)
                    }else{
                        Text(decodedUser.username)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20.0)
                    }
                    
                }
                
                VStack{
                    List(Options){
                        option in
                        if(option.option == "Logoff/ Login"){
                            if(decodedUser.username == ""){
                                NavigationLink(destination: LoginView() ){
                                    Text(option.option)
                                }
                            }else {
                                Button(action: {
                                    Logout()
                                    
                                }){
                                    Text(option.option)
                                }.alert(isPresented: self.$showsLogoutAlert){
                                    Alert(title: Text(
                                        "Logout successfully"
                                    ), message: Text("See you again!"),
                                          dismissButton: .default(Text("ok")))
                                }
                            }
                        }else {
                            Button(action: {
                                if(Login == true){
                                    isLogin = true
                                }else{
                                    isLogin = false
                                    showsCouponAlert = true
                                }
                            }, label: {
                                Text("My redeemed coupons")
                            })
                                .background(NavigationLink(destination: RedeemedCouponView(), isActive: $isLogin){
                                })
                                .alert(isPresented: self.$showsCouponAlert ){
                                    Alert(title: Text(
                                        "This function is not available for guest"
                                    ), message: Text("You need to login first!"),
                                          dismissButton: .default(Text("ok"))
                                          {
                                    }
                                    )
                            
                                }
                        
                        
                        
                    }
                    
                }
            }
            
        }
        .padding(.top, -60.0)
        .onAppear{
            guard let decode = try? JSONDecoder().decode(User.self, from: LoginUser) else {return }
           
           decodedUser = decode
            print("OnAppear")
            print("UserView LoginUser \(LoginUser)")
            print("UserView Login \(Login)")
            //user = LoginUser
            print("UserView user  \(decodedUser)")
            print("UserCOOKIE: \(cookie)")
        }
    }
}

func Logout(){
    
    var Error = false
    
    print("Logout()")
    print("UserView LoginUser \(LoginUser)")
    print("UserView Login \(Login)")
    print("UserView user  \(decodedUser)")
    print("UserView isLogin \(isLogin)")
    
    print("Logout")
    guard let url = URL(string: "\(baseURL)/logout") else{
        print("URL error")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(cookie, forHTTPHeaderField: "Cookie")
    
    
    let task = URLSession.shared.dataTask(with: request){ data,
        response, error in
        
        
        if let error = error{
            print("\(error)")
            Error = true
            return
        }
        
        guard let httpResponse = response as?
                HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else{
                  print("httpResponse error")
                  Error = true
                  return
              }
        let data = User(id: -1, username: "", role: "", coins: -1)
        guard let user = try? JSONEncoder().encode(data) else {return}
        LoginUser = user
        decodedUser = data
        Login = false
        cookie = ""
        print("LOGOUTCOOKIE: \(cookie)")
        print("end of setting")
        return
    }
    task.resume()
    if(Error == false){
        showsLogoutAlert = true
    }
    print("end of function")
}

}



struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

struct options: Identifiable{
    let id = UUID()
    let option: String
}

var Options: [options] = [
    options(option: "Logoff/ Login"),
    options(option: "My Redeemed Coupons")
]
