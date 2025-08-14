//
//  ContentView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 7/8/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            NavigationStack {
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Dashboard")
                        }
                    // DEBUG: Checking Amount of logs within Data.geojson
                        .onAppear {
                            let foods = DataManager.loadFoodData()
                            print("Loaded \(foods.count) foods")
                        }
                        .tag(0)
                    
                    BarcodeView()
                        .tabItem {
                            Image(systemName: "barcode.viewfinder")
                            Text("Barcode")
                        }
                        .tag(1)
                    
                    SearchView()
                        .tabItem {
                            Image(systemName: "plus.circle")
                            .symbolRenderingMode(.palette)
                            .background(.green)
                            .shadow(radius: 5)
                            .symbolEffect(.bounce.up.byLayer, options: .nonRepeating)
                        }
                        .tag(2)
                    
                    WeightInputView()
                        .tabItem {
                            Image(systemName: "plus")
                            Text("Add Weight")
                        }
                        .tag(3)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(4)
                    
                }
            }
        }
    }
}

struct appPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
