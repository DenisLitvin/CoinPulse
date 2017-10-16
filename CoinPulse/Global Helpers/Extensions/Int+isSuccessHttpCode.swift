//
//  Int+isSuccessHttpCode.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

extension Int {
    public var isSuccessHttpCode: Bool {
        return 200 <= self && self < 300
    }
}
