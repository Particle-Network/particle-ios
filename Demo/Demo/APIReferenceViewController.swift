//
//  APIReferenceViewController.swift
//  Demo
//
//  Created by link on 2022/5/17.
//

import ConnectCommon
import ConnectEVMAdapter
import ConnectWalletConnectAdapter
import Foundation
import ParticleAA
import ParticleConnect
import ParticleNetworkBase
import ParticleNetworkChains
import ParticleWalletAPI
import ParticleWalletGUI
import RxSwift
import UIKit

class APIReferenceViewController: UIViewController {
    let bag = DisposeBag()
    var mask: UIView?
    var loading: UIActivityIndicatorView?
    var publicAddress: String?
    var walletType: WalletType = .authCore
    var adapter: ConnectAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adapter = ParticleConnect.getAllAdapters().first {
            $0.walletType == self.walletType
        }!
        self.adapter = adapter
        
        // get evm address
        self.publicAddress = adapter.getAccounts().filter {
            $0.publicAddress.isValidEVMAddress()
        }.first?.publicAddress
        
        if self.publicAddress == nil {
            print("not login with authCore")
        }
    }
    
    @IBAction func signAndSendTransaction() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        switch ParticleNetwork.getChainInfo().chainType {
        case .solana:
            let transaction = "87PYtzaf2kzTwVq1ckrGzYDEi47ThJTu4ycMth8M3yrAfs7DWWwxFGjWMy8Pr6GAgu21VsJSb8ipKLBguwGFRJPJ6E586MvJcVSo1u6UTYGodUqay8bYmUcb3hq6ezPKnUrAuKyzDoW5WT1R1K62yYR8XTwxttoWdu5Qx3AZL8qa3F7WobW5WDGRT4fS8TsXSxWbVYMfWgdu"
            
            adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction).subscribe { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let signature):
                    print(signature)
                }
            }.disposed(by: self.bag)
            
        default:
            // test send native
            self.sendNativeEVM()
            
            // test send erc20
//            self.sendErc20Token()
            
            // test your custom contract function
//            self.sendCustomContractFunction()
            
