//
//  ParticleContextTests.swift
//  ForceGraphTests
//
//  Created by Hunter Eisler on 7/2/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import XCTest

// MARK: - ParticleContext tests
@testable import ForceGraph
class ParticleContextTests: XCTestCase {

    // MARK: - Properties
    var sut: ParticleContext<MockParticle>!
    
    // MARK: - Setup | teardown
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Initializes a context at (0,0).
        sut = .createDefaultContext()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    // MARK: - Initializer tests
    func testDefaultCreation() throws {
        /// Arrange
        // SUT is created via default creation
        let particlePosition = sut.particle.positionRef
        let contextPosition = sut.position
        
        /// Act | Assert
        let areIdentical = (particlePosition === contextPosition)
        XCTAssertTrue(areIdentical, "The particle position and the context position are not identical.")
    }
    
    func testDefaultPositionCreation() throws {
        /// Arrange
        // SUT is not created via this initializer
        sut = ParticleContext<MockParticle>.init(particle: .init(position: Position(0,0)))
        
        /// Act | Assert
        let areIdentical = (sut.position === sut.particle.positionRef)
        XCTAssertTrue(areIdentical, "The particle position and the context position are not identical.")
    }
    
    func testFullInit() throws {
        /// Arrange
        // SUT is not created via this initializer
        let position = Position(0,0)
        sut = ParticleContext<MockParticle>.init(particle: .init(position: position), at: position)
        
        /// Act
        let areIdentical = (sut.particle.positionRef === sut.position)
        let identicalToBeginning = (sut.position === position)
        
        /// Assert
        XCTAssertTrue({
           areIdentical == identicalToBeginning && areIdentical == true
        }(), "The particle position and the context position are not identical to the given position.")
        
    }
    
    // MARK: - Protocol conformance tests
    
    func testEquality() throws {
        /// Arrange
        let anotherSUT: ParticleContext<MockParticle> = .createDefaultContext()
        
        /// Act
        let areDifferent = (anotherSUT != sut)
        
        /// Assert
        XCTAssertTrue(areDifferent, "The contexts are separate instantiations yet returning equal.")
    }
}
