//
//  ViewController.swift
//  Demo
//
//  Created by link on 2022/5/12.
//

import Alamofire
import AuthenticationServices
import ParticleNetwork
import ParticleNetworkGUI
import RxCocoa
import RxSwift
import SafariServices
import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    let bag = DisposeBag()

    var tableView: UITableView!

    var actionNames: BehaviorRelay<[String]> =
        BehaviorRelay(value:
            [
                "Open Wallet",
                "Receive Token",
                "Send Token",
                "Token transaction records",
                "NFT details",
                "NFT Send",
                "Login",
                "Logout",
                "Clear NFT Caches"
            ])

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    func setUpTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.rx.setDelegate(self).disposed(by: bag)
        actionNames.asDriver().drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
            _, element, cell in
            cell.textLabel?.text = element

        }.disposed(by: bag)

        tableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let indexPath = indexPath.element else { return }

            let row = indexPath.row
            self.tableView.deselectRow(at: indexPath, animated: false)
            switch row {
            case 0:
                PNRouter.navigator(routhPath: .wallet)
            case 1:
                let tokenReceiveConfig = TokenReceiveConfig(tokenAddress: "GCxgQbbvJc4UyqGCsUAUa38npzZX27EMxZwckLuWeEkt")
                PNRouter.navigator(routhPath: .tokenReceive, values: ["tokenReceiveConfig": tokenReceiveConfig])
            case 2:
                let tokenSendConfig = TokenSendConfig(tokenAddress: nil, toAddress: "HKerFyAkFKgTsrAZBe88MHKnbRMjeHL4NFguSPTyiT9g", amount: 232200000)
                PNRouter.navigator(routhPath: .tokenSend, values: ["tokenSendConfig": tokenSendConfig])
            case 3:
                let tokenTransactionRecordsConfig = TokenTransactionRecordsConfig(tokenAddress: "So11111111111111111111111111111111111111112")
                PNRouter.navigator(routhPath: .tokenTransactionRecords, values: ["tokenTransactionRecordsConfig": tokenTransactionRecordsConfig])
            case 4:
                let nftDetailsConfig = NFTDetailsConfig(mintAddress: "5ZLs4k7eymdEssH2g5EETEs4BoKzL8vFXmYEWarQGGtW")
                PNRouter.navigator(routhPath: .nftDetails, values: ["nftDetailsConfig": nftDetailsConfig])
            case 5:
                let nftSendConfig = NFTSendConfig(mintAddress: "5ZLs4k7eymdEssH2g5EETEs4BoKzL8vFXmYEWarQGGtW", toAddress: "HKerFyAkFKgTsrAZBe88MHKnbRMjeHL4NFguSPTyiT9g")
                PNRouter.navigator(routhPath: .nftSend, values: ["nftSendConfig": nftSendConfig])
            case 6:
                ParticleNetwork.login(type: .email).subscribe { [weak self] result in
                    switch result {
                    case .failure(let error):
                        Logger.log(message: error, event: .error, tag: .core)
                    case .success(let user):
                        print(user)
                    }
                }.disposed(by: self.bag)
            case 7:
                ParticleNetwork.logout().subscribe { [weak self] result in
                    switch result {
                    case .failure(let error):
                        Logger.log(message: error, event: .error, tag: .core)
                    case .success(let str):
                        print(str)
                    }
                }.disposed(by: self.bag)
            case 8:
                let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("NFTCache")
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    print("Remove NFTCache succeed")
                } catch {
                    print("Remove NFTCache failed error = \(error)")
                }

            default: break
            }

        }.disposed(by: bag)
    }
}



