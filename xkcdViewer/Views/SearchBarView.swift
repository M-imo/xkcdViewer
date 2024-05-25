//
//  SearchBarView.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//


import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    // Callback when the search button is clicked
    var onSearchButtonClicked: () -> Void
    
    // Coordinator class to handle UISearchBarDelegate methods
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var onSearchButtonClicked: () -> Void

        // Initializes the coordinator with the binding text and search button callback
        init(text: Binding<String>, onSearchButtonClicked: @escaping () -> Void) {
            _text = text
            self.onSearchButtonClicked = onSearchButtonClicked 
            
        }
        // Called when the search text changes
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onSearchButtonClicked() // Triggers the search callback
        }
        // Called when the search button is clicked
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onSearchButtonClicked() // Triggers the search callback
        }
    }
    // Creates an instance of the coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onSearchButtonClicked: onSearchButtonClicked)
    }
    // Creates the UISearchBar and sets the coordinator as its delegate
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    // Updates the UISearchBar when the SwiftUI state changes
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
