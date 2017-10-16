//
//  TickerType.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

struct Coin {
    
    let ticker: String
    let name: String
    var coinData: CoinData?
    var coinChartData: [CoinChartData]?
    
    init(ticker: String, name: String) {
        self.ticker = ticker
        self.name = name
    }
    static func getCoins() -> [Coin]{
        let tickers = ["BTC", "DASH", "LTC", "NXT", "ETH", "ETC", "REP", "ZEC", "BCH", "XRP", "STR", "XMR"]
        let names = ["Bitcoin", "Dash","Litecoin","NXT", "Ethereum", "Ethereum Classic", "Augur", "Z-cash", "Bitcoin Cash", "Ripple", "Stellar Lumens", "Monero"]
        var coins: [Coin] = []
        for i in 0..<tickers.count {
            coins.append(Coin(ticker: tickers[i], name: names[i]))
        }
        return coins
    }
}













