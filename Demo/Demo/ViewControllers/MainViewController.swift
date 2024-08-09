//
//  MainViewController.swift
//  Demo
//
//  Created by link on 2022/5/13.
//

import AuthCoreAdapter
import Base58_swift
import ConnectCommon
import Foundation
import ParticleAuthCore
import ParticleConnect
import ParticleConnectKit
import ParticleNetworkBase
import ParticleNetworkChains
import ParticleWalletAPI
import ParticleWalletGUI
import RxSwift
import SwiftUI
import UIKit

class Counter: ObservableObject {
    @Published var selectedItems: Set<ChainInfo> = Set()
}

class MainViewController: UIViewController {
    var counter: Counter = .init()

    private let bag = DisposeBag()
    @IBOutlet var bgView: UIImageView!
    @IBOutlet var emailButton: UIButton!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!

    @IBOutlet var logoImageView: UIImageView!

    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet var collecionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collecionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: CarouselCollectionView!
    @IBOutlet var pageControl: UIPageControl!

    let auth = Auth()
    // control develop mode
    // before build ipa, set false
    var isDevelopMode: Bool {
        return false
//        return true
    }

    var data: [MainDataModel] {
        return (0 ... 3).map {
            let string = self.getString(by: "main message \($0)")
            return MainDataModel(imageName: "main_image_\($0)", message: string)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

        if isDevelopMode {
        } else {
            if AccountChecker.hasAccount() {
                for subview in view.subviews {
                    if subview != bgView {
                        subview.isHidden = true
                    }
                }
            } else {}
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        emailButton.setTitle(getString(by: "login or sign up"), for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isDevelopMode {
            ParticleConnect.setWalletConnectV2SupportChainInfos(Array(counter.selectedItems))
        } else {
            if AccountChecker.hasAccount() {
                openWallet(animated: false)
            } else {}
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
        if UIScreen.main.bounds.height <= 736 {
            // CarouselCollectionView itemSize set float will cause error.
            // easy solution is set int number.
            width = CGFloat(Int(UIScreen.main.bounds.size.width * 0.8))
            titleTopConstraint.constant = 10
        } else {
            width = UIScreen.main.bounds.size.width
            titleTopConstraint.constant = UIScreen.main.bounds.height * 0.0714
        }

        collecionViewWidthConstraint.constant = width
        let height = CGFloat(Int(width * 340.0 / 375.0))
        collecionViewHeightConstraint.constant = height

        collectionView.flowLayout.itemSize = CGSize(width: width, height: height)
        collectionView.flowLayout.sectionInset = .zero
        collectionView.reloadData()

        for item in [emailButton] {
            item!.layer.cornerRadius = 18
            item!.layer.masksToBounds = true

            item!.imageView!.snp.makeConstraints { make in
                make.width.height.equalTo(37)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(17)
            }

            item!.titleLabel!.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }

            item!.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            item!.titleLabel?.textAlignment = .center
        }

        if UIApplication.shared.windows[0].safeAreaInsets.bottom != 0 {
            logoBottomConstraint.constant = 17
        } else {
            logoBottomConstraint.constant = 7
        }
    }

    @IBAction func loginWithEmail() {
        let connectOptions: [ConnectOption] = [.email, .phone, .social, .wallet]
        let socialProviders: [EnableSocialProvider] = [.google, .apple, .discord, .twitter, .facebook, .github, .microsoft, .twitch, .linkedin]
        let wallets: [String] = ["MetaMask", "OKX", "Phantom", "Trust", "Bitget", "WalletConnect"]

        let walletProviders = wallets.map {
            if $0.lowercased() == "metamask" {
                EnableWalletProvider(name: $0, state: .recommended)
            } else {
                EnableWalletProvider(name: $0, state: .none)
            }
        }

        let layoutOptions = AdditionalLayoutOptions(isCollapseWalletList: false, isSplitEmailAndSocial: true, isSplitEmailAndPhone: false, isHideContinueButton: false)
        let designOptions = DesignOptions(icon: .local(UIImage(named: "particle_icon")!))

        let config = ConnectKitConfig(connectOptions: connectOptions, socialProviders: socialProviders, walletProviders: walletProviders, additionalLayoutOptions: layoutOptions, designOptions: designOptions)
        Task {
            do {
                let account = try await ParticleConnectUI.connect(config: config).value
                print(account as Any)
                self.openWallet(animated: true)
            } catch {
                if let responseError = error as? ParticleNetwork.ResponseError {
                    if responseError.code == ParticleNetwork.ResponseError.userCancel.code {
                        // user cancel, do nothing.
                    } else {
                        let title = responseError.code?.description ?? ""
                        self.showToast(title: title, message: responseError.message)
                    }
                }
                print(error)
            }
        }
    }

    private func openWallet(animated: Bool) {
        if isDevelopMode {
            PNRouter.navigatorWallet(hiddenBackButton: false, animated: animated)
        } else {
            PNRouter.navigatorWallet(hiddenBackButton: true, animated: animated)
        }
    }
}

extension MainViewController: CarouselCollectionViewDataSource {
    var numberOfItems: Int {
        return data.count
    }

    func carouselCollectionView(_: CarouselCollectionView, cellForItemAt index: Int, fakeIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MainCollectionCell.self), for: fakeIndexPath) as! MainCollectionCell
        let model = data[index]
        cell.imageView.image = UIImage(named: model.imageName)!
        return cell
    }

    func carouselCollectionView(_: CarouselCollectionView, didSelectItemAt index: Int) {
        if isDevelopMode == false { return }
        print("Did select item at \(index)")

//        let vc = AuthServiceTestViewController()
//        let vc = ConnectServiceTestViewController()
//        let vc = APIServiceTestViewController()
//        let vc = WalletServiceTestViewController()
//        let vc = EVMAPIReqeustViewController()
//        let vc = SolanaAPIRequestViewController()
//        let vc = UIHostingController(rootView: ChainListView(counter: counter))
//        vc.modalPresentationStyle = .pageSheet
//        present(vc, animated: true)
    }

    func carouselCollectionView(_: CarouselCollectionView, didDisplayItemAt index: Int) {
        pageControl.currentPage = index
        messageLabel.text = data[index].message
    }

    func getString(by key: String) -> String {
        let language = ParticleNetwork.getLanguage().rawValue
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        let string = bundle.localizedString(forKey: key, value: nil, table: nil)
        return string
    }

    func test() {
//        ParticleAuthService.login(type: .google).subscribe { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let userInfo):
//                print(userInfo)
//            }
//        }.disposed(by: bag)

//        ParticleAuthService.login(type: .jwt, account: "your jwt").subscribe { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let userInfo):
//                print(userInfo)
//            }
//        }.disposed(by: bag)

//        ParticleAuthService.login(type: .email, authorization: .init(message: "Hello Particle", isUnique: false)).subscribe { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let userInfo):
//                print(userInfo)
//            }
//        }.disposed(by: bag)

//        ParticleAuthService.signMessage("Hello Particle").subscribe { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let signature):
//                print(signature)
//            }
//        }.disposed(by: bag)

//        ParticleAuthService.fastLogout().subscribe { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success:
//                print("success")
//            }
//        }.disposed(by: bag)

//        let transaction = ""
//        ParticleAuthService.signAndSendTransaction(transaction).subscribe { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let signature):
//                print(signature)
//            }
//        }.disposed(by: bag)
    }
}
