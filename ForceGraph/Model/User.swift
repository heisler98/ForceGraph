//
//  User.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import SwiftUI

public struct UserParticle: Particle {
    
    public var velocity: CGPoint
    public var position: CGPoint
    public var fixed: Bool
    public var id: UUID = UUID()
    
    @Binding fileprivate var viewPosition: CGPoint
    
    @inline(__always)
    public func tick() {
        viewPosition = position
    }
    
    public init(position: Binding<CGPoint>) {
        self._viewPosition = position
        self.velocity = .zero
        self.position = position.wrappedValue
        self.fixed = false
    }
}

extension UserParticle: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
    }
}

public func ==(lhs: UserParticle, rhs: UserParticle) -> Bool {
    return lhs.id == rhs.id
}