//
//  FileManagement.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/16/21.
//

import Foundation

class FileManagement {
    
    static var getDocumentsDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    static func writeToDisk(data: Data, fileName: String) -> (isSuccessful: Bool, url: URL?) {
        guard let url = getDocumentsDirectory?.appendingPathComponent(fileName)
            else { return (false, nil) }
        
        do {
            print(url)
            
            try data.write(to: url)
            return (true, url)
        } catch {
            return (false, nil)
        }
    }
    
    static func readFromDisk(fileName: String) -> Data? {
        guard let url = getDocumentsDirectory?.appendingPathComponent(fileName) else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
    
    static func read(url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
    
    static func fileExist(fileName: String) -> Bool {
        guard let url = getDocumentsDirectory?.appendingPathComponent(fileName) else {
            return false
        }
        
        return FileManager.default.fileExists(atPath: url.path)
    }
}
