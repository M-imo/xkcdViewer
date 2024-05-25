//
//  ComicsViewController.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//


import SwiftUI
import UIKit

struct ComicDetailView: View {
    @ObservedObject var viewModel: ComicViewModel
    let comic: Comic

    @State private var isFavorited: Bool // Tracks if the comic is favorited

    // Initializer to set up the view with the ViewModel and comic
    init(viewModel: ComicViewModel, comic: Comic) {
        self.viewModel = viewModel
        self.comic = comic
        self._isFavorited = State(initialValue: viewModel.isFavorite(comic)) // Set the initial favorite state
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Comic image
                AsyncImage(url: URL(string: comic.img)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(contentMode: .fit)
                .background(Color(hex: "#FFEFEF").opacity(0.1))
                .cornerRadius(10)

                // Comic title
                Text(comic.title)
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "#5E1675")) // Updated colors
                    .padding(.top)

                // Comic alt text
                Text(comic.alt)
                    .font(.body)
                    .foregroundColor(Color.gray)

                // Comic explanation
                if let explanation = comic.explanation {
                    Text("Explanation")
                        .font(.title2)
                        .foregroundColor(Color(hex: "#5E1675")) // Updated colors
                        .padding(.top)

                    Text(explanation)
                        .font(.body)
                        .foregroundColor(Color.gray)
                } else {
                    Text("No explanation available")
                        .font(.body)
                        .foregroundColor(Color.gray)
                }

                // Favorite button
                Button(action: {
                    viewModel.toggleFavorite(comic: comic)
                    isFavorited.toggle()
                }) {
                    Text(isFavorited ? "Favorited" : "Favorite")
                }
                .padding()
                .background(Color(hex: isFavorited ? "#D988B9" : "#B0578D")) // Updated colors
                .foregroundColor(.white)
                .cornerRadius(10)

                // Share button
                Button(action: {
                    shareComic()
                }) {
                    Text("Share")
                }
                .padding()
                .background(Color(hex: "#FACBEA")) // Updated colors
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle(comic.title)
        .background(Color(hex: "#F6F5F2"))
    }

    // Method to share the comic
    private func shareComic() {
        let url = URL(string: comic.img)!
        let activityController = UIActivityViewController(activityItems: [comic.title, url], applicationActivities: nil)

        // Show the share sheet
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}
