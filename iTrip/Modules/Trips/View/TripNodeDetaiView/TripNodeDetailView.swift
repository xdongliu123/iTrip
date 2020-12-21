//
//  TripNodeDetailView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/12/20.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine

struct TripNodeDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: TripNodeViewModel
    let title: String
    @State var viewState: ConcreteNodeViewState
    let editViewBuilder: ()->AnyView
    let contentBuilder: (ConcreteNodeViewState)-> AnyView
    
    @State var showSheet = false
    @State var editState = false
    @State var showActionMenus = false
    @State var showEdit = false
    @State var showFeeds = false
    @State var showDeleteAlert = false
    @State var subscription: AnyCancellable? = nil
    
    var body: some View {
        contentBuilder(viewState)
        .navigationBarTitle(title)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnItem(title: "", action: {
            self.presentationMode.wrappedValue.dismiss()
        }), trailing: Button(action: {
            self.showActionMenus = true
        }) {
            Image(systemName: "ellipsis").font(Font.system(size: 20, weight: .bold  , design: .default))
        })
        .actionSheet(isPresented: $showActionMenus, content: { () -> ActionSheet in
            ActionSheet.init(title: Text("Select Operator"),
            buttons: [
            .default(Text("Edit"), action: {
                self.showEdit = true
                self.showFeeds = false
                self.viewModel.isEdit = true
                self.showSheet = true
            }),
            .default(Text("Feeds"), action: {
                self.showFeeds = true
                self.showEdit = false
                self.showSheet = true
            }),
           .destructive(Text("Delete"), action: {
                self.showDeleteAlert = true
            }),
            .cancel(Text("Cancel"))])
        })
        .sheet(isPresented: self.$showSheet) {
            if (self.showEdit) {
                self.editViewBuilder()
            } else if (self.showFeeds) {
                TripNodeFeedView(viewModel: TripNodeFeedViewModel(viewModel.data))
            }
        }
        .alert(isPresented: self.$showDeleteAlert, content: {
            Alert(title: Text("Warning"), message: Text("Are you certain to delete this item"), primaryButton: .default(Text("Confirm"), action: {
                self.subscription = self.viewModel.deleteNode().sink(receiveCompletion: { (completion) in
                    print("\(completion)")
                }) { () in
                    self.presentationMode.wrappedValue.dismiss()
                }
            }), secondaryButton: .default(Text("Cancel")))
        })
        .onReceive(self.viewModel.nodeChangePublisher, perform: { (node) in
            if let generator = self.viewModel as? GenerateConcreteNodeViewState {
                self.viewState = generator.viewState()
            }
            StrorageHelper.save()
        })
        .onAppear {
            if let generator = self.viewModel as? GenerateConcreteNodeViewState {
                self.viewState = generator.viewState()
            }
        }
    }
}
