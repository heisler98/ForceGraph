//
//  Controller.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import SwiftUI


class Controller: ObservableObject {
    let center: Center<UserParticle> = Center(.zero)
    private let manyParticle: ManyParticle<UserParticle> = ManyParticle()
    private let links: Links<UserParticle> = Links()
    
    @Published var nodes: [Node] = []
    @Published var cgPoints: [Binding<CGPoint>] = []
    @Published var linkLayer: LinkLayer = LinkLayer(path: Path())
    
    var particles: [UserParticle] = []
    
    lazy var simulation: Simulation<UserParticle> = {
        let simulation : Simulation<UserParticle> = Simulation()
        simulation.insert(force: self.manyParticle)
        simulation.insert(force: self.links)
        simulation.insert(force: self.center)
        simulation.insert(tick: { self.linkLayer = LinkLayer(path: self.links.path(from: &$0)) })
        return simulation
    }()
    
    init() {
        for i in 0..<10 {
            let node = Node()
            cgPoints.append(node.$position)
            let particle = UserParticle(position: cgPoints[i])
            simulation.insert(particle: particle)
            particles.append(particle)
            nodes.append(node)
        }
        for i in 0...nodes.endIndex-2 {
            for v in i+1...nodes.endIndex-1 {
                self.links.link(between: particles[i], and: particles[v], distance: 200)
            }
        }
        
    }
}
