//
//  ContentView.swift
//  WatchModeApp
//
//  Created by Nishit Vats on 03/02/25.
//

import SwiftUI



struct ContentView: View {
    @StateObject var vm = TitleViewModel()
    @State private var selectedCategory: category = .both

    var body: some View {
        NavigationView {
            VStack {
                // Picker for category selection
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(category.allCases, id: \.self) { cat in
                        Text(cat.rawValue.capitalized).tag(cat)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .bold()
                        .padding()
                } else if vm.isLoading {
                    ScrollView{
                        ForEach(0..<15, id: \.self) { _ in
                            TitleRowSkeletonView()
                        }.padding()
                    }
                } else {
                    List(vm.titles) { title in
                        NavigationLink {
                            DetailView(title: title)
                        } label: {
                            TitleRowView(title: title)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        vm.fetchTitles()
                    }
                }
            }
            .navigationTitle("Movies & TV Shows")
            .onAppear {
                vm.fetchTitles()
            }
            .onChange(of: selectedCategory) { value in
                vm.category = value
                vm.fetchTitles()
            }
        }
    }
}

// MARK: - Title Row View
struct TitleRowView: View {
    let title: TitleModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(title.title)
                    .font(.headline)
                    .bold()
                Text("Year: \(title.year ?? 0)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if let rating = title.userRating {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(rating, specifier: "%.1f") / 10")
                            .font(.subheadline)
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}



struct TitleRowSkeletonView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 16) {
            // Placeholder for image
            RoundedRectangle(cornerRadius: 8)
                .fill(shimmerGradient)
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                // Placeholder for title text
                RoundedRectangle(cornerRadius: 4)
                    .fill(shimmerGradient)
                    .frame(height: 20)

                // Placeholder for year text
                RoundedRectangle(cornerRadius: 4)
                    .fill(shimmerGradient)
                    .frame(width: 80, height: 16)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating.toggle()
            }
        }
    }

    // Shimmer Gradient
    private var shimmerGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.gray.opacity(0.1),
                Color.gray.opacity(0.01),
                Color.gray.opacity(0.1)
            ]),
            startPoint: isAnimating ? .leading : .trailing, endPoint: .zero
        )
    }
}



#Preview {
    ContentView()
}
