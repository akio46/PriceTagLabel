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
        let lableHeight = 100
        let tagView = EchoPriceTagLabelView(frame: CGRect(x: 50, y: 40, width: 800, height: lableHeight / 2))
        tagView.setPrice(price: 100.11, currencyShowMode:.SUBSCRIPT)
        
        let tagView1 = EchoPriceTagLabelView(frame: CGRect(x: 50, y: 240, width: 800, height: lableHeight))
        tagView1.setPrice(price: 100.11, currencyShowMode:.SUPERSCRIPT)
        tagView1.backgroundColor = UIColor.gray
        
        let tagView2 = EchoPriceTagLabelView(frame: CGRect(x: 50, y: 440, width: 800, height: lableHeight))
        tagView2.setPrice(price: 100.11,
                          currencyShowMode:.SUPERSCRIPT,
                          decimalPointShowMode: .SUBSCRIPT,
                          decimalsShowMode:.SUBSCRIPT)
                
        self.view.addSubview(tagView)
        self.view.addSubview(tagView1)
        self.view.addSubview(tagView2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

