//
//  CoinPickerCell.swift
//  CoinPulse
//
//  Created by macbook on 18.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CoinPickerCell: UICollectionViewCell {
    
    var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = Color.darkBlue
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(titleLabel)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    override var isSelected: Bool{
        didSet{
            self.backgroundColor = isSelected ? Color.ultraDarkBlue : Color.darkBlue
        }
    }
    override var isHighlighted: Bool{
        didSet{
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }
        }
    }
}
