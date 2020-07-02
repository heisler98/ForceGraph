# Force

A force-based graph simulation packaged in a Swift library.

## Description

This library provides default functionality for a force-based graph simulation. The simulation provides force-based behavior on a mutable set of particles. 

This library is compatible with both UIKit and SwiftUI. 

## Usage 

### Configuring a controller
```
let controller = ForceController<_> { (links: Links<_>) in 
    // Create particle contexts 
    let firstContext = ParticleContext<_>(position: .init(0,0))
    let secondContext = ParticleContext<_>(position: .init(1, 1))
    
    // Link the context
    links.link(between: firstContext.particle, and: secondContext.particle, distance: 100, strength: 25)
    
    // Return the context set 
    return [firstContext, secondContext]
}
```
### Observing a controller
The controller can be observed from within a SwiftUI view. 
```
struct Graph: View { 
    @ObservedObject var controller = ForceController(configuration: myConfiguration)
}
```
See the sample ForceGraph app, including SampleGraph.swift, for more details.
