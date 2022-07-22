//
//  SwitchChainViewController.swift
//  Demo
//
//  Created by link on 2022/6/6.
//  Copyright © 2022 ParticleNetwork. All rights reserved.
//

import Foundation
import ParticleAuthService
import ParticleNetworkBase
import RxSwift
import UIKit

typealias Chain = ParticleNetwork.ChainName
typealias SolanaNetwork = ParticleNetwork.SolanaNetwork
typealias EthereumNetwork = ParticleNetwork.EthereumNetwork
typealias BscNetwork = ParticleNetwork.BscNetwork
typealias PolygonNetwork = ParticleNetwork.PolygonNetwork
typealias AvalancheNetwork = ParticleNetwork.AvalancheNetwork
typealias FantomNetwork = ParticleNetwork.FantomNetwork
typealias ArbitrumNetwork = ParticleNetwork.ArbitrumNetwork
typealias MoonbeamNetwork = ParticleNetwork.MoonbeamNetwork
typealias MoonriverNetwork = ParticleNetwork.MoonriverNetwork
typealias HecoNetwork = ParticleNetwork.HecoNetwork
typealias AuroraNetwork = ParticleNetwork.AuroraNetwork
typealias HarmonyNetwork = ParticleNetwork.HarmonyNetwork
typealias KccNetwork = ParticleNetwork.KccNetwork

class SwitchChainViewController: UIViewController {
    let bag = DisposeBag()
    var selectHandler: (() -> Void)?
    let tableView = UITableView(frame: .zero, style: .grouped)

    var data: [[String: [String]]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureTableView()
    }

    func configureData() {
        data.append([Chain.solana(.mainnet).nameString: [
            SolanaNetwork.mainnet.rawValue, SolanaNetwork.testnet.rawValue, SolanaNetwork.devnet.rawValue
        ]])
        data.append([Chain.ethereum(.mainnet).nameString: [
            EthereumNetwork.mainnet.rawValue, EthereumNetwork.kovan.rawValue
        ]])
        data.append([Chain.bsc(.mainnet).nameString: [
            BscNetwork.mainnet.rawValue, BscNetwork.testnet.rawValue
        ]])
        data.append([Chain.polygon(.mainnet).nameString: [
            PolygonNetwork.mainnet.rawValue, PolygonNetwork.mumbai.rawValue
        ]])
        data.append([Chain.avalanche(.mainnet).nameString: [
            AvalancheNetwork.mainnet.rawValue, AvalancheNetwork.testnet.rawValue
        ]])
        data.append([Chain.fantom(.mainnet).nameString: [
            FantomNetwork.mainnet.rawValue, FantomNetwork.testnet.rawValue
        ]])
        data.append([Chain.arbitrum(.mainnet).nameString: [
            ArbitrumNetwork.mainnet.rawValue, ArbitrumNetwork.testnet.rawValue
        ]])
        data.append([Chain.moonbeam(.mainnet).nameString: [
            MoonbeamNetwork.mainnet.rawValue, MoonbeamNetwork.testnet.rawValue
        ]])
        data.append([Chain.moonriver(.mainnet).nameString: [
            MoonriverNetwork.mainnet.rawValue, MoonriverNetwork.testnet.rawValue
        ]])
        data.append([Chain.heco(.mainnet).nameString: [
            HecoNetwork.mainnet.rawValue, HecoNetwork.testnet.rawValue
        ]])
        data.append([Chain.aurora(.mainnet).nameString: [
            AuroraNetwork.mainnet.rawValue, AuroraNetwork.testnet.rawValue
        ]])
        data.append([Chain.harmony(.mainnet).nameString: [
            HarmonyNetwork.mainnet.rawValue, HarmonyNetwork.testnet.rawValue
        ]])
        data.append([Chain.kcc(.mainnet).nameString: [
            KccNetwork.mainnet.rawValue, KccNetwork.testnet.rawValue
        ]])
    }

    func configureTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SwitchChainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].values.first?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let network = data[indexPath.section].values.first?[indexPath.row] ?? ""
        cell.textLabel?.text = network
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        data[section].keys.first
    }
}

extension SwitchChainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let network = data[indexPath.section].values.first?[indexPath.row] ?? ""
        let name = data[indexPath.section].keys.first ?? ""

        var chainName: Chain
        switch name {
        case Chain.solana(.mainnet).nameString:
            chainName = .solana(SolanaNetwork(rawValue: network)!)
        case Chain.ethereum(.mainnet).nameString:
            chainName = .ethereum(EthereumNetwork(rawValue: network)!)
        case Chain.bsc(.mainnet).nameString:
            chainName = .bsc(BscNetwork(rawValue: network)!)
        case Chain.polygon(.mainnet).nameString:
            chainName = .polygon(PolygonNetwork(rawValue: network)!)
        case Chain.avalanche(.mainnet).nameString:
            chainName = .avalanche(AvalancheNetwork(rawValue: network)!)
        case Chain.fantom(.mainnet).nameString:
            chainName = .fantom(FantomNetwork(rawValue: network)!)
        case Chain.arbitrum(.mainnet).nameString:
            chainName = .arbitrum(ArbitrumNetwork(rawValue: network)!)
        case Chain.moonbeam(.mainnet).nameString:
            chainName = .moonbeam(MoonbeamNetwork(rawValue: network)!)
        case Chain.moonriver(.mainnet).nameString:
            chainName = .moonriver(MoonriverNetwork(rawValue: network)!)
        case Chain.heco(.mainnet).nameString:
            chainName = .heco(HecoNetwork(rawValue: network)!)
        case Chain.aurora(.mainnet).nameString:
            chainName = .aurora(AuroraNetwork(rawValue: network)!)
        case Chain.harmony(.mainnet).nameString:
            chainName = .harmony(HarmonyNetwork(rawValue: network)!)
        case Chain.kcc(.mainnet).nameString:
            chainName = .kcc(KccNetwork(rawValue: network)!)
        default:
            chainName = .ethereum(.mainnet)
        }
        if ParticleAuthService.isLogin() {
            ParticleAuthService.setChainName(chainName).subscribe {
                [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let userInfo):
                        print(String(describing: userInfo))

                        let alert = UIAlertController(title: "Switch network", message: "current network is \(name) - \(network)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

                            if let selectHandler = self.selectHandler {
                                selectHandler()
                            }
                            self.dismiss(animated: true)
                        }))

                        self.present(alert, animated: true)
                    }
            }.disposed(by: bag)
        } else {
            ParticleNetwork.setChainName(chainName)

            let alert = UIAlertController(title: "Switch network", message: "current network is \(name) - \(network)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

                if let selectHandler = self.selectHandler {
                    selectHandler()
                }
                self.dismiss(animated: true)
            }))

            present(alert, animated: true)
        }
    }
}
