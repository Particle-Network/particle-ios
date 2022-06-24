//
//  AppDelegate.swift
//  Demo
//
//  Created by link on 2022/5/12.
//

import ParticleAuthService
import ParticleNetworkBase
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // init ParticleNetwork
        // select a network
        let chainName = ParticleNetwork.ChainName.ethereum(.mainnet)
        // and also and you can custom your evm network
//        let chainName = ParticleNetwork.ChainName.customEvmNetwork(fullName: "Ethereum", network: "kovan", chainId: 42, explorePath: "https://kovan.etherscan.io/", symbol: "ETH")

//        let chainName = ParticleNetwork.ChainName.customEvmNetwork(fullName: "Ethereum", network: "rinkeby", chainId: 4, explorePath: "https://rinkeby.etherscan.io/", symbol: "ETH")

        let devEnv = ParticleNetwork.DevEnvironment.debug
        let config = ParticleNetworkConfiguration(chainName: chainName, devEnv: devEnv)
        ParticleNetwork.initialize(config: config)

        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ParticleAuthService.handleUrl(url)
    }
}
