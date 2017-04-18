//
//  PriceTagLabelView.swift
//  PriceTagLabel
//
//  Created by Echo on 2017/3/31.
//  Copyright © 2017年 Echo. All rights reserved.
//

import Foundation
import UIKit

public enum EchoPriceTagLabelPositionMode {
    case SUPERSCRIPT
    case SUBSCRIPT
    case MIDDLESCRIPT
}

public enum EchoPriceTagLabelFontSizeMode {
    case Small
    case Medium
    case Half
    case Big
}

private enum EchoLabelPositionType {
    case Left
    case Right
}

public struct EchoPriceTagShowMode {
    var position: EchoPriceTagLabelPositionMode = .SUPERSCRIPT
    var size: EchoPriceTagLabelFontSizeMode = .Small
}

public struct EchoPriceLabelSetting {
    var color: UIColor = UIColor.black
    var italic = false
    var bold = false
    var underline = false
    var fontSize: CGFloat = 0.0
    var text: String = ""
}

public class EchoPriceTagLabelView: UIView {
    
    // Helvetica is used for the time being
    public let basicFontName = "HelveticaNeue-UltraLight"
    public let italicFontName = "HelveticaNeue-UltraLightItalic"
    public let boldFontName = "HelveticaNeue-Bold"
    public let boldItalicFontName = "HelveticaNeue-BoldItalic"
    
    private var currencyLabel: UILabel?
    private var mainPriceLabel: UILabel?
    private var decimalPointLabel: UILabel?
    private var decimalLabel: UILabel?
    private var components: [UILabel?] = []
    private var height: CGFloat = 0
    private var currency : String = "$"
    private var decimalPoint: String = "."
    
    public var bestDisplayDigits: Int = 2
    
    public var price: Float = 0.0 {
        didSet {
            if self.superview != nil {
                let view = self.superview
                self.removeFromSuperview()
                _ = self.components.map{$0?.removeFromSuperview()}
                mainPriceLabel?.removeFromSuperview()
                
                frame.size.width = UIScreen.main.bounds.width
                frame.size.height = height
                _ = setPrice(price: price, currency: currency, decimalPoint: decimalPoint)
                view!.addSubview(self)
            }
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            currencyLabelSetting.color = textColor!
            mainPriceLabelSetting.color = textColor!
            decimalPointLabelSetting.color = textColor!
            decimalLabelSetting.color = textColor!
        }
    }
    
