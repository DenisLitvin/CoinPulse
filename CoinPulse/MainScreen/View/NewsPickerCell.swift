//
//  NewsPickerCell.swift
//  CoinPulse
//
//  Created by macbook on 19.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class NewsPickerCell: UICollectionViewCell {
    
    var newsItem: NewsItem? {
        didSet{
            guard let newsItem = newsItem else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            
            dateLabel.text = dateFormatter.string(from: newsItem.date)
            titleLabel.text = newsItem.title
        }
    }
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = Color.ultraDarkBlue
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews(){
        addSubview(dateLabel)
        addSubview(titleLabel)
        
        dateLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 12)
        titleLabel.anchor(top: dateLabel.bottomAnchor, left: dateLabel.leftAnchor, bottom: bottomAnchor, right: dateLabel.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
   
    override var isHighlighted: Bool{
        didSet{
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }
        }
    }
}

