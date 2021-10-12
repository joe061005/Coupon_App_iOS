//
//  ContentView.swift
//  Shared
//56
//  Created by joe  on 7/10/2021.
//

import SwiftUI

var baseURL = "https://226f-158-182-191-206.ngrok.io"

var LoginUser:User =  User(id: -1, username: "", role: "", coins: -1)

struct ContentView: View {
    
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
        }
    }
}

struct ContentView_Previews:
    PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

