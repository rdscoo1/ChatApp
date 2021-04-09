//
//  Logger.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/18/21.
//

import UIKit

enum LogType: String {
    case application = "Application"
    case viewController = "ViewController"
}

final class Logger {
    
    private static var isActivated: Bool {
        return Bundle.main.object(forInfoDictionaryKey: "LoggerActivated") as? Bool ?? false
    }
    
    static func defineState(of source: LogType, oldState: String, newState: String, method: String) {
        guard isActivated else { return }
        
        print("\(source.rawValue) moved from \(oldState) to \(newState): \(method)")
    }

    public static func printLogFrom(_ source: String, _ message: String) {
        guard isActivated else { return }

        print("[\(source)]: \(message)")
    }
}
