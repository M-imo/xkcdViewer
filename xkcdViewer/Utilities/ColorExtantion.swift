//
//  ColorExtantion.swift
//  xkcdViewer
//
//  Created by Miriam Moe on 24/05/2024.
//

import SwiftUI


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = scanner.string.index(after: scanner.string.startIndex) 

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

// Color palette retrieved from: https://colorhunt.co/palette/f6f5f2f0ebe3f3d0d7ffefef
