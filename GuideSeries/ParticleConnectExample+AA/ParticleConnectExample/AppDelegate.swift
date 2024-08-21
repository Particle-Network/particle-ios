//
//  AppDelegate.swift
//  ParticleConnectExample
//
//  Created by link on 16/11/2023.
//

import AuthCoreAdapter
import ConnectCommon
import ConnectPhantomAdapter
import ConnectWalletConnectAdapter
import ParticleAA
import ParticleConnect
import ParticleNetworkBase
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        particleInit()

        return true
    }

    func particleInit() {
        let adapters: [ConnectAdapter] = [
            MetaMaskConnectAdapter(),
            AuthCoreAdapter(),
            PhantomConnectAdapter(),
            WalletConnectAdapter(),
            RainbowConnectAdapter(),
            BitgetConnectAdapter(),
            ImtokenConnectAdapter(),
            TrustConnectAdapter(),
            ZerionConnectAdapter(),
            MathConnectAdapter(),
            Inch1ConnectAdapter(),
            ZengoConnectAdapter(),
            AlphaConnectAdapter(),
            OKXConnectAdapter(),
        ]
        ParticleConnect.initialize(env: .debug, chainInfo: .polygon, adapters: adapters)

        AAService.initialize(name: .biconomyV2)
        let aaService = AAService()
        ParticleNetwork.setAAService(aaService)
        aaService.enableAAMode()
        // Set wallet connect chains,
        // Note metamask only support one chain for each connection.
//        ParticleConnect.setWalletConnectV2SupportChainInfos([.ethereum, .ethereumSepolia, .polygon, .polygonAmoy])
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ParticleConnect.handleUrl(url)
    }
}
