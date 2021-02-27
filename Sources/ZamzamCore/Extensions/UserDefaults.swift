//
//  UserDefaults.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-01-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import Foundation.NSUserDefaults

public extension UserDefaults {
    /// Returns a boolean value indicating whether the defaults contains the given key.
    func contains(_ key: String) -> Bool {
        object(forKey: key) != nil
    }

    /// Removes all key-value pairs in the domains in the search list.
    func removeAll() {
        dictionaryRepresentation().keys.forEach(removeObject)
    }
}

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension UserDefaults {
    var publisher: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification, object: self)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
#endif
