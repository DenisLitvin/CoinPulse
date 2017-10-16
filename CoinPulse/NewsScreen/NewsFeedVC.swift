//
//  NewsFeedVC.swift
//  CoinPulse
//
//  Created by macbook on 20.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import SafariServices

class NewsFeedVC: UICollectionViewController {
    
    var news: [NewsItem] = [] {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    let cellId = "celId"
//
//    let separatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
//        view.addSubview(separatorView)
//        separatorView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    func setupCollectionView(){
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0.3
        
        collectionView?.backgroundColor = Color.ultraDarkBlue
        collectionView?.register(NewsPickerCell.self, forCellWithReuseIdentifier: cellId)
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionView?.reloadData()
    }
}
//MARK: - UICollectionViewDataSource
extension NewsFeedVC{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsPickerCell
        cell.newsItem = news[indexPath.item]
        return cell
    }
}
//MARK: - UICollectionViewDelegate
extension NewsFeedVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: news[indexPath.item].urlString)!
        let vc = NewsItemPreviewVC()
        let request = URLRequest(url: url)
        vc.newsWebView.load(request)
            navigationController?.pushViewController(vc, animated: true)
    }
}
extension NewsFeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 80)
    }
}


