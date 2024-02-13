//
//  NetworkErrors.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 09.02.2024.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case httpStatusCode(Int)
    case invalidDecoding
}
