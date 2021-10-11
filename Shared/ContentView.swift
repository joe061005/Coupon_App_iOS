//
//  ContentView.swift
//  Shared
//
//  Created by joe  on 7/10/2021.
//

import SwiftUI

var baseURL = "https://153d-223-16-89-31.ngrok.io"

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
        }
    }
}

struct ContentView_Previews:
    PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
