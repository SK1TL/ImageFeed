//
//  Date+Extension.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 02.03.2024.
//

import Foundation

private let dateTimePhotoFormatter = ISO8601DateFormatter()

extension Date {
    static func dateFromString(_ date: String) -> Date? {
        dateTimePhotoFormatter.date(from: date)
    }
}
