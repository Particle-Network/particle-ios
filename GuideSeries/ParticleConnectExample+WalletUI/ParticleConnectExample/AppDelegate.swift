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
import ParticleWalletConnect
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
            AuthCoreAdapter(),
            MetaMaskConnectAdapter(),
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
        ParticleConnect.initialize(env: .debug, chainInfo: .ethereumSepolia, adapters: adapters)
        ParticleConnect.setWalletConnectV2ProjectId("75ac08814504606fc06126541ace9df6")

        AAService.initialize(name: .biconomyV2, biconomyApiKeys: [:])
        let aaService = AAService()
        ParticleNetwork.setAAService(aaService)
        aaService.enableAAMode()
        // Set wallet connect chains,
        // Note metamask only support one chain for each connection.
//        ParticleConnect.setWalletConnectV2SupportChainInfos([.ethereum, .ethereumSepolia, .polygon, .polygonAmoy])

        ParticleWalletConnect.initialize(
            WalletMetaData(name: "Particle Wallet",
                           icon: URL(string: "https://connect.particle.network/icons/512.png")!,
                           url: URL(string: "https://particle.network")!,
                           description: "Particle Connect is a decentralized wallet connection protocol that makes it easy for users to connect their wallets to your DApp.", redirectUniversalLink: nil))

        ParticleWalletConnect.setWalletConnectV2ProjectId("75ac08814504606fc06126541ace9df6")
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ParticleConnect.handleUrl(url)
    }
}
