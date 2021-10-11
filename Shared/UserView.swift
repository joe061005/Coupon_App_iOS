//
//  UserView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                HStack(alignment: .center){
                    RemoteImageView(urlString: "https://lh3.googleusercontent.com/proxy/y4qrndQbyVW6qnR-QdnGvHd18eX4OrYbYP9iJtm8u-IoaJqbM8A3ztm6Tj6B6LRcNw8h-i147QfokCKYEI0eBmgZdSfKio8P8sP3qXYp4wXveywKD_M_y_84KC1nuPgH")
                        .frame(width: 200.0, height: 200.0)
                    
                    Text("user")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 20.0)
                }
                
                VStack{
                    List(Options){
                        option in
                        Text(option.option)
                    }
                }
                
            }
            .padding(.top, -60.0)
        }
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
