//
//  AppDelegate.swift
//  ParticleConnectExample
//
//  Created by link on 16/11/2023.
//

import ConnectCommon
import ConnectPhantomAdapter
import ConnectWalletConnectAdapter
import ParticleAA
import ParticleAuthAdapter
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
            ParticleAuthAdapter(),
            PhantomConnectAdapter(),
            WalletConnectAdapter(),
            RainbowConnectAdapter(),
            BitkeepConnectAdapter(),
            ImtokenConnectAdapter(),
            TrustConnectAdapter(),
            ZerionConnectAdapter(),
            MathConnectAdapter(),
            OmniConnectAdapter(),
            Inch1ConnectAdapter(),
            ZengoConnectAdapter(),
            AlphaConnectAdapter(),
            OKXConnectAdapter(),
        ]
        ParticleConnect.initialize(env: .debug, chainInfo: .polygon) {
            adapters
        }
        ParticleConnect.setWalletConnectV2ProjectId("75ac08814504606fc06126541ace9df6")

        // set your biconomy api keys
        let biconomyApiKeys =
            [80001: "hYZIwIsf2.e18c790b-cafb-4c4e-a438-0289fc25dba1"]

        //
        AAService.initialize(name: .biconomyV1, biconomyApiKeys: biconomyApiKeys)
        let aaService = AAService()
        ParticleNetwork.setAAService(aaService)
        aaService.enableAAMode()
        // Set wallet connect chains,
        // Note metamask only support one chain for each connection.
        ParticleConnect.setWalletConnectV2SupportChainInfos([.ethereum, .ethereumSepolia, .polygon, .polygonMumbai])
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ParticleConnect.handleUrl(url)
    }
}
