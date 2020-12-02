//
//  SRKitTests.swift
//  SRKitTests
//
//  Created by Nick Robison on 12/2/20.
//

import XCTest
import PromiseKit
@testable import SRKit

class SRKitTests: XCTestCase {
    
    var backend: SRBackend = SRHttpBackend(connect: "http://127.0.0.1:8080/graphql")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPatientGet() throws {
        // This is an example of a functional test case.s
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp1 = XCTestExpectation()
        backend.getPatients().done { patients in
            XCTAssertEqual(0, patients.count)
            exp1.fulfill()
        }.catch { error in
            XCTFail(error.localizedDescription)
        }
        wait(for: [exp1], timeout: 10)
    }
}
