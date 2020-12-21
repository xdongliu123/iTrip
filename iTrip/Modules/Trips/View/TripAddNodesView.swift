//
//  TripAddNodesView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/26.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine

struct TripAddNodesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let viewModel: TripAddNodesViewModel
    
    var body: some View {
        VStack {
            whiteNavBarWithOnlyBackItem("Select Node Type") {
                self.presentationMode.wrappedValue.dismiss()
            }
            List {
                Section(header: Text("Traffic".uppercased()).font(Font.tvHeaderFont()).padding(EdgeInsets.init(top: 20, leading: 0, bottom: 8, trailing: 0))) {
                    Cell(title: "Flight", iconName: "flight-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.flight)
                    }
                    Cell(title: "Rail", iconName: "train-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.rail)
                    }
                    Cell(title: "Cruise", iconName: "ship-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.cruise)
                    }
                    Cell(title: "Coach", iconName: "coach-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.coach)
                    }
                }
                Section(header: Text("Activity".uppercased()).font(Font.tvHeaderFont()).padding(EdgeInsets.init(top: 20, leading: 0, bottom: 8, trailing: 0))) {
                    Cell(title: "Lodging", iconName: "lodging-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.lodging)
                    }
                    Cell(title: "Mall", iconName: "mall-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.mall)
                    }
                    Cell(title: "Restaurant", iconName: "restaurant-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.restaurant)
                    }
                    Cell(title: "Park", iconName: "park-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.park)
                    }
                    Cell(title: "Concert", iconName: "concert-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.concert)
                    }
                    Cell(title: "Theatre", iconName: "theatre-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.theatre)
                    }
                    Cell(title: "Library", iconName: "library-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.library)
                    }
                    Cell(title: "Bookstore", iconName: "bookstore-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.bookstore)
                    }
                    Cell(title: "Museum", iconName: "museum-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.museum)
                    }
                    Cell(title: "Other", iconName: "meeting-icon") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.sendEvent(.other_activity)
                    }
                }
                Section(header: Text("Urban Transport".uppercased()).font(Font.tvHeaderFont()).padding(EdgeInsets.init(top: 20, leading: 0, bottom: 8, trailing: 0))) {
                    Cell(title: "Subway", iconName: "subway-icon") {
                        
                    }
                    Cell(title: "Bus", iconName: "bus-icon") {
                        
                    }
                    Cell(title: "Ferry", iconName: "ferry-icon") {
                        
                    }
                    Cell(title: "Bike", iconName: "bike-icon") {
                        
                    }
                    Cell(title: "Foot", iconName: "foot-icon") {
                        
                    }
                }
            }
        }.onAppear {
            UITableView.appearance().separatorStyle = .singleLine
        }
        .onDisappear {
            UITableView.appearance().separatorStyle = .none
        }
    }
    
    func Cell(title: String, iconName: String, tapHandler: @escaping ()->Void) -> some View {
        return Button(action: {
            tapHandler()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 15) {
                    Image(iconName).resizable()
                    .frame(width: 30, height: 30)
                    Text(title)
                }
                .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }
}

struct TripAddNodesView_Previews: PreviewProvider {
    static var previews: some View {
        TripAddNodesView(viewModel: TripAddNodesViewModel())
    }
}
