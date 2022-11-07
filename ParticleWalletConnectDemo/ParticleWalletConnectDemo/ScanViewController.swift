//
//  ScanViewController.swift
//  ParticleWalletConnectDemo
//
//  Created by link on 2022/11/7.
//

import UIKit

class ScanViewController: UIViewController {
    var scanHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        QRCodeTool.shareInstance.scanQRCode(inView: view) { [weak self] results in
            guard let self = self else { return }
            if results.count > 0 {
                let str = results[0]
                self.resolveString(str)
            }
        }
    }
    
    private func resolveString(_ str: String) {
        if let scanHandler = scanHandler {
            if checkWalletConnectAddress(str) {
                QRCodeTool.shareInstance.stopScan()
                navigationController?.popViewController(animated: true)
                scanHandler(str)
            }
        }
    }

    private func checkWalletConnectAddress(_ string: String) -> Bool {
        if string.prefix(3) == "wc:" {
            if let urlCom = URLComponents(string: string) {
                var hasBridge = false
                var hasKey = false
                if let queryItems = urlCom.queryItems {
                    for item in queryItems {
                        print(item)
                        if item.name == "bridge", item.value != nil {
                            hasBridge = true
                        }
                        if item.name == "key" {
                            hasKey = true
                        }
                    }
                    if hasBridge, hasKey {
                        return true
                    }
                }
            }
        }
        return false
    }
}
