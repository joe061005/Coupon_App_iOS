//
//  CoinView.swift
//  CouponiOS
//
//  Created by joe  on 11/10/2021.
//

import SwiftUI

struct CoinView: View {
    var body: some View {
        NavigationView{
            List(Range){
                coinRange in
                NavigationLink(destination: RestByCoinView(coinRange: coinRange.Range)){
                    Text(coinRange.Range)
                        .font(.title3)
                        .fontWeight(.bold)
                } .padding(.vertical, 15.0)
            }.navigationTitle("Coin Range")
        }.padding(.top, -50.0)
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView()
    }
}

struct CoinsRange: Identifiable{
    let Range: String
    let id = UUID()
}

var Range: [CoinsRange] = [
    CoinsRange(Range: "Coins <= 300"),
    CoinsRange(Range: "300 < Coins < 600"),
    CoinsRange(Range: "Coins >= 600")
]
