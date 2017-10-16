//
//  CoinManager.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

extension ApiManager {
    static let coin: CoinManager = {
        let manager = CoinManager()
        return manager
    }()
}

class CoinManager: NSObject {
      
    func fetchCoinData(_ coin: Coin, complition: @escaping (CoinData) -> () ){
        let url = URL(string: "https://poloniex.com/public?command=returnTicker")!
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error{
                print(error)
            }
            if let response = response as? HTTPURLResponse, response.statusCode.isSuccessHttpCode, let data = data{
                do{
                    let dict = try JSONSerialization.jsonObject(with: data) as! [String : Any]
                    let tickerData = dict["USDT_\(coin.ticker)"] as! [String : Any]
                    
                            let lastPrice = tickerData["last"] as! String
                            let percentChange = tickerData["percentChange"] as! String
                    let coinData = CoinData(last: Double(lastPrice)!, percentChange: Double(percentChange)!)
                    DispatchQueue.main.async {
                        complition(coinData)
                    }
                } catch {
                    
                }
            }
            
            }.resume()
    }
    func fetchCoinChartData(_ coin: Coin, timeFrame: ChartTimeFrame, complition: @escaping ([CoinChartData]) -> () ){
        let url = URL(string: "https://poloniex.com/public?command=returnChartData&currencyPair=USDT_\(coin.ticker)&start=\(timeFrame.interval)&end=9999999999&period=\(timeFrame.offset)")!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error{
                print(error)
            }
            if let response = response as? HTTPURLResponse, response.statusCode.isSuccessHttpCode, let data = data{
                do{
                    let array = try JSONSerialization.jsonObject(with: data) as! [Any]
                    var tickerData: [CoinChartData] = []
                    for item in array {
                        if let coin = item as? [String : Double],
                        let date = coin["date"],
                        let close = coin["close"] {
                            tickerData.append(CoinChartData(date: date, close: close))
                        }
                    }
                    DispatchQueue.main.async {
                        complition(tickerData)
                    }
                } catch {
                    
                }
            }
            
            }.resume()
    }
}
