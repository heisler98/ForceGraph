//
//  Node.swift
//  ForceGraph
//
//  Created by Hunter Eisler on 6/29/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct Node: View {
    @State var position: CGPoint = .zero
    var body: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 44, height: 44)
            //.position(position)
    }
}

struct Node_Previews: PreviewProvider {
    static var previews: some View {
        Node()
    }
}
