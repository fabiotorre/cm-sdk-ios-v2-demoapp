//
//  ConsentViewControllerRepresentable.swift
//  CMPSDKv2DemoApp
//
//  Created by Fabio Torre on 23/10/24.
//


import SwiftUI

struct ConsentViewControllerRepresentable: UIViewControllerRepresentable {
    let onConsentInitialized: (() -> Void)?
    
    func makeUIViewController(context: Context) -> ConsentViewController {
        return ConsentViewController(onConsentInitialized: onConsentInitialized)
    }
    
    func updateUIViewController(_ uiViewController: ConsentViewController, context: Context) {
        // Update the view controller if needed
    }
}