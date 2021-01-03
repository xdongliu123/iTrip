//
//  NewfeedEditView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/18.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine
import SwiftLocation
import ASCollectionView
import ActivityIndicatorView

let cellWidth = (screenWidth - 2 * FieldOffset - 20) / 3

struct NewfeedEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: NewfeedEditViewModel
    @State var selectedItems: Set<Int> = []
    @State var note: String = Lorem.sentences(1 ... 3)
    @State var presentMode: Bool = false
    @State var isEditing: Bool = false
    @State var showShareAlert = false
    @State var showSavingIndicator = false
    @State var address: TripAddressState = TripAddressState.defaultState()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack() {
                    TextViewWrapper(text: self.$note)
                    .cornerRadius(6)
                    .frame(height: 50)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    ForEach(viewModel.images.chunked(into: 3)) { row in
                        HStack(alignment: .center) {
                            ForEach(row.elements) { cell in
                                if cell.addTag {
                                    ZStack(alignment: .center) {
                                        Rectangle().frame(width: cellWidth, height: cellWidth)
                                            .foregroundColor(Color(rgb: 0xEEEEEE))
                                        Image(systemName: "plus").font(Font.system(size: 18))
                                            .foregroundColor(Color.blue)
                                        if isEditing {
                                            Rectangle().frame(width: cellWidth, height: cellWidth)
                                                .foregroundColor(Color.white.opacity(0.5))
                                        }
                                    }.onTapGesture {
                                        if !isEditing {
                                            viewModel.presentingType = .SelectPhoto
                                            self.presentMode = true
                                        }
                                    }
                                } else {
                                    FeedImageCell(cell: cell, editable: isEditing)
                                }
                            }
                            Spacer()
                        }
                    }
                    Button {
                        viewModel.presentingType = .SelectAddress
                        self.presentMode = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "location.fill")
                            Text(address.location.count == 0 ? "Locate me" : address.description)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 10)
                    Spacer()
                }
                .padding(.horizontal, FieldOffset)
                // saving indicator
                Rectangle().foregroundColor(Color.white.opacity(self.showSavingIndicator ? 0.5 : 0.0))
                ActivityIndicator(isAnimating: self.$showSavingIndicator, style: .large)
            }
            .navigationBarTitle("Feed", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnItem(title: "", action: {
                self.presentationMode.wrappedValue.dismiss()
            }), trailing: HStack(spacing: 20) {
                if self.isEditing
                {
                    Button(action: {
                        viewModel.cancelSelectedState()
                        self.isEditing.toggle()
                    })
                    {
                        Text("Done")
                    }
                    Button(action: {
                        viewModel.deletingSelectedPhotos()
                        withAnimation {
                            self.isEditing.toggle()
                        }
                    })
                    {
                        Image(systemName: "trash")
                    }
                } else {
                    Button(action: {
                        self.isEditing.toggle()
                    })
                    {
                        Text("Edit")
                    }
                    Button(action: {
                        checkCondition()
                    })
                    {
                        Image(systemName: "paperplane")
                    }
                }
            })
            .sheet(isPresented: $presentMode) {
                if viewModel.presentingType == .SelectPhoto {
                    MultiPhotosPicker(maxNumberOfItems: 6 - viewModel.imageCount) { (images) in
                        viewModel.appendImages(images)
                    }
                } else if viewModel.presentingType == .SelectAddress {
                    SelectAddressWrapper(address: $address)
                }
            }
            .alert(isPresented: self.$showShareAlert, content: {
                if viewModel.postTipType == .lackphotos {
                    return Alert(title: Text("Warning"), message: Text("The feed must have photos, please add from library"), dismissButton: .default(Text("Got it")))
                } else {
                    return Alert(title: Text("Tip"), message: Text("Are you certain to post this feed"), primaryButton: .default(Text("Confirm"), action: {
                        postfeed()
                    }), secondaryButton: .default(Text("Cancel")))
                }
            })
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .disabled(self.showSavingIndicator)
    }
    
    func checkCondition() {
        if self.viewModel.imageCount == 0  {
            viewModel.postTipType = .lackphotos
        } else {
            viewModel.postTipType = .confirm
        }
        self.showShareAlert = true
    }
    
    func postfeed() {
        self.showSavingIndicator = true
        viewModel.cancellable = viewModel.saveFeed(tip: self.note, addressState: self.address).sink { () in
            self.showSavingIndicator = false
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct FeedImageCell: View {
    @ObservedObject var cell: NewfeedEditViewModel.IdentifiableImage
    var editable: Bool
    var body: some View {
        Button {
            cell.checked.toggle()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: cell.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: cellWidth , height: cellWidth)
                if editable {
                    Rectangle().frame(width: cellWidth, height: cellWidth)
                        .foregroundColor(Color.white.opacity(0.5))
                }
                if cell.checked
                {
                    ZStack
                    {
                        Circle()
                            .fill(Color.blue)
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 2)
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 20, height: 20)
                    .padding(10)
                }
            }
        }
        .disabled(!editable)
    }
}
