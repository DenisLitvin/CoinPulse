//
//  MainVCInteractor.swift
//  CoinPulse
//
//  Created by macbook on 18.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Charts

protocol MainVCInteractorDelegate: class {
    
    func didReceiveCoinData(_ data: CoinData, chartData: [CoinChartData])
    func didReceiveNews(_ news: [NewsItem])
}

class MainVCInteractor: NSObject {
    
    weak var delegate: MainVCInteractorDelegate?
    
    override init() {
        super.init()
        
    }
    func refreshCoinData(with coin: Coin, timeFrame: ChartTimeFrame){
        ApiManager.coin.fetchCoinData(coin) { (coinData) in
            ApiManager.coin.fetchCoinChartData(coin, timeFrame: timeFrame) { (coinChartData) in
                self.delegate?.didReceiveCoinData(coinData, chartData: coinChartData)
            }
        }
    }
    func refreshNews(){
        ApiManager.news.fetchNews { (news) in
            self.delegate?.didReceiveNews(news)
        }
    }
}












