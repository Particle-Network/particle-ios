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

    func checkWalletConnectAddress(_ string: String) -> Bool {
        // should detect both v1 and v2
        // wc:DDCBBAA8-B1F1-4B98-8F74-84939E0B1533@1?bridge=https%3A%2F%2Fbridge%2Ewalletconnect%2Eorg%2F&key=3da9dbb33b560beeb1750203a8d0e3487b4fe3fdd7b7953d79fbccadae8aab48
        // wc:ca9ecbc30ab3b584ab1cd570f494bb344a2801c4543523c47c28f1ee13d8d9f9@2?relay-protocol=irn&symKey=5c09d4849fd38d982e2ed4da344921abdf408853b9840f02dccfe16492499d9b
        if string.prefix(3) == "wc:" {
            if string.contains("@1") {
                if let urlCom = URLComponents(string: string) {
                    var hasBridge = false
                    var hasKey = false
                    if let queryItems = urlCom.queryItems {
                        for item in queryItems {
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
            } else if string.contains("@2") {
                if let urlCom = URLComponents(string: string) {
                    var hasBridge = false
                    var hasKey = false
                    if let queryItems = urlCom.queryItems {
                        for item in queryItems {
                            if item.name == "relay-protocol", item.value != nil {
                                hasBridge = true
                            }
                            if item.name == "symKey", item.value != nil {
                                hasKey = true
                            }
                        }
                        if hasBridge, hasKey {
                            return true
                        }
                    }
                }
            } else {
                return false
            }
        }
        return false
    }
    
}
