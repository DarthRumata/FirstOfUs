//
//  MapGenerator.swift
//  FirstOfUs
//
//  Created by Stas Kirichok on 01-11-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import GameplayKit

class MapGenerator {
  
  private let size: Int32
  
  init(size: Int) {
    self.size = Int32(size)
  }
  
  func createNoiseMap() -> GKNoiseMap {
    //Get our noise source, this can be customized further
    let seed = Int32.random(in: 0...500)
    let source = GKPerlinNoiseSource(frequency: 0.5, octaveCount: 8, persistence: 0.9, lacunarity: 2.1, seed: seed)
    //Initalize our GKNoise object with our source
    let noise = GKNoise(source)
    //Create our map,
    //sampleCount = to the number of tiles in the grid (row, col)
    let map = GKNoiseMap(
      noise,
      size: vector2(1, 1),
      origin: vector2(0, 0),
      sampleCount: vector2(size, size),
      seamless: true
    )
    return map
  }
  
}
