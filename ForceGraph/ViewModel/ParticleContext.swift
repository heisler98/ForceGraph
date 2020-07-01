//
//  ParticleContext.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 7/1/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

// MARK: - ParticleContext
///Describes the context of a particle, including its position.
public struct ParticleContext<T> where T : Particle {
    // MARK: - Public properties
    public typealias ID = UUID
    ///The unique identifier of the context.
    public var id: ID = UUID()
    ///The particle to contextualize.
    public var particle: T
    ///The position of the particle.
    public var position: Position
    
    // MARK: - Public initializers
    ///Initializes and returns a `ParticleContext` at the set position.
    /// - parameter particle: The particle to contextualize.
    /// - parameter at: The position of the particle.
    public init(particle: T, at position: Position) {
        self.particle = particle
        self.position = position
    }
    ///Initializes and returns a `ParticleContext` at the origin.
    /// - parameter particle: The particle to contextualize.
    public init(particle: T) {
        self.particle = particle
        self.position = Position()
    }
}

extension ParticleContext: Identifiable {}
extension ParticleContext: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension ParticleContext: Equatable {
    static public func ==(lhs: ParticleContext<T>, rhs: ParticleContext<T>) -> Bool {
        return lhs.id == rhs.id
    }
}
