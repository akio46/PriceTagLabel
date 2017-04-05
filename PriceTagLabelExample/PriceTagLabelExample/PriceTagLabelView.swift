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

struct EchoPriceLabelSetting {
    var color: UIColor = UIColor.black
    var italic = false
    var bold = false
    var underline = false
    var fontSize: CGFloat = 0.0
    var text: String = ""
}

class EchoPriceTagLabelView: UIView {
    
    public let basicFontName = "HelveticaNeue-UltraLight"
    public let italicFontName = "HelveticaNeue-UltraLightItalic"
    public let boldFontName = "HelveticaNeue-Bold"
    public let boldItalicFontName = "HelveticaNeue-BoldItalic"
    
    private var currencyLabel: UILabel?
    private var integerLabel: UILabel?
    private var decimalPointLabel: UILabel?
    private var decimalLabel: UILabel?
    private var components: [UILabel?] = []
    
    var currencyLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: currencyLabel,
                             setting: currencyLabelSetting)
        }
    }
    
    var integerLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: integerLabel,
                             setting: integerLabelSetting)
        }
    }
    
    var decimalPointLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: decimalPointLabel,
                             setting: decimalPointLabelSetting)
        }
    }
    
    var decimalLabelSetting: EchoPriceLabelSetting = EchoPriceLabelSetting() {
        didSet {
            setLabelSettings(label: decimalLabel,
                             setting: decimalLabelSetting)
        }
    }
    
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
        
        let dividedPrice = getDividedPrice(price: price)
        
        createMainPriceLabel(mainPrice: dividedPrice.integerPart)
        frame.size.height = integerLabel!.frame.size.height
        
        createCurrencyLabel(text: currency, mode: currencyShowMode)
        createDecimalPointLabel(text: decimalPoint, mode: decimalPointShowMode)
        createDecimalLabel(text: String(dividedPrice.decimalPart), mode: decimalsShowMode)
        
        reshape()
        
//        integerLabel!.layer.addBorder(edge: .bottom, color: UIColor.red, thickness: 1)
        
        return frame.width
    }
    
    private func reshape() {
        components = [currencyLabel,
                           integerLabel,
                           decimalPointLabel,
                           decimalLabel]
        let transform = CGAffineTransform(translationX: currencyLabel!.frame.width, y: 0)
        _ = components.map{$0!.transform = transform}
        
        let totalWidth = components.reduce(0){$0 + $1!.frame.size.width}
        frame.size.width = totalWidth
    }
    
    private func createMainPriceLabel(mainPrice: Int) {
        integerLabelSetting.text = String(mainPrice)
        integerLabelSetting.fontSize = frame.size.height
        integerLabel = createMainPriceLabel(frame: frame, setting: integerLabelSetting)
        addSubview(integerLabel!)
        integerLabel!.frame.origin = CGPoint(x: 0, y: 0)
    }
    
    private func createMainPriceLabel(frame: CGRect,
                                      setting: EchoPriceLabelSetting?) -> UILabel {
        let label = UILabel(frame: frame)
        setLabelSettings(label: label, setting: setting)
        label.sizeToFit()
        removeLabelPadding(label: label)
        
        return label
    }
    
    private func createCurrencyLabel(text: String, mode: EchoPriceTagLabelFontMode) {
        currencyLabelSetting.text = text
        currencyLabel = createLabel(positionType: .Left,
                                    heightRatio: smallLabelRatio,
                                    referLabel: integerLabel!,
                                    mode: mode,
                                    setting: currencyLabelSetting)
        addSubview(currencyLabel!)
    }
    
    private func createDecimalPointLabel(text: String, mode: EchoPriceTagLabelFontMode) {
        decimalPointLabelSetting.text = text
        decimalPointLabel = createLabel(positionType: .Right,
                                        heightRatio: smallLabelRatio,
                                        referLabel: integerLabel!,
                                        mode: mode,
                                        setting: decimalPointLabelSetting)
        addSubview(decimalPointLabel!)
    }
    
    private func createDecimalLabel(text: String, mode: EchoPriceTagLabelFontMode) {
        let span = decimalPointLabel!.frame.size.width
        decimalLabelSetting.text = text
        decimalLabel = createLabel(positionType: .Right,
                                   heightRatio: smallLabelRatio,
                                   referLabel: integerLabel!,
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
                             mode:EchoPriceTagLabelFontMode,
                             setting:EchoPriceLabelSetting) -> UILabel{
        let refHeight = referLabel.frame.size.height
        let height = (mode == .Normal) ? refHeight : smallLabelRatio * refHeight
        
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: CGFloat.greatestFiniteMagnitude,
                             height: height)
        var newSetting = setting
        newSetting.fontSize = (mode == .Normal) ? referLabel.font.pointSize : height
        
        setLabelSettings(label: label, setting: newSetting)
        label.sizeToFit()
        removeLabelPadding(label: label)
        
        if positionType == .Left {
            label.frame.origin.x = referLabel.frame.minX - label.frame.size.width - CGFloat(spanToReferLabel)
        } else {
            label.frame.origin.x = referLabel.frame.maxX + spanToReferLabel
        }
        
        let refY = getLabelRefY(mode: mode,
                                refHeight: refHeight,
                                labelHeight: height)
        
        label.frame.origin.y = refY
        
//        label.layer.borderColor = UIColor.red.cgColor
//        label.layer.borderWidth = 1
        
        return label
    }
    
    private func getLabelRefY(mode: EchoPriceTagLabelFontMode,
                              refHeight: CGFloat,
                              labelHeight:CGFloat) -> CGFloat {
        var refY: CGFloat

        switch mode {
        case .Normal, .SUPERSCRIPT:
            refY = 0
            break
        case .MIDDLESCRIPT:
            refY = smallLabelRatio * refHeight
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
