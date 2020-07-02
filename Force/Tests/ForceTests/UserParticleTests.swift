//
//  ForceGraphTests.swift
//  ForceGraphTests
//
//  Created by Hunter Eisler on 7/1/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import XCTest
import CoreGraphics

// MARK: - UserParticle tests
@testable import ForceGraph
class UserParticleTests: XCTestCase {
    
    // MARK: - Properties
    var sut: UserParticle!
    var position: Position!
    
    // MARK: - Setup | teardown
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        position = Position(0, 0)
        sut = UserParticle(position: position)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        position = nil
    }

    // MARK: - Position tests
    func testPositionUpdate() throws {
        // Arrange
        // set up a new position for the particle
        let newPosition = CGPoint(x: 10, y: 10)
        sut.position = newPosition
        
        // Act
        // tick the particle
        sut.tick()
        
        // Assert
        XCTAssertEqual(position.cgPoint, sut.position)
        
    }

    // MARK: - Protocol conformance tests
    func testEquality() throws {
        // Arrange
        let newPosition = Position(0, 0)
        let anotherParticle = UserParticle(position: newPosition)
        
        // Act
        let areDifferent = (sut != anotherParticle)
        
        // Assert
        XCTAssertTrue(areDifferent, "The SUT and a new particle are considered the same.")
    }
    

}
