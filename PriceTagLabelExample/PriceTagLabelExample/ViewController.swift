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
        let tagView = EchoPriceTagLabelView(frame: CGRect(x: 50, y: 40, width: 400, height: 100))
        tagView.setPrice(price: 100.11, currencyShowMode:.SUBSCRIPT)
        
        let tagView1 = EchoPriceTagLabelView(frame: CGRect(x: 50, y: 240, width: 400, height: 100))
        tagView1.setPrice(price: 100.11, currencyShowMode:.SUPERSCRIPT)
        
        let tagView2 = EchoPriceTagLabelView(frame: CGRect(x: 50, y: 440, width: 400, height: 100))
        tagView2.setPrice(price: 100.11,
                          currencyShowMode:.SUPERSCRIPT,
                          decimalPointShowMode: .SUBSCRIPT,
                          decimalsShowMode:.SUBSCRIPT)
        
//        tagView.layer.borderColor = UIColor.black.cgColor
//        tagView.layer.borderWidth = 2
        
        self.view.addSubview(tagView)
        self.view.addSubview(tagView1)
        self.view.addSubview(tagView2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

