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
    @ObservedObject var controller = ForceController()
    @GestureState var isDragging: Bool = false
    @State var show: Bool = false
    var subscribers: [AnyCancellable?] = []
    var body: some View {
        GeometryReader { geometry in
        ZStack {
            self.controller.linkLayer.stroke(Color.gray, lineWidth: 2)
            ForEach(0..<10) { i in
//                self.controller.nodes[i]
                Image(systemName: "paperplane").resizable().frame(width: 44, height: 44)
                    .position(self.controller.positions[i].cgPoint)
                    .gesture(TapGesture().onEnded {
                        self.show.toggle()
                    }.exclusively(before: self.dragParticle(self.controller.particles[i], index: i)))
            }
            if self.show {
                Rectangle().fill(Color.green)
                    .onTapGesture {
                        self.show.toggle()
                }
            }
        }
            .onAppear {
                self.controller.center.center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                self.controller.simulation.start()
                
        }.onDisappear {
            self.controller.simulation.stop()
        }
        }
    }
    
    func dragParticle(_ particle: UserParticle, index: Int) -> some Gesture {
        var aParticle = particle
        return DragGesture(minimumDistance: 0.0).onChanged { value in
            
            //particle state changes
            
                aParticle.fixed = true
                aParticle.position = value.location
                self.controller.simulation.kick()
                self.controller.simulation.particles.update(with: aParticle)
                
            
        }.onEnded { value in
            aParticle.fixed = false
            let xVelocity = abs(Double(value.predictedEndLocation.x - value.location.x) / Double(value.time.timeIntervalSinceNow))
            let yVelocity = abs(Double(value.predictedEndLocation.y - value.location.y) / Double(value.time.timeIntervalSinceNow))
            aParticle.velocity += CGPoint(x: xVelocity, y: yVelocity) * 0.05
            aParticle.position = value.location
            self.controller.simulation.particles.update(with: aParticle)
        }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph()
    }
}
