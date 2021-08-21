//
//  TripsView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/8.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct TripsView: View {
    @ObservedObject var viewModel = TripsViewModel()
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)], animation: .default)
    private var trips: FetchedResults<Trip>
    @State var addTrip = false
    
    func tripView(isClose: Bool, item: Trip) -> some View {
        if isClose {
            return TripInfoDetailIView(TripNodesIndexViewModel(trip: item)).eraseToAnyView()
        } else {
            return TripNodesIndexView(TripNodesIndexViewModel(trip: item)).eraseToAnyView()
        }
    }
    
    var tripList: ASTableViewSection<Int>
    {
        ASTableViewSection(
        id: 0,
            data: trips, onCellEvent: onCellEvent)
        { item, _ in
            NavigationLink(destination: tripView(isClose: false, item: item)) {
                TripItemView(trip: item)
            }
        }
        .tableViewSetEstimatedSizes(headerHeight: 50) // Optional: Provide reasonable estimated heights for this section
    }
    
    var content: some View {
        if #available(iOS 14.0, *) {
            return AnyView (
                ScrollView {
                    LazyVStack {
                        ForEach(trips) { trip in
                            NavigationLink(destination: LazyView(tripView(isClose: false, item: trip))) {
                                TripItemView(trip: trip)
                                // EmptyView()
                            }
                        }
                    }
                }
            )
        } else {
            return AnyView(ASTableView {tripList}.separatorsEnabled(false))
        }
    }
    
    var body: some View {
        NavigationView {
            content
            .navigationBarTitle("Trips", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.addTrip = true
            }) {
                Image(systemName: "plus")
                    .accentColor(.black)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
            })
            .sheet(isPresented: self.$addTrip, onDismiss: {
            
            }) {
                TripBasicInfoEditView(viewModel: TripBasicInfoEditViewModel(nil))
            }
        }
    }
    
    func onCellEvent(_ event: CellEvent<Trip>) {
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
    }
}
