//
//  RedeemedCouponView.swift
//  CouponiOS
//
//  Created by joe  on 13/10/2021.
//

import SwiftUI

struct RedeemedCouponView: View {
    @AppStorage("cookie") var cookie = ""
    
    @State private var redeemedcoupons: redeemedCoupon = redeemedCoupon(id: -1, clients: [])
    
    var body: some View {
        List(redeemedcoupons.clients){
            couponItem in
            NavigationLink(destination: CouponDetailView(coupon: couponItem)){
                VStack(alignment: .leading){
                    Text(couponItem.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 5.0)
                    Text(couponItem.mall)
                        .padding(.bottom, 5.0)
                }
                
            }
        }.navigationTitle("My Redeemed Coupons")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: startLoad)
    }
}

struct RedeemedCouponView_Previews: PreviewProvider {
    static var previews: some View {
        RedeemedCouponView()
    }
}

struct redeemedCoupon: Identifiable{
    let id : Int
    let clients: [Coupons]
    
}

extension redeemedCoupon: Decodable{}

extension RedeemedCouponView {
    
    func handleClientError(_: Error) {
        return
    }
    
    func handleServerError(_: URLResponse?) {
        return
    }
    
    func startLoad() {
        print("Cookie \(cookie)")
        guard let url = URL(string: "\(baseURL)/redeem")else{
            print("Invalid url string")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("Redeemed running")
            
            if let error = error {
                self.handleClientError(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      self.handleServerError(response)
                      return
                  }
            
            if let data = data, let coupons = try? JSONDecoder().decode(redeemedCoupon.self, from: data) {
                self.redeemedcoupons = coupons
            }
            
        }
        task.resume()
        print("Redeemed end")
        
    }
}

