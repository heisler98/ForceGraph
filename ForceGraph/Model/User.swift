//
//  User.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import SwiftUI

///Represents a 2D view.
public struct UserParticle: Particle {
    ///The velocity of the particle.
    public var velocity: CGPoint
    ///The position of the particle in the container's coordinate space.
    public var position: CGPoint
    public var fixed: Bool
    ///The particle's unique identifier.
    public var id: UUID = UUID()
    ///The reference to the view's position.
    fileprivate var positionRef: Position
    
    ///Updates the referenced position to the newest particle position values.
    ///- note: This method is called inline for optimization.
    @inline(__always)
    public func tick() {
        positionRef.x = position.x
        positionRef.y = position.y
    }
    ///Initializes and returns an instance of `UserParticle`.
    ///- returns: A new `UserParticle` value.
    public init(position: Position) {
        self.velocity = .zero
        self.position = position.cgPoint
        self.fixed = false
        self.positionRef = position
    }
}

extension UserParticle: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension UserParticle: Identifiable {}

public func ==(lhs: UserParticle, rhs: UserParticle) -> Bool {
    return lhs.id == rhs.id
}
