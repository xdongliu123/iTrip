//
//  ConcreteNodeViewBuilder.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/12/21.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

class ConcreteNodeViewBuilder {
    static func buildFlightDetailView(viewState: FlightViewState) -> some View {
        List{
            // ************** Depart info *****************
            Section(header: nodeDetailSectionHeader(title: "DEPART INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.startAddress)) {
                    nodeDetailTextItemView(title: "Airport", value: viewState.parent.startAddress.name)
                }
                nodeDetailTextItemView(title: "Depart Time:", value: viewState.parent.startDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
                HStack {
                    nodeDetailTextItemView(title: "Ternimal:", value: viewState.depart_terminal, vertical: false)
                    nodeDetailTextItemView(title: "Gate:", value: viewState.depart_gate, vertical: false)
                }
            }
            Section(header: nodeDetailSectionHeader(title: "ARRIVING INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.endAddress)) {
                    self.nodeDetailTextItemView(title: "Airport", value: viewState.parent.endAddress.name)
                }
                nodeDetailTextItemView(title: "Arriving Time:", value: viewState.parent.endDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
                HStack {
                    nodeDetailTextItemView(title: "Ternimal:", value: viewState.arriving_terminal, vertical: false)
                    nodeDetailTextItemView(title: "Gate:", value: viewState.arriving_gate, vertical: false)
                }
            }
            Section(header: nodeDetailSectionHeader(title: "OTHER INFO")) {
                nodeDetailTextItemView(title: "Airline:", value: viewState.airline, vertical: false)
                nodeDetailTextItemView(title: "Confirmation:", value: viewState.confirmation, vertical: false)
                HStack {
                    nodeDetailTextItemView(title: "Flight Number:", value: viewState.flightNo, vertical: false)
                    nodeDetailTextItemView(title: "Seat:", value: viewState.seat, vertical: false)
                }
                nodeDetailTextItemView(title: "Baggage:", value: viewState.baggage_claim, vertical: false)
                nodeDetailTextItemView(title: "Note", value: viewState.parent.parent.note)
            }
        }
    }
    
    static func buildRailDetailView(viewState: RailViewState) -> some View {
        List{
            // ************** Depart info *****************
            Section(header: nodeDetailSectionHeader(title: "DEPART INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.startAddress)) {
                    nodeDetailTextItemView(title: "Airport", value: viewState.parent.startAddress.name)
                }
                nodeDetailTextItemView(title: "Depart Time:", value: viewState.parent.startDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
            }
            Section(header: nodeDetailSectionHeader(title: "ARRIVING INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.endAddress)) {
                    nodeDetailTextItemView(title: "Airport", value: viewState.parent.endAddress.name)
                }
                nodeDetailTextItemView(title: "Arriving Time:", value: viewState.parent.endDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
            }
            Section(header: nodeDetailSectionHeader(title: "OTHER INFO")) {
                HStack {
                    nodeDetailTextItemView(title: "Train Number:", value: viewState.train_number, vertical: false)
                    nodeDetailTextItemView(title: "Entrance:", value: viewState.carrier, vertical: false)
                }
                HStack {
                    nodeDetailTextItemView(title: "Confirmation:", value: viewState.confirmation, vertical: false)
                    nodeDetailTextItemView(title: "Carriage:", value: viewState.coach, vertical: false)
                }
                HStack {
                    nodeDetailTextItemView(title: "Seat class:", value: viewState.seat_class, vertical: false)
                    nodeDetailTextItemView(title: "Seat:", value: viewState.seat_number, vertical: false)
                }
                nodeDetailTextItemView(title: "Note", value: viewState.parent.parent.note)
            }
        }
    }
    
    static func buildCruiseDetailView(viewState: CruiseViewState) -> some View {
        List{
            // ************** Depart info *****************
            Section(header: nodeDetailSectionHeader(title: "DEPART INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.startAddress)) {
                    nodeDetailTextItemView(title: "Airport", value: viewState.parent.startAddress.name)
                }
                nodeDetailTextItemView(title: "Depart Time:", value: viewState.parent.startDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
            }
            Section(header: nodeDetailSectionHeader(title: "ARRIVING INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.endAddress)) {
                    nodeDetailTextItemView(title: "Airport", value: viewState.parent.endAddress.name)
                }
                nodeDetailTextItemView(title: "Arriving Time:", value: viewState.parent.endDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
            }
            Section(header: nodeDetailSectionHeader(title: "OTHER INFO")) {
                HStack {
                    nodeDetailTextItemView(title: "Line:", value: viewState.cruiseLine, vertical: false)
                    nodeDetailTextItemView(title: "Carrier:", value: viewState.company, vertical: false)
                }
                HStack {
                    nodeDetailTextItemView(title: "Confirmation:", value: viewState.confirmation, vertical: false)
                    nodeDetailTextItemView(title: "Ship Name:", value: viewState.shipName, vertical: false)
                }
                HStack {
                    nodeDetailTextItemView(title: "Carbin class:", value: viewState.carbinType, vertical: false)
                    nodeDetailTextItemView(title: "Carbin:", value: viewState.carbin, vertical: false)
                }
                nodeDetailTextItemView(title: "Note", value: viewState.parent.parent.note)
            }
        }
    }
    
    static func buildCoachDetailView(viewState: CoachViewState) -> some View {
        List{
            // ************** Depart info *****************
            Section(header: nodeDetailSectionHeader(title: "DEPART INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.startAddress)) {
                    nodeDetailTextItemView(title: "Airport", value: viewState.parent.startAddress.name)
                }
                nodeDetailTextItemView(title: "Depart Time:", value: viewState.parent.startDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
            }
            Section(header: nodeDetailSectionHeader(title: "ARRIVING INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.parent.endAddress)) {
                    nodeDetailTextItemView(title: "Airport", value: viewState.parent.endAddress.name)
                }
                nodeDetailTextItemView(title: "Arriving Time:", value: viewState.parent.endDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
            }
            Section(header: nodeDetailSectionHeader(title: "OTHER INFO")) {
                HStack {
                    nodeDetailTextItemView(title: "Confirmation:", value: viewState.confirmation, vertical: false)
                    nodeDetailTextItemView(title: "Entrance:", value: viewState.entrance, vertical: false)
                }
                HStack {
                    nodeDetailTextItemView(title: "Vehicle:", value: viewState.coachbrand, vertical: false)
                    nodeDetailTextItemView(title: "Carrier:", value: viewState.company, vertical: false)
                }
                HStack {
                    nodeDetailTextItemView(title: "Contact:", value: viewState.parent.parent.contact, vertical: false)
                    nodeDetailTextItemView(title: "Phone:", value: viewState.parent.parent.phone, vertical: false)
                }
                nodeDetailTextItemView(title: "Note", value: viewState.parent.parent.note)
            }
        }
    }
    
    static func buildActivityDetailView(viewState: ActivityViewState) -> some View {
        List{
            // ************** Basic info *****************
            Section(header: nodeDetailSectionHeader(title: "BASIC INFO")) {
                NavigationLink(destination: ShowMapPointWrapper(address: viewState.address)
                //.navigationBarBackButtonHidden(true)
                ) {
                    nodeDetailTextItemView(title: "Location", value: viewState.address.name)
                }
                nodeDetailTextItemView(title: "Start Time:", value: viewState.startDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
                nodeDetailTextItemView(title: "End Time:", value: viewState.endDate.formatString(format: "yyyy-MM-dd hh:mm"), vertical: false)
            }
            
            Section(header: self.nodeDetailSectionHeader(title: "OTHER INFO")) {
                HStack {
                    nodeDetailTextItemView(title: "Contact:", value: viewState.parent.contact, vertical: false)
                    nodeDetailTextItemView(title: "Phone:", value: viewState.parent.phone, vertical: false)
                }
                nodeDetailTextItemView(title: "Note", value: viewState.parent.note)
            }
        }
    }
    
    // Tools methods
    static func nodeDetailSectionHeader(title: String) -> AnyView {
        AnyView(
            HStack{
                Text(title).font(Font.callout)
                Spacer()
            }.padding(.top, 8)
             .padding(.bottom, 5)
        )
    }
    
    static func nodeDetailTextItemView(title: String, value: String, vertical: Bool=true) -> AnyView {
        if vertical {
            return AnyView(
                VStack {
                    HStack(spacing: 0) {
                        Text(title).foregroundColor(Color(rgb: 0x5d6569)).font(Font.callout).bold()
                            .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 5, trailing: 10))
                        .background(Color.clear)
                        Spacer()
                    }
                    HStack{
                        Text(value)
                        .font(Font.callout)
                        Spacer()
                    }
                    Spacer().frame(height: 10)
                }
            )
        } else {
            return AnyView(
                HStack(alignment: .bottom, spacing: 10) {
                    Text(title).foregroundColor(Color(rgb: 0x5d6569)).font(Font.callout).bold()
                    .background(Color.clear)
                    Text(value)
                    .font(Font.callout)
                    Spacer()
                }
            )
        }
    }
}
