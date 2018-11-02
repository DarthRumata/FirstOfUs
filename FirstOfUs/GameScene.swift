//
//  GameScene.swift
//  FirstOfUs
//
//  Created by Stas Kirichok on 01-11-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import SpriteKit
import GameplayKit

private let mapSize = 350
private let tileSize = CGSize(width: 111, height: 128)

class GameScene: SKScene {
  
  private var tileMap: SKTileMapNode!
  
  private var lastUpdateTime: TimeInterval = 0
  private var startCameraPosition: NSPoint!
  private var deltaMagnification: CGFloat!
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    configureRecognizers()
  }
  
  override func sceneDidLoad() {
    self.lastUpdateTime = 0
    
    configureCamera()
    
    let tileSet = SKTileSet(named: "Terrain")!
    tileMap = SKTileMapNode(tileSet: tileSet, columns: mapSize, rows: mapSize, tileSize: tileSize)
    tileMap.enableAutomapping = true
    let noiseMap = MapGenerator(size: mapSize).createNoiseMap()
    let texture = SKTexture(noiseMap: noiseMap)
    
    
    for column in 0..<mapSize {
      for row in 0..<mapSize {
        let elevation = noiseMap.value(at: vector2(Int32(row), Int32(column)))
        let tileGroup: SKTileGroup?
        switch elevation {
        case -1..<0:
          tileGroup = tileSet.group(byName: "Water")
          
        case 0.64..<1:
          tileGroup = tileSet.group(byName: "Mountain")
          
        default:
          tileGroup = tileSet.group(byName: "Plain")
        }
        
        if let tileGroup = tileGroup {
          tileMap.setTileGroup(tileGroup, forColumn: column, row: row)
        }
      }
    }
    
    addChild(tileMap)
    let spriteNode = SKSpriteNode(texture: texture)
    spriteNode.size = CGSize(width: 500, height: 500)
    addChild(spriteNode)
  }
  
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (self.lastUpdateTime == 0) {
      self.lastUpdateTime = currentTime
    }
    
    // Calculate time since last update
    let dt = currentTime - self.lastUpdateTime
    
    // Update entities
//    for entity in self.entities {
//      entity.update(deltaTime: dt)
//    }
    
    self.lastUpdateTime = currentTime
  }
  
}

private extension GameScene {
  
  func configureCamera() {
    camera = childNode(withName: "camera") as? SKCameraNode
    camera?.xScale = 2
    camera?.yScale = 2
  }
  
  func configureRecognizers() {
    let magnificationRecognizer = NSMagnificationGestureRecognizer(target: self, action: #selector(handleMagnification(gestureRecognizer:)))
    let panGestureRecognizer = NSPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
    view!.addGestureRecognizer(panGestureRecognizer)
    view!.addGestureRecognizer(magnificationRecognizer)
  }
  
}

extension GameScene {
  
  @objc func handlePan(gestureRecognizer: NSGestureRecognizer) {
    let translation = (gestureRecognizer as! NSPanGestureRecognizer).translation(in: view)
    switch gestureRecognizer.state {
      
    case .began:
      startCameraPosition = camera!.position
      
    case .changed:
      camera!.position = CGPoint(
        x: startCameraPosition.x - translation.x * camera!.xScale,
        y: startCameraPosition.y - translation.y * camera!.yScale
      )
      
    case .cancelled, .ended:
      startCameraPosition = nil
      
    default:
      break
    }
  }
  
  @objc func handleMagnification(gestureRecognizer: NSGestureRecognizer) {
    let magnification = (gestureRecognizer as! NSMagnificationGestureRecognizer).magnification
    
    switch gestureRecognizer.state {
      
    case .began:
      deltaMagnification = magnification
      
    case .changed:
      deltaMagnification = deltaMagnification + magnification
      handleScrollWheel(delta: deltaMagnification)
      
      
    case .cancelled, .ended:
      deltaMagnification = 0
      
    default:
      break
    }
    print(magnification)
  }
  
  func handleScrollWheel(delta: CGFloat) {
    let newMagnification = CGFloat(simd_clamp(Double(camera!.xScale - delta), 1, 10))
    camera!.xScale = newMagnification
    camera!.yScale = newMagnification
  }
  
}
