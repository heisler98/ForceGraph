//
//  Graph.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - SampleGraph
///A sample Force simulation.
struct SampleGraph: View {
    // MARK: - Observed properties
    ///The ForceController responsible for managing the simulation.
    @ObservedObject var controller = ForceController<UserParticle> { (links) in
        
        // Create a context set
        var contexts: [ParticleContext<UserParticle>] = []
        
        for _ in 0..<10 {
            
            // Positions are managed, updated, and published via reference
            // Particles are copied values
            let position = Position()
            let particle = UserParticle(position: position)
            
            // Create the context
            contexts.append(.init(particle: particle, at: position))
        }
        
        // Create a webbed graph with the passed arg
        for i in 0...contexts.endIndex-2 {
            for v in i+1...contexts.endIndex-1 {
                
                // Links stores relationships between particles
                // Updates will redraw the controller's linkLayer path
                links.link(between: contexts[i].particle, and: contexts[v].particle, distance: 200)
            }
        }
        
        // Pass the context set back to the controller
        return contexts
    }
    //MARK: - State properties
    ///Manages the state of a rectangle appearing via TapGesture.
    @State var show: Bool = false
    ///Manages the textual display of node position. (Superfluous)
    @State var currentPosition: CGPoint = .zero
    
    // MARK: - Body
    var body: some View {
        
        // GeometryReader provides the benefit of a relative coordinate space,
        // delivered via a GeometryProxy value passed as an argument
        GeometryReader { geometry in
            
            ZStack {
                
                // Use of controller's linkLayer is necessary to display the links between nodes
                // This shape's path is constantly redrawn by the controller
                self.controller.linkLayer.stroke(Color.gray, lineWidth: 2)
                
                // Controller publishes an array of contexts
                // Each node is represented by its context, which contains
                // its particle and associated position
                ForEach(self.controller.contexts) { context in
                    
                    Circle()
                        .fill(Color.green)
                        .frame(width: 44, height: 44)
                        
                        // The position of each node is published by the controller
                        // Position is a member of the context
                        .position(context.position.cgPoint)
                        
                        // Gestures determine node interactivity
                        // ExclusiveGesture allows both Tap and Drag gestures
                        .gesture(TapGesture().onEnded {
                            withAnimation {
                                self.show.toggle()
                            }
                        }.exclusively(before: self.dragParticle(context.particle)))
                }
                
                // Rectangle state determined via Tap
                if self.show {
                    self.tapAlert
                        .position(x: geometry.size.width/2, y: 10)
                        .padding(geometry.safeAreaInsets)
                        .onTapGesture {
                            self.show.toggle()
                    }
                        .animation(.default)
                }
                
                // For demonstration purposes: shows the position of each node as it's dragged
                VStack(alignment: .center) {
                    Spacer()
                    Text("(\(self.currentPosition.x), \(self.currentPosition.y))")
                        .padding(geometry.safeAreaInsets)
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
    // MARK: - Drag functions
    ///Creates the `DragGesture` responsible for node interaction.
    /// - parameter particle: The particle being dragged.
    /// - returns: An opaque `Gesture`.
    func dragParticle(_ particle: UserParticle) -> some Gesture {
        
        return DragGesture(minimumDistance: 0.0).onChanged { value in
            
            // Performs the default dragging behavior.
            // For other implementations, refer to the default behavior
            // for reference on necessary particle updates.
            self.controller.draggingParticle(particle, value: value)
            
            self.currentPosition = value.location //superfluous; for demo
        }.onEnded { value in
            
            // Performs the default end-of-drag behavior.
            self.controller.endedDraggingParticle(particle, value: value)
           
            self.currentPosition = value.location //superfluous; for demo
        }
    }
    // MARK: - Ancillary views
    var tapAlert: some View {
        Rectangle()
            .fill(Color.green)
            .frame(width: 120, height: 80)
        .overlay(
            Text("Tapped a node")
        )
            
    }
}
// MARK: - Xcode preview provider
#if DEBUG
struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        SampleGraph()
    }
}
#endif
