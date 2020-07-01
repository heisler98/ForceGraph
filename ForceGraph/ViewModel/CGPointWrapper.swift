//
//  CGPointWrapper.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import CoreGraphics

///A class wrapper for `CGPoint` structures.
public class Position {
    ///The x-coordinate value.
    public var x: CGFloat
    ///The y-coordinate value.
    public var y: CGFloat
    ///Initializes and returns a new instance of `Position` at point (0,0).
    ///- returns: A new `Position` object.
    public convenience init() {
        self.init(0,0)
    }
    ///Initializes and returns a new instance of `Position` at the specified coordinate.
    ///- parameter x: The x-coordinate.
    ///- parameter y: The y-coordinate.
    ///- returns: A new `Position` object.
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    ///The point expressed as a `CGPoint` scalar value.
    public var cgPoint: CGPoint {
        CGPoint(x: self.x, y: self.y)
    }
}

public extension CGPoint {
    ///The point value wrapped in a `Position` object.
    ///- returns: A `Position` object with the same scalar value.
    func wrapped() -> Position {
        Position(self.x, self.y)
    }
}
