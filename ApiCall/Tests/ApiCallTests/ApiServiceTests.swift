//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import XCTest
@testable import ApiCall

final class ApiServiceTests: XCTestCase {
    
    struct TestCases {
        let api: ApiService
        let input: URL
        let output: URL
    }
    func testFullURlGeneration() {
        let testCases = [
            TestCases(api: ApiService(), input: URL(string: "a/b/c")!, output: URL(string: "a/b/c")!),
            TestCases(api: ApiService(url: URL(string: "a/b/c")!), input: URL(string: "d/e/f")!, output: URL(string: "a/b/c/d/e/f")!)
        ]
        testCases.forEach({ tc in
            XCTAssertEqual(tc.api.getFullUrl(tc.input), tc.output, "Expected URL Path to be generated correctly")
        })
    }
    
}
