//
//  AutoRefreshController.swift
//  CoinPulse
//
//  Created by macbook on 19.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

protocol AutoRefreshControllerDelegate: class {
    func didRequestForRefresh()
}

class AutoRefreshController {
    
    weak var delegate: AutoRefreshControllerDelegate?
    
    var timer: Timer?
    
    func startAutoRefreshing() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(loop), userInfo: nil, repeats: true)
        }
    }
    
    func stopAutoRefreshing() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func loop() {
        delegate?.didRequestForRefresh()
    }
}
