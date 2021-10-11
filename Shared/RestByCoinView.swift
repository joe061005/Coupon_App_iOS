//
//  RestByCoinView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct RestByCoinView: View {
    
    var coinRange: String
    
    @State private var coupons: [Coupons] = []
    
    var body: some View {
        List(coupons){
            couponItem in
            NavigationLink(destination: CouponDetailView(coupon: couponItem)){
                
                VStack(alignment: .leading) {
                    Text(couponItem.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 5.0)
                    Text(couponItem.mall)
                        .padding(.bottom, 5.0)
                }
            }
        }.padding(.top, -50.0)
            .navigationTitle("Restaurants (\(coinRange))")
                .onAppear(perform: startLoad)
                .navigationBarTitleDisplayMode(.inline)
    }
}

struct RestByCoinView_Previews: PreviewProvider {
    static var previews: some View {
        RestByCoinView(coinRange: "300 < Coins < 600")
    }
}

extension RestByCoinView {
    
    func handleClientError(_: Error) {
        return
    }
    
    func handleServerError(_: URLResponse?) {
        return
    }
    
    func startLoad() {
        
        let encodedURL = "\(baseURL)/Coins/\(coinRange)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: encodedURL!)else{
            print("Invalid url string")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                self.handleClientError(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      self.handleServerError(response)
                      return
                  }
            
            if let data = data, let coupons = try? JSONDecoder().decode([Coupons].self, from: data) {
                
                self.coupons = coupons
            }
        }
        task.resume()
    }
}

