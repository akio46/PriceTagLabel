//
//  ViewController.swift
//  PriceTagLabelExample
//
//  Created by Echo on 2017/3/31.
//  Copyright © 2017年 Echo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var tagView:EchoPriceTagLabelView?
    private var tagView1:EchoPriceTagLabelView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lableHeight: CGFloat = 100
        tagView = EchoPriceTagLabelView(x: 50,
                                        y: 40,
                                        height: lableHeight,
                                        bestDisplayDigits: 2)
        _ = tagView?.setPrice(price: 108.01,
                              decimalPoint: "",
                              currencyShowMode:EchoPriceTagShowMode(position: .SUPERSCRIPT, size: .Small),
                              decimalShowMode:EchoPriceTagShowMode(position: .SUPERSCRIPT, size: .Medium))
        tagView?.currencyLabelSetting = EchoPriceLabelSetting(color: UIColor.red,
                                                             italic: true,
                                                             bold: true,
                                                             underline: false,
                                                             fontSize: 0.0,
                                                             text: "")
        tagView?.mainPriceLabelSetting = EchoPriceLabelSetting(color: UIColor.blue,
                                                              italic: false,
                                                              bold: false,
                                                              underline: false,
                                                              fontSize: 0.0,
                                                              text: "")
        tagView?.decimalLabelSetting = EchoPriceLabelSetting(color: UIColor.blue,
                                                            italic: true,
                                                            bold: false,
                                                            underline: true,
                                                            fontSize: 0.0,
                                                            text: "")
        
        tagView1 = EchoPriceTagLabelView(x: 50,
                                         y: 240,
                                         height: lableHeight,
                                         bestDisplayDigits: 2)
        _ = tagView1?.setPrice(price: 99.01,
                               decimalPoint: "",
        currencyShowMode: EchoPriceTagShowMode(position: .MIDDLESCRIPT, size: .Medium),
        decimalPointShowMode: EchoPriceTagShowMode(position: .SUBSCRIPT, size: .Big),
        decimalShowMode: EchoPriceTagShowMode(position: .SUPERSCRIPT, size: .Small))
        tagView1?.textColor = .blue
        
        let tagView2 = EchoPriceTagLabelView(x: 50,
                                             y: 440,
                                             height: lableHeight,
                                             bestDisplayDigits: 2)
        _ = tagView2.setPrice(price: 8.07,
                                      decimalPoint: "",
                                      currencyShowMode: EchoPriceTagShowMode(position: .MIDDLESCRIPT, size: .Half),
                                      decimalShowMode: EchoPriceTagShowMode(position: .SUPERSCRIPT, size: .Medium))

        self.view.addSubview(tagView!)
        self.view.addSubview(tagView1!)
        self.view.addSubview(tagView2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addOne(_ sender: Any) {
        debugPrint("add one")
        
        guard tagView != nil else {
            return
        }
        
        tagView?.price += 1
        tagView1?.price += 1
    }
    
    @IBAction func addZeroPointOne(_ sender: Any) {
        guard tagView != nil else {
            return
        }
        
        tagView?.price += 0.1
        tagView1?.price += 0.1
    }
}

