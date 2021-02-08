//
//  LError.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import Foundation

enum LError: String, Error {

    case invalidURL = "The requested URL is invalid."
    case invalidData = "The data received from service is invalid. Please try again."
    case parseError = "Unable to parse JSON."
    case invalidResponse = "The response received from service is invalid. Please try again."
    case unableToComplete = "Unable to get data from service. Please check your internet connection."
    
}
