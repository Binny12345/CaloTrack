//
//  PersonalDetailsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 4/10/2025.
//
import SwiftUI
import FirebaseAuth

/// Displays the user's stored personal information, body stats and nutrition goals
struct PersonalDetailsView: View {
    
    // Observed object to access current user's details
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Header card
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.green)
                        .padding(.bottom, 4)
                    
                    // User's name and age, provides default options
                    Text(userProfileViewModel.currentUser?.name ?? "Unknown User")
                        .font(.title2.bold())
                    
                    Text(userProfileViewModel.currentUser?.gender ?? "N/A")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .shadow(radius: 3)
                .padding(.horizontal)
                
                // Body Stats
                InfoSection(title: "Body Stats") {
                    InfoRow(label: "Weight", value: "\(userProfileViewModel.currentUser?.weight ?? 0) kg")
                    InfoRow(label: "Height", value: "\(userProfileViewModel.currentUser?.height ?? 0) cm")
                }
                
                // Nutrition Goals
                InfoSection(title: "Nutrition Goals") {
                    InfoRow(label: "Calorie Budget", value: "\(Int(userProfileViewModel.currentUser?.calorieBudget ?? 0)) kcal")
                    InfoRow(label: "Protein Goal", value: "\(userProfileViewModel.currentUser?.proteinGoal ?? 0) g")
                    InfoRow(label: "Carb Goal", value: "\(userProfileViewModel.currentUser?.carbGoal ?? 0) g")
                    InfoRow(label: "Fat Goal", value: "\(userProfileViewModel.currentUser?.fatGoal ?? 0) g")
                }
                
                // Weight Goal
                InfoSection(title: "Weight Goal") {
                    InfoRow(label: "Target Weight", value: "\(userProfileViewModel.currentUser?.weightGoal ?? 0) kg")
                }
                
                Spacer(minLength: 30)
            }
            .padding(.top)
        }
        .background(Color.black.ignoresSafeArea())
        .scrollIndicators(.hidden)
        .navigationTitle("Personal Details")
        .preferredColorScheme(.dark)
    }
}
/// A reuseable card-style container that groups related rows (InfoRow)
struct InfoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content  // Content closure containing InfoRow elements
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.green)
            
            VStack(spacing: 10) {
                content
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

/// Displays a single piece of data within the InfoSection
struct InfoRow: View {
    // Passed-in information
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.green)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
}

#Preview {
    PersonalDetailsView(userProfileViewModel: UserProfileViewModel())
}
