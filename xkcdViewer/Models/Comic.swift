//
//  Comic.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//

import Foundation

// Represents a comic
struct Comic: Codable, Identifiable {
    var id: Int { num }
    let num: Int
    let title: String
    let img: String
    let alt: String
    let transcript: String
    var explanation: String? 
}


