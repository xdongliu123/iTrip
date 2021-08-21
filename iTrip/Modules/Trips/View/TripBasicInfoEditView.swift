//
//  TripBasicInfoEditView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import PopupView

struct TripBasicInfoEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject private var keyboardListener = KeyboardResponder()
    @ObservedObject var viewModel: TripBasicInfoEditViewModel
    
    @State var name: String = ""
    @State var destination: String = ""
    @State var description: String = ""
    
    @State var descriptionValid = false
    
    @State var startDate = Date()
    @State var endDate = Date()
    @State var showDatePicker = false
    
    @State var showPhotoLibrary = false
    @State var coverImage: UIImage? = nil
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                self.whiteNavBar("", backAction: {
                    self.presentationMode.wrappedValue.dismiss()
                }, rightTitle: "Save") {
                    self.saveTripInfo()
                }
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        // Name
                        RectBorderTextField(valid: self.viewModel.validName(self.name), value: self.$name, required: true, secureDisplay: false, title: "Trip Name", placeHolder: "Tibet travel") {
                            UIApplication.shared.endEditing()
                        }
                        .padding(.horizontal, FieldOffset)
                        .padding(.top, 0)
                        
                        // Destination
                        RectBorderTextField(valid: self.viewModel.validDestination(self.destination), value: self.$destination, required: true, secureDisplay: false, title: "Trip Destination", placeHolder: "香格里拉") {
                            UIApplication.shared.endEditing()
                        }
                        .padding(.horizontal, FieldOffset)
                        .padding(.top, 10)
                        
                        // Date-range
                        HStack {
                            DateRangePicker(startDate: self.$startDate, endDate: self.$endDate, totalWidth: geo.size.width - 2 * FieldOffset, showPicker: self.$showDatePicker, required: true)
                        }
                        .padding(.horizontal, FieldOffset)
                        .padding(.top, 10)
                        
                        // Description
                        HStack {
                            Text("Description").foregroundColor(Color.blue).font(Font.system(size: 15))
                            Spacer()
                        }
                        .padding(.horizontal, FieldOffset)
                        .padding(.top, 10)
                        TextViewWrapper(text: self.$description)
                        .cornerRadius(6)
                        .frame(height: 100)
                        //.roundCornerBordered()
                        .padding(.horizontal, FieldOffset)
                        
                        // Cover photo
                        HStack {
                            Text("Cover Image").foregroundColor(Color.blue).font(Font.system(size: 15))
                            Spacer()
                        }
                        .padding(.horizontal, FieldOffset)
                        .padding(.top, 10)
                        Button(action: {
                            self.showPhotoLibrary = true
                        }) {
                            if (self.coverImage != nil) {
                                Image(uiImage: self.coverImage!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)).resizable().scaledToFit()
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerSize: CGSize.init(width: 4, height: 4))
                                    .fill(Color.white)
                                    .frame(height: 150, alignment: .center)
                                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.blue, style: .init(lineWidth: 1.0,
                                        dash: [3, 2],
                                        dashPhase: 0)).foregroundColor(.gray))
                                    Image(systemName: "camera.on.rectangle").resizable().frame(width: 50, height: 40)
                                }
                            }
                        }
                        .padding(.horizontal, FieldOffset)
                        .padding(.bottom, 20)
                    }
                }
            }
            // iOS14会自动处理
//            .padding(.bottom, self.keyboardListener.keyboardHeight)
//            .animation(Animation.default)
        }
        .popup(isPresented: self.$viewModel.showPopupView, autohideIn: 3) {
            HStack {
                Text(self.viewModel.popUpTip)
            }
            .frame(width: 200, height: 60)
            .background(Color(red: 0.85, green: 0.8, blue: 0.95))
            .cornerRadius(30.0)
        }
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(image: self.$coverImage, sourceType: .photoLibrary)
        }
        .background(Color.white)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            self.setStateProperties()
        }
    }
    
    func saveTripInfo() {
        var map = ["name": self.name,
                   "destination": self.destination,
                   "description": self.description,
                   "startDate": self.startDate,
                   "endDate": self.endDate] as [String : Any]
        if let cover = self.coverImage {
            map["cover"] = cover
        }
        if (self.viewModel.save(tripItem: map)) {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func setStateProperties() {
        name = viewModel.data?.name ?? ""
        destination = viewModel.data?.destination ?? ""
        description = viewModel.data?.desc ?? ""
        startDate = viewModel.data?.startDate ?? Date()
        endDate = viewModel.data?.endDate ?? Date()
        coverImage = viewModel.data?.cover != nil ? UIImage.init(data: (viewModel.data?.cover)!) : nil
    }
}

struct TripInfoEditView_Previews: PreviewProvider {
    static var previews: some View {
        TripBasicInfoEditView(viewModel: TripBasicInfoEditViewModel(nil))
    }
}
