//
//  DetailScreen.swift
//  WatchModeApp
//
//  Created by Nishit Vats on 04/02/25.
//

import SwiftUI


struct DetailView: View {
    let title: TitleModel
    @StateObject private var viewModel = DetailViewModel()
    var body: some View {
        ZStack{
            if viewModel.isLoading {
                DetailViewSkeletonView()
            }else if viewModel.detail != nil{
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Poster Image
                        if let posterURL = viewModel.detail?.poster {
                            AsyncImage(url: URL(string: posterURL)) { image in
                                image.resizable()
                                    .scaledToFit()
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 300)
                            }
                            .frame(maxWidth: .infinity,maxHeight: 300)
                            .cornerRadius(10)
                            
                        }

                        // Title & Year
                        Text(viewModel.detail?.title ?? title.title)
                            .font(.title)
                            .bold()

                        Text("Release Year: \(viewModel.detail?.year ?? title.year ?? 0)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("⭐\(viewModel.detail?.userRating?.description ?? "N/A")")
                                .font(.headline)
                                .foregroundColor(.yellow)
                            
                            Spacer()
                            
                            if let genres = viewModel.detail?.genreNames {
                                ForEach(genres,id:\.self){ genre in
                                    Text("\(genre)")
                                        .scaledToFit()
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        
                                }
                            }
                        }

                        Divider()
                        Text("Overview")
                            .font(.headline)
                        
                        Text(viewModel.detail?.plotOverview ?? "No description available.")
                            .font(.body)

                        Divider()
                        if let sources = viewModel.detail?.sources, !sources.isEmpty {
                            Text("Available On")
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(sources, id: \.id) { source in
                                        VStack {
                                            if let logo = source.logo100px {
                                                AsyncImage(url: URL(string: logo)) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.gray.opacity(0.3))
                                                }
                                                .frame(width: 60, height: 60)
                                            }
                                            
                                            Text(source.name)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                        }
                                        .padding(5)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }else if let errorMessage = viewModel.errorMessage{
                VStack{
                    ContentUnavailableView(
                        "No Internet Connection",
                        systemImage: "wifi.exclamationmark",
                        description: Text("\(errorMessage)")
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchDetail(for: title.id)
        }
    }
}

struct DetailViewSkeletonView:View {
    @State private var isAnimating = false
    var body: some View {
        ScrollView{
            VStack{
                RoundedRectangle(cornerRadius: 10).fill(shimmerGradient)
                    .frame(height:300)
                HStack{
                    RoundedRectangle(cornerRadius: 10).fill(shimmerGradient)
                        .frame(height:50)
                    Spacer()
                }
               
                HStack{
                    RoundedRectangle(cornerRadius: 10).fill(shimmerGradient)
                        .frame(width:150,height:25)
                    Spacer()
                    RoundedRectangle(cornerRadius: 10).fill(shimmerGradient)
                        .frame(width:100,height:25)
                }
                HStack{
                    RoundedRectangle(cornerRadius: 10).fill(shimmerGradient)
                        .frame(width:100,height:18)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 10).fill(shimmerGradient)
                    .frame(height:300)
            }.padding(.horizontal)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        isAnimating.toggle()
                    }
                }
        }
    }
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


//#Preview {
//    DetailView()
//}
