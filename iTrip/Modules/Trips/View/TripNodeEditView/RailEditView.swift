//
//  RailEditView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import CoreLocation

struct RailEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: RailViewModel
    @ObservedObject private var keyboardListener = KeyboardResponder()
    
    @State var viewState = RailViewState()
    @State var showStartPicker = false
    @State var showEndPicker = false
    
    @State var showMapPointPicker = false
    
    @State var errorTip = ""
    @State var showErrorPopUp = false
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                self.whiteNavBar("Rail", backAction: {
                    self.presentationMode.wrappedValue.dismiss()
                }, rightTitle: "Save") {
                    self.save()
                }
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        // ************** Depart info *****************
                        Section(header: self.tripNodeEditSectionHeader("DEPART INFO", topPadding: 5)) {
                            RectBorderTextField(valid: self.$viewState.parent.wrappedValue.startAddress.name.count > 0, value: self.$viewState.parent.startAddress.name, required: false, secureDisplay: false, title: "Station Name", placeHolder: "") {
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
                            
                        }
                        
                        // ************** Arriving info *****************
                        Section(header: self.tripNodeEditSectionHeader("ARRIVING INFO")) {
                            RectBorderTextField(valid: self.$viewState.parent.wrappedValue.endAddress.name.count > 0, value: self.$viewState.parent.endAddress.name, required: false, secureDisplay: false, title: "Station Name", placeHolder: "") {
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
                        }
                        
                        // ************** Rail info *****************
                        Section(header: self.tripNodeEditSectionHeader("Rail Info")) {
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.train_number.count > 1, value: self.$viewState.train_number, required: false, secureDisplay: false, title: "Train Number", placeHolder: "G6") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.carrier.count > 1, value: self.$viewState.carrier, required: false, secureDisplay: false, title: "Entrance", placeHolder: "18B") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.confirmation.count > 1, value: self.$viewState.confirmation, required: false, secureDisplay: false, title: "Confirmation", placeHolder: "E428942850") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.coach.count > 1, value: self.$viewState.coach, required: false, secureDisplay: false, title: "Carriage", placeHolder: "09") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.seat_class.count > 1, value: self.$viewState.seat_class, required: false, secureDisplay: false, title: "Seat Class", placeHolder: "一等座") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.seat_number.count > 1, value: self.$viewState.seat_number, required: false, secureDisplay: false, title: "Seat", placeHolder: "01B") {
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
                // iOS14会自动处理
//                .padding(.bottom, self.keyboardListener.keyboardHeight)
//                .animation(Animation.default)
            }
            .sheet(isPresented: self.$showMapPointPicker) {
                SelectMapPointWrapper(address: viewModel.editDepart ? self.$viewState.parent.startAddress : self.$viewState.parent.endAddress)
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
            self.viewState = self.viewModel.viewState() as! RailViewState
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
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
