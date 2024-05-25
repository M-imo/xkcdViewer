//
//  ComicDetailViewController.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//



import SwiftUI

struct ComicsListView: View {
    @ObservedObject var viewModel = ComicViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                SearchBar(text: $searchText, onSearchButtonClicked: {
                    viewModel.searchComics(by: searchText)
                })
                .padding(.horizontal)
                .background(Color(hex: "#F6F5F2")) // Light background for search bar

                // List of comics
                List {
                    ForEach(viewModel.filteredComics) { comic in
                        NavigationLink(destination: ComicDetailView(viewModel: viewModel, comic: comic)) {
                            ComicRowView(comic: comic)
                        }
                    }
                    
                    // Load more button at the end of the list
                    if !viewModel.filteredComics.isEmpty {
                        Button(action: {
                            viewModel.fetchComics()
                        }) {
                            HStack {
                                Spacer()
                                Text("Load More")
                                Spacer()
                            }
                        }
                    }
                }
                .navigationBarTitle("Comics", displayMode: .inline)
                .foregroundColor(Color(hex: "#D895DA")) // Updated color
            }
            .background(Color(hex: "#F6F5F2")) // Light background for main view
        }
    }
}


#Preview {
  ComicsListView()
}
