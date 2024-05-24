//
//  ViewModel.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//




import Foundation
import Combine

class ComicViewModel: ObservableObject {
    @Published var comics: [Comic] = []
    @Published var filteredComics: [Comic] = []
    @Published var favorites: [Comic] = []
    private var currentComicNumber = 1

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadFavorites()
        fetchComics()
    }

    // Fetches a batch of comics starting from the current comic number
    func fetchComics() {
        let comicNumbers = (currentComicNumber..<currentComicNumber + 10)
        let fetchGroup = DispatchGroup()
        
        comicNumbers.forEach { number in
            fetchGroup.enter()
            NetworkManager.shared.fetchComic(comicNumber: number) { result in
                switch result {
                case .success(let comic):
                    DispatchQueue.main.async {
                        self.comics.append(comic)
                        self.filteredComics = self.comics
                    }
                case .failure(let error):
                    print("Error fetching comic: \(error)")
                }
                fetchGroup.leave()
            }
        }
        
        fetchGroup.notify(queue: .main) {
            self.currentComicNumber += 10
        }
    }

    // Searches comics by text
    func searchComics(by text: String) {
        if text.isEmpty {
            filteredComics = comics
        } else {
            filteredComics = comics.filter { $0.transcript.localizedCaseInsensitiveContains(text) }
        }
    }

    // Toggles the favorite status of a comic
    func toggleFavorite(comic: Comic) {
        if let index = favorites.firstIndex(where: { $0.num == comic.num }) {
            favorites.remove(at: index)
        } else {
            favorites.append(comic)
        }
        saveFavorites()
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }

    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([Comic].self, from: savedFavorites) {
            favorites = decoded
        }
    }
    
    // Checks if a comic is a favorite
    func isFavorite(_ comic: Comic) -> Bool {
        return favorites.contains(where: { $0.num == comic.num })
    }
}
