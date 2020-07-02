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
    
    
}
