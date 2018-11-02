//
//  SKTileSet+GroupAccess.swift
//  FirstOfUs
//
//  Created by Stas Kirichok on 01-11-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import SpriteKit

extension SKTileSet {
  
  func group(byName name: String) -> SKTileGroup? {
    return tileGroups.first(where: {
      return ($0.name ?? "") == name
    })
  }
  
}
