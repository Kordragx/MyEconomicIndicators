//
//  MemoryCache.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import Foundation


final class MemoryCache<Key: Hashable, Value> {
    private var cache: [Key: (expiresAt: Date, value: Value)] = [:]
    private let duration: TimeInterval

    init(duration: TimeInterval = 6000) {
        self.duration = duration
    }

    func get(_ key: Key) -> Value? {
        guard let entry = cache[key], Date() < entry.expiresAt else {
            cache.removeValue(forKey: key)
            return nil
        }
        return entry.value
    }

    func set(_ key: Key, value: Value) {
        cache[key] = (Date().addingTimeInterval(duration), value)
    }

    func clear() {
        cache.removeAll()
    }
}
