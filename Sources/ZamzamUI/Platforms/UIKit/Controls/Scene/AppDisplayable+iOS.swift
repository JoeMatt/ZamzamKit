//
//  AppDisplayable+iOS.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-07-19.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

extension AppDisplayable where Self: UIViewController {
    
    /// Display a native alert controller modally.
    ///
    /// - Parameter error: The error details to present.
    public func display(error: AppModels.Error) {
        // Force in next runloop via main queue since view hierachy may not be loaded yet
        DispatchQueue.main.async { [weak self] in
            self?.endRefreshing()
            self?.present(alert: error.title, message: error.message)
        }
    }
}