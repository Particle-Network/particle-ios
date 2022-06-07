//
//  APIReferenceViewController.swift
//  Demo
//
//  Created by link on 2022/5/17.
//

import Foundation
import ParticleNetworkBase
import ParticleWalletGUI
import ParticleAuthService
import RxSwift
import UIKit

class APIReferenceViewController: UIViewController {
    let bag = DisposeBag()
    
    
    @IBAction func signAndSendTransaction() {
        let transaction = "your transaction"
        ParticleAuthService.signAndSendTransaction(transaction).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signature):
                print(signature)
            }
        }.disposed(by: bag)
    }
    
    @IBAction func signTransaction() {
        let transaction = "your transaction"
        ParticleAuthService.signtransaction(transaction).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signed):
                print(signed)
            }
        }.disposed(by: bag)
    }
    
    @IBAction func signMessage() {
        let message = "your message"
        ParticleAuthService.signMessage(message).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signed):
                print(signed)
            }
        }.disposed(by: bag)
    }
    
    @IBAction func openWallet() {
        PNRouter.navigatorWallet(display: .token)
    }
    
    @IBAction func openSendToken() {
        let config = TokenSendConfig(tokenAddress: nil, toAddress: nil, amount: nil)
        PNRouter.navigatorTokenSend(tokenSendConfig: config)
    }
    
    @IBAction func openReceiveToken() {
        let config = TokenReceiveConfig(tokenAddress: nil)
        PNRouter.navigatorTokenReceive(tokenReceiveConfig: config)
    }
    
    @IBAction func openTransactionRecords() {
        let tokenAddress = ""
        let config = TokenTransactionRecordsConfig(tokenAddress: tokenAddress)
        
        PNRouter.navigatorTokenTransactionRecords(tokenTransactionRecordsConfig: config)
    }
    
    @IBAction func openNFTDetail() {
        let mintAddress = ""
        let tokenId = ""
        let config = NFTDetailsConfig(address: mintAddress, tokenId: tokenId)
        PNRouter.navigatorNFTDetails(nftDetailsConfig: config)
    }
    
    @IBAction func openNFTSend() {
        let mintAddress = ""
        let toAddress = ""
        let tokenId = ""
        let config = NFTSendConfig(address: mintAddress, toAddress: toAddress, tokenId: tokenId)
        PNRouter.navigatroNFTSend(nftSendConfig: config)
    }
}
