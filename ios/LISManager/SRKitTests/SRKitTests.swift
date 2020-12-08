//
//  SRKitTests.swift
//  SRKitTests
//
//  Created by Nick Robison on 12/2/20.
//

//import XCTest
//import Combine
//@testable import SRKit
//
//class SRKitTests: XCTestCase {
//
//    var backend: SRBackend = SRHttpBackend(connect: "http://127.0.0.1:8080/graphql")
//
//    var cancellables: [AnyCancellable] = []
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testPatientGet() throws {
//        let exp1 = XCTestExpectation()
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.backend.getPatients()
//                .count()
//                .assertNoFailure()
//                .sink { count in
//                    XCTAssertEqual(30, count)
//                    exp1.fulfill()
//                }.store(in: &self.cancellables)
//        }
//
//        wait(for: [exp1], timeout: 10)
//    }
//}
