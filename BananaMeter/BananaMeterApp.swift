//
//  BananaMeterApp.swift
//  BananaMeter
//
//  Created on 29/12/2025.
//

import SwiftUI
import GoogleMobileAds

@main
struct BananaMeterApp: App {
    
    init() {
        // Initialize AdMob safely after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            MobileAds.shared.start { _ in }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
