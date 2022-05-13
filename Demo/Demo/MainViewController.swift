//
//  MainViewController.swift
//  Demo
//
//  Created by link on 2022/5/13.
//

import Foundation
import ParticleNetwork
import ParticleNetworkGUI
import RxSwift
import UIKit

class MainViewController: UIViewController {
    private let bag = DisposeBag()
    @IBOutlet var loginWithEmailButton: UIButton!
    @IBOutlet var loginWithPhoneButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var openWalletButton: UIButton!
    @IBOutlet var switchChainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLogin(true)
        switchChainButton.titleLabel!.lineBreakMode = .byWordWrapping
        switchChainButton.titleLabel!.numberOfLines = 2
        switchChainButton.titleLabel!.textAlignment = .center
        switchChainButton.transform = CGAffineTransform(rotationAngle: Double.pi / 4);
        switchChainButton.setTitle("Solana \n \(ParticleNetwork.getChainEnv().rawValue.lowercased())", for: .normal)
    }
    
    @IBAction func loginWithEmail() {
        ParticleNetwork.login(type: .email).subscribe { [weak self] result in
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
        ParticleNetwork.login(type: .phone).subscribe { [weak self] result in
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
        ParticleNetwork.logout().subscribe { [weak self] result in
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
        PNRouter.navigator(routhPath: .wallet)
    }
    
    @IBAction func switchChainClick() {
        let alert = UIAlertController(title: "Choose Chain", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "solana-mainnet", style: .default , handler:{ (UIAlertAction)in
                ParticleNetwork.setChainEnv(.main)
                self.switchChainButton.setTitle("Solana \n \(ParticleNetwork.getChainEnv().rawValue.lowercased())", for: .normal)
            }))
            
            alert.addAction(UIAlertAction(title: "solana-testnet", style: .default , handler:{ (UIAlertAction)in
                ParticleNetwork.setChainEnv(.testnet)
                self.switchChainButton.setTitle("Solana \n \(ParticleNetwork.getChainEnv().rawValue.lowercased())", for: .normal)
            }))

            alert.addAction(UIAlertAction(title: "solana-devnet", style: .default , handler:{ (UIAlertAction)in
                ParticleNetwork.setChainEnv(.devnet)
                self.switchChainButton.setTitle("Solana \n \(ParticleNetwork.getChainEnv().rawValue.lowercased())", for: .normal)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            }))
        
            self.present(alert, animated: true, completion: {
                
            })
    }
    
    private func showLogin(_ isShow: Bool) {
        loginWithEmailButton.isHidden = !isShow
        loginWithPhoneButton.isHidden = !isShow
        logoutButton.isHidden = isShow
        openWalletButton.isHidden = isShow
    }
}
