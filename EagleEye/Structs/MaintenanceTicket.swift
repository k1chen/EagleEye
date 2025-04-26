//
//  MaintenanceTicket.swift
//  EagleEye
//
//  Created by Kenneth Chen on 4/21/25.
//

import Foundation
import FirebaseFirestore

struct MaintenanceTicket: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var buildingID: String
    var title: String
    var floor: String
    var description: String
    var imageURL: String?
    var timestamp: Timestamp

    init(id: String? = nil,
         buildingID: String,
         title: String = "",
         floor: String = "",
         description: String = "",
         imageURL: String? = nil,
         timestamp: Timestamp = Timestamp()) {
        self.id = id
        self.buildingID = buildingID
        self.title = title
        self.floor = floor
        self.description = description
        self.imageURL = imageURL
        self.timestamp = timestamp
    }
}

