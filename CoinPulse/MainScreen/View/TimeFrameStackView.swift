//
//  TimeFrameStackView.swift
//  CoinPulse
//
//  Created by macbook on 17.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

protocol TimeFrameStackViewDelegate: class {
    
    func handleTimeFrameButton(with timeframe: ChartTimeFrame)
}

class TimeFrameStackView: UIStackView {
    
    weak var delegate: TimeFrameStackViewDelegate?
   
    lazy var buttons: [CSButton] = []
    lazy var subContainers: [UIView] = []
    private let buttonTitles = ["24H", "1W", "1M", "3M", "1Y", "3Y"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .horizontal
        self.distribution = .fillEqually
        
        for i in 0 ..< 6 {
            let view = UIView()
            self.subContainers.append(view)
            self.addArrangedSubview(subContainers[i])
            
            let button = CSButton()
            button.selectedColor = .yellow
            button.isOn = i == 0 ? true : false
            button.setTitle(buttonTitles[i], for: .normal)
            button.addTarget(self, action: #selector(timeFrameButtonTapped), for: .touchUpInside)
            buttons.append(button)
            
            view.addSubview(button)
            button.fillSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func timeFrameButtonTapped(_ button: CSButton){
        let index: Int = buttons.index(of: button)!
        var timeFrame: ChartTimeFrame = .week1
        switch index {
        case 0:
            timeFrame = .hours24
        case 1:
            timeFrame = .week1
        case 2:
            timeFrame = .month1
        case 3:
            timeFrame = .month3
        case 4:
            timeFrame = .year1
        case 5:
            timeFrame = .year3
        default:
            break
        }
        for button in buttons{
            button.isOn = false
        }
        button.isOn = true
        delegate?.handleTimeFrameButton(with: timeFrame)
    }
}
class timeFrameButton: CSButton {
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
}










