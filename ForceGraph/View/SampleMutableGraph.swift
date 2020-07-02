//
//  SampleMutableGraph.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 7/1/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI
//MARK: - SampleMutableGraph
/// A sample mutable Force simulation.
struct SampleMutableGraph: View {
    //MARK: - Observed properties
    @ObservedObject var controller = ForceController<UserParticle> { (links) in
        
        // Create a context set
        var contexts = [ParticleContext<UserParticle>]()
        
        // Add three particles
        contexts.append(contentsOf: [
            
            // .createDefaultContext() initializes a default particle and position
            ParticleContext<UserParticle>.createDefaultContext(),
            ParticleContext<UserParticle>.createDefaultContext(),
            ParticleContext<UserParticle>.createDefaultContext()
        ])
        
        // Link three particles
        links.link(between: contexts.first!.particle, and: contexts.last!.particle, distance: 100)
        links.link(between: contexts.first!.particle, and: contexts[1].particle, distance: 100)
        links.link(between: contexts[1].particle, and: contexts.last!.particle, distance: 100)
        
        // Return the context set
        return contexts
    }
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                // linkLayer given by controller
                self.controller.linkLayer
                    .stroke(Color.green, lineWidth: 2)
                
                // Iterate through controller's context set
                ForEach(self.controller.contexts) { context in
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 44, height: 44)
                        
                        // Position updated by controller
                        .position(context.position.cgPoint)
                    
                        // Make node draggable
                        .gesture(self.dragParticle(context.particle))
                }
                // Provide an "add" view
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        self.button
                            .padding()
                    }
                }
            }.onAppear {
                
                //Performs the controller's default .onAppear behavior
                self.controller.defaultOnAppear(proxy: geometry)
            }.onDisappear {
                
                //Performs the controller's default .onDisappear behavior
                self.controller.defaultOnDisappear()
            }
            
        }
    }
    
    // MARK: - Ancillary views
    ///Provides a `Button` view for adding a new node.
    var button: some View {
        Button(action: {
            self.controller.update(configuration: self.addNode(link:))
        }) {
            Image(systemName: "plus.circle.fill")
            .resizable()
                .frame(width: 44, height: 44)
        }
    }
    
    // MARK: - Helper functions
    ///Returns a configuration which adds a node.
    /// - parameter links: The links passed by the configuration.
    /// - returns: A `ParticleContext` set.
    func addNode(link: Links<UserParticle>) -> [ParticleContext<UserParticle>] {
        
        // Create a context set
        var contexts = [ParticleContext<UserParticle>]()
        
        // Create a new position & particle
        let position = Position(30, 0)
        let particle = UserParticle(position: position)
        let newContext = ParticleContext(particle: particle, at: position)
        
        // Append the context
        contexts.append(newContext)
        
        // Find a node to link
        let contextToAttach = self.controller.contexts.randomElement()!
        
        // Link the nodes
        link.link(between: newContext.particle, and: contextToAttach.particle, distance: 100)
        
        // .kick() ensures display link remains active
        self.controller.simulation.kick()
        
        // Return the context set
        return contexts
    }
    
    // MARK: - Drag functions
    ///Creates the `DragGesture` responsible for node interaction.
    /// - parameter particle: The particle being dragged.
    /// - returns: An opaque `Gesture`.
    func dragParticle(_ particle: UserParticle) -> some Gesture {
        DragGesture(minimumDistance: 0.0)
            .onChanged { value in
                
                // Controller provides drag interactivity
                self.controller.draggingParticle(particle, value: value)
            }
        .onEnded { value in
            
            self.controller.endedDraggingParticle(particle, value: value)
            }
    }
}

struct SampleMutableGraph_Previews: PreviewProvider {
    static var previews: some View {
        SampleMutableGraph()
    }
}
