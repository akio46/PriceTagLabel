//
//  ViewController.swift
//  PriceTagLabelExample
//
//  Created by Echo on 2017/3/31.
//  Copyright © 2017年 Echo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let lableHeight: CGFloat = 100
        let tagView = EchoPriceTagLabelView(x: 50, y: 40, height: lableHeight)
        _ = tagView.setPrice(price: 100.11, currencyShowMode:.SUBSCRIPT)
        tagView.currencyLabelTextColor = UIColor.red
        
        let tagView1 = EchoPriceTagLabelView(x: 50, y: 240, height: lableHeight)
        _ = tagView1.setPrice(price: 100.11, currencyShowMode:.SUPERSCRIPT)
        tagView1.backgroundColor = UIColor.gray
        
        let tagView2 = EchoPriceTagLabelView(x: 50, y: 440, height: lableHeight)
        let width = tagView2.setPrice(price: 100.11,
                          currencyShowMode:.SUPERSCRIPT,
                          decimalPointShowMode: .SUBSCRIPT,
                          decimalsShowMode:.SUBSCRIPT)
        debugPrint(width)
                
        self.view.addSubview(tagView)
        self.view.addSubview(tagView1)
        self.view.addSubview(tagView2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

