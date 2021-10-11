//
//  CouponView.swift
//  CouponiOS
//
//  Created by joe  on 9/10/2021.
//

import SwiftUI

struct CouponView: View {
    @State private var coupons: [Coupons] = []
    
    var body: some View {
        
        NavigationView{
            List(coupons){
                couponItem in
                NavigationLink(destination: CouponDetailView(
                    coupon: couponItem
                )){
                    VStack{
                        RemoteImageView(
                            urlString: couponItem.image
                        )
                        Text(couponItem.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 1.0)
                        
                        Text(couponItem.title)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 1.0)
                        
                        
                        Text("Coins: \(couponItem.coins)")
                        
                        
                    }
                    .padding(.all, 20.0)
                    
                }.padding(.all, 10.0).overlay(
                RoundedRectangle(cornerRadius:20)
                    .stroke(Color.black, lineWidth: 2)
                )
            }.onAppear(perform: startLoad)
                .navigationTitle("Coupons")

            
        } .padding(.top, -50.0)
        
    }
}

struct CouponView_Previews: PreviewProvider {
    static var previews: some View {
        CouponView()
    }
}

struct Coupons: Identifiable{
    let id: Int
    let title: String
    let name: String
    let region: String
    let mall: String
    let image: String
    let quota: Int
    let coins: Int
    let validtill: String
    let detail: String
}

extension Coupons: Decodable {}

struct RemoteImageView: View {
    
    var urlString: String
    @State var image: UIImage = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .onAppear {
                loadImage(for: urlString)
            }
    }
    
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            self.image = UIImage(data: data) ?? UIImage()
        }
        task.resume()
    }
}

extension CouponView {
    
    func handleClientError(_: Error) {
        return
    }
    
    func handleServerError(_: URLResponse?) {
        return
    }
    
    func startLoad() {
        
        let url = URL(string: baseURL)!
        
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
