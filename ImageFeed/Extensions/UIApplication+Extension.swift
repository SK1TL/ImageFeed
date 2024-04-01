//
//  UIApplication+Extension.swift
//  ImageFeed
//
//  Created by Артур Гайфуллин on 01.04.2024.
//

import UIKit

extension UIApplication {
    public static var isRunningTest: Bool {
        ProcessInfo().arguments.contains("testMode")
    }
}