    public var currencyLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: currencyLabel,
                             setting: currencyLabelSetting)
        }
    }
    
    public var mainPriceLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: mainPriceLabel,
                             setting: mainPriceLabelSetting)
        }
    }
    
    public var decimalPointLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: decimalPointLabel,
                             setting: decimalPointLabelSetting)
        }
    }
    
    public var decimalLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: decimalLabel,
                             setting: decimalLabelSetting)
        }
    }
    
    private let smallLabelRatio = CGFloat(1.0 / 3)
    
    public init(x: CGFloat, y: CGFloat, height: CGFloat, bestDisplayDigits: Int = 0) {
        self.height = height
        self.bestDisplayDigits = bestDisplayDigits
        super.init(frame:CGRect(x: x, y: y, width: UIScreen.main.bounds.width, height: height))
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    public func setPrice(price: Float,
                         currency: String = "$",
                         decimalPoint: String = ".",
                         currencyShowMode: EchoPriceTagShowMode = EchoPriceTagShowMode(),
                         decimalPointShowMode: EchoPriceTagShowMode = EchoPriceTagShowMode(),
                         decimalsShowMode: EchoPriceTagShowMode = EchoPriceTagShowMode()
        ) -> CGFloat {
        
        self.price = price
        self.currency = currency
        self.decimalPoint = decimalPoint
        
        let dividedPrice = getDividedPrice(price: price)
        
        createMainPriceLabel(mainPrice: dividedPrice.integerPart)
        createCurrencyLabel(text: currency, mode: currencyShowMode)
        createDecimalPointLabel(text: decimalPoint, mode: decimalPointShowMode)
        createDecimalLabel(text: String(format:"%02d", dividedPrice.decimalPart),
                           mode: decimalsShowMode)
        
        reshape()
        
        return frame.width
    }
    
    private func reshape() {
        frame.size.height = mainPriceLabel!.frame.size.height
        if decimalPointLabel == nil {
            components = [currencyLabel,
                          decimalLabel]
        } else {
            components = [currencyLabel,
                          decimalPointLabel,
                          decimalLabel]
        }
        
        let transform = CGAffineTransform(translationX: currencyLabel!.frame.width, y: 0)
        _ = components.map{$0!.transform = transform}
        
        mainPriceLabel?.frame.origin.x += currencyLabel!.frame.width
        
        let totalWidth = components.reduce(0){$0 + $1!.frame.size.width} + (mainPriceLabel?.frame.width)!
        frame.size.width = totalWidth
        
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.blue.cgColor
    }
    
    private func createMainPriceLabel(mainPrice: Int) {
        mainPriceLabelSetting.text = String(mainPrice)
        mainPriceLabelSetting.fontSize = frame.size.height
        mainPriceLabel = createMainPriceLabel(frame: frame, setting: mainPriceLabelSetting)
        addSubview(mainPriceLabel!)
        mainPriceLabel!.frame.origin = CGPoint(x: 0, y: 0)
        
        if self.bestDisplayDigits > 0 && mainPrice > 9 {
            let scale = getFitableWidth() / mainPriceLabel!.frame.width
            let oldX = mainPriceLabel!.frame.minX
            mainPriceLabel!.transform = CGAffineTransform(scaleX: scale, y: 1)
            mainPriceLabel!.frame.origin.x = oldX
        }
    }
    
    private func createMainPriceLabel(frame: CGRect,
                                      setting: EchoPriceLabelSetting?) -> UILabel {
        let label = UILabel(frame: frame)
        setLabelSettings(label: label, setting: setting)
        label.sizeToFit()
        removeLabelPadding(label: label)
        
        return label
    }
    
    private func createCurrencyLabel(text: String, mode: EchoPriceTagShowMode) {
        currencyLabelSetting.text = text
        currencyLabel = createLabel(positionType: .Left,
                                    heightRatio: smallLabelRatio,
                                    referLabel: mainPriceLabel!,
                                    mode: mode,
                                    setting: currencyLabelSetting)
        addSubview(currencyLabel!)
    }
    
    private func createDecimalPointLabel(text: String, mode: EchoPriceTagShowMode) {
        guard !text.isEmpty else {
            return
        }
        
        decimalPointLabelSetting.text = text
        decimalPointLabel = createLabel(positionType: .Right,
                                        heightRatio: smallLabelRatio,
                                        referLabel: mainPriceLabel!,
                                        mode: mode,
                                        setting: decimalPointLabelSetting)
        addSubview(decimalPointLabel!)
    }
    
    private func createDecimalLabel(text: String, mode: EchoPriceTagShowMode) {
        let span = decimalPointLabelSetting.text.isEmpty ? 0 : decimalPointLabel!.frame.size.width
        decimalLabelSetting.text = text
        decimalLabel = createLabel(positionType: .Right,
                                   heightRatio: smallLabelRatio,
                                   referLabel: mainPriceLabel!,
                                   spanToReferLabel: span,
                                   mode: mode,
                                   setting: decimalLabelSetting)
        addSubview(decimalLabel!)
    }
    
    private func createLabelAttributeString(text:String,
                                            fontName: String,
                                            fontSize: CGFloat,
                                            color: UIColor = UIColor.black)
        -> NSAttributedString {
        let myAttribute = [ NSForegroundColorAttributeName: color,
                            NSFontAttributeName: UIFont(name: fontName, size: fontSize)!] as [String : Any]
        let attrString = NSMutableAttributedString(string: text, attributes: myAttribute)
        
//        if underline {
//            attrString.addAttribute(NSUnderlineStyleAttributeName,
//                                    value: NSUnderlineStyle.styleSingle.rawValue,
//                                    range: (attrString.string as NSString).range(of: text))
//        }
        
        return attrString
    }
    
    private func createLabel(positionType: EchoLabelPositionType,
                             heightRatio: CGFloat,
                             referLabel: UILabel,
                             spanToReferLabel: CGFloat = 0,
                             mode:EchoPriceTagShowMode,
                             setting:EchoPriceLabelSetting) -> UILabel{
        let refHeight = referLabel.frame.size.height
        let ratio = getLabelHeightRatio(sizeMode: mode.size)
        let height = ratio * refHeight
        
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: CGFloat.greatestFiniteMagnitude,
                             height: height)
        var newSetting = setting
        newSetting.fontSize = (mode.size == .Big) ? referLabel.font.pointSize : height
        
        setLabelSettings(label: label, setting: newSetting)
        label.sizeToFit()
        removeLabelPadding(label: label)
        
        if positionType == .Left {
            label.frame.origin.x = referLabel.frame.minX - label.frame.size.width - CGFloat(spanToReferLabel)
        } else {
            label.frame.origin.x = referLabel.frame.maxX + spanToReferLabel
        }
        
        let refY = getLabelRefY(positionMode: mode.position,
                                refHeight: refHeight,
                                labelHeight: height)
        
        label.frame.origin.y = refY
        
        return label
    }
    
    private func getLabelHeightRatio(sizeMode: EchoPriceTagLabelFontSizeMode) -> CGFloat {
        var ratio: CGFloat
        
        switch sizeMode {
        case .Small:
            ratio = 1.0 / 3
            break
        case .Medium:
            ratio = 2.0 / 3
            break
        case .Half:
            ratio = 1.0 / 2
            break
        case .Big:
            ratio = 1.0
        }
        
        return ratio
    }
    
    private func getLabelRefY(positionMode: EchoPriceTagLabelPositionMode,
                              refHeight: CGFloat,
                              labelHeight:CGFloat) -> CGFloat {
        var refY: CGFloat

        switch positionMode {
        case .SUPERSCRIPT:
            refY = 0
            break
        case .MIDDLESCRIPT:
            refY = (refHeight - labelHeight) / 2
            break
        case .SUBSCRIPT:
            refY = refHeight - labelHeight
            break
        }
        
        return refY
    }
    
    private func setLabelSettings(label: UILabel?,
                                  setting: EchoPriceLabelSetting?) {
        guard label != nil else {
            return
        }
        
        guard setting != nil else {
            return
        }
        
        let text = setting!.text == "" ? label!.text : setting!.text
        
        guard text != nil else {
            return
        }

        let fontName = getFontName(italic: setting!.italic,
                                   bold: setting!.bold)
        let fontSize = (setting?.fontSize == 0) ? (label!.font.pointSize) : setting!.fontSize
        
        let attrString = createLabelAttributeString(text: text!,
                                                    fontName: fontName,
                                                    fontSize: fontSize,
                                                    color:setting!.color)
        label!.attributedText = attrString
        
        if label!.superview != nil {
            if setting!.underline {
                label!.layer.addBorder(edge: .bottom,
                                       color: setting!.color,
                                       thickness: 1)
            }
        }
    }
    
    private func getPaddingAdjustValue(label: UILabel) -> CGFloat {
        let fontsize = label.font.pointSize
        let adjust = (label.frame.size.height - fontsize) * 2
        return adjust
    }
    
    private func removeLabelPadding(label: UILabel) {
        label.frame.size.height -= getPaddingAdjustValue(label: label)
    }
    
    internal func getFontName(italic: Bool, bold: Bool) -> String {
        let fonts = [basicFontName, italicFontName, boldFontName, boldItalicFontName]
        let index = (italic ? 0b01 : 0) + (bold ? 0b10 : 0)
        
        return fonts[index]
    }
    
    internal func getDividedPrice(price: Float) -> (integerPart: Int, decimalPart: Int) {
        let roundedPrice = (price * 100).rounded() / 100
        let priceParts = String(format:"%.2f", roundedPrice).components(separatedBy: ".")
        return (Int(priceParts[0])!, Int(priceParts[1])!)
    }
    
    public func getFitableWidth() -> CGFloat {
        let dividedPrice = getDividedPrice(price: Float(10^bestDisplayDigits / 10))
        var setting = mainPriceLabelSetting
        setting.text = String(dividedPrice.integerPart)
        setting.fontSize = frame.size.height
        let label = createMainPriceLabel(frame: self.frame, setting: setting)
        return label.frame.width
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
