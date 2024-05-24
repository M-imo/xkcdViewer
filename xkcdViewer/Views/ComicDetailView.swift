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

    @State private var isFavorited: Bool

    init(viewModel: ComicViewModel, comic: Comic) {
        self.viewModel = viewModel
        self.comic = comic
        self._isFavorited = State(initialValue: viewModel.isFavorite(comic))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display comic image
                AsyncImage(url: URL(string: comic.img)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(contentMode: .fit)
                .background(Color(hex: "#FFEFEF").opacity(0.1))
                .cornerRadius(10)

                // Display comic title
                Text(comic.title)
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "#F3D0D7"))
                    .padding(.top)

                // Display comic alt text
                Text(comic.alt)
                    .font(.body)
                    .foregroundColor(Color.gray)

                // Display comic explanation
                if let explanation = comic.explanation {
                    Text("Explanation")
                        .font(.title2)
                        .foregroundColor(Color(hex: "#F3D0D7"))
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
                .background(isFavorited ? Color.gray : Color(hex: "#FFEFEF"))
                .foregroundColor(.white)
                .cornerRadius(10)

                // Share button
                Button(action: {
                    shareComic()
                }) {
                    Text("Share")
                }
                .padding()
                .background(Color(hex: "#F3D0D7"))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle(comic.title)
        .background(Color(hex: "#F6F5F2"))
    }

    private func shareComic() {
        let url = URL(string: comic.img)!
        let activityController = UIActivityViewController(activityItems: [comic.title, url], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}
