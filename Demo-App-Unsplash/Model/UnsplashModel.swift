//
//  UnsplashModel.swift
//  Demo-App-Unsplash
//
//  Created by Rajesh Jha on 18/04/24.
//

import Foundation


struct ImageInfo: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let regular: String
    var regularUrl: URL {
        return URL(string: regular)!
    }
}
