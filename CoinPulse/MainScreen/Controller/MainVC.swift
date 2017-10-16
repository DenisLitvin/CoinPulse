//
//  ViewController.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import SafariServices

class MainVC: UIViewController {

    var news: [NewsItem] = []
    var coin = Coin(ticker: "BTC", name: "Bitcoin")
    var timeFrame = ChartTimeFrame.hours24
    
    lazy var autoRefreshController: AutoRefreshController = { [unowned self] in
        let controller = AutoRefreshController()
        controller.delegate = self
        return controller
    }()
    
    lazy var interactor: MainVCInteractor = { [unowned self] in
        let interactor = MainVCInteractor()
        interactor.delegate = self
        return interactor
    }()
    
//    lazy var viewManager: MainVCViewManager = { [unowned self] in
//        let view = MainVCViewManager()
//        view.delegate = self
////        view.adsView.rootViewController = self
////        view.adsView.load(GADRequest())
//        return view
//    }()
    var viewManager: MainVCViewManager?
    
    lazy var refreshButton: CSButton = { [unowned self] in
        let button = CSButton()
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.ultraDarkBlue
        refreshButton.anchor(top: nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 23, heightConstant: 23)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
        setupViewManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        autoRefreshController.startAutoRefreshing()
        getInitialData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        autoRefreshController.stopAutoRefreshing()
    }
    
    private func getInitialData(){
        
        interactor.refreshCoinData(with: coin, timeFrame: timeFrame)
        interactor.refreshNews()
    }
    private func setupViewManager(){
        viewManager = MainVCViewManager()
        viewManager?.delegate = self
        view.addSubview(viewManager!)
        viewManager?.fillSuperviewSafeLayout()
    }
    private func startRefreshAnimation(){
        
        refreshButton.alpha = 0.5
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.isAdditive = true
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.repeatCount = HUGE
        refreshButton.layer.add(animation, forKey: "animation")
    }
    private func stopRefreshAnimation(){
        
        refreshButton.layer.removeAllAnimations()
        refreshButton.alpha = 1
    }
    @objc func refreshButtonTapped(){
        
        interactor.refreshCoinData(with: coin, timeFrame: timeFrame)
        startRefreshAnimation()
    }
}
extension MainVC: MainVCInteractorDelegate {
    
    func didReceiveNews(_ news: [NewsItem]) {
        
        self.news = news
        viewManager?.updateNewsPickerViewData(with: news)
    }
    
    func didReceiveCoinData(_ data: CoinData, chartData: [CoinChartData]) {
        
        coin.coinData = data
        coin.coinChartData = chartData
        self.viewManager?.updateViewsData(with: coin)
        stopRefreshAnimation()
    }
}
extension MainVC: MainVCViewManagerDelegate{
    
    func didTapAllNewsButton() {
        
        let vc = NewsFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.news = news
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectNewsItem(_ newsItem: NewsItem) {
        
        let vc = NewsItemPreviewVC()
        let url = URL(string: newsItem.urlString)!
        let request = URLRequest(url: url)
        vc.newsWebView.load(request)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectCoin(_ coin: Coin) {
        
        self.coin = coin
        interactor.refreshCoinData(with: coin, timeFrame: timeFrame)
        startRefreshAnimation()
    }

    func didSelectTimeFrame(_ timeFrame: ChartTimeFrame) {
        
        self.timeFrame = timeFrame
        interactor.refreshCoinData(with: coin, timeFrame: timeFrame)
        startRefreshAnimation()
    }
}
extension MainVC: AutoRefreshControllerDelegate {
    
    func didRequestForRefresh() {
        interactor.refreshCoinData(with: coin, timeFrame: timeFrame)
        startRefreshAnimation()
    }
}
//extension MainVC: GADBannerViewDelegate {
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print(bannerView.frame)
//        self.viewManager.adsViewHeightConstraint?.constant = bannerView.frame.height
//    }
//}

extension UIViewController {
    
    #if DEBUG
    @objc func injected() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        if let sublayers = self.view.layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        viewDidLoad()
        viewDidAppear(false)
    }
    #endif
}




