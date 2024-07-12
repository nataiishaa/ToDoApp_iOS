//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 20.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

@main
struct ToDoApp: App {

	init() {
		DDLog.add(DDOSLogger.sharedInstance)
		let fileLogger: DDFileLogger = DDFileLogger()
		fileLogger.rollingFrequency = 60 * 60 * 24
		fileLogger.logFileManager.maximumNumberOfLogFiles = 7
		DDLog.add(fileLogger)
	}

    var body: some Scene {
        WindowGroup {
            TodoItemList()
        }
    }
}
