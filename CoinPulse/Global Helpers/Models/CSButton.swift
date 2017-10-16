//
//  CSButton.swift
//  CoinPulse
//
//  Created by macbook on 17.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CSButton: UIButton {
    
    var isOn = false {
        didSet {
            setupAppearance()
            setNeedsDisplay()
        }
    }
    
    var selectedColor: UIColor = .white
    var unselectedColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        addTarget(self, action: #selector(endTapInside), for: .touchUpInside)
        addTarget(self, action: #selector(endTapOutside), for: .touchUpOutside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupAppearance(){
        if isOn {
            setTitleColor(selectedColor, for: .normal)
        } else {
            setTitleColor(unselectedColor, for: .normal)
        }
    }

    @objc func endTapInside(){
        isOn = !isOn
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    @objc func endTapOutside(){
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.3
        }
        return true
    }
}

