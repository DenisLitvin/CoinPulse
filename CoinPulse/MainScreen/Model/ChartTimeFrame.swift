//
//  ChartTimeInterval.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

enum ChartTimeFrame {
    
    case hours24
    case week1
    case month1
    case month3
    case year1
    case year3
    
    var offset: Int{
        switch self {
        case .hours24:
            return 900
        case .week1:
            return 7200
        case .month1:
            return 14400
        case .month3:
            return 86400
        case .year1:
            return 86400
        case .year3:
            return 86400
        }
    }
    var interval: TimeInterval {
        let intervalToAdd: TimeInterval
        switch self {
        case .hours24:
            intervalToAdd = -60 * 60 * 24
        case .week1:
            intervalToAdd = -60 * 60 * 24 * 7
        case .month1:
            intervalToAdd = -60 * 60 * 24 * 7 * 4
        case .month3:
            intervalToAdd = -60 * 60 * 24 * 7 * 4 * 3
        case .year1:
            intervalToAdd = -60 * 60 * 24 * 7 * 4 * 12
        case .year3:
            intervalToAdd = -60 * 60 * 24 * 7 * 4 * 12 * 3
        }
        return Date().addingTimeInterval(intervalToAdd).timeIntervalSince1970
    }
}















