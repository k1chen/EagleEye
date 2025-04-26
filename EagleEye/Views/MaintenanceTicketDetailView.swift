//
//  MaintenanceTicketDetailView.swift
//  EagleEye
//
//  Created by Kenneth Chen on 4/21/25.
//

import SwiftUI
import PhotosUI

struct MaintenanceTicketDetailView: View {
    @State var ticket: MaintenanceTicket
    let buildingName: String
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage = Image(systemName: "photo")
    @State private var imageData: Data?
    @State private var isSaving = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss

    var isSaveDisabled: Bool {
        ticket.title.trimmingCharacters(in: .whitespaces).isEmpty ||
        ticket.description.trimmingCharacters(in: .whitespaces).isEmpty ||
        isSaving
    }

    var body: some View {
        VStack {
            Group {
                TextField("Issue Title", text: $ticket.title)
                    .font(.title)
                    .autocorrectionDisabled()
                TextField("Floor / Location", text: $ticket.floor)
                    .font(.title2)
                    .autocorrectionDisabled()
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $ticket.description)
                    .frame(height: 150)
                    .padding(.horizontal)
                if ticket.description.isEmpty {
                    Text("Describe the issue…")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            HStack {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Label(imageData == nil ? "Add Photo" : "Change Photo", systemImage: "photo.on.rectangle")
                }
                .buttonStyle(.bordered)
                Spacer()
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(ticket.id == nil ? "New \(buildingName) Ticket" : "Ticket Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") { saveTicket() }
                    .disabled(isSaveDisabled)
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                imageData = nil
                selectedImage = Image(systemName: "photo")
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    imageData = data
                    if let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }

    private func saveTicket() {
        isSaving = true
        Task { @MainActor in
            let success = await MaintenanceTicketViewModel.saveTicket(ticket: ticket, imageData: imageData) != nil
            isSaving = false
            if success {
                dismiss()
            } else {
                alertTitle = "Save Error"
                alertMessage = "Could not save the ticket. Please try again."
                showingAlert = true
            }
        }
    }

}

#Preview {
    NavigationStack {
        MaintenanceTicketDetailView(
            ticket: MaintenanceTicket(buildingID: "preview_building"),
            buildingName: "Preview Hall"
        )
    }
}

