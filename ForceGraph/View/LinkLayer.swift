//
//  LinkLayer.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct LinkLayer: Shape {
    var path: Path
    
    func path(in rect: CGRect) -> Path {
        self.path
    }
    
    init(path: Path) {
        self.path = path
    }
}
