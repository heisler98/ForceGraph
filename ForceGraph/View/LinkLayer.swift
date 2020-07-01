//
//  LinkLayer.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI
///The shape responsible for drawing links (edges) between particles (vertices).
public struct LinkLayer: Shape {
    ///The path of the links.
    ///- Note: This is updated before the shape is redrawn.
    public var path: Path
    
    public func path(in rect: CGRect) -> Path {
        self.path
    }
    ///Initializes and returns a `Shape` with the specified path.
    /// - parameter path: The path of the shape. 
    public init(path: Path) {
        self.path = path
    }
}
