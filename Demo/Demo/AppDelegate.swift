//
//  AppDelegate.swift
//  Demo
//
//  Created by link on 2022/5/12.
//

import UIKit
import ParticleNetworkBase
import ParticleAuthService

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // init ParticleNetwork
        let config = ParticleNetworkConfiguration(chainName: .ethereum(.kovan), devEnv: .debug)
        ParticleNetwork.initialize(config: config)
        
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ParticleAuthService.handleUrl(url)
    }


}


