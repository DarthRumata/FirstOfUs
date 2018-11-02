//
//  ViewController.swift
//  FirstOfUs
//
//  Created by Stas Kirichok on 01-11-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
  
  @IBOutlet var skView: SKView!
  
  private var scene: GameScene!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
    // including entities and graphs.
    if let scene = GKScene(fileNamed: "GameScene") {
      
      // Get the SKScene from the loaded GKScene
      if let sceneNode = scene.rootNode as! GameScene? {
        self.scene = sceneNode
        sceneNode.scaleMode = .aspectFill
        
        // Present the scene
        if let view = self.skView {
          view.presentScene(sceneNode)
          
          view.ignoresSiblingOrder = true
          
          view.showsFPS = true
          view.showsNodeCount = true
        }
      }
    }
  }
  
  override func scrollWheel(with event: NSEvent) {
    super.scrollWheel(with: event)
    
    scene.handleScrollWheel(delta: event.deltaY)
  }
}

