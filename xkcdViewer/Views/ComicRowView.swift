//
//  ComicCollectionViewCell.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//


import SwiftUI

struct ComicRowView: View {
    let comic: Comic

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: comic.img)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .aspectRatio(contentMode: .fit)
            .background(Color(hex: "#FFEFEF").opacity(0.1))
            .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(comic.title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "#5E1675")) // Updated colors
                Text(comic.alt)
                    .font(.subheadline)
                    .foregroundColor(Color.gray) // Neutral color for subtitle
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 5)
    }
}


