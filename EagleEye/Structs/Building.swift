//
//  Building.swift
//  EagleEye
//
//  Created by Kenneth Chen on 4/21/25.
//

import Foundation
import MapKit

struct Building: Identifiable {
    let id = UUID()
    let name: String
    let buildingID: String
    let systemImage: String
    let coordinate: CLLocationCoordinate2D
}
