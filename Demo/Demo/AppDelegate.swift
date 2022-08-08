//
//  AppDelegate.swift
//  Demo
//
//  Created by link on 2022/5/12.
//

import ConnectCommon
import ConnectEVMAdapter
import ConnectPhantomAdapter
import ConnectSolanaAdapter
import ConnectWalletConnectAdapter
import ParticleAuthService
import ParticleConnect
import ParticleNetworkBase
import ParticleWalletGUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // init ParticleNetwork
        // select a network
        let chainName = ParticleNetwork.ChainName.ethereum(.mainnet)
        // and also and you can custom your evm network
//        let chainName = ParticleNetwork.ChainName.customEvmNetwork(fullName: "Ethereum", network: "kovan", chainId: 42, explorePath: "https://kovan.etherscan.io/", symbol: "ETH")

//        let chainName = ParticleNetwork.ChainName.customEvmNetwork(fullName: "Ethereum", network: "rinkeby", chainId: 4, explorePath: "https://rinkeby.etherscan.io/", symbol: "ETH")

        // You can disable pay feature, default is true
//        ParticleWalletGUI.enablePay(false)

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

        ParticleConnect.initialize(env: .debug, chainName: .solana(.devnet), dAppData: dAppData) {
            adapters
        }

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
