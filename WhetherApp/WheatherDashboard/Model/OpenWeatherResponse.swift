//
//  OpenWeatherResponse.swift
//  WhetherApp
//
//  Created by MAC on 11/9/2025.
//

import Foundation
import UIKit

struct OpenWeatherResponseDTO: Decodable {
    let name: String
    let main: WhetherMainResponseDTO
    let weather: [WheatherDetailsResponseDTO]
}


struct WhetherMainResponseDTO: Decodable {
    let temp: Double
}

struct WheatherDetailsResponseDTO: Decodable {
    let main: String
    let icon: String
    
    var iconResource: ImageResource {
        switch main.lowercased() {
        case "clear": return .icSunnyWhether
        case "clouds": return .icFoggyWhether
        case "rain": return .icFoggyWhether
        case "fog": return .icFoggyWhether
        default: return .icSunnyWhether
        }
    }
}
