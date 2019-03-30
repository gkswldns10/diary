//
//  DiaryAppTests.swift
//  DiaryAppTests
//
//  Created by  Jeewwon Han on 4/7/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import XCTest
@testable import DiaryApp

class DiaryAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testgettimes() {
        let vc = AddDiaryViewController()
        let ret = vc.getDate()
        XCTAssert(ret.isEmpty == false, "cannot load current time")
    }
    
    func testGetEmail(){
        let vc = ViewController()
        let email = vc.fetchProfile()
        XCTAssert(email.isEmpty == false, "cannot load email")
    }
    
    func testget(){
        let vc = indicatorViewControlViewController()
        vc.getData(email_: "gkswldns10@naver,com")
        XCTAssert(Diaries.count != 0, "not successful signout")
        
    }
    func testsignout(){
        let vc = ListViewController()
        vc.f_signout()
        XCTAssert(FBSDKAccessToken.current() == nil, "not successful signout")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
