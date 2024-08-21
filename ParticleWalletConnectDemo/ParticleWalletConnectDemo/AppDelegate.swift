//
//  AppDelegate.swift
//  ParticleWalletConnectDemo
//
//  Created by link on 2022/11/7.
//

import ParticleAuthService
import ParticleNetworkBase
import ParticleWalletConnect
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // initialize Particle network
        ParticleNetwork.initialize(config: .init(chainInfo: .ethereum, devEnv: .debug))

        // initialize Particle wallet connect
        // pass your wallet information
        ParticleWalletConnect.initialize(
            .init(name: "Particle Wallet Connect Demo",
                  icon: URL(string: "https://connect.particle.network/icons/512.png")!,
                  url: URL(string: "https://github.com/Particle-Network/particle-ios")!,
                  description: "This is demo for Particle Wallet Connect SDK", redirectUniversalLink: nil))

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ParticleAuthService.handleUrl(url)
    }
}
