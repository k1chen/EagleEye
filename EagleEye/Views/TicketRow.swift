//
//  TicketRow.swift
//  EagleEye
//
//  Created by Kenneth Chen on 4/22/25.
//

import Foundation
import SwiftUI
import FirebaseCore


struct TicketRow: View {
    let ticket: MaintenanceTicket
    var body: some View {
        HStack(alignment: .top) {
            if let urlString = ticket.imageURL,
                let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(5)
                } placeholder: {
                    ProgressView()
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(ticket.title)
                    .font(.headline)
                if !ticket.floor.isEmpty {
                    Text("Floor: \(ticket.floor)")
                        .font(.subheadline)
                }
                Text(ticket.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                Text("Reported: \(ticket.timestamp.dateValue(), style: .relative)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

