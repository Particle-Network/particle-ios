//
//  ViewController.swift
//  ParticleConnectExample
//
//  Created by link on 16/11/2023.
//

import ConnectCommon
import ParticleAuthCore
import ParticleConnect
import ParticleNetworkBase
import ParticleWalletAPI
import RxSwift
import UIKit

class ViewController: UIViewController {
    let bag = DisposeBag()

    var account: Account?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func connectParticle() {
        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == .authCore
        }.first!

        let authConfig: ParticleAuthConfig = .init(loginType: .google)

        adapter.connect(authConfig).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let account):
                self.account = account
                print(account)

                // in auth core,
                let auth = Auth()
                let userInfo = auth.getUserInfo()
            case .failure(let error):
                print(error)
            }
        }.disposed(by: self.bag)
    }

    @IBAction func connectMetaMask() {
        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == .metaMask
        }.first!

        adapter.connect(ConnectConfig.none).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let account):
                self.account = account
                print(account)
            // there are no more user infos when connect with third wallets, like metamask, trust...
            case .failure(let error):
                print(error)
            }
        }.disposed(by: self.bag)
    }

    @IBAction func signMessage() {
        guard let account = self.account else {
            print("you didn't connect any account")
            return
        }

        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == account.walletType
        }.first!

        let publicAddress = account.publicAddress

        adapter.signMessage(publicAddress: publicAddress, message: "Hello Particle!").subscribe {
            [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let signature):
                    print(signature)
                case .failure(let error):
                    print(error)
                }
        }.disposed(by: self.bag)
    }

    @IBAction func sendTransaciton() {
        guard let account = self.account else {
            print("you didn't connect any account")
            return
        }

        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == account.walletType
        }.first!

        let publicAddress = account.publicAddress

        let receiverAddress = "0x0000000000000000000000000000000000000000"

        // the smallest unit
        let amount = BInt(10000000000000).toHexString()
        ParticleWalletAPI.getEvmService().createTransaction(from: publicAddress, to: receiverAddress, value: amount, data: "0x", gasFeeLevel: .high).flatMap { transaction in
            adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction)
        }.subscribe { result in
            switch result {
            case .success(let signature):
                print(signature)
            case .failure(let error):
                print(error)
            }

        }.disposed(by: self.bag)
    }

    @IBAction func disconnect() {
        guard let account = self.account else {
            print("you didn't connect any account")
            return
        }

        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == account.walletType
        }.first!

        let publicAddress = account.publicAddress

        adapter.disconnect(publicAddress: publicAddress).subscribe {
            [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let flag):
                    print(flag)
                    self.account = nil
                case .failure(let error):
                    print(error)
                }
        }.disposed(by: self.bag)
    }
}

extension ViewController {
    @IBAction func readContract() {
        guard let account = self.account else {
            print("you didn't connect any account")
            return
        }

        let contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB"
        let methodName = "balanceOf"
        // each element of params should be presented as a hex string,
        // for example, you should convert your int to a hex string, start with 0x
        let params = [account.publicAddress]
        let contractParams = ContractParams.customAbiEncodeFunctionCall(contractAddress: contractAddress, methodName: methodName, params: params)
        ParticleWalletAPI.getEvmService().readContract(contractParams: contractParams).subscribe { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let json):
                let string = json.stringValue
                // because the method name is `balanceOf`
                // we can resolve the string as BInt
                let balance = BInt(string, radix: 16)
                print(balance)

                // and we know the token decimals is 18
                let number = balance?.convertToBalance(decimals: 18)
                print(number)
            }
        }.disposed(by: self.bag)
    }

    @IBAction func writeContract() {
        guard let account = self.account else {
            print("you didn't connect any account")
            return
        }

        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == account.walletType
        }.first!

        let contractAddress = "0x9B1AAb1492c375F011811cBdBd88FFEf3ce2De76"
        let methodName = "mint"
        // each element of params should be presented as a hex string,
        // for example, you should convert your int to a hex string, start with 0x
        let params = ["0x3"]

        let contractParams = ContractParams.customAbiEncodeFunctionCall(contractAddress: contractAddress, methodName: methodName, params: params)
        ParticleWalletAPI.getEvmService().writeContract(contractParams: contractParams, from: account.publicAddress).flatMap { transaction in
            adapter.signAndSendTransaction(publicAddress: account.publicAddress, transaction: transaction)
        }.subscribe {
            result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let transaction):
                print(transaction)
                // here you get the transaction
                // you can sign and send now.
            }
        }.disposed(by: self.bag)
    }

    @IBAction func getTransactionReceipt() {
        // track the txhash
        let hash = "0x639c16e24acf8a39536051dba38c13fe28d6675b48548c49095e59e639071c03"

        ParticleWalletAPI.getEvmService().eth_getTransactionReceipt(txHash: hash).subscribe { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let receipt):
                print(receipt)
            }
        }.disposed(by: self.bag)
    }
}
