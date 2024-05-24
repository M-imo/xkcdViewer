//
//  NetworkManager.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//

import Foundation
import SwiftSoup

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

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                var comic = try JSONDecoder().decode(Comic.self, from: data)
                self.fetchExplanation(for: comic) { result in
                    switch result {
                    case .success(let explanation):
                        comic.explanation = explanation
                        completion(.success(comic))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Fetches the explanation for a given comic
    private func fetchExplanation(for comic: Comic, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://www.explainxkcd.com/wiki/index.php/\(comic.num)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            if let htmlString = String(data: data, encoding: .utf8),
               let explanation = self.parseExplanation(from: htmlString) {
                completion(.success(explanation))
            } else {
                completion(.failure(NetworkError.parsingFailed))
            }
        }.resume()
    }
    
    // Parses the explanation HTML and extracts plain text
    private func parseExplanation(from html: String) -> String? {
        do {
            let document = try SwiftSoup.parse(html)
            // Assume the main content is within the first <p> tag, but you can adjust the selector
            if let explanationElement = try document.select("div.mw-parser-output > p").first() {
                return try explanationElement.text()
            }
        } catch {
            print("Error parsing HTML with SwiftSoup: \(error)")
        }
        return nil
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case parsingFailed
}
