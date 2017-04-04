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
    private var components: [UILabel?] = []
    
    var currencyLabelTextColor: UIColor = UIColor.black
    var integerLabelTextColor: UIColor = UIColor.black
    var decimalPointLabelTextColor: UIColor = UIColor.black
    var decimalLabelTextColor: UIColor = UIColor.black
    
    private let smallLabelRatio = CGFloat(1.0 / 3)
    
    init(x: CGFloat, y: CGFloat, height: CGFloat) {
        super.init(frame:CGRect(x: x, y: y, width: UIScreen.main.bounds.width, height: height))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    public func setPrice(price: Float,
                         currency: String = "$",
                         decimalPoint: String = ".",
                         currencyShowMode: EchoPriceTagLabelFontMode = .SUPERSCRIPT,
                         decimalPointShowMode: EchoPriceTagLabelFontMode = .SUPERSCRIPT,
                         decimalsShowMode: EchoPriceTagLabelFontMode = .SUPERSCRIPT
        ) -> CGFloat {
        
        let dividedPrice = self.getDividedPrice(price: price)
        
        self.createMainPriceLabel(mainPrice: dividedPrice.integerPart)
        
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
        
        self.reshape()
        
        return self.frame.width
    }
    
    private func reshape() {
        self.components = [self.currencyLabel,
                           self.integerLabel,
                           self.decimalPointLabel,
                           self.decimalLabel]
        let transform = CGAffineTransform(translationX: self.currencyLabel!.frame.width, y: 0)
        _ = self.components.map{$0!.transform = transform}
        
        let totalWidth = self.components.reduce(0){$0 + $1!.frame.size.width}
        self.frame.size.width = totalWidth
    }
    
    private func createMainPriceLabel(mainPrice: Int) {
        let fontName = "HelveticaNeue-UltraLight"
        self.integerLabel = self.createMainPriceLabel(frame: self.frame,
                                                      text: String(mainPrice),
                                                      textColor: self.integerLabelTextColor,
                                                      fontName: fontName)
        self.addSubview(self.integerLabel!)
        self.integerLabel!.frame.origin = CGPoint(x: 0, y: 0)
        self.frame.size.height = self.integerLabel!.frame.size.height        
    }
    
    private func createMainPriceLabel(frame: CGRect,
                                      text: String,
                                      textColor: UIColor,
                                      fontName: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = UIFont(name: fontName, size: frame.size.height)
        label.textColor = textColor
        label.text = text
        label.sizeToFit()
        
        let fontsize = label.font.pointSize
        let adjust = (label.frame.size.height - fontsize) * 2
        label.frame.size.height -= adjust
        
        return label
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
