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
///Use an object of this type to observe node's view positions
///and update by gesture accordingly.
public class ForceController<T : Particle>: ObservableObject {
    
    //MARK: - Private properties
    ///Conforms to `Force` protocol; inserted into simulation.
    private let manyParticle: ManyParticle<T> = ManyParticle()
    private let links: Links<T> = Links()
    
    //MARK: - Published properties
    ///A 2D shape which draws the links between particles. Updates with each tick.
    @Published var linkLayer: LinkLayer = LinkLayer(path: Path())
    //
    @Published var contexts: [ParticleContext<T>] = []
    
    //MARK: - Public properties
    ///A public collection of `UserParticle`s used by the controller.
    public var particles: [T] = []
    ///The center of the view, in the parent's coordinate space.
    public let center: Center<T> = Center(.zero)
    ///The current simulation managed by the controller.
    public lazy var simulation: Simulation<T> = {
        let simulation : Simulation<T> = Simulation()
        simulation.insert(force: self.manyParticle)
        simulation.insert(force: self.links)
        simulation.insert(force: self.center)
        simulation.insert(tick: { self.linkLayer = LinkLayer(path: self.links.path(from: &$0)) })
        return simulation
    }()
    
    //MARK: - Initializers
    ///An anonymous function for use in configuration of `ForceController`.
    public typealias ForceConfigurator = (Links<T>) -> [ParticleContext<T>]
    ///Initializes and returns a `Controller` object through calling the passed configuration.
    public init(configuration: @escaping ForceConfigurator) {
        self.contexts = configuration(links)
        self.contexts.forEach { self.simulation.insert(particle: $0.particle) }
    }
    
    //MARK: - Public view configurators
    ///Performs the default Force behavior for `View`.onAppear()
    /// - parameter proxy: The `GeometryProxy` in a `GeometryReader` view-building closure.
    /// - note: If proxy is nil, the center will be calculated based on the bounds of the screen.
    public func defaultOnAppear(proxy: GeometryProxy?) {
        //guard against a nil proxy
        guard let proxy = proxy else {
            self.center.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            self.simulation.start()
            return
        }
        //set the center to the proxy's center
        self.center.center = CGPoint(x: proxy.size.width/2, y: proxy.size.height/2)
        self.simulation.start()
    }
    ///Performs the default Force behavior for `View`.onDisappear()
    public func defaultOnDisappear() {
        self.simulation.stop()
    }
    
    //MARK: - Public gesture configurators
    ///Performs the default Force behavior for a particle currently being dragged.
    /// - parameter particle: The particle being dragged.
    /// - parameter value: The gesture's value.
    public func draggingParticle(_ particle: T, value: DragGesture.Value) {
        var particle = particle
        particle.fixed = true
        particle.position = value.location
        self.simulation.kick()
        self.simulation.particles.update(with: particle)
    }
    ///Performs the default Force behavior for a particle that has just finished a drag.
    /// - parameter particle: The particle being dragged.
    /// - parameter value: The gesture's value.
    public func endedDraggingParticle(_ particle: T, value: DragGesture.Value) {
        var particle = particle
        particle.fixed = false
        
        let xVelocity = abs(Double(value.predictedEndLocation.x - value.location.x) / Double(value.time.timeIntervalSinceNow))
        let yVelocity = abs(Double(value.predictedEndLocation.y - value.location.y) / Double(value.time.timeIntervalSinceNow))
        particle.velocity += CGPoint(x: xVelocity, y: yVelocity) * 0.05
        particle.position = value.location
        
        self.simulation.particles.update(with: particle)
    }

}

