//
//  TripNodesIndexView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/9/1.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine
import StepperView

struct TripNodesIndexView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: TripNodesIndexViewModel
    @State var editTripInfo = false
    @State var selectNodeType = false
    @State var showAddNodePage = false
    @State var showActionMenus = false
    @State var showSheet = false
    @State var subscription: AnyCancellable? = nil
    @State var nodeType: TripNodeType?
    @State var active: Bool = false
    
    init(_ vm: TripNodesIndexViewModel) {
        viewModel = vm
    }
    
    var body: some View {
        List {
            ForEach(self.viewModel.groups) { section in
                Section(header: Text(section.key)) {
                    ForEach(section.nodes) { node in
                        // remove navigationLink's right arrow
                        ZStack {
                            NavigationLink(destination: LazyView(self.createTripNodeDetailView(node)
                            )) {
                                EmptyView()
                            }
                            VStack {
                                HStack {
                                    Image(systemName: "clock").renderingMode(.original)
                                    Text("\(node.startDate.formatString(format: "HH:mm"))")
                                    Spacer()
                                }
                                TripNodePanel(node: node)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("\(viewModel.name)", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnItem(title: "", action: {
            self.presentationMode.wrappedValue.dismiss()
        }), trailing: Button(action: {
            self.showActionMenus = true
        }) {
            Image(systemName: "ellipsis").font(Font.system(size: 20, weight: .bold  , design: .default))
        })
        .onAppear(perform: {
            self.viewModel.startProgressTimer()
        })
        .onReceive(self.viewModel.addNodeVM.nodeTypePublisher) { (nodeType) in
            self.nodeType = nodeType
            self.selectNodeType = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                self.addTripNode()
            }
        }
        .onReceive(self.viewModel.editingFlightVM.nodeChangePublisher, perform: { (tripNode) in
            if tripNode != nil {
                self.viewModel.addTripNode(tripNode!)
            } else {
                self.viewModel.refreshNodes()
            }
        })
        .onReceive(self.viewModel.editingCoachVM.nodeChangePublisher, perform: { (tripNode) in
            if tripNode != nil {
                self.viewModel.addTripNode(tripNode!)
            } else {
                self.viewModel.refreshNodes()
            }
        })
        .onReceive(self.viewModel.editingRailVM.nodeChangePublisher, perform: { (tripNode) in
            if tripNode != nil {
                self.viewModel.addTripNode(tripNode!)
            } else {
                self.viewModel.refreshNodes()
            }
        })
        .onReceive(self.viewModel.editingCruiseVM.nodeChangePublisher, perform: { (tripNode) in
            if tripNode != nil {
                self.viewModel.addTripNode(tripNode!)
            } else {
                self.viewModel.refreshNodes()
            }
        })
        .onReceive(self.viewModel.editingActivityVM.nodeChangePublisher, perform: { (tripNode) in
            if tripNode != nil {
                self.viewModel.addTripNode(tripNode!)
            } else {
                self.viewModel.refreshNodes()
            }
        })
        .actionSheet(isPresented: $showActionMenus, content: { () -> ActionSheet in
            ActionSheet.init(title: Text("Select Operator"),
            buttons: [
            .default(Text("Edit Trip"), action: {
                self.showSheet = true
                self.editTripInfo = true
                self.selectNodeType = false
                self.showAddNodePage = false
            }),
            .default(Text("Add Node"), action: {
                self.nodeType = nil
                self.showSheet = true
                self.selectNodeType = true
                self.editTripInfo = false
                self.showAddNodePage = false
            }),
           .destructive(Text("Delete"), action: {
                self.subscription = self.viewModel.deleteTrip().sink(receiveCompletion: { (completion) in
                    print("\(completion)")
                }) { () in
                    self.presentationMode.wrappedValue.dismiss()
                }
            }),
            .cancel(Text("Cancel"))])
        })
        .sheet(isPresented: self.$showSheet) {
            if (self.selectNodeType) {
                TripAddNodesView(viewModel: self.viewModel.addNodeVM)
            } else if (self.editTripInfo) {
                TripBasicInfoEditView(viewModel: TripBasicInfoEditViewModel(self.viewModel.data))
            } else if (self.showAddNodePage) {
                self.createTripNodeEditView()
            }
        }
    }
    
    func addTripNode() {
        if nodeType! == .flight {
            let flight: Flight = StrorageHelper.createEntity()
            flight.type = Int16(TripNodeType.flight.rawValue)
            self.viewModel.editingFlightVM.isEdit = false
            self.viewModel.editingFlightVM.data = flight
        } else if nodeType! == .rail {
            let rail: Rail = StrorageHelper.createEntity()
            rail.type = Int16(TripNodeType.rail.rawValue)
            self.viewModel.editingRailVM.isEdit = false
            self.viewModel.editingRailVM.data = rail
        } else if nodeType! == .cruise {
            let cruise: Cruise = StrorageHelper.createEntity()
            cruise.type = Int16(TripNodeType.cruise.rawValue)
            self.viewModel.editingCruiseVM.isEdit = false
            self.viewModel.editingCruiseVM.data = cruise
        } else if nodeType! == .coach {
            let coach: Coach = StrorageHelper.createEntity()
            coach.type = Int16(TripNodeType.coach.rawValue)
            self.viewModel.editingCoachVM.isEdit = false
            self.viewModel.editingCoachVM.data = coach
        } else {
            let activity: Activity = StrorageHelper.createEntity()
            activity.type = Int16(nodeType!.rawValue)
            self.viewModel.editingActivityVM.isEdit = false
            self.viewModel.editingActivityVM.data = activity
            self.viewModel.editingActivityVM.type = nodeType!
        }
        self.showAddNodePage = true
        self.selectNodeType = false
        self.editTripInfo = false
        self.showSheet = true
    }
    
    func createTripNodeEditView() -> AnyView {
        if nodeType! == .flight {
            return AnyView(FlightEditView(viewModel: self.viewModel.editingFlightVM))
        } else if nodeType! == .rail {
            return AnyView(RailEditView(viewModel: self.viewModel.editingRailVM))
        } else if nodeType! == .cruise {
            return AnyView(CruiseEditView(viewModel: self.viewModel.editingCruiseVM))
        } else if nodeType! == .coach {
            return AnyView(CoachEditView(viewModel: self.viewModel.editingCoachVM))
        } else {
            return AnyView(ActivityEditView(viewModel: self.viewModel.editingActivityVM))
        }
    }
    
    func createTripNodeDetailView(_ node: TripNodeListItemViewModel) -> AnyView {
        if node.data.type == TripNodeType.flight.rawValue {
            self.viewModel.editingFlightVM.data = node.data
            let flightView = TripNodeDetailView(viewModel: self.viewModel.editingFlightVM,
                                                title: "Flight",
                                                viewState: FlightViewState(),
                                                editViewBuilder: {
                return AnyView(FlightEditView(viewModel: self.viewModel.editingFlightVM))
            }) { (viewState) -> AnyView in
                guard let flightState = viewState as? FlightViewState else {
                    fatalError("Error view state type")
                }
                return AnyView(ConcreteNodeViewBuilder.buildFlightDetailView(viewState: flightState))
            }
            return AnyView(flightView)
        }
        else if node.data.type == TripNodeType.rail.rawValue {
            self.viewModel.editingRailVM.data = node.data
            let railView = TripNodeDetailView(viewModel: self.viewModel.editingRailVM,
                                                title: "Rail",
                                                viewState: RailViewState(),
                                                editViewBuilder: {
                                                    return AnyView(RailEditView(viewModel: self.viewModel.editingRailVM))
            }) { (viewState) -> AnyView in
                guard let railState = viewState as? RailViewState else {
                    fatalError("Error view state type")
                }
                return AnyView(ConcreteNodeViewBuilder.buildRailDetailView(viewState: railState))
            }
            return AnyView(railView)
        } else if node.data.type == TripNodeType.cruise.rawValue {
            self.viewModel.editingCruiseVM.data = node.data
            let cruiseView = TripNodeDetailView(viewModel: self.viewModel.editingCruiseVM,
                                                title: "Cruise",
                                                viewState: CruiseViewState(),
                                                editViewBuilder: {
                                                    return AnyView(CruiseEditView(viewModel: self.viewModel.editingCruiseVM))
            }) { (viewState) -> AnyView in
                guard let cruiseState = viewState as? CruiseViewState else {
                    fatalError("Error view state type")
                }
                return AnyView(ConcreteNodeViewBuilder.buildCruiseDetailView(viewState: cruiseState))
            }
            return AnyView(cruiseView)
        } else if node.data.type == TripNodeType.coach.rawValue {
            self.viewModel.editingCoachVM.data = node.data
            let coachView = TripNodeDetailView(viewModel: self.viewModel.editingCoachVM,
                                                title: "Coach",
                                                viewState: CoachViewState(),
                                                editViewBuilder: {
                                                    return AnyView(CoachEditView(viewModel: self.viewModel.editingCoachVM))
            }) { (viewState) -> AnyView in
                guard let coachState = viewState as? CoachViewState else {
                    fatalError("Error view state type")
                }
                return AnyView(ConcreteNodeViewBuilder.buildCoachDetailView(viewState: coachState))
            }
            return AnyView(coachView)
        } else {
            self.viewModel.editingActivityVM.data = node.data
            self.viewModel.editingActivityVM.type = TripNodeType.init(rawValue: Int(node.data.type))!
            let activityView = TripNodeDetailView(viewModel: self.viewModel.editingActivityVM,
                                                  title: self.viewModel.editingActivityVM.title,
                                                viewState: ActivityViewState(),
                                                editViewBuilder: {
                                                    return AnyView(ActivityEditView(viewModel: self.viewModel.editingActivityVM))
            }) { (viewState) -> AnyView in
                guard let activityState = viewState as? ActivityViewState else {
                    fatalError("Error view state type")
                }
                return AnyView(ConcreteNodeViewBuilder.buildActivityDetailView(viewState: activityState))
            }
            return AnyView(activityView)
        }
    }
}

struct TripNodePanel: View {
    @ObservedObject var node: TripNodeListItemViewModel
    @State private var totalHeight = CGFloat(100)
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Circle().foregroundColor(node.progressColor).frame(width: 14, height: 14)
                Rectangle().foregroundColor(node.progressColor).frame(width: 8)
            }
            .padding(.bottom, 5)
            
            HStack(alignment: .top, spacing: 15) {
                self.node.icon.renderingMode(.original).resizable().frame(width: 30, height: 30)
                self.createNodeView(self.node)
                Spacer()
            }
            .padding(.all, 10)
            .frame(width: screenWidth * 0.8)
            .bordered(foregroundColor: Color.init(rgb: 0xEFEFEF))
        }
        .padding(.bottom, 5)
    }
    
    func createNodeView(_ node: TripNodeListItemViewModel) -> AnyView {
        let view = VStack(alignment: .leading) {
            Text(node.title).fontWeight(Font.Weight.bold)
            Spacer().frame(height: 10)
            if node.data is Traffic {
                createTrafficView(node.data as! Traffic)
            } else if node.data is Activity {
                createActivityView(node.data as! Activity)
            }
        }
        return view.eraseToAnyView()
    }
    
    func createTrafficView(_ traffic: Traffic) -> AnyView {
        let view = VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("arriving at: ")
                Text(traffic.endDate!.formatString(format: "HH:mm"))
                if traffic.endDate!.diff(ofComponent: .day, fromDate: traffic.startDate!) > 0 {
                    Text("(\(traffic.endDate!.diff(ofComponent: .day, fromDate: traffic.startDate!)) days later)")
                    .font(Font.footnote)
                }
            }
            .padding(.top, 0)
            .padding(.trailing, 0)
            
            if ((traffic.note ?? "").count > 0) {
                Text(traffic.note ?? "")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
//                    In a List or ScrollView the SwiftUI engine will compress back the text area. .lineLimit(x) give you a maximum of line, not a minimum ;) To secure that the engine does not shrink back the Text height and goes up to the maximum limit, add .fixedSize(horizontal: false, vertical: true) as shown below
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 5)
                .padding(.trailing, 10)
            }
        }
        return AnyView(view)
    }
    
    func createActivityView(_ activity: Activity) -> AnyView {
            let view = VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 0) {
                    Text(activity.address?.desc ?? "").font(Font.footnote)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                }
                .padding(.top, 0)
                .padding(.trailing, 10)
                
                HStack(spacing: 0) {
                    Text("end at: ")
                    Text(activity.endDate!.formatString(format: "HH:mm"))
                    if activity.endDate!.diff(ofComponent: .day, fromDate: activity.startDate!) > 0 {
                        Text("(\(activity.endDate!.diff(ofComponent: .day, fromDate: activity.startDate!)) days later)")
                        .font(Font.footnote)
                    }
                }
                .padding(.top, 5)
                .padding(.trailing, 0)
                
                if ((activity.note ?? "").count > 0) {
                    Text(activity.note ?? "")
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
    //                    In a List or ScrollView the SwiftUI engine will compress back the text area. .lineLimit(x) give you a maximum of line, not a minimum ;) To secure that the engine does not shrink back the Text height and goes up to the maximum limit, add .fixedSize(horizontal: false, vertical: true) as shown below
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 5)
                    .padding(.trailing, 10)
                }
            }
            return AnyView(view)
        }
}
