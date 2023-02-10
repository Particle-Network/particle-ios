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
import WalletConnectSwift

class ViewController: UIViewController, ParticleWalletConnectDelegate {
    @IBOutlet var tableView: UITableView!
    
    let bag = DisposeBag()
    var sessions: [Session] = []
    let cellIdentifier = "sessionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.allowsSelection = false
        // Set ParticleWalletConnect delegate
        ParticleWalletConnect.shared.delegate = self
        // set SDWebImage to support webp format.
        let webpCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(webpCoder)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        loadData()
    }
    
    @IBAction func loginParticle() {
        ParticleAuthService.login(type: .email).subscribe { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let userInfo):
                print(userInfo)
            }
        }.disposed(by: bag)
    }

    @IBAction func scanButtonClick() {
        let vc = ScanViewController()
        vc.scanHandler = { [weak self] code in
            guard let self = self else { return }
            ParticleWalletConnect.shared.connect(code: code)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadData() {
        sessions = ParticleWalletConnect.shared.getAllSessions()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        let name = sessions[indexPath.row].dAppInfo.peerMeta.name
        let url = sessions[indexPath.row].dAppInfo.peerMeta.url
        let icon = sessions[indexPath.row].dAppInfo.peerMeta.icons.first
        cell.textLabel?.text = name
        cell.imageView?.sd_setImage(with: icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration?
    {
        let session = sessions[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Disconnect", handler: { _, _,
                _ in
            
            ParticleWalletConnect.shared.disconnect(session: session)
            ParticleWalletConnect.shared.removeSession(by: session.url.topic)
            self.loadData()
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func transmit(method: String, params: [Encodable], successHandler: @escaping (Data?) -> Void, failureHandler: @escaping (Error) -> Void) {
        ParticleProvider.request(method: method, params: params).subscribe { data in
            successHandler(data)
        } onFailure: { error in
            failureHandler(error)
        }.disposed(by: bag)
    }
}

extension ViewController {
    
    func request(topic: String, method: String, params: [Encodable], completion: @escaping (WCResult<Data?>) -> Void) {
        // call ParticleProvider to handle request from dapp
        // also you can interrupt method by yourself
        
        transmit(method: method, params: params) { data in
            completion(.success(data))
        } failureHandler: { error in
            print(error)
            if let responseError = error as? ParticleNetwork.ResponseError {
                let err: WCResponseError = WCResponseError(code: responseError.code, message: responseError.message, data: responseError.data)
                completion(.failure(err))
            }
        }
    }
    
    func shouldStartSession(_ session: WalletConnectSwift.Session, completion: @escaping (String, Int) -> Void) {
        DispatchQueue.main.async {
            let chainId = ParticleNetwork.getChainInfo().chainId
            let publicAddress = ParticleAuthService.getAddress()
        
            // control if connect
            // in demo, present a alert
            let message = (session.dAppInfo.peerMeta.name ?? "") + "\n" + (session.dAppInfo.peerMeta.url?.absoluteString ?? "")
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
    
    func didConnectSession(_ session: WalletConnectSwift.Session) {
        print("Did connect session \(session)")
    }
    
    func didDisconnect(_ session: WalletConnectSwift.Session) {
        print("Did disconnect session \(session)")
    }
}
