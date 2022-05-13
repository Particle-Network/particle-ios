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
        let projectUuid: String = "c49932d1-9389-4b79-a4a2-e83d1ce13239"
        let projectClientKey: String = "cnYEof2j3C1U27qmt9OQkGeAxc5RfkNiTZlSeFrM"
        let projectAppUuid: String = "06b25f79-fc97-4301-98e6-21bce45cdd4b"
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




}


