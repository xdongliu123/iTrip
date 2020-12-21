//
//  TripItemView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/15.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct TripItemView: View {
    let trip: Trip
    var body: some View {
        ZStack {
            Image(uiImage: trip.uiImageCover() ?? UIImage(named: "default_trip_cover")!.withRenderingMode(.alwaysOriginal))
            .resizable().aspectRatio(1/1, contentMode: .fill)
            .frame(height: 180)
            .cornerRadius(10)
            
            // mask cover
            RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.black.opacity(0.2))
            .frame(height: 180)
                
            VStack(alignment: .leading) {
                HStack{
                    Text(trip.name!).font(Font.title).bold()
                        .foregroundColor(Color.white).multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack{
                    Text(trip.destination!).font(Font.headline).bold().foregroundColor(Color.white).multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack{
                    Text(trip.desc ?? "").font(Font.subheadline).bold().foregroundColor(Color.white).multilineTextAlignment(.leading)
                    Spacer()
                }
                Spacer()
                HStack{
                    Text("\(trip.startDate!.formatString()) to \(trip.endDate!.formatString())").font(Font.footnote).bold().foregroundColor(Color.white).multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding(.all, 10)
        }
        .padding()
    }
}
