//
//  NewsPickerView.swift
//  CoinPulse
//
//  Created by macbook on 19.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

protocol NewsPickerViewDelegate: class {
    
    func handleNewsSelection(with newsItem: NewsItem)
    func handlePageScrolling(next: Bool)
}

class NewsPickerView: UIView {
    
    weak var delegate: NewsPickerViewDelegate?
    
    var news: [NewsItem] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    let cellId = "celId"
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collection = UICollectionView(frame: .zero, collectionViewLayout: CellSnappingLayout())
        let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collection.backgroundColor = Color.ultraDarkBlue
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = UIScrollViewDecelerationRateFast
        collection.register(NewsPickerCell.self, forCellWithReuseIdentifier: cellId)
        return collection
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var previousPage: CGFloat = 0
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / self.bounds.width
        if previousPage != currentPage{
            if currentPage > previousPage {
                delegate?.handlePageScrolling(next: true)
            } else if currentPage < previousPage {
                delegate?.handlePageScrolling(next: false)
            }
            previousPage = currentPage
        }
    }
    func reloadCollectionData(){
        if !self.news.isEmpty {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
        self.collectionView.reloadData()
    }
    
    private func setupViews(){
        addSubview(collectionView)
        
        collectionView.fillSuperview()
    }
}
//MARK: - UICollectionViewDataSource
extension NewsPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsPickerCell
        cell.newsItem = news[indexPath.item]
//        cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .blue
        return cell
    }
}
//MARK: - UICollectionViewDelegate
extension NewsPickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.handleNewsSelection(with: news[indexPath.item])
    }
}
extension NewsPickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
}

