//
//  AppDelegate.swift
//  ParticleAuthDemo
//
//  Created by link on 2022/11/3.
//

import UIKit
import ParticleAuthService
import ParticleNetworkBase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Particle Network
        ParticleNetwork.initialize(config: .init(chainInfo: .ethereum(.mainnet), devEnv: .debug))
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ParticleAuthService.handleUrl(url)
    }

}

