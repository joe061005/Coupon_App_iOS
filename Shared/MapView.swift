//
//  MapView.swift
//  CouponiOS
//
//  Created by joe  on 9/10/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    let restaurant: [Restaurant]
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $region, annotationItems: restaurant){
                rest in
                MapAnnotation(coordinate: rest.coordinate){
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                        .foregroundColor(Color(.systemRed))
                    Text(rest.title)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 150)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            Button("Reset") {
                withAnimation {
                    region.center = CLLocationCoordinate2D(
                        latitude: restaurant[0].latitude,
                        longitude: restaurant[0].longitude
                    )
                }
            }
            .padding()
        
        }.onAppear{
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: restaurant[0].latitude,
                    longitude: restaurant[0].longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.005,
                    longitudeDelta: 0.005
                )
            )
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(restaurant: [Restaurant(title: "IFC Mall", latitude: 22.2849, longitude: 114.158917)])
    }
}

struct Restaurant: Identifiable{
    var id = UUID()
    let title: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
    }

}

