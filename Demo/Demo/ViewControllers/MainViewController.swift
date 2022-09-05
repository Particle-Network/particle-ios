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
import SwiftUI
import UIKit

class MainViewController: UIViewController {
    private let bag = DisposeBag()
    @IBOutlet var bgView: UIImageView!
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var metamaskButton: UIButton!
    
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var appleButton: UIButton!
    @IBOutlet var discordButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var logoImageView: UIImageView!
    
    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet var stackBottomConstarint: NSLayoutConstraint!
    @IBOutlet var collecionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collecionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: CarouselCollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    lazy var data: [MainDataModel] = (0 ... 3).map {
        MainDataModel(imageName: "main_image_\($0)", message: NSLocalizedString("main message \($0)", comment: "main_message"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        if AccountChecker.hasAccount() {
            view.subviews.forEach {
                if $0 != bgView {
                    $0.isHidden = true
                }
            }
        } else {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AccountChecker.hasAccount() {
            openWallet(animated: false)
        } else {
            view.subviews.forEach {
                if $0 != bgView {
                    $0.isHidden = false
                }
            }
        }
    }

    func setUI() {
        pageControl.numberOfPages = data.count
        pageControl.tintColor = .black

        collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(MainCollectionCell.self))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isAutoscrollEnabled = true
        
        collectionView.autoscrollTimeInterval = 2.0
        
        var width: CGFloat
        if UIScreen.main.bounds.height <= 667 {
            // CarouselCollectionView itemSize set float will cause error.
            // easy solution is set int number.
            width = CGFloat(Int(UIScreen.main.bounds.size.width * 0.8))
        } else {
            width = UIScreen.main.bounds.size.width
        }
        
        collecionViewWidthConstraint.constant = width
        let height = CGFloat(Int(width * 340.0 / 375.0))
        collecionViewHeightConstraint.constant = height
        
        collectionView.flowLayout.itemSize = CGSize(width: width, height: height)
        collectionView.flowLayout.sectionInset = .zero
        collectionView.reloadData()
        
        stackBottomConstarint.constant = UIScreen.main.bounds.height * 0.064
        titleTopConstraint.constant = UIScreen.main.bounds.height * 0.0714
        
        [emailButton, metamaskButton].forEach {
            $0!.layer.cornerRadius = 22.5
            $0!.layer.masksToBounds = true
            
            $0!.imageView!.snp.makeConstraints { make in
                make.width.height.equalTo(37)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(17)
            }
            
            $0!.titleLabel!.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            $0!.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0!.titleLabel?.textAlignment = .center
        }
        
        if UIApplication.shared.windows[0].safeAreaInsets.bottom != 0 {
            logoBottomConstraint.constant = 17
        } else {
            logoBottomConstraint.constant = 7
        }
        
        emailButton.setTitle(NSLocalizedString("login with", comment: "login with").replacingOccurrences(of: "%@", with: NSLocalizedString("email", comment: "email")), for: .normal)
        
        metamaskButton.setTitle(NSLocalizedString("login with", comment: "login with").replacingOccurrences(of: "%@", with: NSLocalizedString("MetaMask", comment: "MetaMask")), for: .normal)
    }
    
    @IBAction func loginWithEmail() {
//        if AccountChecker.hasAccount() {
//        openWallet()
//        } else {
        login(type: .email)
//        }
    }
    
    @IBAction func loginWithMetaMask() {
        connect(walletType: .metaMask)
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
    
    @IBAction func loginWithDiscord() {
        login(type: .discord)
    }
    
    @IBAction func loginMore() {
        PNRouter.navigatorLoginList().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                if let error = error as? ParticleNetwork.Error {
                    if case .invalidResponse(let responseError) = error {
                        if responseError.code == ResponseError.userCancel.code {
                            // user cancel, do nothing.
                        } else {
                            let title = responseError.code?.description ?? ""
                            self.showToast(title: title, message: responseError.message)
                        }
                    }
                }
            case .success(let account):
                print(account)
                self.openWallet(animated: true)
            }
        }.disposed(by: bag)
    }
    
    private func login(type: LoginType, supportAuthType: [SupportAuthType] = [SupportAuthType.all], loginFormMode: Bool = false) {
        ParticleAuthService.login(type: type, supportAuthType: supportAuthType, loginFormMode: loginFormMode).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                
                print(error)
            case .success(let userinfo):
                print(userinfo)
                self.openWallet(animated: true)
            }
        }.disposed(by: bag)
    }

    private func connect(walletType: WalletType) {
        let adapter = ParticleConnect.getAllAdapters().filter {
            $0.walletType == walletType
        }.first!
        
        var single: Single<Account?>
        if adapter.walletType == .walletConnect {
            single = (adapter as! WalletConnectAdapter).connectWithQrCode(from: self)
        } else {
            single = adapter.connect(.none)
        }
        single.subscribe { [weak self] result in
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
                self.openWallet(animated: true)
            }
        }.disposed(by: bag)
    }
    
    private func openWallet(animated: Bool) {
        PNRouter.navigatorWallet(hiddenBackButton: true, animated: animated)
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
    
    func getChainInfo() -> String {
        let chainInfo = ParticleNetwork.getChainInfo()
        return ["chain_name": chainInfo.name, "chain_id": chainInfo.chainId, "chain_id_name": chainInfo.network].jsonString() ?? ""
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

extension MainViewController: CarouselCollectionViewDataSource {
    var numberOfItems: Int {
        return data.count
    }

    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, cellForItemAt index: Int, fakeIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MainCollectionCell.self), for: fakeIndexPath) as! MainCollectionCell
        let model = data[index]
        cell.imageView.image = UIImage(named: model.imageName)!
        return cell
    }

    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didSelectItemAt index: Int) {
        print("Did select item at \(index)")
    }

    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didDisplayItemAt index: Int) {
        pageControl.currentPage = index
        messageLabel.text = data[index].message
    }
}
