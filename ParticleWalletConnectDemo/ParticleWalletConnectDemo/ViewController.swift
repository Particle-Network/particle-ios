//
//  ViewController.swift
//  ParticleWalletConnectDemo
//
//  Created by link on 2022/11/7.
//

import ParticleAuthService
import ParticleNetworkBase
import ParticleWalletConnect
import RxSwift
import SDWebImage
import SDWebImageWebPCoder
import UIKit

class ViewController: UIViewController, ParticleWalletConnectDelegate {
    @IBOutlet var tableView: UITableView!
    
    let bag = DisposeBag()
    var dapps: [DappMetaData] = []
    let cellIdentifier = "sessionCell"
    
    lazy var pwc = ParticleWalletConnect()
    
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.allowsSelection = false
        // Set ParticleWalletConnect delegate
        pwc.delegate = self
        // set SDWebImage to support webp format.
        let webpCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(webpCoder)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        loadData()
    }
    
    @IBAction func loginParticle() {
        ParticleAuthService.login(type: .email).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let userInfo):
                print(userInfo)
                self.userInfo = userInfo
            }
        }.disposed(by: bag)
    }

    @IBAction func scanButtonClick() {
        let vc = ScanViewController()
        vc.scanHandler = { [weak self] code in
            guard let self = self else { return }
            Task {
                do {
                    try await self.pwc.connect(code: code)
                } catch {
                    print(error)
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadData() {
        guard let publicAddress = userInfo?.wallets.first(where: {
            $0.chainName == "evm_chain"
        })?.publicAddress else {
            print("no evm address")
            return
        }
        dapps = pwc.getAllDapps(publicAddress: publicAddress)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dapps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        let dapp = dapps[indexPath.row]
        let name = dapp.name
        let icon = dapp.icons.first
        cell.textLabel?.text = name
        if let icon = icon, let iconUrl = URL(string: icon) {
            cell.imageView?.sd_setImage(with: iconUrl)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration?
    {
        let dapp = dapps[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Disconnect", handler: { _, _,
                _ in
            
            Task {
                do {
                    try await self.pwc.disconnect(topic: dapp.topic)
                } catch {
                    print(error)
                }
            }
           
            self.loadData()
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension ViewController {
    func request(topic: String, method: String, params: [Encodable], completion: @escaping (WCResult<Data?>) -> Void) {
        // call ParticleSDK to handle request from dapp
        // also you can interrupt method by yourself
        
    }
    
    func shouldConnectDapp(_ dappMetaData: DappMetaData, completion: @escaping (String, Int) -> Void) {
        DispatchQueue.main.async {
            let chainId = ParticleNetwork.getChainInfo().chainId
            let publicAddress = ParticleAuthService.getAddress()
        
            // control if connect
            // in demo, present a alert
            let message = dappMetaData.name + "\n" + dappMetaData.url
            let vc = UIAlertController(title: "Connect dapp", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let connectAction = UIAlertAction(title: "Connect", style: .default) { _ in
                completion(publicAddress, chainId)
                self.loadData()
            }
        
            vc.addAction(cancelAction)
            vc.addAction(connectAction)
        
            self.present(vc, animated: true)
        }
    }
    
    func didConnectDapp(_ topic: String) {
        print("Did connect dapp \(topic)")
    }
    
    func didDisconnectDapp(_ topic: String) {
        print("Did disconnect dapp \(topic)")
    }
}
