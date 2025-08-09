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
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
            BarcodeView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Barcode")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            WeightInputView()
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Weight")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct appPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
