//
//  CoinPickerView.swift
//  CoinPulse
//
//  Created by macbook on 18.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

protocol CoinPickerViewDelegate: class {
    func handleCoinSelection(with coin: Coin)
}

class CoinPickerView: UIView {
    
    weak var delegate: CoinPickerViewDelegate?
    
    var coins: [Coin] = []{
        didSet{
            if coins.count > 0 {
                collectionView.reloadData()
            }
        }
    }
    let cellId = "celId"
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = Color.darkBlue
        collection.delegate = self
        collection.dataSource = self
        collection.register(CoinPickerCell.self, forCellWithReuseIdentifier: cellId)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        coins = Coin.getCoins()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(collectionView)
        
        collectionView.fillSuperview()
    }
}
//MARK: - UICollectionViewDataSource
extension CoinPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coins.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoinPickerCell
        cell.title = coins[indexPath.item].name
        return cell
    }
}
//MARK: - UICollectionViewDelegate
extension CoinPickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.handleCoinSelection(with: coins[indexPath.item])
    }
}
extension CoinPickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: 50)
    }
}













