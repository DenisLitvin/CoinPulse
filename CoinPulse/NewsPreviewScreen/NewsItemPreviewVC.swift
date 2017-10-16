//
//  NewsItemPreviewVC.swift
//  CoinPulse
//
//  Created by macbook on 20.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import WebKit

class NewsItemPreviewVC: UIViewController {
    
    let newsWebView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews(){
        view.addSubview(newsWebView)
        
        newsWebView.fillSuperview()
    }
}
