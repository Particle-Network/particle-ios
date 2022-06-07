//
//  MainViewController.swift
//  Demo
//
//  Created by link on 2022/5/13.
//

import Foundation
import ParticleNetworkBase
import ParticleWalletGUI
import ParticleAuthService
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
        
        self.switchChainButton.setTitle("\(name) \n \(network.lowercased())", for: .normal)
    }
}
