//
//  SearchBarView.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//


import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var onSearchButtonClicked: () -> Void

        init(text: Binding<String>, onSearchButtonClicked: @escaping () -> Void) {
            _text = text
            self.onSearchButtonClicked = onSearchButtonClicked
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onSearchButtonClicked()
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onSearchButtonClicked()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onSearchButtonClicked: onSearchButtonClicked)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
