//
//  BuildingMaintenanceView.swift
//  EagleEye
//
//  Created by Kenneth Chen on 4/21/25.


import SwiftUI
import FirebaseFirestore

struct BuildingMaintenanceView: View {
    let buildingID: String
    let buildingName: String
    @FirestoreQuery(collectionPath: "maintenance_tickets")
    var tickets: [MaintenanceTicket]
    @State private var showingAddSheet = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            if tickets.isEmpty {
                VStack(spacing: 20) {
                    Label("No Tickets Found", systemImage: "doc.text.magnifyingglass")
                        .font(.title2)
                    Text("No maintenance tickets have been reported for \(buildingName) yet, or tickets are loading.")
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding()
                Spacer()
            } else {
                List(tickets) { ticket in
                    TicketRow(ticket: ticket)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(buildingName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAddSheet = true } label: {
                    Label("Add Ticket", systemImage: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            NavigationStack {
                MaintenanceTicketDetailView(
                    ticket: MaintenanceTicket(buildingID: buildingID),
                    buildingName: buildingName
                )
            }
        }
        .task {
            $tickets.predicates = [
                .where("buildingID", isEqualTo: buildingID),
                .orderBy("timestamp", true)
            ]
        }
    }
}

#Preview {
    NavigationStack {
        BuildingMaintenanceView(buildingID: "preview_fulton", buildingName: "Fulton Hall")
    }
}
 

