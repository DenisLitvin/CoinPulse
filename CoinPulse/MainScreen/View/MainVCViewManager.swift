//
//  ViewContainer.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import Charts
import GoogleMobileAds
import Firebase

protocol MainVCViewManagerDelegate: class {
    
    func didSelectTimeFrame(_ timeFrame: ChartTimeFrame)
    func didSelectCoin(_ coin: Coin)
    func didSelectNewsItem(_ newsItem: NewsItem)
    func didTapAllNewsButton()
}

class MainVCViewManager: UIView {
    
    weak var delegate: MainVCViewManagerDelegate?
    let databaseRef = Database.database().reference()
    
    lazy var coinPickerButton: CSButton = { [unowned self] in
        let button = CSButton()
        button.selectedColor = .white
        button.tintColor = .blue
        button.titleLabel?.textColor = .white
        button.setImage(#imageLiteral(resourceName: "triangle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -110, bottom: 0, right: 110)
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: -60, bottom: 13, right: 60)
        button.addTarget(self, action: #selector(coinPickerButtonTapped), for: .touchUpInside)
        return button
        }()
    let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .white
        return label
    }()
    let change24StaticLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Change"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    let change24Label: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    lazy var timeFrameStackView: TimeFrameStackView = { [unowned self] in
        let view = TimeFrameStackView()
        view.delegate = self
        return view
        }()
    lazy var coinPickerView: CoinPickerView = { [unowned self] in
        let view = CoinPickerView()
        view.delegate = self
        return view
        }()
    
    let chartView: ChartView = {
        let view = ChartView()
        return view
    }()
    
    lazy var newsTitleButton: CSButton = { [unowned self] in
        let button = CSButton()
        button.addTarget(self, action: #selector(newsTitleButtonTapped), for: .touchUpInside)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        let underlineAttribute: [NSAttributedStringKey : Any] = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
        let underlineAttributedString = NSAttributedString(string: "All News", attributes: underlineAttribute)
        button.setAttributedTitle(underlineAttributedString, for: .normal)
        //        button.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //        button.tintColor = UIColor.lightGray
        return button
    }()
    
    lazy var newsPickerView: NewsPickerView = { [unowned self] in
        let view = NewsPickerView()
        view.delegate = self
        return view
    }()
   
    let pageControlView: UIPageControl = {
        let view = UIPageControl()
        view.numberOfPages = 3
        view.pageIndicatorTintColor = .lightGray
        view.currentPageIndicatorTintColor = .white
        view.isUserInteractionEnabled = false
        return view
    }()
//    lazy var adsView: GADBannerView = { [unowned self] in
//        let view = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        view.adUnitID = "ca-app-pub-6118176763479254/8840666918"
//        return view
//        }()
    var adBanners: [Banner] = []
    var currentAdBanner: Int = 0
    lazy var adsView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MainVCViewManager.adsViewTapped))
        view.addGestureRecognizer(gesture)
        return view
    }()

