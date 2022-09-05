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
import ParticleConnect
import ParticleNetworkBase
import ParticleWalletGUI

public class ParticleConnectWrapper: NSObject {
    @objc public static func initParticleConnect() {
        let dAppData = DAppMetaData(name: "Test", icon: URL(string: "https://static.particle.network/wallet-icons/Particle.png")!, url: URL(string: "https://static.particle.network")!)

        var adapters: [ConnectAdapter] = [
            MetaMaskConnectAdapter(),
            ParticleConnectAdapter(),
            PhantomConnectAdapter(),
            WalletConnectAdapter(),
            RainbowConnectAdapter(),
            BitkeepConnectAdapter(),
            ImtokenConnectAdapter()
        ]

        if ParticleNetwork.getDevEnv() == .production {
            adapters.append(EVMConnectAdapter())
            adapters.append(SolanaConnectAdapter())
        } else {
            adapters.append(EVMConnectAdapter(rpcUrl: "http://api-debug.app-link.network/evm-chain/rpc/"))
            adapters.append(SolanaConnectAdapter(rpcUrl: "http://api-debug.app-link.network/solana/rpc/"))
        }

        ParticleConnect.initialize(env: .debug, chainInfo: .ethereum(.mainnet), dAppData: dAppData) {
            adapters
        }

        // Custom your wallet
        ParticleWalletGUI.showTestNetwork(false)
        ParticleWalletGUI.supportChain([.bsc, .arbitrum, .harmony])
        ParticleWalletGUI.showManageWallet(true)
    }
    
    @objc public static func handleUrl(url: URL) -> Bool {
        return ParticleConnect.handleUrl(url)
    }
}