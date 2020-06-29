//
//  CGPointWrapper.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import CoreGraphics

public class Position {
    public var x: CGFloat
    public var y: CGFloat
    
    public convenience init() {
        self.init(0,0)
    }
    
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    public var cgPoint: CGPoint {
        CGPoint(x: self.x, y: self.y)
    }
}

public extension CGPoint {
    func wrapped() -> Position {
        Position(self.x, self.y)
    }
}
