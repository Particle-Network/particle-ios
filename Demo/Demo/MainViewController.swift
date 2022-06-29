//
//  MainViewController.swift
//  Demo
//
//  Created by link on 2022/5/13.
//

import Foundation
import ParticleAuthService
import ParticleNetworkBase
import ParticleWalletAPI
import ParticleWalletGUI
import RxSwift
import UIKit

class MainViewController: UIViewController {
    private let bag = DisposeBag()
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var appleButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var openWalletButton: UIButton!
    @IBOutlet var switchChainButton: UIButton!
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var welcomeImageView: UIImageView!
    @IBOutlet var coreImageView: UIImageView!
    @IBOutlet var apiReferenceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLogin(true)
        switchChainButton.titleLabel!.lineBreakMode = .byWordWrapping
        switchChainButton.titleLabel!.numberOfLines = 2
        switchChainButton.titleLabel!.textAlignment = .center
        switchChainButton.transform = CGAffineTransform(rotationAngle: Double.pi / 4)
        
        if ParticleAuthService.isUserLoggedIn() {
            showLogin(false)
        } else {
            showLogin(true)
        }
        
        let user = ParticleAuthService.getUserInfo()
        print(user)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    @IBAction func loginWithEmail() {
        login(type: .email)
    }
    
    @IBAction func loginWithPhone() {
        login(type: .phone)
    }
    
    @IBAction func loginWithGoogle() {
        login(type: .google)
    }
    
    @IBAction func loginWithApple() {
        login(type: .apple)
    }
    
    @IBAction func loginWithFacebook() {
        login(type: .facebook)
    }
    
    @IBAction func logout() {
        ParticleAuthService.logout().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let success):
                print(success)
                self.showLogin(true)
            }
            
        }.disposed(by: bag)
    }
    
    @IBAction func openWallet() {
        PNRouter.navigatorWallet(display: .token)
    }
    
    @IBAction func switchChainClick() {
        let vc = SwitchChainViewController()
        vc.selectHandler = { [weak self] in
            self?.updateUI()
        }
        present(vc, animated: true)
    }
    
    private func showLogin(_ isShow: Bool) {
        stackView.isHidden = !isShow
        coreImageView.isHidden = !isShow
        logoutButton.isHidden = isShow
        openWalletButton.isHidden = isShow
        welcomeImageView.isHidden = isShow
        apiReferenceButton.isHidden = isShow
        if isShow {
            welcomeLabel.text = "Sign in to \nParticle Wallet"
            welcomeLabel.numberOfLines = 2
        } else {
            welcomeLabel.text = "Welcome!"
        }
    }
    
    private func updateUI() {
        let name = ParticleNetwork.getChainName().nameString
        let network = ParticleNetwork.getChainName().network
        
        switchChainButton.setTitle("\(name) \n \(network.lowercased())", for: .normal)
    }
}

// MARK: - Solana Service

