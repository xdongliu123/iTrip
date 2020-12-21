//
//  FlightEditView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import CoreLocation

struct FlightEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: FlightViewModel
    @ObservedObject private var keyboardListener = KeyboardResponder()
    
    @State var viewState: FlightViewState = FlightViewState()
    @State var showStartPicker = false
    @State var showEndPicker = false
    
    @State var showMapPointPicker = false
    @State var errorTip = ""
    @State var showErrorPopUp = false
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                self.whiteNavBar("Flight", backAction: {
                    self.presentationMode.wrappedValue.dismiss()
                }, rightTitle: "Save") {
                    self.save()
                }
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        // ************** Depart info *****************
                        Section(header: self.tripNodeEditSectionHeader("DEPART INFO", topPadding: 5)) {
                            RectBorderTextField(valid: self.$viewState.parent.wrappedValue.startAddress.name.count > 0, value: self.$viewState.parent.startAddress.name, required: false, secureDisplay: false, title: "Airport Name", placeHolder: "") {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                            .padding(.bottom, 10)
                            
                            RectBorderLocationField(valid: self.$viewState.parent.wrappedValue.startAddress.location.isValidCooridnate(), value: self.$viewState.parent.startAddress.location, required: true, title: "Location", mapClick: {
                                viewModel.editDepart = true
                                self.showMapPointPicker = true
                            }) {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            DateTimePicker(dateTime: self.$viewState.parent.startDate, showPicker: self.$showStartPicker, totalWidth: geo.size.width - 2 * FieldOffset, dateTitle: "Date", timeTitle: "Time", required: true)
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.depart_terminal.count > 0, value: self.$viewState.depart_terminal, required: false, secureDisplay: false, title: "Terminal", placeHolder: "8") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.6)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.depart_gate.count > 0, value: self.$viewState.depart_gate, required: false, secureDisplay: false, title: "Gate", placeHolder: "42") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.35)
                            }
                            .padding(.horizontal, FieldOffset)
                        }
                        
                        // ************** Arriving info *****************
                        Section(header: self.tripNodeEditSectionHeader("ARRIVING INFO")) {
                            RectBorderTextField(valid: self.$viewState.parent.wrappedValue.endAddress.name.count > 0, value: self.$viewState.parent.endAddress.name, required: false, secureDisplay: false, title: "Airport Name", placeHolder: "") {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                            .padding(.bottom, 10)
                            
                            RectBorderLocationField(valid: self.$viewState.parent.wrappedValue.endAddress.location.isValidCooridnate(), value: self.$viewState.parent.endAddress.location, required: true, title: "Location", mapClick: {
                                viewModel.editDepart = false
                                self.showMapPointPicker = true
                            }) {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            DateTimePicker(dateTime: self.$viewState.parent.endDate, showPicker: self.$showEndPicker, totalWidth: geo.size.width - 2 * FieldOffset, dateTitle: "Date", timeTitle: "Time", required: true)
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.arriving_terminal.count > 0, value: self.$viewState.arriving_terminal, required: false, secureDisplay: false, title: "Terminal", placeHolder: "4") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.6)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.arriving_gate.count > 0, value: self.$viewState.arriving_gate, required: false, secureDisplay: false, title: "Gate", placeHolder: "41") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.35)
                            }
                            .padding(.horizontal, FieldOffset)
                        }
                        
                        // ************** Flight info *****************
                        Section(header: self.tripNodeEditSectionHeader("FLIGHT INFO")) {
                            RectBorderTextField(valid: self.$viewState.wrappedValue.airline.count > 1, value: self.$viewState.airline, required: false, secureDisplay: false, title: "Airline/Aircraft", placeHolder: "AA/Airbus A319") {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                              
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.flightNo.count > 1, value: self.$viewState.flightNo, required: false, secureDisplay: false, title: "Flight Number", placeHolder: "1") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.seat.count > 1, value: self.$viewState.seat, required: false, secureDisplay: false, title: "Seat", placeHolder: "20B") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.baggage_claim.count > 1, value: self.$viewState.baggage_claim, required: false, secureDisplay: false, title: "Baggage", placeHolder: "Terminal 6, Carousel 10") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.confirmation.count > 1, value: self.$viewState.confirmation, required: false, secureDisplay: false, title: "Confirmation", placeHolder: "JH58092") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                        }
                        Section(header: self.tripNodeEditSectionHeader("NOTE")) {
                            TextViewWrapper(text: self.$viewState.parent.parent.note)
                            .cornerRadius(6)
                            .frame(height: 100)
                            .padding(.horizontal, FieldOffset)
                        }
                    }
                }
                .padding(.bottom, self.keyboardListener.keyboardHeight)
                .animation(Animation.default)
            }
            .sheet(isPresented: self.$showMapPointPicker) {
                SelectMapPointWrapper(address: editAddress())
            }
            .popup(isPresented: self.$showErrorPopUp, autohideIn: 3) {
                HStack {
                    Text(self.errorTip)
                }
                .frame(width: 200, height: 60)
                .background(Color(red: 0.85, green: 0.8, blue: 0.95))
                .cornerRadius(30.0)
            }
        }.onAppear {
            self.viewState = self.viewModel.viewState() as! FlightViewState
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func editAddress() -> Binding<TripAddressState> {
        return viewModel.editDepart ? self.$viewState.parent.startAddress : self.$viewState.parent.endAddress
    }
    
    func save() {
        _ = viewModel.save(viewState).sink(receiveCompletion: { (completion) in
            if case .failure(let error) = completion {
                self.errorTip = error.description
                self.showErrorPopUp = true
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) { () in
        
        }
    }
}

struct FlightEditView_Previews: PreviewProvider {
    static var previews: some View {
        FlightEditView(viewModel: FlightViewModel(nil))
    }
}
