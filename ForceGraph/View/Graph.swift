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
    @State var cgPoints: [CGPoint] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map { _ in CGPoint(x: 0, y: 0)}
    @GestureState var isDragging: Bool = false
    var subscribers: [AnyCancellable?] = []
    var body: some View {
        ZStack {
            controller.linkLayer.stroke(Color.gray, lineWidth: 2)
            ForEach(0..<10) { i in
                self.controller.nodes[i]
                    .position(self.controller.simulation.particles[self.controller.simulation.particles.firstIndex(of: self.controller.particles[i])!].position)
                    
            }
        }
            .onAppear {
                self.controller.center.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                _ = self.controller.$cgPoints.sink {
                    self.cgPoints = $0.map { $0.wrappedValue }
                }
                self.controller.simulation.start()
                
        }.onDisappear {
            self.controller.simulation.stop()
        }
    }
    
    func dragParticle(_ particle: UserParticle) -> some Gesture {
        var aParticle = particle
        return DragGesture(minimumDistance: 0.0).updating($isDragging) { (value, state, transaction) in
            
            
        }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph()
    }
}
