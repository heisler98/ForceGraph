//
//  Graph.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI
import Combine

///A sample Force simulation.
struct Graph: View {
    
    ///The ForceController responsible for managing the simulation.
    @ObservedObject var controller = ForceController<UserParticle> { (links) in
        var contexts: [ParticleContext<UserParticle>] = []
        for _ in 0..<10 {
            let position = Position()
            let particle = UserParticle(position: position)
            
            contexts.append(.init(particle: particle, at: position))
        }
        // creates a webbed graph
        for i in 0...contexts.endIndex-2 {
            for v in i+1...contexts.endIndex-1 {
                links.link(between: contexts[i].particle, and: contexts[v].particle, distance: 200)
            }
        }
        return contexts
    }
    
    ///Manages the state of a rectangle appearing via TapGesture.
    @State var show: Bool = false
    
    var body: some View {
        
        // GeometryReader provides the benefit of a relative coordinate space,
        // delivered via a GeometryProxy value passed as an argument
        GeometryReader { geometry in
            
            ZStack {
                
                // Use of controller's linkLayer is necessary to display the links between nodes
                // This shape's path is constantly redrawn by the controller
                self.controller.linkLayer.stroke(Color.gray, lineWidth: 2)
                
                // For sample's sake, create 10 nodes
                ForEach(self.controller.contexts) { context in
                    
                    Circle()
                        .fill(Color.green)
                        .frame(width: 44, height: 44)
                        
                        // The position of each node is published by the controller
                        // Each position is accessible via index path
                        .position(context.position.cgPoint)
                        
                        // Gestures determine node interactivity
                        // ExclusiveGesture allows both Tap and Drag gestures
                        .gesture(TapGesture().onEnded {
                            self.show.toggle()
                        }.exclusively(before: self.dragParticle(context.particle)))
                }
                
                // Rectangle state determined via Tap
                if self.show {
                    Rectangle().fill(Color.green)
                        .onTapGesture {
                            self.show.toggle()
                    }
                }
            }
            .onAppear {
                
                // Performs the controller's default .onAppear behavior
                self.controller.defaultOnAppear(proxy: geometry)
                
            }.onDisappear {
                
                // Performs the controller's default .onDisappear behavior
                self.controller.defaultOnDisappear()
            }
        }
    }
    ///Creates the `DragGesture` responsible for node interaction.
    /// - parameter particle: The particle being dragged.
    /// - returns: An opaque `Gesture`.
    func dragParticle(_ particle: UserParticle) -> some Gesture {
        
        return DragGesture(minimumDistance: 0.0).onChanged { value in
            
            // Performs the default dragging behavior.
            // For other implementations, refer to the default behavior
            // for reference on necessary particle updates.
            self.controller.draggingParticle(particle, value: value)
            
        }.onEnded { value in
            
            // Performs the default end-of-drag behavior.
            self.controller.endedDraggingParticle(particle, value: value)
            
        }
    }
}

#if DEBUG
struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph()
    }
}
#endif
