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
    @State private var product: FoodSearchResult? = nil
    
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    @State private var item: FoodItem? = nil
    
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
                
                // Displays "Search" button for barcode when scanned
                if !scannedBarcode.isEmpty {
                    Button {
                        OpenFoodFactsAPI.shared.fetchProduct(by: scannedBarcode) { result in
                            DispatchQueue.main.async {
                                self.product = result
                            }
                            item = FoodItem(
                                name: result?.name ?? "",
                                calories: result?.calories ?? 0,
                                protein: result?.protein ?? 0,
                                carbs: result?.carbs ?? 0,
                                fats: result?.fats ?? 0,
                                mealType: result?.mealType ?? "Snack",
                                date: result?.date ?? Date()
                            )
                        }
                        
                    } label: {
                        Text("Search")
                    }
                    .frame(width: 100, height: 40)
                    .background(.green)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }
            }
            // Displays FoodDetailView (Same as SearchView) but now with barcode food item
            .sheet(item: $item) { item in
                FoodDetailView(
                    foodItem: item,
                    dailyLogViewModel: dailyLogViewModel
                )
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

