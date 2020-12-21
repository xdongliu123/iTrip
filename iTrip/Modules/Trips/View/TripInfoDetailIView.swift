//
//  TripInfoDetailIView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/16.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine

struct TripInfoDetailIView: View {
    @State var present = false
    @State var show = false
    @State var scaleStart: CGPoint = CGPoint(x: -1000, y: -1000)
    @State var cardAnimatonCtrl = [String: Bool]()
    @State var currentNode: TripNodeListItemViewModel? = nil
    let viewModel: TripNodesIndexViewModel
    let coverPhotoWidth = (screenWidth - 60) / 3
    
    init(_ vm: TripNodesIndexViewModel) {
        viewModel = vm
    }
    
    var body: some View {
        ZStack {
            GeometryReader {geo in
                DetailViewOfShow(self.viewModel, self.$show, self.$cardAnimatonCtrl, hitHandler: { pt, node in
                    self.scaleStart = pt
                    self.currentNode = node
                    DispatchQueue.main.async {
                        self.present = true
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.show = true
                        }
                    }
                })
                
                if self.present {
                    RoundedRectangle(cornerRadius: 15).fill(Color.pink).overlay(MyForm(show: self.$show, handlerDone: {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.show = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                self.present = false
                                self.scaleStart = CGPoint(x: -1000, y: -1000)
                                self.$cardAnimatonCtrl.wrappedValue[self.currentNode!.startDate.formatString()] = false
                            }
                        }
                    }))
                    .frame(width: screenWidth, height: screenWidth * 1.2)
                    .shadow(color: .black, radius: 3)
                    .scaleEffect(self.show ? 1.0 : self.coverPhotoWidth / screenWidth)
                    .position(self.show ? CGPoint(x: geo.size.width / 2, y: geo.size.height / 2) : self.scaleStart)
                    .animation(Animation.default)
                }
            }
        }
        //.navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea([.top, .bottom])
        .coordinateSpace(name: "container")
    }
}

