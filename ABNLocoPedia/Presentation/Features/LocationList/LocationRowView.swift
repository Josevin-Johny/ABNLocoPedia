//
//  LocationRow.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import SwiftUI

// MARK: - Location Row

/// Displays one  location with name and coordinates
/// - Shows location name as headline
/// - Displays latitude and longitude with icons
struct LocationRowView : View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text (location.name)
                .font(.headline)
            
            HStack {
                Label(
                    "Lat: \(String(format: "%.4f", location.latitude))",
                    systemImage: "location"
                )
                .font(.caption)
                .foregroundColor(.secondary)
                
                Spacer ()
                
                Label(
                    "Lon: \(String(format: "%.4f", location.latitude))",
                    systemImage: "location.fill"
                )
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
