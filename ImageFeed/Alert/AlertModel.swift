//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 20.02.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let error: ProblemType?
    let completion: ((ProblemType?) -> Void)?
}
