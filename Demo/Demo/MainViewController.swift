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
    @IBOutlet var loginWithEmailButton: UIButton!
    @IBOutlet var loginWithPhoneButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var openWalletButton: UIButton!
    @IBOutlet var switchChainButton: UIButton!
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var welcomeImageView: UIImageView!
    @IBOutlet var coreImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLogin(true)
        switchChainButton.titleLabel!.lineBreakMode = .byWordWrapping
        switchChainButton.titleLabel!.numberOfLines = 2
        switchChainButton.titleLabel!.textAlignment = .center
        switchChainButton.transform = CGAffineTransform(rotationAngle: Double.pi / 4)
        
        if ParticleAuthService.isLogin() {
            showLogin(false)
        } else {
            showLogin(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    @IBAction func loginWithEmail() {
        ParticleAuthService.login(type: .email).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let userinfo):
                print(userinfo)
                
                self.showLogin(false)
            }
        }.disposed(by: bag)
    }
    
    @IBAction func loginWithPhone() {
        ParticleAuthService.login(type: .phone).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let userinfo):
                print(userinfo)
                self.showLogin(false)
            }
            
        }.disposed(by: bag)
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
        loginWithEmailButton.isHidden = !isShow
        loginWithPhoneButton.isHidden = !isShow
        coreImageView.isHidden = !isShow
        
        logoutButton.isHidden = isShow
        openWalletButton.isHidden = isShow
        welcomeImageView.isHidden = isShow
        welcomeLabel.isHidden = isShow
    }
    
    private func updateUI() {
        let name = ParticleNetwork.getChainName().name
        let network = ParticleNetwork.getChainName().network
        
        switchChainButton.setTitle("\(name) \n \(network.lowercased())", for: .normal)
    }
}

// MARK: - Solana Service

extension MainViewController {
    func getSolanaPrice() {
        let addresses = ["native"]
        ParticleWalletAPI.getSolanaService().enhancedGetPrice(by: addresses, currencies: ["usd"]).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func getSolanaTokensAndNFTs() {
        let address = ""
        ParticleWalletAPI.getSolanaService().enhancedGetTokensAndNFTs(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func getSolanaTransactions() {
        let address = ""
        ParticleWalletAPI.getSolanaService().enhancedGetTransactions(by: address, beforeSignature: nil, untilSignature: nil, limit: 1000).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func getSolanaTokenList() {
        ParticleWalletAPI.getSolanaService().getTokenList().subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func solanaRpc() {
        let method = "getBalance"
        let params: [Encodable?] = ["8FE27ioQh3T7o22QsYVT5Re8NnHFqmFNbdqwiF3ywuZQ"]
        ParticleWalletAPI.getSolanaService().rpc(method: method, params: params).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func solanaSerializeTransaction() {
        let transactionType: SolanaTransactionType = .transferSol
        let sender = ""
        let receiver = ""
        let lamports = BInt(0)
        let mintAddress: String? = nil
        let payer: String? = nil
        ParticleWalletAPI.getSolanaService().enhancedSerializeTransaction(type: transactionType, sender: sender, receiver: receiver, lamports: lamports, mintAddress: mintAddress, payer: payer).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
}

// MARK: - EVM Service

extension MainViewController {
    func getEvmPrice() {
        let addresses = ["native"]
        ParticleWalletAPI.getEvmService().particleGetPrice(by: addresses, vsCurrencies: ["usd"]).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func getEvmTokensAndNFTs() {
        let address = ""
        ParticleWalletAPI.getEvmService().particleGetTokensAndNFTs(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func getEvmTransactions() {
        let address = ""
        ParticleWalletAPI.getEvmService().particleGetTransactions(by: address).subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result
        }.disposed(by: bag)
    }
    
    func getEvmTokenList() {
        ParticleWalletAPI.getEvmService().getTokenList().subscribe { [weak self] _ in
            guard let self = self else { return }
            // hande result

        }.disposed(by: bag)
    }
    
    func evmRpc() {
//        let method = "eth_getBalance"
//        let params: [Encodable?] = ["0xfe3b557e8fb62b89f4916b721be55ceb828dbd73", "latest"]
//        ParticleWalletAPI.getEvmService().rpc(method: method, params: params).subscribe { [weak self] _ in
//            guard let self = self else { return }
//            // hande result
//        }.disposed(by: bag)
    }
}
