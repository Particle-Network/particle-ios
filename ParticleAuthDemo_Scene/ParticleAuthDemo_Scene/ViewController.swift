//
//  ViewController.swift
//  ParticleAuthDemo_Scene
//
//  Created by link on 2022/11/3.
//

import UIKit
import RxSwift
import ParticleAuthService

class ViewController: UIViewController {

    let bag = DisposeBag()
    
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginClick(_ sender: UIButton) {
        ParticleAuthService.login(type: .email).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let userInfo):
                print(userInfo)
            }
            
        }.disposed(by: bag)
    }
    

}


