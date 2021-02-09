//
//  SearchResponseModel.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import Foundation

struct SearchResponseModel: Codable {
    let Search: [SearchItemModel]
    let totalResults: String
}

struct SearchItemModel: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let `Type`: String
    let Poster: String
}