//    var subContainers: [UIView] = []
//    lazy var subStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.distribution = .fillEqually
//        for i in 0..<6{
//            let subContainer = UIView()
//            subContainer.backgroundColor = (i % 2 == 0) ? .red : .blue
//            subContainers.append(subContainer)
//            view.addArrangedSubview(subContainer)
//        }
//        return view
//    }()
    
    lazy var scrollView: CSScrollView = { [unowned self] in
        let view = CSScrollView()
        view.backgroundColor = Color.ultraDarkBlue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.clipsToBounds = false
        backgroundColor = Color.ultraDarkBlue
        setupViews()
        setupAdBanner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iPhone = traitCollection.horizontalSizeClass == .compact || traitCollection.verticalSizeClass == .compact
        let landscapeOrientation = bounds.width > bounds.height
        let selfSize = self.bounds.size
        
        if iPhone, landscapeOrientation{
            scrollView.contentSize = CGSize(width: selfSize.width, height: selfSize.height + 162)
        } else {
            scrollView.contentSize = selfSize
        }
        
//        if landscapeOrientation || !iPhone {
//            adsViewHeightConstraint?.constant = 32
//        } else {
//            adsViewHeightConstraint?.constant = 50
//        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        newsPickerView.reloadCollectionData()
        newsPickerView.previousPage = 0
        pageControlView.currentPage = 0
        newsPickerView.collectionView.reloadData()
        coinPickerView.collectionView.reloadData()
    }
    //MARK: - Private methods
    private func setupAdBanner(){
        databaseRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                self?.adBanners = []
                for banner in value {
                    if let bannerValue = banner.value as? [String : String],
                        let imageUrlString = bannerValue["imageUrl"],
                        let sourceUrlString = bannerValue["sourceUrl"] {
                        self?.adBanners.append((Banner(imageUrl: URL(string: imageUrlString)!, sourceUrl: URL(string: sourceUrlString)!)))
                    }
                }
                self?.iterateAdBanner()
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
                    self?.iterateAdBanner()
                }
            }
        }
        
    }
    private func iterateAdBanner(){
        DispatchQueue.global().async {
            let banner = self.adBanners[self.currentAdBanner]
            let imageData = try! Data(contentsOf: banner.imageUrl)
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                self.adsView.image = image
                if self.currentAdBanner >= self.adBanners.count - 1 {
                    self.currentAdBanner = 0
                } else {
                    self.currentAdBanner += 1
                }
            }
        }
    }
    private func setupViews(){
        addSubview(scrollView)
        scrollView.fillSuperview()
        
//        scrollView.contentView.addSubview(subStackView)
//        subStackView.fillSuperview()
        
        for view in [coinPickerButton, timeFrameStackView, coinPriceLabel, change24StaticLabel, change24Label, chartView, newsPickerView, newsTitleButton, pageControlView, adsView]{
            scrollView.contentView.addSubview(view)
        }
        
        coinPickerButton.anchor(top: scrollView.contentView.topAnchor, left: scrollView.contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        timeFrameStackView.anchor(top: coinPriceLabel.bottomAnchor, left: scrollView.contentView.leftAnchor, bottom: chartView.topAnchor, right: scrollView.contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        coinPriceLabel.anchor(top: coinPickerButton.bottomAnchor, left: coinPickerButton.leftAnchor, bottom: nil, right: change24StaticLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 50)
        
        change24StaticLabel.anchor(top: coinPickerButton.bottomAnchor, left: nil, bottom: nil, right: scrollView.contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 90, heightConstant: 25)
        
        change24Label.anchor(top: change24StaticLabel.bottomAnchor, left: change24StaticLabel.leftAnchor, bottom: coinPriceLabel.bottomAnchor, right: change24StaticLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        chartView.anchor(top: timeFrameStackView.bottomAnchor, left: scrollView.contentView.leftAnchor, bottom: newsTitleButton.topAnchor, right: scrollView.contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        newsTitleButton.anchor(top: nil, left: scrollView.contentView.centerXAnchor, bottom: newsPickerView.topAnchor, right: nil, topConstant: 0, leftConstant: -45, bottomConstant: 10, rightConstant: 0, widthConstant: 90, heightConstant: 40)
        
        newsPickerView.anchor(top: nil, left: scrollView.contentView.centerXAnchor, bottom: pageControlView.topAnchor, right: nil, topConstant: 0, leftConstant: -160, bottomConstant: 5, rightConstant: 0, widthConstant: 320, heightConstant: 60)
        
        pageControlView.anchor(top: nil, left: newsPickerView.leftAnchor, bottom: adsView.topAnchor, right: newsPickerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 10)
    
        adsView.anchor(top: nil, left: nil, bottom: scrollView.contentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 320, heightConstant: 50)
        adsView.centerXAnchor.constraint(equalTo: self.scrollView.contentView.centerXAnchor).isActive = true
        
        
    }
    private func createCoinPickerViewIfNeeded(){
        if self.subviews.contains(coinPickerView){
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.coinPickerView.transform = CGAffineTransform(translationX: 0, y: -40)
                self.coinPickerView.alpha = 0
            }, completion: { _ in
                self.coinPickerView.removeFromSuperview()
            })
        } else {
            self.addSubview(coinPickerView)
            self.coinPickerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 40, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            self.coinPickerView.alpha = 0
            self.coinPickerView.transform = CGAffineTransform(translationX: 0, y: -40)
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.coinPickerView.transform = .identity
                self.coinPickerView.alpha = 1
            })
        }
    }
    
    //MARK: - Public methods
    func updateViewsData(with coin: Coin){
        //chart
        guard let chartData = coin.coinChartData,
            let coinData = coin.coinData else { return }
        
        var chartDataEntries: [ChartDataEntry] = []
        for coinData in chartData{
            let chartDataEntry = ChartDataEntry(x: coinData.date, y: coinData.close)
            chartDataEntries.append(chartDataEntry)
        }
        self.chartView.updateChartView(with:chartDataEntries)
        
        //coin labels
        let numberFormatter = NumberFormatter()
        numberFormatter.zeroSymbol = "0"
        numberFormatter.maximumFractionDigits = 4
        numberFormatter.numberStyle = .decimal
        let lastFormatted = numberFormatter.string(from: NSNumber(value: coinData.last))
        
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        let percentFormatted = numberFormatter.string(from: NSNumber(value: coinData.percentChange))
        coinPickerButton.setTitle(coin.name, for: .normal)
        coinPriceLabel.text = "$" + lastFormatted!
        change24Label.text = percentFormatted!
        change24Label.textColor = coinData.percentChange < 0 ? .red : .green
    }
    func updateNewsPickerViewData(with news: [NewsItem]){
        newsPickerView.news = news
    }
    //MARK: - Handling events
    @objc func adsViewTapped(){
        UIApplication.shared.open(adBanners[currentAdBanner].sourceUrl, options: [:], completionHandler: nil)
    }
    @objc func coinPickerButtonTapped(){
        createCoinPickerViewIfNeeded()
    }
    @objc func newsTitleButtonTapped(){
        delegate?.didTapAllNewsButton()
    }
}
//MARK: - Delegations
extension MainVCViewManager: TimeFrameStackViewDelegate {
    
    func handleTimeFrameButton(with timeframe: ChartTimeFrame) {
        delegate?.didSelectTimeFrame(timeframe)
    }
}
extension MainVCViewManager: CoinPickerViewDelegate {
    
    func handleCoinSelection(with coin: Coin) {
        createCoinPickerViewIfNeeded()
        delegate?.didSelectCoin(coin)
    }
}
extension MainVCViewManager: NewsPickerViewDelegate {
    
    func handleNewsSelection(with newsItem: NewsItem) {
        delegate?.didSelectNewsItem(newsItem)
    }
    func handlePageScrolling(next: Bool){
        let operand = next ? 1 : -1
        if pageControlView.currentPage == 2 && next {
            pageControlView.currentPage = 0
        } else if pageControlView.currentPage == 0 && !next{
            pageControlView.currentPage = 2
        } else {
            pageControlView.currentPage = pageControlView.currentPage + operand
        }
    }
}





