//
//  String+getSize.swift
//  CoinPulse
//
//  Created by macbook on 18.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

extension String{
    func getSize(with boundaries: CGSize, font: UIFont) -> CGSize{
        let nsstring = NSString(string: self)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: NSParagraphStyle.default, NSAttributedStringKey.foregroundColor: UIColor.black]
        return nsstring.boundingRect(with: boundaries, options: options, attributes: attributes, context: nil).size
    }
}
