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
import ParticleWalletAPI
import RxSwift
import UIKit

class APIReferenceViewController: UIViewController {
    let bag = DisposeBag()
    var mask: UIView?
    var loading: UIActivityIndicatorView?
    
    @IBAction func signAndSendTransaction() {
        switch ParticleNetwork.getChainName() {
        case .solana:
            let transaction = "87PYtzaf2kzTwVq1ckrGzYDEi47ThJTu4ycMth8M3yrAfs7DWWwxFGjWMy8Pr6GAgu21VsJSb8ipKLBguwGFRJPJ6E586MvJcVSo1u6UTYGodUqay8bYmUcb3hq6ezPKnUrAuKyzDoW5WT1R1K62yYR8XTwxttoWdu5Qx3AZL8qa3F7WobW5WDGRT4fS8TsXSxWbVYMfWgdu"
            
            ParticleAuthService.signAndSendTransaction(transaction).subscribe { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let signature):
                    print(signature)
                }
            }.disposed(by: self.bag)
            
        default:
            // test send native
//            sendNativeEVM()
            
            // test send erc20
            self.sendErc20Token()
            
            // test your custom contract function
            self.sendCustomContractFunction()
        }
    }
    
    func sendNativeEVM() {
        showLoading()
        // firstly, make sure current user has some native token for test there methods
        // send 0.0001 native from self to receiver
        let sender = ParticleAuthService.getAddress()
        let receiver = "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b"
        let amount = BDouble(0.0001 * pow(10, 18)).rounded()
        
        ParticleWalletAPI.getEvmService().createTransaction(from: sender, to: receiver, value: amount.toHexString()).flatMap { transaction -> Single<String> in
            print(transaction)
            return ParticleAuthService.signAndSendTransaction(transaction)
        }.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signature):
                print(signature)
            }
            self.hideLoading()
        }.disposed(by: self.bag)
    }
    
    func sendErc20Token() {
        showLoading()
        // firstly, make sure current user has some native token and erc20 token for test there methods
        // send 0.0001 erc20 token from self to receiver
        let from = ParticleAuthService.getAddress()
        let to = "0xa36085F69e2889c224210F603D836748e7dC0088"
        let amount = BDouble(0.0001 * pow(10, 18)).rounded()
        let contractAddress = "0xa36085F69e2889c224210F603D836748e7dC0088"
        let receiver = "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b"
        let contractParams = ContractParams.erc20Transfer(contractAddress: contractAddress, to: receiver, amount: amount)
        
        // because you want to send erc20 token, interact with contact, 'to' should be the contract address.
        // and value could be nil.
        ParticleWalletAPI.getEvmService().createTransaction(from: from, to: to, value: nil, contractParams: contractParams).flatMap { transaction -> Single<String> in
            print(transaction)
            return ParticleAuthService.signAndSendTransaction(transaction)
        }.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signature):
                print(signature)
            }
            self.hideLoading()
        }.disposed(by: self.bag)
    }
    
    func sendCustomContractFunction() {
        showLoading()
        let from = ParticleAuthService.getAddress()
        let to = "YOUR_CONTRACT_ADDRESS"
        
        let contractAddress = "YOUR_CONTRACT_ADDRESS"
        let methodName = "YOUR_METHOD_NAME"
        let params = ["YOUR_PARAMS", "YOUR_PARAMS"]
        let abiJsonString: String? = nil
        let contractParams = ContractParams.customAbiEncodeFunctionCall(contractAddress: contractAddress, methodName: methodName, params: params, abiJsonString: abiJsonString)
        ParticleWalletAPI.getEvmService().createTransaction(from: from, to: to, value: nil, contractParams: contractParams).flatMap { transaction -> Single<String> in
            print(transaction)
            return ParticleAuthService.signAndSendTransaction(transaction)
        }.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signature):
                print(signature)
            }
            self.hideLoading()
        }.disposed(by: self.bag)
    }
    
    func readContract() {
        let from = ParticleAuthService.getAddress()
        let to = "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b"
        let data = "0x"
        let txData = ReadContractData(from: from, to: to, data: data)
        
        // Integer block number, or the string 'latest', 'earliest' or 'pending'
        let quantity = "latest"
        
        ParticleWalletAPI.getEvmService().rpc(method: "eth_call", params: [txData, quantity]).subscribe { response in
            print(response)
        }.disposed(by: self.bag)
    }
    
    struct ReadContractData: Codable {
        let from: String
        let to: String
        let data: String
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

extension APIReferenceViewController {
    func showLoading() {
        if self.mask == nil {
            self.mask = UIView()
            self.mask!.frame = self.view.bounds
            self.view.addSubview(self.mask!)
        }
        
        if self.loading == nil {
            self.loading = UIActivityIndicatorView()
            self.loading!.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.mask!.addSubview(self.loading!)
            self.loading?.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        }
        
        self.mask?.isHidden = false
        self.loading?.startAnimating()
    }
    
    func hideLoading() {
        self.mask?.isHidden = true
        self.loading?.stopAnimating()
    }
}
