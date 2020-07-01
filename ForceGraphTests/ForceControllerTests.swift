//
//  ForceControllerTests.swift
//  ForceGraphTests
//
//  Created by Hunter Eisler on 7/1/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import XCTest

@testable import ForceGraph
class ForceControllerTests: XCTestCase {

    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

// mock Particle structure
public struct MockParticle: Particle {
    public var position: CGPoint
    public var velocity: CGPoint
    public var fixed: Bool
    public var id: ID = UUID()
    
    public func tick() {
        
    }
}

extension MockParticle: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MockParticle: Identifiable {
    public typealias ID = UUID
    
}
