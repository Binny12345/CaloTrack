//
//  BarcodeView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 9/8/2025.
//

import SwiftUI
/// BarcodeView letsr the user to scan the barcode of a food item in order to log it
struct BarcodeView: View {
    
    @State private var scannedBarcode: String = ""
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationView {
            VStack {
                // Camera screen
                ScannerView(scannedBarcode: $scannedBarcode, alertItem: $alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer()
                    .frame(height: 100)
                
                Label("Scan Barcode Above", systemImage: "barcode.viewfinder")
                    .font(.title)
                    .padding()
                
                Text(scannedBarcode.isEmpty ? "Not Yet Scanned" : "Search")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $alertItem) { alertItem in
                // Displays alert using helper structs and error alerts from BarcodeViewModel
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: alertItem.dismissButton
                )
            }
        }
    }
}

#Preview {
    BarcodeView()
}
