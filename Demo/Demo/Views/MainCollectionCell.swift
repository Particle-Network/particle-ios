//
//  CVCell.swift
//  Demo
//
//  Created by link on 2022/8/12.
//  Copyright © 2022 ParticleNetwork. All rights reserved.
//

import Foundation
import UIKit

final class MainCollectionCell: UICollectionViewCell {
    
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
