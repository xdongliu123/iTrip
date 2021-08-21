//
//  CoachEditView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import CoreLocation

struct CoachEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: CoachViewModel
    @ObservedObject private var keyboardListener = KeyboardResponder()
    
    @State var viewState = CoachViewState()
    @State var showStartPicker = false
    @State var showEndPicker = false
    
    @State var showMapPointPicker = false
    
    @State var errorTip = ""
    @State var showErrorPopUp = false
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                self.whiteNavBar("Coach", backAction: {
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
                            
                            RectBorderLocationField(valid: self.$viewState.parent.wrappedValue.endAddress.location != nil, value: self.$viewState.parent.endAddress.description, required: true, title: "Location", placeHolder: "", mapClick: {
                                viewModel.editDepart = false
                                self.showMapPointPicker = true
                            }) {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            DateTimePicker(dateTime: self.$viewState.parent.endDate, showPicker: self.$showEndPicker, totalWidth: geo.size.width - 2 * FieldOffset, dateTitle: "Date", timeTitle: "Time", required: true)
                            .padding(.horizontal, FieldOffset)
                        }
                        
                        // ************** Coach info *****************
                        Section(header: self.tripNodeEditSectionHeader("COACH INFO")) {
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.confirmation.count > 1, value: self.$viewState.confirmation, required: false, secureDisplay: false, title: "Confirmation", placeHolder: "confirmation code") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.entrance.count > 1, value: self.$viewState.entrance, required: false, secureDisplay: false, title: "Entrance", placeHolder: "12") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.wrappedValue.company.count > 1, value: self.$viewState.company, required: false, secureDisplay: false, title: "Company", placeHolder: "祥龙客运") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.wrappedValue.coachbrand.count > 1, value: self.$viewState.coachbrand, required: false, secureDisplay: false, title: "Coach brand", placeHolder: "宇通") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            HStack {
                                RectBorderTextField(valid: self.$viewState.parent.parent.wrappedValue.contact.count > 1, value: self.$viewState.parent.parent.contact, required: false, secureDisplay: false, title: "Contact", placeHolder: "李师傅") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.parent.parent.wrappedValue.phone.count > 1, value: self.$viewState.parent.parent.phone, required: false, secureDisplay: false, title: "Phone", placeHolder: "189XXXXXXXX") {
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
            self.viewState = self.viewModel.viewState() as! CoachViewState
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
