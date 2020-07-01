# ForceGraph
An implementation of a force directed Swift graph. 
## Usage
A graph is producible via an object of type `ForceController`. Instantiate `ForceController` with information regarding initial node count and connection: 

```
let controller = ForceController { (linker: Links<T: Particle> -> [ParticleContext<T: Particle>] in
  var contexts = [ParticleContexts<T>]()
  
  for _ in 0..<10 { 
    let position = Position() 
    let particle = T(position: position)
    contexts.append(ParticleContexts<T>(particle: particle))
   }
   
   //...
   linker.link(between: contextOne.particle, and: contextTwo.particle)
}
```

### SwiftUI
Observe `ForceController` in a SwiftUI view to receive updates on the contexts of nodes in the graph. 

```
@ObservedObject var controller = ForceController { ... } 

var body: some View { 
  // ... 
  ForEach(self.controller.contexts) { context in 
    Circle()
      .position(context.position.cgPoint)
}
```

Set the given `linkLayer` shape property in the view for a visible path between nodes. 

```
var body: some View { 
  controller.linkLayer
    .stroke(Color.gray, lineWidth: 2)
  //...
}
```

Utilize configurator methods to offer preset interactivity. 

```
// ... 
Circle()
.position(context.position.cgPoint)
.gesture(
  DragGesture()
    .onChanged { value in 
      controller.draggingParticle(particle, value: value)
    }.onEnded { value in 
      controller.endedDraggingParticle(particle, value: value)
    }
)
```

