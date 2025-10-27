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
                    
                    TextField("Latitude", text: $viewModel.customeLatitude)
                        .keyboardType(.decimalPad)
                    
                    TextField("Longitude", text: $viewModel.customeLongitude)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Location Details")
                }
                
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
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Open") {
                        viewModel.openCustomLocation()
                        dismiss()
                    }
                    .disabled(!viewModel.isCustomLocationValid)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
