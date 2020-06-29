//
//  Graph.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI
import Combine

struct Graph: View {
    @ObservedObject var controller = Controller()
    @GestureState var isDragging: Bool = false
    var subscribers: [AnyCancellable?] = []
    var body: some View {
        ZStack {
            controller.linkLayer.stroke(Color.gray, lineWidth: 2)
            ForEach(0..<10) { i in
                self.controller.nodes[i]
                    .position(self.controller.positions[i].cgPoint)
                    .gesture(self.dragParticle(self.controller.particles[i]))
            }
        }
            .onAppear {
                self.controller.center.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                self.controller.simulation.start()
                
        }.onDisappear {
            self.controller.simulation.stop()
        }
    }
    
    func dragParticle(_ particle: UserParticle) -> some Gesture {
        var aParticle = particle
        return DragGesture(minimumDistance: 0.0).updating($isDragging) { (value, state, transaction) in
            //gesture state change
            state = true
            
            //particle state changes
            if state == true {
                aParticle.fixed = true
                aParticle.position = value.location
                self.controller.simulation.kick()
                self.controller.simulation.particles.update(with: aParticle)
            }
        }.onEnded { value in
            aParticle.fixed = false
            let xVelocity = abs(Double(value.predictedEndLocation.x - value.location.x) / Double(value.time.timeIntervalSinceNow))
            let yVelocity = abs(Double(value.predictedEndLocation.y - value.location.y) / Double(value.time.timeIntervalSinceNow))
            //aParticle.velocity += CGPoint(x: xVelocity, y: yVelocity) * 0.05
            self.controller.simulation.particles.update(with: aParticle)
        }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph()
    }
}
