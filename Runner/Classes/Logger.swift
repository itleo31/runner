//
//  Logger.swift
//  Runner
//
//  Created by Khanh Pham on 3/23/17.
//  Copyright © 2017 Khanh Pham. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Logger {
    init() {
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    func logDebug(_ message: String) {
        DDLogDebug(message)
    }
    
    func logInfo(_ message: String) {
        DDLogInfo(message)
    }
    
    func logWarn(_ message: String) {
        DDLogWarn(message)
    }
    
    func logError(_ message: String) {
        DDLogError(message)
    }
}
