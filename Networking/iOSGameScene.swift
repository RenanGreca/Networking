//
//  GameScene.swift
//  Networking
//
//  Created by Renan Greca on 5/10/16.
//  Copyright (c) 2016 renangreca. All rights reserved.
//

import SpriteKit

class iOSGameScene: SKScene {
    
    let client = BonjourTCPClient.sharedInstance
    var service = NSNetService()
    
    var path: CGMutablePath?
    var line: SKShapeNode?

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        
        client.servicesCallback = { (services) in
            guard let service = services.first else {
                return NSLog("no services...")
            }
            
            NSLog("connecting to: \(service.name)")
            self.service = service
            
            self.client.connectTo(service, callback: {
                print("Connected to AppleTV")
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        let location = touches.first!.locationInNode(self)
        
        path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, location.x, location.y)
        
        line = SKShapeNode(path: path!)
        line?.strokeColor = SKColor.blueColor()
        self.addChild(line!)
        
        let x = (location.x / self.size.width)
        let y = (location.y / self.size.width)
        
        print("sending point \(x),\(y)")
        client.send("newline|\(x),\(y)")
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        
        CGPathAddLineToPoint(path, nil, location.x, location.y)
        line?.path = path
        
        let x = (location.x / self.size.width)
        let y = (location.y / self.size.width)
        
        print("sending point \(x),\(y)")
        client.send("point|\(x),\(y)")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
