//
//  FriendListView.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 15.05.25.
//

import SwiftUI

struct FriendListView: View {
    @State private var viewModel = FriendViewModel()
    
    @State var sampleId = 4
    
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach (viewModel.friends) {friend in
                    NavigationLink(destination: FriendView(friend: friend, viewModel: viewModel)) {
                            Text(friend.name)
                    }
                } 
                .onDelete { IndexSet in
                    Task {
                        await viewModel.deleteFriend(at: IndexSet)
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showingSheet) {
                            AddFriendSheetView(viewModel: viewModel, isPresented: $showingSheet, sampleId: $sampleId)
                        }
                        Button(action: {
                            viewModel.refreshFriends()
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                        
                        Button(action: {
                            viewModel.printAllFriends()
                        }) {
                            Image(systemName: "printer")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FriendListView()
}
