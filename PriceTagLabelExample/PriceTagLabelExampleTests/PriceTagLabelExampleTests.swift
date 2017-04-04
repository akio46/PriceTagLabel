//
//  PriceTagLabelExampleTests.swift
//  PriceTagLabelExampleTests
//
//  Created by Echo on 2017/4/3.
//  Copyright © 2017年 Echo. All rights reserved.
//

import XCTest
@testable import PriceTagLabelExample

class PriceTagLabelExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSplitPrice() {
        let label = EchoPriceTagLabelView(x:0, y:0, height:100)
        var result = label.getDividedPrice(price: 10.123)
        XCTAssertEqual(result.integerPart, 10)
        XCTAssertEqual(result.decimalPart, 12)
        
        result = label.getDividedPrice(price: 10.125)
        XCTAssertEqual(result.integerPart, 10)
        XCTAssertEqual(result.decimalPart, 13)
        
        result = label.getDividedPrice(price: 0.125)
        XCTAssertEqual(result.integerPart, 0)
        XCTAssertEqual(result.decimalPart, 13)
        
        result = label.getDividedPrice(price: -1.125)
        XCTAssertEqual(result.integerPart, -1)
        XCTAssertEqual(result.decimalPart, 13)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
