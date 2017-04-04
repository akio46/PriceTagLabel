//
//  PriceTagLabelView.swift
//  PriceTagLabel
//
//  Created by Echo on 2017/3/31.
//  Copyright © 2017年 Echo. All rights reserved.
//

import Foundation
import UIKit

enum EchoPriceTagLabelFontMode {
    case Normal
    case SUPERSCRIPT
    case SUBSCRIPT
    case MIDDLESCRIPT
}

enum EchoLabelPositionType {
    case Left
    case Right
}

class EchoPriceTagLabelView: UIView {
    
    private var currencyLabel: UILabel?
    private var integerLabel: UILabel?
    private var decimalPointLabel: UILabel?
    private var decimalLabel: UILabel?
    
    private let smallLabelRatio = CGFloat(1.0 / 3)
    
    public func setPrice(price: Float,
                         currency: String = "$",
                         decimalPoint: String = ".",
                         currencyShowMode: EchoPriceTagLabelFontMode = .SUPERSCRIPT,
                         decimalPointShowMode: EchoPriceTagLabelFontMode = .SUPERSCRIPT,
                         decimalsShowMode: EchoPriceTagLabelFontMode = .SUPERSCRIPT) {
        
        let dividedPrice = self.getDividedPrice(price: price)
        
        self.integerLabel = UILabel(frame: self.frame)
        self.addSubview(self.integerLabel!)
        let fontName = "HelveticaNeue-UltraLight"
        let font = UIFont(name: fontName, size: self.frame.size.height)
        self.integerLabel!.font = font
        self.integerLabel!.textColor = UIColor.blue
        self.integerLabel!.text = String(dividedPrice.integerPart)
        self.integerLabel!.sizeToFit()
        self.integerLabel!.frame.origin = CGPoint(x: 0, y: 0)
        
        let fontsize = self.integerLabel!.font.pointSize
        let adjust = (self.integerLabel!.frame.size.height - fontsize) * 2
        self.integerLabel!.frame.size.height -= adjust
        
        self.currencyLabel = self.createLable(positionType: .Left,
                                              heightRatio: self.smallLabelRatio,
                                              referLabel: self.integerLabel!,
                                              mode: currencyShowMode,
                                              text: currency,
                                              italic:true)
        self.addSubview(self.currencyLabel!)

        self.decimalPointLabel = self.createLable(positionType: .Right,
                                              heightRatio: self.smallLabelRatio,
                                              referLabel: self.integerLabel!,
                                              mode: decimalPointShowMode,
                                              text: decimalPoint)
        self.addSubview(self.decimalPointLabel!)
        
        let span = self.decimalPointLabel!.frame.size.width
        self.decimalLabel = self.createLable(positionType: .Right,
                                              heightRatio: self.smallLabelRatio,
                                               referLabel: self.integerLabel!,
                                         spanToReferLabel: span,
                                                     mode: decimalsShowMode,
                                                     text: String(dividedPrice.decimalPart),
                                                underline: true,
                                                   italic: true)
        self.addSubview(self.decimalLabel!)
    }
    
    private func createLable(positionType: EchoLabelPositionType,
                             heightRatio: CGFloat,
                             referLabel: UILabel,
                             spanToReferLabel: CGFloat = 0,
                             mode:EchoPriceTagLabelFontMode,
                             text: String = "",
                             underline: Bool = false,
                             italic: Bool = false) -> UILabel {
        
        let refHeight = referLabel.frame.size.height
        var height = smallLabelRatio * refHeight
        
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: CGFloat.greatestFiniteMagnitude,
                             height: height)
        let fontSize = height
        let fontName = italic ? "HelveticaNeue-UltraLightItalic" : "HelveticaNeue-UltraLight"
        
        let myAttribute = [ NSForegroundColorAttributeName: UIColor.black,
                            NSFontAttributeName: UIFont(name: fontName, size: fontSize)!] as [String : Any]
        let attrString = NSMutableAttributedString(string: text, attributes: myAttribute)
        
        if underline {
            attrString.addAttribute(NSUnderlineStyleAttributeName,
                                    value: NSUnderlineStyle.styleSingle.rawValue,
                                    range: (attrString.string as NSString).range(of: text))
        }
        

        label.attributedText = attrString
        label.sizeToFit()
        
        if positionType == .Left {
            label.frame.origin.x = referLabel.frame.minX - label.frame.size.width - CGFloat(spanToReferLabel)
        } else {
            label.frame.origin.x = referLabel.frame.maxX + spanToReferLabel
        }
        
        var refY: CGFloat
        switch mode {
        case .Normal, .SUPERSCRIPT:
            refY = 0
            
            if mode == .Normal {
                height = refHeight
            }
            
            break
        case .MIDDLESCRIPT:
            refY = smallLabelRatio * refHeight
            break
        case .SUBSCRIPT:
            refY = referLabel.frame.size.height - label.frame.size.height
            break
        }

        label.frame.origin.y = refY
        
        return label
    }
    
    internal func getDividedPrice(price: Float) -> (integerPart: Int, decimalPart: Int) {
        let roundedPrice = (price * 100).rounded() / 100
        let priceParts = String(format:"%.2f", roundedPrice).components(separatedBy: ".")
        return (Int(priceParts[0])!, Int(priceParts[1])!)
    }
}
