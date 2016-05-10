//
//  GameScene.swift
//  tvNetworking
//
//  Created by Renan Greca on 5/10/16.
//  Copyright (c) 2016 renangreca. All rights reserved.
//

import SpriteKit

class tvOSGameScene: SKScene {
    
    let server = BonjourTCPServer.sharedInstance
    let screenSize = UIScreen.mainScreen().bounds.size
    
    var path: CGMutablePath?
    var line: SKShapeNode?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 65
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        
        server.dataReceivedCallback = {(data) in
            NSLog("\(data)")
            //self.textView.text = "\(data)"
            
            self.receivedData(data)
        }

    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        /* Called when a touch begins */
//        
//        print("touched!")
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
//    }
    
    func receivedData(data: String) {
        
        let dataString = "\(data)".componentsSeparatedByString("|")
        let pointString = "\(dataString[1])".componentsSeparatedByString(",")
        guard let x = Float(pointString[0]),
            y = Float(pointString[1]) else { return }
        let location = CGPoint(x: CGFloat(x)*self.size.width, y: CGFloat(y)*self.size.width)

        if dataString[0] == "newline" {
            path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, location.x, location.y)

            line = SKShapeNode(path: path!)
            line?.strokeColor = SKColor.blueColor()
            self.addChild(line!)
        } else {
            CGPathAddLineToPoint(path, nil, location.x, location.y)
            line?.path = path
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
