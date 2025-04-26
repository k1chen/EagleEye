//
//  MaintenanceTicketViewModel.swift
//  EagleEye
//
//  Created by Kenneth Chen on 4/21/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

struct MaintenanceTicketViewModel {
    @discardableResult
    static func saveTicket(ticket: MaintenanceTicket, imageData: Data?) async -> String? {
        let db = Firestore.firestore()
        let ticketsRef = db.collection("maintenance_tickets")
        var ticketToSave = ticket

        if let data = imageData, !data.isEmpty {
            let imageName = "\(UUID().uuidString).jpg"
            let imageRef = Storage.storage()
                .reference()
                .child("maintenance_images/\(ticket.buildingID)/\(imageName)")
            _ = try? await imageRef.putDataAsync(data)
            if let url = try? await imageRef.downloadURL() {
                ticketToSave.imageURL = url.absoluteString
            }
        }

        do {
            if let id = ticketToSave.id, !id.isEmpty {
                try ticketsRef.document(id).setData(from: ticketToSave, merge: true)
                return id
            } else {
                let docRef = try ticketsRef.addDocument(from: ticketToSave)
                return docRef.documentID
            }
        } catch {
            return nil
        }
    }

    static func deleteTicket(ticket: MaintenanceTicket) async {
        let db = Firestore.firestore()
        guard let id = ticket.id, !id.isEmpty else {
            print("No ticket.id")
            return
        }
        try? await db.collection("maintenance_tickets").document(id).delete()
        if let urlString = ticket.imageURL {
            try? await Storage.storage().reference(forURL: urlString).delete()
        }
    }
}

