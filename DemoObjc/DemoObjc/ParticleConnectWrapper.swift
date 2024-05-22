//
//  Bridge.swift
//  DemoObjc
//
//  Created by link on 2022/8/12.
//

import ConnectCommon
import ConnectEVMAdapter
import ConnectPhantomAdapter
import ConnectSolanaAdapter
import ConnectWalletConnectAdapter
import Foundation
import ParticleAuthAdapter
import ParticleConnect
import ParticleNetworkBase
import ParticleWalletConnect
import ParticleWalletGUI

public class ParticleConnectWrapper: NSObject {
    @objc public static func initParticleConnect() {
        var adapters: [ConnectAdapter] = [
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
            Inch1ConnectAdapter(),
            ZengoConnectAdapter(),
            AlphaConnectAdapter(),
            OKXConnectAdapter()
        ]

        adapters.append(EVMConnectAdapter())
        adapters.append(SolanaConnectAdapter())

        ParticleConnect.initialize(env: .debug, chainInfo: .ethereum, dAppData: .standard) {
            adapters
        }

        // Custom your wallet
        ParticleWalletGUI.setShowTestNetwork(false)
        ParticleWalletGUI.setSupportChain([.bnbChain, .arbitrumOne, .harmony])
        ParticleWalletGUI.setShowManageWallet(true)
        // Initialize particle wallet connect sdk
        ParticleWalletConnect.initialize(
            WalletMetaData(name: "Particle Wallet",
                           icon: URL(string: "https://connect.particle.network/icons/512.png")!,
                           url: URL(string: "https://particle.network")!,
                           description: "Particle Wallet",
                           redirectUniversalLink: nil))
        // set wallet connect v2 project id to ParticleWalletConnect, used when connect as a wallet.
        ParticleWalletConnect.setWalletConnectV2ProjectId("75ac08814504606fc06126541ace9df6")
    }

    @objc public static func handleUrl(url: URL) -> Bool {
        return ParticleConnect.handleUrl(url)
    }
}
