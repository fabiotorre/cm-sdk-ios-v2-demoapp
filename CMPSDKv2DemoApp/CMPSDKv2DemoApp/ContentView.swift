//
//  ContentView 2.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 23/10/24.
//


import SwiftUI
import CmpSdk

struct ContentView: View {
    @State private var isConsentInitialized = false
    
    var body: some View {
        if isConsentInitialized {
            HomeView()
        } else {
            InitializationView(onConsentInitialized: { isConsentInitialized = true })
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            ConsentViewControllerRepresentable(onConsentInitialized: nil)
                .navigationBarHidden(true)
        }
    }
}

struct InitializationView: View {
    let onConsentInitialized: () -> Void
    
    var body: some View {
        ConsentViewControllerRepresentable(onConsentInitialized: onConsentInitialized)
            .overlay(
                Text("Initializing Consent Manager...")
                    .font(.headline)
            )
    }
}