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


enum ActiveAlert{
    case NotLogin, confirm, success, fail, redeemed, redeemFail
}

struct CouponDetailView: View {
    
    var coupon: Coupons
    
    @State private var showsAlert = false
    @State private var activeAlert: ActiveAlert = .confirm
    
    @State private var isUpdate = false
    @State private var isAdd = false
    
    
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
                        if(Login == false){
                            self.showAlert(.NotLogin)
                        }else{
                            self.showAlert(.confirm)
                        }
                    }){
                        Text("redeem")
                            .padding(.horizontal, 30.0)
                            .foregroundColor(.black)
                        
                    }.padding(.all, 10.0).border(Color.black, width: 1)
                        .alert(isPresented: self.$showsAlert){
                            switch activeAlert{
                            case .NotLogin:
                                return Alert(title: Text(
                                    "This function is not available for guest"
                                ), message: Text("You need to login first!"),
                                      dismissButton: .default(Text("ok")))
                                
                            case .confirm:
                                return Alert(
                                    title: Text(
                                    "Are you sure?"
                                ), message: Text("To redeem this coupon?")
                                    ,primaryButton: .default(Text("No"))
                                    ,secondaryButton: .default(Text("Yes")){
                                    isRedeemed()
                                }
                                )
                            case .success:
                                return Alert(title: Text(
                                    "redeem successfully"
                                ), message: Text("please use it before the expiry date"),
                                      dismissButton: .default(Text("ok")))
                            case .fail:
                                return Alert(title: Text(
                                    "cannot redeeem"
                                ), message: Text("No quota/ Not enough coins"),
                                      dismissButton: .default(Text("ok")))
                            case .redeemed:
                                return Alert(title: Text(
                                    "cannot redeem"
                                ), message: Text("You have redeemed this coupon!"),
                                      dismissButton: .default(Text("ok")))
                            case .redeemFail:
                                return Alert(title: Text(
                                    "cannot redeem"
                                ), message: Text("Server error"),
                                      dismissButton: .default(Text("ok")))
                            }
                            
                        }
                    
                    NavigationLink(destination: MapView(restaurant: Rest)){
                        Text("address")
                            .padding(.horizontal, 35.0)
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
    
    func showAlert(_ active: ActiveAlert) -> Void{
        DispatchQueue.global().async{
            self.activeAlert = active
            self.showsAlert = true
        }
    }
    
    func isRedeemed(){
        
        let group = DispatchGroup()
        
        group.enter()
        
        var isRedeem = false
        
        guard let url = URL(string: "\(baseURL)/check/\(coupon.id)")else{
            print("Invalid url string")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print(error)
                group.leave()
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 409 else {
                      group.leave()
                      return
                  }
            
            isRedeem = true
            group.leave()
        }

        
        task.resume()
        
        group.notify(queue: .main){
            if(isRedeem == true){
                self.showAlert(.redeemed)
            }else{
                redeem()
            }
        }
    }
    
    func redeem(){
        
        if(LoginUser.coins < coupon.coins || coupon.quota == 0){
            self.showAlert(.fail)
            return
        }
            AddRecord()
            UpdateRecord()
    }
    
    func AddRecord(){
        
       // let group = DispatchGroup()
        
       // group.enter()
        
        isAdd = false
        
        guard let Addurl = URL(string: "\(baseURL)/user/clients/add/\(coupon.id)")else{
            print("Invalid url string")
            return
        }
        
        var request = URLRequest(url: Addurl)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){ data,
            response, error in

            if let error = error{
                print(error)
               // group.leave()
                return
            }
            
            guard let httpResponse = response as?
                    HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else{
                      print("httpResponse error")
                      //group.leave()
                      return
                  }
            isAdd = true
           // group.leave()
        }
        task.resume()
        
//        group.notify(queue: .main){
//            if(isAdd == true){
//                UpdateRecord()
//            }else{
//                self.showAlert(.redeemFail)
//            }
//        }
    }
    
    func UpdateRecord(){
        
        let group = DispatchGroup()
        
        group.enter()
        
        isUpdate = false
        
        guard let Updateurl = URL(string: "\(baseURL)/user/update/\(coupon.id)")else{
            print("Invalid url string")
            return
        }
        
        var request = URLRequest(url: Updateurl)
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request){ data,
            response, error in

            if let error = error{
                print(error)
                group.leave()
                return
            }
            
            guard let httpResponse = response as?
                    HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else{
                      print("httpResponse error")
                      group.leave()
                      return
                  }
            isUpdate = true
            group.leave()
            return
        }
        
        task.resume()
        
        group.notify(queue: .main ){
            checking()
        }
    }
    
    func checking(){
        if(isAdd == true && isUpdate == true){
            LoginUser = User(id: LoginUser.id, username: LoginUser.username, role: LoginUser.role, coins: LoginUser.coins - coupon.coins)
            self.showAlert(.success)
        }else{
            self.showAlert(.redeemFail)
        }
    }
    
}


struct CouponDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CouponDetailView(coupon: Coupons(id: 0,title: "Simply receive a complimentary drink",name: "Greyhound Cafe", region: "",mall: "IFC Mall", image: "https://i.pinimg.com/originals/97/f4/65/97f46506136adc8e08dd26fae40b4a41.jpg", quota: 0, coins: 500, validtill: "2021-03-31",detail: ""))
    }
}












