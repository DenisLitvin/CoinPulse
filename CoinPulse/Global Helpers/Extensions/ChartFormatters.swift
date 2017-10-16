//
//  ChartDateFormatter.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Charts

class ChartDateFormatter: NSObject, IAxisValueFormatter {
    
    let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
class ChartNumberFormatter: NSObject, IAxisValueFormatter {
    
    let formatter: NumberFormatter
    
    
    override init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return formatter.string(from: NSNumber(value: value))!
    }
}










