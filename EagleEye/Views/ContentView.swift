//
//  ContentView.swift
//  EagleEye
//
//  Created by Kenneth Chen on 4/21/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var locations: [Building] = [
            Building(name: "O'Neill Library", buildingID: "oneill", systemImage: "building.columns", coordinate: CLLocationCoordinate2D(latitude: 42.336194, longitude: -71.169253)),
            Building(name: "St. Mary's Hall", buildingID: "stmarys", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.336748, longitude: -71.170472)),
            Building(name: "Bapst Library", buildingID: "bapst", systemImage: "building.columns", coordinate: CLLocationCoordinate2D(latitude: 42.336643, longitude: -71.171365)),
            Building(name: "Gasson Hall", buildingID: "gasson", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.335608, longitude: -71.170491)),
            Building(name: "Maloney Hall", buildingID: "maloney", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.336324, longitude: -71.168266)),
            Building(name: "Lyons Hall", buildingID: "lyons", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.334985, longitude: -71.170984)),
            Building(name: "Devlin Hall", buildingID: "devlin", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.335247, longitude: -71.169670)),
            Building(name: "Higgins Hall", buildingID: "higgins", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.335025, longitude: -71.168768)),
            Building(name: "Stokes North", buildingID: "stokes_n", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.334581, longitude: -71.171225)),
            Building(name: "Stokes South", buildingID: "stokes_s", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.333964, longitude: -71.171337)),
            Building(name: "Fulton Hall", buildingID: "fulton", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.334536, longitude: -71.170094)),
            Building(name: "245 Beacon St (Schiller)", buildingID: "schiller", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.334582, longitude: -71.168842)),
            Building(name: "Carney Hall", buildingID: "carney", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.333590, longitude: -71.170595)),
            Building(name: "McGuinn Hall", buildingID: "mcguinn", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.333699, longitude: -71.169794)),
            Building(name: "Campion Hall", buildingID: "campion", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.333851, longitude: -71.168468)),
            Building(name: "Merkert Hall", buildingID: "merkert", systemImage: "building", coordinate: CLLocationCoordinate2D(latitude: 42.333867, longitude: -71.167218)),
            Building(name: "McElroy Commons", buildingID: "mcelroy", systemImage: "fork.knife", coordinate: CLLocationCoordinate2D(latitude: 42.333165, longitude: -71.172520))
        ]
    
    @State private var selectedBuilding: Building? = nil
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        NavigationView {
            Map(position: $mapCameraPosition) {
                ForEach(locations) { building in
                    Annotation(building.name, coordinate: building.coordinate) {
                        Image(systemName: building.systemImage)
                            .padding(8)
                            .foregroundStyle(.white)
                            .background(Color.indigo)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .onTapGesture {
                                print("Tap worked: You tapped on \(building.name)")
                                selectedBuilding = building
                            }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .navigationTitle("Eagle Eye")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedBuilding) { building in
                NavigationStack {
                    BuildingMaintenanceView(
                        buildingID: building.buildingID,
                        buildingName: building.name
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

