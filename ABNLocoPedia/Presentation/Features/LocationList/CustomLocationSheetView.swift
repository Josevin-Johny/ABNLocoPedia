//
//  CustomLocationSheetView.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import SwiftUI
import Combine


// MARK: - Custom Location Sheet

/// Sheet for adding custom location with manual coordinate input
/// - User enters name, latitude, longitude
/// - Validates coordinates before enabling "Open" button
/// - Opens Wikipedia app at specified coordinates
struct CustomLocationSheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: LocationsListViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                // Section 1: Input fields
                Section {
                    TextField("Name", text: $viewModel.customLocationName)
                        .accessibilityLabel("Location name")
                        .accessibilityHint("Enter the name of the location")
                    
                    TextField("Latitude", text: $viewModel.customeLatitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Latitude")
                        .accessibilityHint("Enter latitude between minus 90 and 90")
                    
                    TextField("Longitude", text: $viewModel.customeLongitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Longitude")
                        .accessibilityHint("Enter longitude between minus 180 and 180")
                    
                } header: {
                    Text("Location Details")
                }
                .accessibilityElement(children: .contain)
                
                // Section 2: Hints
                Section {
                    Text("Latitude: -90 to 90")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Longitude: -180 to 180")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Custom Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityLabel("Cancel")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Open") {
                        viewModel.openCustomLocation()
                        dismiss()
                    }
                    .disabled(!viewModel.isCustomLocationValid)
                    .accessibilityLabel(viewModel.isCustomLocationValid ? "Open in Wikipedia" : "Open in ABN test Wikipedia, disabled")
                    .accessibilityHint(viewModel.isCustomLocationValid ? "Double tap to open location in ABN test Wikipedia app" : "Fill in all fields with valid coordinates to enable")
                }
            }
        }
        .presentationDetents([.medium])
    }
}