extension MainViewController {
    func getSolanaPrice() {
        let addresses = ["native"]
        ParticleWalletAPI.getSolanaService().getPrice(by: addresses, currencies: ["usd"]).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getSolanaTokensAndNFTs() {
        let address = ""
        ParticleWalletAPI.getSolanaService().getTokensAndNFTs(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getSolanaTransactions() {
        let address = ""
        ParticleWalletAPI.getSolanaService().getTransactions(by: address, beforeSignature: nil, untilSignature: nil, limit: 1000).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getSolanaTokenList() {
        ParticleWalletAPI.getSolanaService().getTokenList().subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func solanaRpc() {
        let method = "getBalance"
        let params: [Encodable?] = ["8FE27ioQh3T7o22QsYVT5Re8NnHFqmFNbdqwiF3ywuZQ"]
        ParticleWalletAPI.getSolanaService().rpc(method: method, params: params).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func solanaSerializeTransaction() {
        let transactionType: SolanaTransactionType = .transferSol
        let sender = ""
        let receiver = ""
        let lamports = BInt(0)
        let mintAddress: String? = nil
        let payer: String? = nil
        ParticleWalletAPI.getSolanaService().serializeTransaction(type: transactionType, sender: sender, receiver: receiver, lamports: lamports, mintAddress: mintAddress, payer: payer).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func evmAddCustomToken() {
        let address = ParticleAuthService.getAddress()
        let tokenAddresses: [String] = ["0xFab46E002BbF0b4509813474841E0716E6730136", "0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa"]
        ParticleWalletAPI.getEvmService().addCustomTokens(address: address, tokenAddresses: tokenAddresses).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tokenModels):
                print(tokenModels)
            }
        }.disposed(by: bag)
    }
    
    func solanaAddCustomToken() {
        let address = ParticleAuthService.getAddress()
        let tokenAddresses = ["8FE27ioQh3T7o22QsYVT5Re8NnHFqmFNbdqwiF3ywuZQ"]
        ParticleWalletAPI.getSolanaService().addCustomTokens(address: address, tokenAddresses: tokenAddresses).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tokenModels):
                print(tokenModels)
            }
        }.disposed(by: bag)
    }
}

// MARK: - EVM Service

extension MainViewController {
    func getEvmPrice() {
        let addresses = ["native"]
        ParticleWalletAPI.getEvmService().getPrice(by: addresses, currencies: ["usd"]).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getEvmTokensAndNFTs() {
        let address = ""
        ParticleWalletAPI.getEvmService().getTokensAndNFTs(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getEvmTokensAndNFTsFromDB() {
        let address = ""
        ParticleWalletAPI.getEvmService().getTokensAndNFTsFromDB(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getEvmTransactions() {
        let address = ""
        ParticleWalletAPI.getEvmService().getTransactions(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getEvmTransactionsFromDB() {
        let address = ""
        ParticleWalletAPI.getEvmService().getTransactionsFromDB(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func getEvmTokenList() {
        ParticleWalletAPI.getEvmService().getTokenList().subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result

        }.disposed(by: bag)
    }
    
    func evmRpc() {
        let method = "eth_getBalance"
        let params: [Encodable?] = ["0xfe3b557e8fb62b89f4916b721be55ceb828dbd73", "latest"]
        ParticleWalletAPI.getEvmService().rpc(method: method, params: params).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func erc20Transfer() {
        let contractAddress = ""
        let to = ""
        let amount = BInt(1)
        ParticleWalletAPI.getEvmService().erc20Transfer(contractAddress: contractAddress, to: to, amount: amount).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }

    func erc20Approve() {
        let contractAddress = ""
        let spender = ""
        let amount = BInt(1)
        ParticleWalletAPI.getEvmService().erc20Approve(contractAddress: contractAddress, spender: spender, amount: amount).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }

    func erc20TransferFrom() {
        let contractAddress = ""
        let from = ""
        let to = ""
        let amount = BInt(1)
        ParticleWalletAPI.getEvmService().erc20TransferFrom(contractAddress: contractAddress, from: from, to: to, amount: amount).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }

    func erc721SafeTransferFrom() {
        let contractAddress = ""
        let from = ""
        let to = ""
        let tokenId = ""
        ParticleWalletAPI.getEvmService().erc721SafeTransferFrom(contractAddress: contractAddress, from: from, to: to, tokenId: tokenId).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }

    func erc1155SafeTransferFrom() {
        let contractAddress = ""
        let from = ""
        let to = ""
        let id = ""
        let amount = BInt(0)
        let data: [UInt8] = []
        ParticleWalletAPI.getEvmService().erc1155SafeTransferFrom(contractAddress: contractAddress, from: from, to: to, id: id, amount: amount, data: data).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
    
    func customMethodAbiEncode() {
        let contractAddress = ""
        let methodName = ""
        let params: [String] = []
        let abiJsonString = ""
        ParticleWalletAPI.getEvmService().abiEncodeFunctionCall(contractAddress: contractAddress, methodName: methodName, params: params, abiJsonString: abiJsonString).subscribe { [weak self] _ in
            guard let self = self else { return }
            // handle result
        }.disposed(by: bag)
    }
}

extension MainViewController {
    private func login(type: LoginType) {
        ParticleAuthService.login(type: type).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                if let error = error as? ParticleNetwork.Error {
                    if case .authService(let responseError) = error {
                        let title = responseError.code?.description ?? ""
                        self.showToast(title: title, message: responseError.message)
                    }
                }
                print(error)
            case .success(let userinfo):
                print(userinfo)
                self.showLogin(false)
            }
            
        }.disposed(by: bag)
    }
}

extension UIViewController {
    func showToast(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
        present(alert, animated: true)
    }
}

struct TypedDataV1: Encodable {
    let type: String
    let name: String
    let value: String
}
