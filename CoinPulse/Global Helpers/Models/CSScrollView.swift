//
//  CSScrollView.swift
//  CoinPulse
//
//  Created by macbook on 19.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CSScrollView: UIScrollView {
    
    let contentView = UIView()

    override var contentSize: CGSize {
        didSet{
            contentView.frame = CGRect(origin: .zero, size: contentSize)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
