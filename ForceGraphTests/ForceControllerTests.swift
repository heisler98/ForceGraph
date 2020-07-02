//
//  ForceControllerTests.swift
//  ForceGraphTests
//
//  Created by Hunter Eisler on 7/1/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import XCTest
import SwiftUI

// MARK: - ForceController tests
@testable import ForceGraph
class ForceControllerTests: XCTestCase {

    // MARK: - Properties
    var sut: ForceController<MockParticle>!
    var configuration: ForceController<MockParticle>.ForceConfigurator = { links in
        var contexts = [ParticleContext<MockParticle>]()
        contexts.append(contentsOf: [
            ParticleContext<MockParticle>.createDefaultContext(),
            ParticleContext<MockParticle>.createDefaultContext()
        ])
        
        links.link(between: contexts[0].particle, and: contexts[1].particle)
        
        return contexts
    }
    // MARK: - Setup | teardown
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ForceController<MockParticle>(configuration: configuration)
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    // MARK: - Configuration tests
    func testConfiguration() throws {
        /// Arrange
        // Create arrays for comparison
        let sutParticles = sut.contexts.map { $0.particle }
        let simParticles = sut.simulation.particles
        
        /// Act
        // Compare the sets' contents
        let areSetsEqual = (Set<MockParticle>(sutParticles) == simParticles)
        
        /// Assert
        // Test they are equal
        XCTAssertTrue(areSetsEqual, "The simulation particle set is unequal to controller's particle set.")
    }
    
    func testUpdateConfiguration() throws {
        /// Arrange
        // Find and create nodes
        // Update configuration
        let newContext = try addNode()
        
        /// Act
        // Find newest context member
        let newestNode = try XCTUnwrap(sut.contexts.last, "No elements in SUT contexts array")
        
        /// Assert
        // Test contexts are equal
        let areContextsEqual = (newestNode.id == newContext.id)
        XCTAssertTrue(areContextsEqual, "The latest context is not the most recent context in the controller")
    }

    func testUpdateSimulation() throws {
        /// Arrange
        // Create new context and update controller
        let newContext = try addNode()
        
        /// Act
        // Does the simulation contain the new context's particle?
        let doesContain = sut.simulation.particles.contains(newContext.particle)
        
        /// Assert
        // Test whether the simulation contains the particle
        XCTAssertTrue(doesContain, "The simulation did not contain the new context's particle.")
    }
    
    // MARK: - Publisher tests
    
    func testContextPublishing() throws {
        /// Arrange
        // Create a new context and update controller
        let newContext = try addNode()
        
        /// Act
        // Set the new positions
        newContext.position.x = 19
        newContext.position.y = 24
        
        /// Assert
        // Test that the positions are equal
        guard let latestContext = sut.contexts.last else {
            throw ArrayError.unexpectedlyEmpty(sut.contexts)
        }
        XCTAssertEqual(newContext.position.x, latestContext.position.x, "The x-values of the positions are not equal.")
        XCTAssertEqual(newContext.position.y, latestContext.position.y, "The y-values of the positions are not equal.")
    }
    
    // Shall pass so long as the paths are not equal
    func testPathPublishing() throws {
        /// Arrange
        // Determine the original path
        let originalPath = sut.linkLayer.path
        
        /// Act
        // Add a node
        try addNode()
        
        /// Assert
        let newPath = sut.linkLayer.path
        XCTAssertNotEqual(originalPath, newPath, "The paths are the same after adding a new particle.")
    }
    
    // MARK: - Helper functions
    /// Creates a context and publishes it to the controller.
    /// - returns: The newly created context.
    @discardableResult
    func addNode() throws -> ParticleContext<MockParticle> {
        
        // Find a random context currently in the controller,
        // or throw .unexpectedlyEmpty if none are found
        guard let randomNode = sut.contexts.randomElement() else {
            throw ArrayError.unexpectedlyEmpty(sut.contexts)
        }
        // Create the context
        let newContext: ParticleContext<MockParticle> = .createDefaultContext()
        
        // Update the controller
        sut.update { links in
            links.link(between: newContext.particle, and: randomNode.particle)
            return [newContext]
        }
        
        // Return the context
        return newContext
    }
    
    ///An `Error` type describing array errors
    enum ArrayError: Error, CustomStringConvertible {
        
        var description: String {
            switch self {
            case .unexpectedlyEmpty(let obj):
                return "\(obj) was unexpectedly empty"
            }
        }
        ///An array found empty, unexpectedly.
        case unexpectedlyEmpty(Any)
    }
}

// mock Particle structure
public struct MockParticle: Particle {
    public init(position: Position) {
        self.positionRef = position
        self.position = position.cgPoint
        self.velocity = .zero
        self.fixed = false
    }
    public var positionRef: Position
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
extension MockParticle: Equatable {
    public static func ==(lhs: MockParticle, rhs: MockParticle) -> Bool {
        lhs.id == rhs.id
    }
}
extension MockParticle: Identifiable {
    public typealias ID = UUID
    
}
