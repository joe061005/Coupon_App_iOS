//
//  RestByMallView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct RestByMallView: View {
    
    var MallTitle: String
    
    @State private var coupons: [Coupons] = []
    
    var body: some View {
        List(coupons){
            couponItem in
            NavigationLink(destination: CouponDetailView(coupon: couponItem)){
                Text(couponItem.name)
            }
        }.navigationTitle("Restaurants")
            .onAppear(perform: startLoad)
    }
}

struct RestByMallView_Previews: PreviewProvider {
    static var previews: some View {
        RestByMallView(MallTitle: "IFC Mall")
    }
}

extension RestByMallView {
    
    func handleClientError(_: Error) {
        return
    }
    
    func handleServerError(_: URLResponse?) {
        return
    }
    
    func startLoad() {
        
        let encodedURL = "\(baseURL)/mall/\(MallTitle)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
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
            print(self.coupons)
        }
        task.resume()
    }
}
