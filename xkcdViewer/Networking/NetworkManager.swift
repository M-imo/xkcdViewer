//
//  NetworkManager.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//

import Foundation
import SwiftSoup

// Manages network requests to fetch comics and explanations
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    
    // Fetches a comic by its number
    func fetchComic(comicNumber: Int, completion: @escaping (Result<Comic, Error>) -> Void) {
        let urlString = "https://xkcd.com/\(comicNumber)/info.0.json"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        // Make network request
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Network error
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData)) // No data error
                return
            }

            do {
                var comic = try JSONDecoder().decode(Comic.self, from: data)
                // Fetch comic explanation
                self.fetchExplanation(for: comic) { result in
                    switch result {
                    case .success(let explanation):
                        comic.explanation = explanation
                        completion(.success(comic)) // Return comic with explanation
                    case .failure(let error):
                        completion(.failure(error)) // Explanation fetch error
                    }
                }
            } catch {
                completion(.failure(error)) // JSON decode error
            }
        }.resume() // Start request
    }

    // Fetches the explanation for a comic
    private func fetchExplanation(for comic: Comic, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://www.explainxkcd.com/wiki/index.php/\(comic.num)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // Make network request
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Network error
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData)) // No data error
                return
            }

            if let htmlString = String(data: data, encoding: .utf8),
               let explanation = self.parseExplanation(from: htmlString) {
                completion(.success(explanation)) // Return explanation
            } else {
                completion(.failure(NetworkError.parsingFailed)) // Parsing error
            }
        }.resume() // Start request
    }
    
    // Parses the explanation HTML and extracts plain text
    private func parseExplanation(from html: String) -> String? {
        do {
            let document = try SwiftSoup.parse(html)
            // Get text from first paragraph in specified div
            if let explanationElement = try document.select("div.mw-parser-output > p").first() {
                return try explanationElement.text()
            }
        } catch {
            print("Error parsing HTML with SwiftSoup: \(error)")
            // Return nil if parsing fails
        }
        return nil
    }
}
// Custom errors for network requests
enum NetworkError: Error {
    case invalidURL
    case noData
    case parsingFailed
}
