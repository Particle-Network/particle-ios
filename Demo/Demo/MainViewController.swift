//
//  MainViewController.swift
//  Demo
//
//  Created by link on 2022/5/13.
//

import ConnectCommon
import ConnectEVMAdapter
import ConnectPhantomAdapter
import ConnectSolanaAdapter
import ConnectWalletConnectAdapter
import Foundation
import ParticleAuthService
import ParticleConnect
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
    
    @IBOutlet var connectStackView: UIStackView!
    @IBOutlet var metamaskButton: UIButton!
    @IBOutlet var walletConnectButton: UIButton!
    @IBOutlet var phantomButton: UIButton!
    @IBOutlet var solanaButton: UIButton!
    @IBOutlet var evmButton: UIButton!
    
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
        
        if AccountChecker.hasAccount() {
            showLogin(false)
        } else {
            showLogin(true)
        }
        
        let user = ParticleAuthService.getUserInfo()
        print(String(describing: user))
        
        [metamaskButton, walletConnectButton, phantomButton].forEach {
            $0?.imageView?.layer.cornerRadius = 21.5
            $0?.imageView?.layer.masksToBounds = true
        }
        
//        ParticleAuthService.setModalPresentStyle(.fullScreen)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
        if AccountChecker.hasAccount() {
            showLogin(false)
        } else {
            showLogin(true)
        }
    }
    
    @IBAction func loginWithEmail() {
        login(type: .email, supportAuthType: [])
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
    
    private func login(type: LoginType, supportAuthType: [SupportAuthType] = SupportAuthType.allCases) {
        ParticleAuthService.login(type: type, supportAuthType: supportAuthType).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                if let error = error as? ParticleNetwork.Error {
                    if case .invalidResponse(let responseError) = error {
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
    
    @IBAction func connectMetaMask() {
        let adapters: [ConnectAdapter] = ParticleConnect.getAdapters(chainType: .evm)
        let adapter = adapters.first {
            $0 is MetaMaskConnectAdapter
        }
        
        if adapter != nil {
            connectAdapter(adapter: adapter!)
        }
    }
    
    @IBAction func connectWallet() {
        let adapters = ParticleConnect.getAdapters(chainType: .evm)
        let adapter = adapters.first {
            $0.walletType == .walletConnect
        }
        
        if adapter != nil {
            (adapter as! WalletConnectAdapter).connectWithQrCode(from: self).subscribe { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    if let connectError = error as? ConnectError {
                        let message = connectError.message
                        let code = connectError.code
                        
                        self.showToast(title: code == nil ? "" : String(code!), message: message)
                    }
                case .success(let account):
                    print(account)
                    self.showLogin(false)
                }
            }.disposed(by: bag)
        }
    }
    
    @IBAction func connectPhantom() {
        let adapters = ParticleConnect.getAdapters(chainType: .solana)
        let adapter = adapters.first {
            $0 is PhantomConnectAdapter
        }
        
        if adapter != nil {
            connectAdapter(adapter: adapter!)
        }
    }
    
    @IBAction func connectSolanaPrivateKey() {
        PNRouter.navigator(routhPath: .importPrivateKey, values: ["chainType": ChainType.solana])
    }
    
    @IBAction func connectEVMPrivateKey() {
        PNRouter.navigator(routhPath: .importPrivateKey, values: ["chainType": ChainType.evm])
    }
    
    private func connectAdapter(adapter: ConnectAdapter) {
        adapter.connect().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                if let connectError = error as? ConnectError {
                    let message = connectError.message
                    let code = connectError.code
                    self.showToast(title: code == nil ? "" : String(code!), message: message)
                }
            case .success(let account):
                print(account)
                self.showLogin(false)
            }
        }.disposed(by: bag)
    }
    
    @IBAction func logout() {
        ParticleAuthService.logout().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                if let error = error as? ParticleNetwork.Error {
                    if case .invalidResponse(let responseError) = error {
                        let title = responseError.code?.description ?? ""
                        self.showToast(title: title, message: responseError.message)
                    }
                }
                print(error)
            case .success(let success):
                print(success)
                self.showLogin(true)
            }
            
        }.disposed(by: bag)
    }
    
    @IBAction func openWallet() {
        PNRouter.navigatorWallet()
    }
    
    @IBAction func switchChainClick() {
        let vc = SwitchChainViewController()
        vc.selectHandler = { [weak self] in
            self?.updateUI()
        }
        present(vc, animated: true)
    }
    
    private func testGetTokensByTokenAddresses() {
        let address = ParticleAuthService.getAddress()
        let tokenAddresses = ["Fm9rHUTF5v3hwMLbStjZXqNBBoZyGriQaFM6sTFz3K8A"]
        ParticleWalletAPI.getEvmService().addCustomTokens(address: address, tokenAddresses: tokenAddresses).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tokenModels):
                print(tokenModels)
            }
        }.disposed(by: bag)
    }
    
    private func testEvmAddCustomToken() {
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
    
    private func switchChangeName() {
        let chainName = ParticleNetwork.ChainName.ethereum(.kovan)
        ParticleAuthService.setChainName(chainName).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let userInfo):
                print(userInfo)
            }
        }.disposed(by: bag)
    }
  
    private func showLogin(_ isShow: Bool) {
        stackView.isHidden = !isShow
        connectStackView.isHidden = !isShow
        coreImageView.isHidden = !isShow
        
        openWalletButton.isHidden = isShow
        welcomeImageView.isHidden = isShow
        
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

extension MainViewController {
    private func showToast(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        
        present(alert, animated: true)
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

// unity helpers
extension MainViewController {
    func getUserInfo() -> String {
        guard let userInfo = ParticleAuthService.getUserInfo() else { return "" }
        let statusModel = UnityStatusModel(status: true, json: userInfo)
        let data = try! JSONEncoder().encode(statusModel)
        let json = String(data: data, encoding: .utf8)
        return json ?? ""
    }
    
    func getChainName() -> String {
        let chainName = ParticleNetwork.getChainName()
        return ["chain_name": chainName.nameString, "chain_id": chainName.chainId, "chain_id_name": chainName.network].jsonString() ?? ""
    }
}

struct UnityStatusModel<T: Codable>: Codable {
    let status: Bool
    let json: T
}

extension Dictionary {
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
