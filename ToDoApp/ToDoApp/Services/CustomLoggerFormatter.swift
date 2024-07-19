//
//  CustomLoggerFormatter.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 08.07.2024.
//

import CocoaLumberjack

final class CustomLoggerFormatter: NSObject, DDLogFormatter {
    private var dateTransformer: DateFormatter    
    override init() {
        dateTransformer = DateFormatter()
        dateTransformer.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        super.init()
    }
    func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = dateTransformer.string(from: logMessage.timestamp)
        let severity = determineLogLevel(logMessage.flag)
        
        let logText = "\(timestamp) [\(severity)] " +
        "[\(logMessage.fileName):\(logMessage.line)] \(logMessage.message)"
        return logText
    }
    private func determineLogLevel(_ flag: DDLogFlag) -> String {
        switch flag {
        case .error: return "ERROR"
        case .warning: return "WARNING"
        case .info: return "INFO"
        case .debug: return "DEBUG"
        case .verbose: return "VERBOSE"
        default: return "UNKNOWN"
        }
    }
}
