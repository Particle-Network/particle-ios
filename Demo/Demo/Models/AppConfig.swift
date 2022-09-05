//
//  AppConfig.swift
//  Demo
//
//  Created by link on 2022/9/2.
//  Copyright © 2022 ParticleNetwork. All rights reserved.
//

import Foundation

public class AppConfig: NSObject {
    public static var appName: String = {
        Bundle.main.infoDictionary!["APP_NAME"] as? String ?? ""
    }()

    public static var channel: String = {
        Bundle.main.infoDictionary!["CHANNEL"] as? String ?? ""
    }()

    public static var package_id: String = {
        Bundle.main.infoDictionary!["PACKAGE_ID"] as? String ?? ""
    }()

    public static var UmengAppKey: String = {
        Bundle.main.infoDictionary!["UMENG_APP_KEY"] as? String ?? ""
    }()

    public static var schemeName: String = {
        Bundle.main.infoDictionary!["SCHEME_NAME"] as? String ?? ""
    }()
    
    public static var privacyURL: String = {
        Bundle.main.infoDictionary!["PRIVACY_URL"] as? String ?? ""
    }()
    
    public static var tosURL: String = {
        Bundle.main.infoDictionary!["TOS_URL"] as? String ?? ""
    }()

   
  
    
   

   
}
