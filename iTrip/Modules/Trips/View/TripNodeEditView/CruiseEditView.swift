//
//  CruiseEditView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import CoreLocation

struct CruiseEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: CruiseViewModel
    @ObservedObject private var keyboardListener = KeyboardResponder()
    
    @State var viewState = CruiseViewState()
    @State var showStartPicker = false
    @State var showEndPicker = false
    
    @State var showMapPointPicker = false
    
    @State var errorTip = ""
    @State var showErrorPopUp = false
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                self.whiteNavBar("Cruise", backAction: {
                    self.presentationMode.wrappedValue.dismiss()
                }, rightTitle: "Save") {
                    self.save()
                }
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        // ************** Depart info *****************
                        Section(header: self.tripNodeEditSectionHeader("DEPART INFO", topPadding: 5)) {
                            RectBorderTextField(valid: self.$viewState.parent.wrappedValue.startAddress.name.count > 0, value: self.$viewState.parent.startAddress.name, required: false, secureDisplay: false, title: "Port Name", placeHolder: "") {
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
                            RectBorderTextField(valid: self.$viewState.parent.wrappedValue.endAddress.name.count > 0, value: self.$viewState.parent.endAddress.name, required: false, secureDisplay: false, title: "Port Name", placeHolder: "") {
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
                        
                        // ************** Cruise info *****************
                        Section(header: self.tripNodeEditSectionHeader("CRUISE INFO")) {
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.cruiseLine.count > 1, value: self.$viewState.cruiseLine, required: false, secureDisplay: false, title: "Cruise Line", placeHolder: "G-666") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.company.count > 1, value: self.$viewState.company, required: false, secureDisplay: false, title: "Company", placeHolder: "嘉年华") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.carbinType.count > 1, value: self.$viewState.carbinType, required: false, secureDisplay: false, title: "Carbin Type", placeHolder: "19") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.carbin.count > 1, value: self.$viewState.carbin, required: false, secureDisplay: false, title: "Carbin", placeHolder: "10-92") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.confirmation.count > 1, value: self.$viewState.confirmation, required: false, secureDisplay: false, title: "Confirmation", placeHolder: "0293-29229") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.shipName.count > 1, value: self.$viewState.shipName, required: false, secureDisplay: false, title: "Ship Name", placeHolder: "企业号") {
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
                .padding(.bottom, self.keyboardListener.keyboardHeight)
                .animation(Animation.default)
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
            self.viewState = self.viewModel.viewState() as! CruiseViewState
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