//            self.readContract()
//            self.deployContract()
        }
    }
    
    func signAllTransaction() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        let transactions: [String] = []
        
        adapter.signAllTransactions(publicAddress: publicAddress, transactions: transactions).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signature):
                print(signature)
            }
        }.disposed(by: self.bag)
    }
    
    func sendNativeEVM() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        showLoading()
        // firstly, make sure current user has some native token for test there methods
        // send 0.0001 native from self to receiver
        let sender = publicAddress
        let receiver = "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b"
        let amount = BDouble(0.0001 * pow(10, 18)).rounded()
        
        ParticleWalletAPI.getEvmService().createTransaction(from: sender, to: receiver, value: amount.toHexString(), contractParams: nil).flatMap { transaction -> Single<String> in
            print(transaction)
            return adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction)
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
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        showLoading()
        // firstly, make sure current user has some native token and erc20 token for test there methods
        // send 0.0001 erc20 token from self to receiver
        let from = publicAddress
        // this token's decimals is 18, convert 0.0001 to minimum unit
        let amount = BDouble(0.0001 * pow(10, 18)).rounded()
        // this is your token contract address
        let contractAddress = "0xa36085F69e2889c224210F603D836748e7dC0088"
        // this is receiver address
        let receiver = "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b"
        
        let contractParams = ContractParams.erc20Transfer(contractAddress: contractAddress, to: receiver, amount: amount)
        
        // because you want to send erc20 token, interact with contact, 'to' should be the contract address.
        // and value could be nil.
        ParticleWalletAPI.getEvmService().createTransaction(from: from, to: contractAddress, value: nil, contractParams: contractParams).flatMap { transaction -> Single<String> in
            print(transaction)
            return adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction)
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
    
    func sendErc721NFT() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        showLoading()
        // firstly, make sure current user has some native token and the NFT for test there methods
        // send 1 erc721 NFT from self to receiver
        let from = publicAddress
        // this is your nft contract address
        let contractAddress = "0xD18e451c11A6852Fb92291Dc59bE35a59d143836"
        // this is receiver address
        let receiver = "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b"
        // your NFT token id, make sure you own the NFT
        let tokenId = "2302"
        
        let contractParams = ContractParams.erc721SafeTransferFrom(contractAddress: contractAddress, from: from, to: receiver, tokenId: tokenId)
        
        // because you want to send erc721 NFT, interact with contact, 'to' should be the contract address.
        // and value could be nil.
        ParticleWalletAPI.getEvmService().createTransaction(from: from, to: contractAddress, value: nil, contractParams: contractParams).flatMap { transaction -> Single<String> in
            print(transaction)
            return adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction)
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
    
    func sendErc1155NFT() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        showLoading()
        // firstly, make sure current user has some native token and the NFT for test there methods
        // send 10 erc1155 NFT from self to receiver
        let from = publicAddress
        // this is your nft contract address
        let contractAddress = "0xD18e451c11A6852Fb92291Dc59bE35a59d143836"
        // this is receiver address
        let receiver = "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b"
        // your NFT token id, make sure you own the NFT
        let tokenId = "2302"
        // send amount
        let tokenAmount: BInt = 10
        
        let contractParams = ContractParams.erc1155SafeTransferFrom(contractAddress: contractAddress, from: from, to: receiver, id: tokenId, amount: tokenAmount, data: "0x")
        
        // because you want to send erc1155 NFT, interact with contact, 'to' should be the contract address.
        // and value could be nil.
        ParticleWalletAPI.getEvmService().createTransaction(from: from, to: contractAddress, value: nil, contractParams: contractParams).flatMap { transaction -> Single<String> in
            print(transaction)
            return adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction)
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
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        showLoading()
        let from = publicAddress
        let to = "YOUR_CONTRACT_ADDRESS"
        
        let contractAddress = "YOUR_CONTRACT_ADDRESS"
        let methodName = "YOUR_METHOD_NAME"
        let params = ["YOUR_PARAMS", "YOUR_PARAMS"]
        let abiJsonString: String? = nil
        let contractParams = ContractParams.customAbiEncodeFunctionCall(contractAddress: contractAddress, methodName: methodName, params: params, abiJsonString: abiJsonString)
        
        ParticleWalletAPI.getEvmService().createTransaction(from: from, to: to, value: nil, contractParams: contractParams).flatMap { transaction -> Single<String> in
            print(transaction)
            return adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction)
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
    
    @IBAction func signTransaction() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        var transaction = ""
        switch ParticleNetwork.getChainInfo().chainType {
        case .solana:
            transaction = "87PYtzaf2kzTwVq1ckrGzYDEi47ThJTu4ycMth8M3yrAfs7DWWwxFGjWMy8Pr6GAgu21VsJSb8ipKLBguwGFRJPJ6E586MvJcVSo1u6UTYGodUqay8bYmUcb3hq6ezPKnUrAuKyzDoW5WT1R1K62yYR8XTwxttoWdu5Qx3AZL8qa3F7WobW5WDGRT4fS8TsXSxWbVYMfWgdu"
        default:
            transaction = "0x0"
        }
        
        if transaction.isEmpty { return }
        adapter.signTransaction(publicAddress: publicAddress, transaction: transaction).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signed):
                print(signed)
            }
        }.disposed(by: self.bag)
    }
    
    @IBAction func signMessage() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        var message = ""
        switch ParticleNetwork.getChainInfo().chainType {
        case .solana:
            // "hello world" encoded to base58
            message = "StV1DL6CwTryKyV"
        default:
            let hello = "hello world"
            let hexString = "0x" + hello.data(using: .utf8)!.map { String(format: "%02x", $0) }.joined()
            
            message = hexString
        }
        
        if message.isEmpty { return }
        
        adapter.signMessage(publicAddress: publicAddress, message: message).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signed):
                print(signed)
            }
        }.disposed(by: self.bag)
    }
    
    @IBAction func signTypedData() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        var message = ""
        switch ParticleNetwork.getChainInfo().chainType {
        case .solana:
            message = ""
        default:
            let typedData = [TypedDataV1(type: "string", name: "fullName", value: "John Doe"),
                             TypedDataV1(type: "uint64", name: "Name", value: "Doe")]
            let encoded = try! JSONEncoder().encode(typedData)
            let hexString = "0x" + encoded.toHexString()
            message = hexString
        }
        
        if message.isEmpty { return }
        
        adapter.signTypedData(publicAddress: publicAddress, data: message).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signed):
                print(signed)
            }
        }.disposed(by: self.bag)
    }
    
    @IBAction func openWallet() {
        PNRouter.navigatorWallet(hiddenBackButton: false)
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
    
    func openNFTDetails() {
        let address = ""
        let tokenId = ""
        let config = NFTDetailsConfig(address: address, tokenId: tokenId)
        PNRouter.navigatorNFTDetails(nftDetailsConfig: config)
    }
    
    func openDappBrowser() {
        if let url = URL(string: "app.uniswap.org") {
            PNRouter.navigatorDappBrowser(url: url)
        }
    }
    
    func erc20Transfer() {
        let contractAddress = ""
        let to = ""
        let amount = BInt(1)
        ParticleWalletAPI.getEvmService().erc20Transfer(contractAddress: contractAddress, to: to, amount: amount).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: self.bag)
    }

    func erc20Approve() {
        let contractAddress = ""
        let spender = ""
        let amount = BInt(1)
        ParticleWalletAPI.getEvmService().erc20Approve(contractAddress: contractAddress, spender: spender, amount: amount).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: self.bag)
    }

    func erc20TransferFrom() {
        let contractAddress = ""
        let from = ""
        let to = ""
        let amount = BInt(1)
        ParticleWalletAPI.getEvmService().erc20TransferFrom(contractAddress: contractAddress, from: from, to: to, amount: amount).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: self.bag)
    }

    func erc721SafeTransferFrom() {
        let contractAddress = ""
        let from = ""
        let to = ""
        let tokenId = ""
        ParticleWalletAPI.getEvmService().erc721SafeTransferFrom(contractAddress: contractAddress, from: from, to: to, tokenId: tokenId).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: self.bag)
    }

    func erc1155SafeTransferFrom() {
        let contractAddress = ""
        let from = ""
        let to = ""
        let id = ""
        let amount = BInt(1)
        let data = "0x"
        ParticleWalletAPI.getEvmService().erc1155SafeTransferFrom(contractAddress: contractAddress, from: from, to: to, id: id, amount: amount, data: data).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: self.bag)
    }
    
    func readContract() {
        let from = ""
        // example for evm read contract
        let params = ContractParams.customAbiEncodeFunctionCall(contractAddress: "0xd000f000aa1f8accbd5815056ea32a54777b2fc4", methodName: "balanceOf", params: ["0xBbc1CA8776EfDeC12C75e218C64e96ce52aC6671"])
        ParticleWalletAPI.getEvmService().readContract(from: from, value: "0x", contractParams: params).subscribe {
            [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let json):
                    print(json)
                }
        }.disposed(by: self.bag)
    }
    
    func writeContract1() {
        let params = ContractParams.customAbiEncodeFunctionCall(contractAddress: "0xd000f000aa1f8accbd5815056ea32a54777b2fc4", methodName: "mint", params: ["1"])
        let from = "0x0cf3ffe33e45ad43fcd0aa7016c590b5f629d9aa"
        ParticleWalletAPI.getEvmService().writeContract(contractParams: params, from: from).flatMap { transaction -> Single<String> in
            let adapters = ParticleConnect.getAdapterByAddress(publicAddress: from)
            
            guard let adapter = adapters.first else { return .error(ParticleNetwork.ResponseError(code: nil, message: "adapter is nil")) }
            return adapter.signAndSendTransaction(publicAddress: from, transaction: transaction)
        }.subscribe {
            [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let signature):
                    print(signature)
                }
        }.disposed(by: self.bag)
    }
    
    func writeContract2() {
        let params = ContractParams.customAbiEncodeFunctionCall(contractAddress: "0xd000f000aa1f8accbd5815056ea32a54777b2fc4", methodName: "safeTransferFrom", params: ["0xbbc1ca8776efdec12c75e218c64e96ce52ac6671", "0x2D2164e5D004c804C47fb39c97e67fd447a49c0D", "3586"])
        let from = "0xbbc1ca8776efdec12c75e218c64e96ce52ac6671"
        ParticleWalletAPI.getEvmService().writeContract(contractParams: params, from: from).flatMap { transaction -> Single<String> in
            let adapters = ParticleConnect.getAllAdapters().filter {
                $0.walletType == .metaMask
            }
            guard let adapter = adapters.first else { return .error(ParticleNetwork.ResponseError(code: nil, message: "adapter is nil")) }
            return adapter.signAndSendTransaction(publicAddress: from, transaction: transaction)
        }.subscribe {
            [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let signature):
                    print(signature)
                }
        }.disposed(by: self.bag)
    }
    
    func deployContract() {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        let data = getContractData()
        let from = publicAddress
        let to = ""
        ParticleWalletAPI.getEvmService().createTransaction(from: from, to: to, data: data).flatMap {
            transaction -> Single<String> in
            print("transaction = \(transaction)")
            return adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction)
        }.subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let signature):
                print(signature)
            }
        }.disposed(by: self.bag)
    }
    
    func openBuyCrypto() {
        let walletAddress = "YOUR WALLET ADDRESS"
        let network: ChainInfo = .ethereum
        let cryptoCoin = "ETH"
        let fiatCoin = "USD"
        let fiatAmt = 1000
        PNRouter.navigatorBuy(walletAddress: walletAddress, network: network, cryptoCoin: cryptoCoin, fiatCoin: fiatCoin, fiatAmt: fiatAmt)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

enum AirdropType: String {
    case tokens
    case png_nft
    case jpg_nft
    case gif_nft
    case gltf_nft
    case glb_nft
}

struct TypedDataV1: Encodable {
    let type: String
    let name: String
    let value: String
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

extension APIReferenceViewController {
    func getContractData() -> String {
        return """
        0x60606040523415600e57600080fd5b603580601b6000396000f3006060604052600080fd00a165627a7a723058204bf1accefb2526a5077bcdfeaeb8020162814272245a9741cc2fddd89191af1c0029
        """
    }
    
    func getContractDataBig() -> String {
        return """
        YOUR CONTRACT DATA
        """
    }
}

extension APIReferenceViewController {
    func sendTransactionInAA() async throws {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return
        }
        
        let aa = ParticleNetwork.getAAService()!
                
        let chainInfo = ParticleNetwork.getChainInfo()
        let eoaAddress = ""
        let transaction = ""
        let wholeFeeQuote = try await aa.rpcGetFeeQuotes(eoaAddress: eoaAddress, transactions: [transaction], chainInfo: chainInfo).value
            
        if wholeFeeQuote.gasless != nil {
            // There are two ways to send gasless
            // 1, call adapter or ParticleAuthService, requires one transaction
            let txHash1 = try await adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction, feeMode: .gasless, chainInfo: chainInfo).value
            // 2, call aa, support multi transactions, requires implement MessageSigner delegate.
            let txHash2 = try await aa.quickSendTransactions([transaction], feeMode: .gasless, messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo).value
        } else {
            // you cant gasless
        }
            
        let nativeFeeQuote = AA.FeeQuote(json: wholeFeeQuote.native.feeQuote, tokenPaymasterAddress: nil)
        if nativeFeeQuote.isEnoughForPay {
            // There are two ways to send, pay token
            // 1, call adapter or ParticleAuthService, requires one transaction
            let txHash1 = try await adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction, feeMode: .native, chainInfo: chainInfo).value
            // 2, call aa, support multi transactions, requires implement MessageSigner delegate.
            let txHash2 = try await aa.quickSendTransactions([transaction], feeMode: .native, messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo).value
        } else {
            // you dont have enough native to pay
        }

        if let token = wholeFeeQuote.token {
            let tokenPaymasterAddress = token.tokenPaymasterAddress
            let tokenFeeQuotes = token.feeQuotes.map {
                AA.FeeQuote(json: $0, tokenPaymasterAddress: tokenPaymasterAddress)
            }.filter {
                // filter out balance >= fee
                $0.isEnoughForPay
            }
            if tokenFeeQuotes.count > 0 {
                // select a feeQuote, here we select the first one.
                let feeQuote = tokenFeeQuotes[0]
                // There are two ways to send, pay token
                // 1, call adapter or ParticleAuthService, requires one transaction
                let txHash1 = try await adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction, feeMode: .token(feeQuote), chainInfo: chainInfo).value
                // 2, call aa, support multi transactions, requires implement MessageSigner delegate.
                let txHash2 = try await aa.quickSendTransactions([transaction], feeMode: .token(feeQuote), messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo).value
            } else {
                // you can't select token to pay
            }
        }
    }
}

extension APIReferenceViewController: MessageSigner {
    func signMessage(_ message: String, chainInfo: ChainInfo?) -> RxSwift.Single<String> {
        guard let publicAddress = self.publicAddress, let adapter = self.adapter else {
            return .error(ParticleNetwork.ResponseError(code: nil,
                                                        message: "not login with authCore"))
        }
        return adapter.signMessage(publicAddress: publicAddress, message: message)
    }
    
    func getEoaAddress() -> String {
        return self.publicAddress ?? ""
    }
}

extension APIReferenceViewController {
    func getSmartAccountAddress() async throws {
        let aa = ParticleNetwork.getAAService()!
        let eoaAddress = ""
        let chainInfo = ParticleNetwork.getChainInfo()
        let smartAccount = try await aa.getSmartAccount(by: eoaAddress, chainInfo: chainInfo).value
        print(smartAccount.smartAccountAddress)
    }
}
