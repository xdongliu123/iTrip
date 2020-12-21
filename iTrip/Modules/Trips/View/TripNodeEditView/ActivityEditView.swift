//
//  ActivityEditView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/11.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ActivityEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ActivityViewModel
    @ObservedObject private var keyboardListener = KeyboardResponder()
    
    @State var viewState = ActivityViewState()
    @State var showStartPicker = false
    @State var showEndPicker = false
    
    @State var showMapPointPicker = false
    
    @State var errorTip = ""
    @State var showErrorPopUp = false
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                self.whiteNavBar(self.viewModel.title, backAction: {
                    self.presentationMode.wrappedValue.dismiss()
                }, rightTitle: "Save") {
                    self.save()
                }
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        // ************** Depart info *****************
                        Section(header: self.tripNodeEditSectionHeader("BASIC INFO", topPadding: 5)) {
                            RectBorderTextField(valid: self.$viewState.wrappedValue.address.name.count > 0, value: self.$viewState.address.name, required: false, secureDisplay: false, title: "Name", placeHolder: "海洋公园") {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                            .padding(.bottom, 10)
                            RectBorderLocationField(valid: self.$viewState.wrappedValue.address.location.isValidCooridnate(), value: self.$viewState.address.location, required: true, title: "Location", mapClick: {
                                self.showMapPointPicker = true
                            }) {
                                UIApplication.shared.endEditing()
                            }
                            .padding(.horizontal, FieldOffset)
                            
                            DateTimePicker(dateTime: self.$viewState.startDate, showPicker: self.$showStartPicker, totalWidth: geo.size.width - 2 * FieldOffset, dateTitle: "Start Date", timeTitle: "Start Time", required: false)
                            .padding(.horizontal, FieldOffset)
                            
                            DateTimePicker(dateTime: self.$viewState.endDate, showPicker: self.$showEndPicker, totalWidth: geo.size.width - 2 * FieldOffset, dateTitle: "End Date", timeTitle: "End Time", required: false)
                            .padding(.horizontal, FieldOffset)
                        }
                        
                        // ************** Activity info *****************
                        Section(header: self.tripNodeEditSectionHeader("OTHER INFO")) {
                            HStack {
                                RectBorderTextField(valid: self.$viewState.parent.wrappedValue.contact.count > 1, value: self.$viewState.parent.contact, required: false, secureDisplay: false, title: "Contact", placeHolder: "李师傅") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                                Spacer()
                                RectBorderTextField(valid: self.$viewState.parent.wrappedValue.phone.count > 1, value: self.$viewState.parent.phone, required: false, secureDisplay: false, title: "Phone", placeHolder: "189XXXXXXXX") {
                                    UIApplication.shared.endEditing()
                                }
                                .frame(width: (geo.size.width - 2 * FieldOffset) * 0.48)
                            }
                            .padding(.horizontal, FieldOffset)
                        }
                        
                        Section(header: self.tripNodeEditSectionHeader("NOTE")) {
                            TextViewWrapper(text: self.$viewState.parent.note)
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
                SelectMapPointWrapper(address: self.$viewState.address)
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
            self.viewState = self.viewModel.viewState() as! ActivityViewState
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
