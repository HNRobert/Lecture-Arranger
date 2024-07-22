//
//  DataProcessor.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/15.
//

import Foundation

class DataStorage {
    static let shared = DataStorage()
    
    private var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveData(data: LA_Data, withName name: String) {
        let fileURL = documentsDirectory.appendingPathComponent("\(name).json")
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func readData(withName name: String) -> LA_Data? {
        let fileURL = documentsDirectory.appendingPathComponent("\(name).json")
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(LA_Data.self, from: data)
            return decodedData
        } catch {
            print("Error reading data: \(error)")
            return nil
        }
    }
    
    func deleteData(withName name: String) {
        let fileURL = documentsDirectory.appendingPathComponent("\(name).json")
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
    func listAllSaves() -> [String] {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: [.contentModificationDateKey], options: [])
            let sortedFiles = files.filter { $0.pathExtension == "json" }.sorted { firstFile, secondFile in
                let firstFileModificationDate = (try? firstFile.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date.distantPast
                let secondFileModificationDate = (try? secondFile.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date.distantPast
                return firstFileModificationDate > secondFileModificationDate
            }
            return sortedFiles.map { $0.deletingPathExtension().lastPathComponent }
        } catch {
            print("Error listing files: \(error)")
            return []
        }
    }

}

func saveLAData(newConfigName: String, cfgAttempts: inout Int, LAData: LA_Data) -> Bool? {
    if newConfigName == "" {
        cfgAttempts += 1
        return nil
    }
    DataStorage.shared.saveData(data: LAData, withName: newConfigName)
    return true
}
