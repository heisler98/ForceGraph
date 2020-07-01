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
    @Published var linkLayer: LinkLayer = LinkLayer(path: Path())
    
    @Published var positions: [Position] = []
    
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
        for _ in 0..<10 {
            let node = Node()
            let position = Position()
            
            positions.append(position)
            let particle = UserParticle(position: position)
            
            simulation.insert(particle: particle)
            particles.append(particle)
            
            nodes.append(node)
        }
        for i in 0...nodes.endIndex-2 {
            for v in i+1...nodes.endIndex-1 {
                self.links.link(between: particles[i], and: particles[v], distance: 200)
            }
        }
//        var i = 0
//        var j = 1
//        for _ in nodes {
//            guard i < particles.endIndex && j < particles.endIndex else { break }
//            self.links.link(between: particles[i], and: particles[j], distance: 50)
//            i = i+1
//            j = j+1
//        }
        
    }
}
