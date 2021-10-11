//
//  CouponDetailView.swift
//  CouponiOS
//
//  Created by joe  on 9/10/2021.
//

import SwiftUI

var Restaurants: [Restaurant] = [
    Restaurant(title: "IFC Mall", latitude: 22.2849, longitude: 114.158917),
    Restaurant(title: "Pacific Place", latitude: 22.2774985, longitude: 114.1663225),
    Restaurant(title: "Times Square", latitude: 22.2782079, longitude: 114.1822994),
    Restaurant(title: "Elements", latitude: 22.3048708, longitude: 114.1615219),
    Restaurant(title: "Harbour City", latitude: 22.2950689, longitude: 114.1668661),
    Restaurant(title: "Festival Walk", latitude: 22.3372971, longitude: 114.1745273),
    Restaurant(title: "MegaBox", latitude: 22.319857, longitude: 114.208168),
    Restaurant(title: "APM", latitude: 22.3121738, longitude: 114.22513219999996),
    Restaurant(title: "Tsuen Wan Plaza", latitude: 22.370735, longitude: 114.111309),
    Restaurant(title: "New Town Plaza", latitude: 22.3814592, longitude: 114.1889307)
]

struct CouponDetailView: View {
    
    var coupon: Coupons
    
    var body: some View {
        let Rest = Restaurants.filter{
             restaurant in
             return restaurant.title == coupon.mall
         }
            VStack(alignment: .center, spacing: 30){
                RemoteImageView(
                    urlString: coupon.image
                )
                VStack(alignment: .leading){
                    
                    Text(coupon.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 5.0)
                    Text(coupon.title)
                        .padding(.bottom, 1.0)
                    
                    Text("Mall: \(coupon.mall), Coins: \(coupon.coins),")
                        .padding(.bottom, 1.0)
                    
                    Text("Expiry Date: \(coupon.validtill)")
                        .padding(.bottom, 1.0)
                    
                    
                    
                    HStack{
                        
                        
                        Button(action : {
                            
                        }){
                            Text("redeem")
                                .padding(.horizontal, 40.0)
                                .foregroundColor(.black)
                            
                        }.padding(.all, 10.0).border(Color.black, width: 1)
                        
                        NavigationLink(destination: MapView(restaurant: Rest)){
                            Text("address")
                                .padding(.horizontal, 40.0)
                                .padding(.vertical, 10.0).border(Color.black, width: 1)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.all, 10.0)
                    
                    
                }.padding(.all).border(Color.black, width: 1)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct CouponDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CouponDetailView(coupon: Coupons(id: 0,title: "Simply receive a complimentary drink",name: "Greyhound Cafe", region: "",mall: "IFC Mall", image: "https://i.pinimg.com/originals/97/f4/65/97f46506136adc8e08dd26fae40b4a41.jpg", quota: 0, coins: 500, validtill: "2021-03-31",detail: ""))
    }
}












