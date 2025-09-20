//
//  ScannerView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 20/9/2025.
//

import Foundation
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedBarcode: String
    @Binding var alertItem: AlertItem?
    
    func makeUIViewController(context: Context) -> BarcodeViewController {
        BarcodeViewController(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: BarcodeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    final class Coordinator: NSObject, BarcodeViewControllerDelegate {
        
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            scannerView.scannedBarcode = barcode
        }
        
        func didSurface(error: CameraError) {
            switch error {
            case .invalidDeviceInput:
                scannerView.alertItem = AlertContext.invalidDeviceInput
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScannedValue
            }
        }
    }
}
