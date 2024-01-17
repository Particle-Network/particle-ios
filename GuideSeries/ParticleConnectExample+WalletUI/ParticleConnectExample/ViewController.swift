//
//  ViewController.swift
//  ParticleConnectExample
//
//  Created by link on 16/11/2023.
//

import ConnectCommon
import ParticleAuthService
import ParticleConnect
import ParticleNetworkBase
import ParticleWalletAPI
import ParticleWalletGUI
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
            $0.walletType == .particle
        }.first!

        let authConfig: ParticleAuthConfig = .init(loginType: .google)
        adapter.connect(authConfig).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let account):
                self.account = account
                print(account)
                print(account?.smartAccount?.smartAccountAddress)
                // when walletType is particle or authCore,
                // if you need token, uuid or others, try getUserInfo.
                // in particle auth service.
                // let userInfo = ParticleAuthService.getUserInfo()
                //
                // in auth core,
                // let auth = Auth()
                // let userInfo = auth.getUserInfo()
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
                print(account?.smartAccount?.smartAccountAddress)
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
        guard let smartAccountAddress = account.smartAccount?.smartAccountAddress else {
            print("you didn't get a smart account address")
            return
        }

        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == account.walletType
        }.first!

        let publicAddress = account.publicAddress

        let receiverAddress = "0x0000000000000000000000000000000000000000"

        // the smallest unit
        let amount = BInt(10000000000000).toHexString()

        ParticleWalletAPI.getEvmService().createTransaction(from: smartAccountAddress, to: receiverAddress, value: amount, data: "0x", gasFeeLevel: .high).flatMap { transaction in
            adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction, feeMode: .native, chainInfo: ParticleNetwork.getChainInfo())
        }.subscribe { result in
            switch result {
            case .success(let signature):
                print(signature)
            case .failure(let error):
                print(error)
            }

        }.disposed(by: self.bag)
    }

    @IBAction func sendTransacitonPayToken() {
        guard let account = self.account else {
            print("you didn't connect any account")
            return
        }
        guard let smartAccountAddress = account.smartAccount?.smartAccountAddress else {
            print("you didn't get a smart account address")
            return
        }

        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == account.walletType
        }.first!

        let publicAddress = account.publicAddress

        let receiverAddress = "0x0000000000000000000000000000000000000000"

        // the smallest unit
        let amount = BInt(10000000000000).toHexString()

        ParticleWalletAPI.getEvmService().createTransaction(from: smartAccountAddress, to: receiverAddress, value: amount, data: "0x", gasFeeLevel: .high).flatMap { transaction -> PrimitiveSequence<SingleTrait, (AA.WholeFeeQuote, String)> in
            let feeQuoteObservable = ParticleNetwork.getAAService()!.rpcGetFeeQuotes(eoaAddress: publicAddress, transactions: [transaction], chainInfo: ParticleNetwork.getChainInfo())

            return Single.zip(feeQuoteObservable, .just(transaction)) as PrimitiveSequence<SingleTrait, (AA.WholeFeeQuote, String)>
        }.flatMap { wholeFeeQuote, transaction -> Single<String> in
            guard let tokenPaymaster = wholeFeeQuote.token else {
                return .error(ParticleNetwork.ResponseError(code: nil, message: "pay token is unavailable"))
            }
            let tokenPaymasterAddress = tokenPaymaster.tokenPaymasterAddress
            let tokenFeeQuoters = tokenPaymaster.feeQuotes
            let feeQuotes = tokenFeeQuoters.map {
                AA.FeeQuote(json: $0, tokenPaymasterAddress: tokenPaymasterAddress)
            }
            // select a token, which isEnoughForPay is true
            let feeQuote = feeQuotes.first {
                $0.isEnoughForPay
            }

            if feeQuote == nil {
                return .error(ParticleNetwork.ResponseError(code: nil, message: "pay token is unavailable"))
            }

            return adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction, feeMode: .token(feeQuote!), chainInfo: ParticleNetwork.getChainInfo())
        }.subscribe { result in
            switch result {
            case .success(let signature):
                print(signature)
            case .failure(let error):
                print(error)
            }

        }.disposed(by: self.bag)
    }

    @IBAction func batchSendTransactions() {
        guard let account = self.account else {
            print("you didn't connect any account")
            return
        }
        guard let smartAccountAddress = account.smartAccount?.smartAccountAddress else {
            print("you didn't get a smart account address")
            return
        }

        let receiverAddress = "0x0000000000000000000000000000000000000000"
        // the smallest unit
        let amount = BInt(10000000000000).toHexString()

        // make two transactions
        let createTransactionObservable1 = ParticleWalletAPI.getEvmService().createTransaction(from: smartAccountAddress, to: receiverAddress, value: amount, data: "0x", gasFeeLevel: .high)
        let createTransactionObservable2 = ParticleWalletAPI.getEvmService().createTransaction(from: smartAccountAddress, to: receiverAddress, value: amount, data: "0x", gasFeeLevel: .high)

        Single.zip(createTransactionObservable1, createTransactionObservable2).flatMap { [weak self] transaction1, transaction2 -> Single<String> in
            guard let self = self else { return .error(ParticleNetwork.ResponseError(code: nil, message: "self is nil")) }
            return ParticleNetwork.getAAService()!.quickSendTransactions([transaction1, transaction2], feeMode: .native, messageSigner: self, wholeFeeQuote: nil, chainInfo: ParticleNetwork.getChainInfo())
        }.subscribe {
            result in
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

    @IBAction func openWallet() {
        PNRouter.navigatorWallet(display: .token)
    }

    @IBAction func openTokenSend() {
        PNRouter.navigatorTokenSend(tokenSendConfig: nil)
    }

    @IBAction func openTokenTransactions() {
        PNRouter.navigatorTokenTransactionRecords(tokenTransactionRecordsConfig: nil)
    }

    @IBAction func openNFTDetail() {
        let nftAddress = "0xb3a07Fa38804810a14bB8877AF69Ab547502D321"
        let tokenId = "1690288350001"
        let config: NFTDetailsConfig = .init(address: nftAddress, tokenId: tokenId)
        PNRouter.navigatorNFTDetails(nftDetailsConfig: config)
    }
    
    @IBAction func openNFTSend() {
        let nftAddress = "0xb3a07Fa38804810a14bB8877AF69Ab547502D321"
        let toAddress = "0x0000000000000000000000000000000000000000"
        let tokenId = "1690288350001"
        let config: NFTSendConfig = .init(address: nftAddress, toAddress: toAddress, tokenId: tokenId, amount: 1)
        PNRouter.navigatorNFTSend(nftSendConfig: config)
    }
}

extension ViewController: MessageSigner {
    func signMessage(_ message: String, chainInfo: ParticleNetworkBase.ParticleNetwork.ChainInfo?) -> RxSwift.Single<String> {
        guard let account = self.account else {
            print("you didn't connect any account")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "you didn't connect any account"))
        }

        guard let smartAccountAddress = account.smartAccount?.smartAccountAddress else {
            print("you didn't get a smart account address")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "you didn't get a smart account address"))
        }

        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == account.walletType
        }.first!

        let publicAddress = account.publicAddress

        return adapter.signMessage(publicAddress: publicAddress, message: message)
    }

    func getEoaAddress() -> String {
        self.account?.publicAddress ?? ""
    }
}
