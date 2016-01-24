//
//  GameScene.swift
//  LockPick
//
//  Created by Mohammad Haque on 1/23/16.
//  Copyright (c) 2016 shaun Haque. All rights reserved.
//
//WATCH JARED DAVIDSON POP THE LOCK PART 3 TO FINISH THE REST 


import SpriteKit


class GameScene: SKScene {
    
    var background = SKAction.colorizeWithColor(UIColor.grayColor(), colorBlendFactor: 0.25, duration: 30.0)
    
    var circle = SKSpriteNode()
    var person = SKSpriteNode()
    var dot = SKSpriteNode()
    
    var intersected = false
    
    var path = UIBezierPath()
    var gamestarted = Bool()
    var movingclockwise = Bool()
    
    
    override func didMoveToView(view: SKView) {
        
        loadview()

    }
    
    func loadview() {
        self.runAction(background)
        
        person = SKSpriteNode(imageNamed: "person")
        person.size = CGSize(width: 40, height: 7)
        person.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 129)
        person.zRotation = 3.14 / 2
        person.zPosition = 2.0
        self.addChild(person)
        
        circle = SKSpriteNode(imageNamed: "circle")
        circle.size = CGSize(width: 300, height: 300)
        circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(circle)
        
        adddot()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gamestarted == false {
            
            moveclockwise()
            movingclockwise = true
            gamestarted = true
            
        }
        
        else if gamestarted == true {
            dottouched()
            if movingclockwise == true {
                movecounterclockwise()
                movingclockwise = false
            }
            
            else if movingclockwise == false{
                
                moveclockwise()
                movingclockwise = true
            }
        }

        
        

    }
    
    
    func adddot() {
        
        let dx = person.position.x - self.frame.width/2
        
        let dy = person.position.y - self.frame.height/2
        
        let rad = atan2(dy, dx)
       
        dot = SKSpriteNode(imageNamed: "dot")
        
        dot.size = CGSize(width: 40, height: 40)
        
        dot.zPosition = 1.0
        
        if movingclockwise == true {
            
            let tempangle = CGFloat.random(min: rad + 1.0, max: rad + 2.5)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 130, startAngle: tempangle, endAngle: tempangle + CGFloat(M_PI * 4), clockwise: true)
            dot.position = path2.currentPoint
            
        }
        
        else if movingclockwise == false {
            
            let tempangle = CGFloat.random(min: rad - 1.0, max: rad - 2.5)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 130, startAngle: tempangle, endAngle: tempangle + CGFloat(M_PI * 4), clockwise: true)
            dot.position = path2.currentPoint
            
        }
        
        self.addChild(dot)
        
    }
    
    func moveclockwise() {
        
            let dx = person.position.x - self.frame.width/2
            
            let dy = person.position.y - self.frame.height/2
            
            let rad = atan2(dy, dx)
            
            path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 130, startAngle: rad, endAngle: rad + CGFloat(M_PI * 40), clockwise: true)
            
            let follow = SKAction.followPath( path.CGPath, asOffset: false, orientToPath: true, duration: 200)
            person.runAction(SKAction.repeatActionForever(follow).reversedAction())
            
        
    }
    
    func movecounterclockwise() {
        
        let dx = person.position.x - self.frame.width/2
        
        let dy = person.position.y - self.frame.height/2
        
        let rad = atan2(dy, dx)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 130, startAngle: rad, endAngle: rad + CGFloat(M_PI * 40), clockwise: true)
        
        let follow = SKAction.followPath( path.CGPath, asOffset: false, orientToPath: true, duration: 200)
        person.runAction(SKAction.repeatActionForever(follow))

    }
    
    func dottouched() {
        
        if intersected == true {
            dot.removeFromParent()
            adddot()
            intersected = false
        }
        
        else if intersected == true{

            died()
            
        }
        
    }
    
    func died() {
        
        self.removeAllChildren()
        
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.3)
        
        let action2 = SKAction.colorizeWithColor(UIColor.grayColor(), colorBlendFactor: 0.25, duration: 0.3)
        
        self.scene?.runAction(SKAction.sequence([action1, action2]))
        movingclockwise = false
        intersected = false
        gamestarted = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        //gameover
        if person.intersectsNode(dot) {
            intersected = true
            
        }
        
        else {
            if intersected == true {
                if person.intersectsNode(dot) == false {
                    died()
                    
                    //restart game and end up back from begining 
                    self.loadview()
                    
                }
            }
        }
    
}


}