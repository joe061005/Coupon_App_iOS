//
//  ContentView.swift
//  Shared
//56
//  Created by joe  on 7/10/2021.
//

import SwiftUI

var baseURL = "https://6b61-223-16-89-31.ngrok.io"

//var LoginUser:User =  User(id: -1, username: "", role: "", coins: -1)
//var Login = false

struct ContentView: View {
    @AppStorage("Login") var Login = false
    @AppStorage("LoginUser") var LoginUser = Data()
    @AppStorage("cookie") var cookie = ""
    
    var body: some View {
        TabView{
            CouponView().tabItem{
                Image(
                    systemName: "house.fill")
                Text("Home")
            }
            
            MallView().tabItem{
                Image(systemName: "bag.fill")
                Text("Malls")
            }
            
            CoinView().tabItem{
                Image(systemName: "dollarsign.circle.fill")
                Text("Coins")
            }
            
            UserView().tabItem{
                Image(systemName: "person.fill")
                Text("User")
            }
        }.onAppear{
            if(Login == false){
                let data = User(id: -1, username: "", role: "", coins: -1)
                guard let user = try? JSONEncoder().encode(data) else {return}
                LoginUser = user
                
            }
        }
    }
}

struct ContentView_Previews:
    PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

