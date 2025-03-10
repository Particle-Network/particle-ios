//
//  AppDelegate.swift
//  Demo
//
//  Created by link on 2022/5/12.
//

import AuthCoreAdapter
import ConnectCommon
import ConnectEVMAdapter
import ConnectPhantomAdapter
import ConnectSolanaAdapter
import ConnectWalletConnectAdapter
import ParticleAA
import ParticleConnect
import ParticleNetworkBase
import ParticleWalletConnect
import ParticleWalletGUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // init ParticleNetwork

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
            EVMConnectAdapter(),
            SolanaConnectAdapter()
        ]

        // select a network
        ParticleConnect.initialize(env: .debug, chainInfo: .ethereum, dAppData: .standard, adapters: adapters)

        ParticleWalletGUI.setAdapters(ParticleConnect.getAllAdapters())

//        ParticleConnect.setWalletConnectV2SupportChainInfos([.ethereum, .polygon])

        // Custom Wallet GUI
        // Control if show test network
        ParticleWalletGUI.setShowTestNetwork(true)
        // Control support chains
//        ParticleWalletGUI.setSupportChain([.bnbChain, .arbitrum, .harmony])

        // Control if show manage wallet
//        ParticleWalletGUI.showManageWallet(true)

        // Control disable pay feature
//        ParticleWalletGUI.setPayDisabled(true)
        // Control disable swap feature
//        ParticleWalletGUI.setSwapDisabled(true)

        // show language setting in setting page
        ParticleWalletGUI.setShowLanguageSetting(true)
        // show appearance setting in setting page
        ParticleWalletGUI.setShowAppearanceSetting(true)
        // Set appearance
//        ParticleNetwork.setAppearance(.unspecified)

        // Set custom ui is pass json string
//        let jsonString = ""
//        try! ParticleWalletGUI.loadCustomUIJsonString(jsonString)

        // Initialize particle wallet connect sdk
        ParticleWalletConnect.initialize(
            WalletMetaData(name: "Particle Wallet",
                           icon: URL(string: "https://connect.particle.network/icons/512.png")!,
                           url: URL(string: "https://particle.network")!,
                           description: "Particle Wallet",
                           redirectUniversalLink: nil))
                           
        // Control if disable wallet connect feature.
        // If disable wallet connect feature, you dont need to initialize particle Wallet Connect.
        ParticleWalletGUI.setSupportWalletConnect(true)

        // Initialize AA service
        AAService.initialize(name: AA.AccountName.biconomyV1)
        // create a aa service
        let aaService = AAService()
        // set it to ParticleNetwork
        ParticleNetwork.setAAService(aaService)

        ParticleNetwork.setSecurityAccountConfig(config: .init(promptSettingWhenSign: 1, promptMasterPasswordSettingWhenLogin: 2))
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // if open Wallet Connect in GUI, you should call this method to handle wallet connect
        // You need paste your app scheme, GUI will return true if it can reslove the url with your scheme, otherwise return false.
        if ParticleWalletGUI.handleWalletConnectUrl(url, withScheme: "particlewallet") {
            return true
        } else {
            return ParticleConnect.handleUrl(url)
        }
    }
}