struct DetailViewOfShow: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let viewModel: TripNodesIndexViewModel
    var cardAnimatonCtrl: Binding<[String: Bool]>
    var show: Binding<Bool>
    let handlerHit: ((CGPoint, TripNodeListItemViewModel)->Void)
    
    init(_ vm: TripNodesIndexViewModel, _ _show: Binding<Bool>, _ animatonCtrl: Binding<[String: Bool]>, hitHandler: @escaping ((CGPoint, TripNodeListItemViewModel)->Void)) {
        viewModel = vm
        show = _show
        cardAnimatonCtrl = animatonCtrl
        handlerHit = hitHandler
    }
    
    var body: some View {
        GeometryReader {reader in
            VStack(alignment: .center) {
                ZStack {
                    Image("beach_cover").resizable().aspectRatio(contentMode: ContentMode.fill)
                    .frame(width: screenWidth)
                    .overlay(grayMaskGadient)
                    VStack(alignment: .leading) {
                        self.customNavBar("", backAction: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, rightImage: Image(systemName: "map"), rightAction: {
                            
                        })
                        .padding(.top, 40).padding(.bottom, 10).padding(.horizontal, 15)
                        
                        Text("relaxing one week yacht tour".uppercased()).font(Font.title)
                        .foregroundColor(Color.white).multilineTextAlignment(.leading)
                        .mask(colorMaskGadient)
                        .frame(width: reader.size.width / 2.0)
                        .padding(.leading, 20)
                        
                        Text("\(self.viewModel.destination)".uppercased()).font(Font.headline)
                        .foregroundColor(Color.white).multilineTextAlignment(.leading)
                        .mask(colorMaskGadient)
                        .padding(.leading, 20).padding(.top, 20)
                        
                        Text("\(self.viewModel.startDate!.formatString()) to \(self.viewModel.endDate!.formatString())".uppercased()).font(Font.headline)
                        .foregroundColor(Color.white).multilineTextAlignment(.leading)
                        .mask(colorMaskGadient)
                        .padding(.leading, 20).padding(.top, 20)
                        
                        Spacer()
                        VStack(spacing: 0) {
                            Rectangle().frame(height: 1).foregroundColor(Color.black.opacity(0.5))
                            Rectangle().frame(height: 1).foregroundColor(Color.white.opacity(0.5))
                        }.padding(.bottom, 10)
                    }
                }
                .frame(height: reader.size.height * 0.6)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(self.viewModel.nodes.sorted().reversed(), id: \.data) { node in
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(node.startDate.formatString(format: "dd/MM"))").foregroundColor(.white)
                                .padding(.leading, 10).padding(.bottom, 5)
                                Circle().frame(width: 10, height: 10).foregroundColor(.white).padding(.leading, 10)
                                VStack(alignment: .leading, spacing: 0) {
                                GeometryReader {geo in
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            self.cardAnimatonCtrl.wrappedValue[node.startDate.formatString()] = true
                                        }
                                        let center = geo.frame(in: .named("container")).center
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                            self.handlerHit(CGPoint(x: center.x, y: center.y), node)
                                        }
                                    }) {
                                        if ((self.cardAnimatonCtrl.wrappedValue[node.startDate.formatString()] ?? false)) {
                                            Image("snapshot").renderingMode(.original).resizable().scaledToFill()
                                            .frame(width: (screenWidth - 60) / 3, height: (screenWidth - 60) * 1.2 / 3)
                                            .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                                            .cornerRadius(5)
                                        } else {
                                            Image("default_trip_cover").renderingMode(.original).resizable().aspectRatio(contentMode: ContentMode.fill)
                                            .frame(width: (screenWidth - 60) / 3, height: (screenWidth - 60) * 1.2 / 3)
                                            .cornerRadius(5)
                                        }
                                    }
                                    .rotation3DEffect(Angle(degrees: (self.cardAnimatonCtrl.wrappedValue[node.startDate.formatString()] ?? false) ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                    .animation(Animation.default)
                                }
                                .frame(width: (screenWidth - 60) / 3, height: (screenWidth - 60) * 1.2 / 3)
                                    
                                Text("\(node.startDate.formatString())").font(Font.headline).mask(colorMaskGadient).padding(.top, 6)
                                Text("Demarcusberg").font(Font.headline).foregroundColor(.gray).padding(.top, 5)
                                }
                                .padding(.horizontal, 10).padding(.top, 25)
                                .background(gray2WhiteMaskGadient)
                            }
                        }
                    }
                }
                .offset(x: 0, y: -50)
                Spacer()
            }
        }
    }
}

struct MyForm: View {
    @Binding var show: Bool

    @State private var departure = Date()
    @State private var checkin = Date()

    @State private var pets = true
    @State private var nonsmoking = true
    @State private var airport: Double = 7.3
    
    let handlerDone: (()->Void)
    
    var body: some View {
        VStack {
            Text("Booking").font(.title).foregroundColor(.white)

            Form {
                DatePicker(selection: $departure, label: {
                    HStack {
                        Image(systemName: "airplane")
                        Text("Departure")
                    }
                })

                DatePicker(selection: $checkin, label: {
                    HStack {
                        Image(systemName: "house.fill")
                        Text("Check-In")
                    }
                })
                
                Toggle(isOn: $pets, label: { HStack { Image(systemName: "hare.fill"); Text("Have Pets") } })
                Toggle(isOn: $nonsmoking, label: { HStack { Image(systemName: "nosign"); Text("Non-Smoking") } })
                Text("Max Distance to Airport \(String(format: "%.2f", self.airport as Double)) km")
                Slider(value: $airport, in: 0...10) { EmptyView() }
                
                Button(action: {
                    self.handlerDone()
                }) {
                    HStack { Spacer(); Text("Save"); Spacer() }
                }
                
            }
        }.padding(20)
    }
}
