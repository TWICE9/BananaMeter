//
//  SettingsView.swift
//  BananaMeter
//
//  Created on 29/12/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    // Get app version from Bundle
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image("bananalogo") // Use the logo if available, otherwise just text
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text("BananaMeter")
                                .font(.headline)
                            Text("Measure with Bananas")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Legal")) {
                    // Link to GitHub Privacy Policy
                    Link("Privacy Policy", destination: URL(string: "https://github.com/TWICE9/BananaMeter/blob/main/PRIVACY_POLICY.md")!)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
