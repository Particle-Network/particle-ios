//
//  AccountChecker.swift
//  Demo
//
//  Created by link on 2022/7/25.
//  Copyright © 2022 ParticleNetwork. All rights reserved.
//

import ConnectCommon
import Foundation
import ParticleConnect
import ParticleNetworkBase

class AccountChecker {
    public static func hasAccount() -> Bool {
        let adapters = ParticleConnect.getAdapters(chainType: .solana) + ParticleConnect.getAdapters(chainType: .evm)
        let accounts = adapters.map {
            $0.getAccounts()
        }.flatMap {
            $0
        }.filter {
            !$0.publicAddress.isEmpty
        }
        
        if accounts.count > 0 {
            return true
        } else {
            return false
        }
    }
}
