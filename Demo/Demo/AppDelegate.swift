//
//  AppDelegate.swift
//  Demo
//
//  Created by link on 2022/5/12.
//

import UIKit
import ParticleNetwork

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // init ParticleNetwork
        let projectUuid: String = "your project uuid"
        let projectClientKey: String = "your project client key"
        let projectAppUuid: String = "your project app uuid"
        let chainName = ChainName.solana
        let chainEnv = ChainEnvironment.devnet
        let devEnv = DevEnvironment.debug
        
        ParticleNetwork.initialize(projectUuid: projectUuid,
                                   projectClientKey: projectClientKey,
                                   projectAppUuid: projectAppUuid,
                                   chainName: chainName,
                                   chainEnv: chainEnv,
                                   devEnv: devEnv)
        
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ParticleNetwork.handleUrl(url)
    }


}


