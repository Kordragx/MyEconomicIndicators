//
//  DiskCache.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import Foundation

final class DiskCache<Value: Codable> {
    private let folderURL: URL

    init(folderName: String = "Cache") {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.folderURL = base.appendingPathComponent(folderName)

        // Crear carpeta si no existe
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
    }

    private func fileURL(for key: String) -> URL {
        let safeKey = key.replacingOccurrences(of: "/", with: "_") // evitar caracteres inválidos
        return folderURL.appendingPathComponent("\(safeKey).json")
    }

    func save(_ value: Value, for key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: fileURL(for: key))
        } catch {
            print("DiskCache save error:", error)
        }
    }

    func load(for key: String) -> Value? {
        do {
            let data = try Data(contentsOf: fileURL(for: key))
            return try JSONDecoder().decode(Value.self, from: data)
        } catch {
            return nil
        }
    }

    func clear(for key: String) {
        try? FileManager.default.removeItem(at: fileURL(for: key))
    }

    func clearAll() {
        try? FileManager.default.removeItem(at: folderURL)
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
    }
}
