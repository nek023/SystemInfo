//
//  SystemInfo.swift
//  SystemInfo
//
//  Created by Katsuma Tanaka on 2015/10/15.
//  Copyright © 2015 Katsuma Tanaka. All rights reserved.
//

import UIKit

public class SystemInfo {
    
    // MARK: - Properties
    
    public let modelID: String?
    public let modelName: String?
    public let systemName: String
    public let systemVersion: String
    public let applicationName: String?
    public let applicationVersion: String?
    
   
    // MARK: - Initializers
    
    public class func currentSystemInfo() -> SystemInfo {
        // Get model ID
        var mib: [Int32] = [CTL_HW, HW_MACHINE]
        var len: Int = 0
        sysctl(&mib, u_int(mib.count), nil, &len, nil, 0)
        
        let machine = UnsafeMutablePointer<CChar>.alloc(len)
        sysctl(&mib, u_int(mib.count), machine, &len, nil, 0)
        let modelID = String(CString: machine, encoding: NSASCIIStringEncoding)
        machine.dealloc(len)
        
        // Get model name
        var modelName: String?
        if modelID != nil {
            let bundle = NSBundle(forClass: SystemInfo.self)
            if let filePath = bundle.pathForResource("ModelNames", ofType: "plist"),
                let modelNames = NSDictionary(contentsOfFile: filePath) as? [String: String] {
                    modelName = modelNames[modelID!]
            }
        }
        
        // Get system info
        let currentDevice = UIDevice.currentDevice()
        let systemName = currentDevice.systemName
        let systemVersion = currentDevice.systemVersion
        
        // Get application info
        let mainBundle = NSBundle.mainBundle()
        let applicationName = mainBundle.objectForInfoDictionaryKey("CFBundleName") as? String
        let applicationVersion = mainBundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        
        // Create system info object
        let systemInfo = SystemInfo(
            modelID: modelID,
            modelName: modelName,
            systemName: systemName,
            systemVersion: systemVersion,
            applicationName: applicationName,
            applicationVersion: applicationVersion
        )
        
        return systemInfo
    }
    
    private init(modelID: String?, modelName: String?, systemName: String, systemVersion: String, applicationName: String?, applicationVersion: String?) {
        self.modelID = modelID
        self.modelName = modelName
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.applicationName = applicationName
        self.applicationVersion = applicationVersion
    }
    
}
