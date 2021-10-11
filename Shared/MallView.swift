//
//  MallView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct MallView: View {
    var body: some View {
        NavigationView{
            List(Restaurants){
                rest in
                NavigationLink(destination: RestByMallView(MallTitle: rest.title)){
                    Text(rest.title)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 15.0)
            }.navigationTitle("Malls")
            
        }
        .padding(.top, -70.0)
    }
    
}

struct MallView_Previews: PreviewProvider {
    static var previews: some View {
        MallView()
    }
}
