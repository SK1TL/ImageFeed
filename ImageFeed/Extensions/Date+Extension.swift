//
//  Date+Extension.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 02.03.2024.
//

import Foundation

private let dateTimePhotoFormatter = ISO8601DateFormatter()

extension Date {
    static func dateFromString(_ date: String?) -> Date? {
        guard let date else { return nil }
        return dateTimePhotoFormatter.date(from: date)
    }
}
