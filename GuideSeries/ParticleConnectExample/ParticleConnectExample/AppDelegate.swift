//
//  AppDelegate.swift
//  ParticleConnectExample
//
//  Created by link on 16/11/2023.
//

import ConnectCommon
import ConnectEVMAdapter
import ConnectPhantomAdapter
import ConnectSolanaAdapter
import ConnectWalletConnectAdapter
import ParticleAuthAdapter
import ParticleConnect
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
            ParticleAuthAdapter(),
            MetaMaskConnectAdapter(),
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
            SolanaConnectAdapter(),
            EVMConnectAdapter()
        ]
        ParticleConnect.initialize(env: .debug, chainInfo: .polygonMumbai) {
            adapters
        }
        ParticleConnect.setWalletConnectV2ProjectId("75ac08814504606fc06126541ace9df6")

        // Set wallet connect chains,
        // Note metamask only support one chain for each connection.
        ParticleConnect.setWalletConnectV2SupportChainInfos([.ethereum, .ethereumGoerli, .polygon, .polygonMumbai])
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ParticleConnect.handleUrl(url)
    }
}
