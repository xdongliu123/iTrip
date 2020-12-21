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
    
    var tripList: ASTableViewSection<Int>
    {
        ASTableViewSection(
        id: 0,
            data: trips, onCellEvent: onCellEvent)
        { item, _ in
            // completed trip detail page
//            NavigationLink(destination: TripInfoDetailIView(TripNodesIndexViewModel(trip: item))) {
//                TripItemView(trip: item)
//            }
            NavigationLink(destination: TripNodesIndexView(TripNodesIndexViewModel(trip: item))) {
                TripItemView(trip: item)
            }
        }
        .tableViewSetEstimatedSizes(headerHeight: 50) // Optional: Provide reasonable estimated heights for this section
    }
    
    var body: some View {
        NavigationView {
            ASTableView {
                tripList
            }
            .separatorsEnabled(false)
            .navigationBarTitle("Trips", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.addTrip = true
            }) {
                Image(systemName: "plus").font(Font.system(size: 20, weight: .bold  ,design: .default))
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
