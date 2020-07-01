//
//  Controller.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import SwiftUI

//MARK: - ForceController
///A type which manages a running Force simulation.
public class ForceController: ObservableObject {
    
    //MARK: - Private properties
    ///Conforms to `Force` protocol; inserted into simulation.
    private let manyParticle: ManyParticle<UserParticle> = ManyParticle()
    private let links: Links<UserParticle> = Links()
    
    //MARK: - Published properties
    ///A 2D shape which draws the links between particles. Updates with each tick.
    @Published var linkLayer: LinkLayer = LinkLayer(path: Path())
    ///A published collection of `Position` objects ordered by particle.
    @Published var positions: [Position] = []
    
    //MARK: - Public properties
    ///A public collection of `UserParticle`s used by the controller.
    public var particles: [UserParticle] = []
    ///The center of the view, in the parent's coordinate space.
    public let center: Center<UserParticle> = Center(.zero)
    ///The current simulation managed by the controller.
    public lazy var simulation: Simulation<UserParticle> = {
        let simulation : Simulation<UserParticle> = Simulation()
        simulation.insert(force: self.manyParticle)
        simulation.insert(force: self.links)
        simulation.insert(force: self.center)
        simulation.insert(tick: { self.linkLayer = LinkLayer(path: self.links.path(from: &$0)) })
        return simulation
    }()
    ///Initializes and returns an instance with preset configuration.
    public init() {
        for _ in 0..<10 {
            
            let position = Position()
            
            positions.append(position)
            let particle = UserParticle(position: position)
            
            simulation.insert(particle: particle)
            particles.append(particle)
            
            
        }
        for i in 0...particles.endIndex-2 {
            for v in i+1...particles.endIndex-1 {
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
    ///An anonymous function for use in configuration of `ForceController`.
    public typealias ForceConfigurator = (Links<UserParticle>) -> ([UserParticle], [Position])
    ///Initializes and returns a `Controller` object through calling the passed configuration.
    public init(configuration: ForceConfigurator) {
        
    }
}
