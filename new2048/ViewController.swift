//
//  ViewController.swift
//  new2048
//
//  Created by 谭钧豪 on 16/3/4.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class Color2048{
    class var bg2:UIColor{
        return UIColor(red:0.93, green:0.89, blue:0.85, alpha:1)
    }
    class var bg4:UIColor{
        return UIColor(red:0.91, green:0.87, blue:0.78, alpha:1)
    }
    class var bg8:UIColor{
        return UIColor(red:0.95, green:0.7, blue:0.45, alpha:1)
    }
    class var bg16:UIColor{
        return UIColor(red:0.96, green:0.58, blue:0.37, alpha:1)
    }
    class var bg32:UIColor{
        return UIColor(red:0.96, green:0.49, blue:0.35, alpha:1)
    }
    class var bg64:UIColor{
        return UIColor(red:0.96, green:0.37, blue:0.2, alpha:1)
    }
    class var bgother:UIColor{
        return UIColor(red:0.93, green:0.82, blue:0.42, alpha:1)
    }
    class var txt1:UIColor{
        return UIColor(red:0.46, green:0.43, blue:0.38, alpha:1)
    }
    class var txt2:UIColor{
        return UIColor.whiteColor()
    }
}

class ViewController: UIViewController {
    var startView:UIView!
    var gameframe:CGRect!
    var gameBGView:UIView!
    var scoreLabel:UILabel!
    var poshasvalue = [Int:Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置游戏区域大小
        gameframe = CGRectMake(20, self.view.frame.height+50, self.view.frame.width-40, self.view.frame.width-40)
        //设置游戏画面背景颜色
        self.view.backgroundColor = UIColor(red:0.98, green:0.85, blue:0.61, alpha:1)
        //配置开始引导画面
        startView = UIView(frame: self.view.frame)
        startView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(startView)
        let startlbl = UILabel(frame: CGRectMake(self.startView.frame.width/2-180,self.startView.frame.height/2-25,360,50))
        startlbl.text = "点击屏幕开始游戏"
        startlbl.textAlignment = NSTextAlignment.Center
        startlbl.font = UIFont.boldSystemFontOfSize(40)
        startView.addSubview(startlbl)
        let starttap = UITapGestureRecognizer(target: self, action: Selector("Go"))
        startView.addGestureRecognizer(starttap)
        //设置所有点尚未有值
        for i in 0...15{
            poshasvalue[i] = false
        }
        
        
    }
    //点击移除开始画面
    func Go(){
        UIView.animateWithDuration(0.2, animations: {
            self.startView.frame.origin.y = 20
            }, completion: {
                (Bool) -> Void in
                UIView.animateWithDuration(0.5, animations: {
                    self.startView.frame.origin.y = -self.view.frame.height
                    },completion: {
                        (Bool) -> Void in
                        self.startView.removeFromSuperview()
                        self.drawGameArea()
                })
                
        })
    }
    
    func allNumView() -> [UIView]{
        var numViews = [UIView]()
        for view in gameBGView.subviews{
            if view.tag != 0{
                numViews.append(view)
            }
        }
        return numViews
    }
    
    func up(){
        let numViews = allNumView()
        var alreadyCreated = false
        for numView in numViews{
            if numView.tag-1 != (numView.tag-1)%4{
                var desfloor = [Int:Int]()
                desfloor[(numView.tag-1)%4] = 0
                for i in (numView.tag-1)/4...3{
                    let curmappos = (3-i)*4+((numView.tag)%4==0 ? 4 : (numView.tag)%4)
                    if let mapnumView = self.view.viewWithTag(curmappos){
                        //检测寻址目标是否是自身
                        if mapnumView.tag != numView.tag{
                            desfloor[(numView.tag-1)%4]! += 1
                            //检测落点的上一层或者当前的上一层数字是否相等
                            if mapnumView.tag-4 == (desfloor[(numView.tag-1)%4]!*4+((numView.tag)%4==0 ? 4 : (numView.tag)%4)) || mapnumView.tag-4 == numView.tag{
                                let mapnum = (mapnumView.viewWithTag(-1) as! UILabel).text
                                let curnum = (numView.viewWithTag(-1) as! UILabel).text
                                print(mapnum!+","+curnum!)
                                if mapnum == curnum{
                                    mapnumView.removeFromSuperview()
                                    (numView.viewWithTag(-1) as! UILabel).text = "\(Int(curnum!)!*2)"
                                    numView.backgroundColor = numColorBG(Int(curnum!)!*2)
                                    (numView.viewWithTag(-1) as! UILabel).textColor = numColor(Int(curnum!)!*2)
                                    desfloor[(numView.tag-1)%4]! -= 1
                                }
                            }
                        }
                    }
                }
                
                if desfloor[(numView.tag-1)%4] == (numView.tag-1)/4{
                    continue
                }
                let despos = desfloor[(numView.tag-1)%4]!*4+(numView.tag-1)%4
                
                poshasvalue[numView.tag-1] = false
                poshasvalue[despos] = true
                numView.tag = despos+1
                
                UIView.animateWithDuration(0.2, animations: {
                    numView.frame.origin.y = self.pos(despos).y
                    }, completion: {
                        (Bool) -> Void in
                        if !alreadyCreated{
                            self.createRandomNum((Int(arc4random()%2)+1)*2)
                            alreadyCreated = true
                        }
                        
                })
            }
        }
    }
    
    func down(){
        let numViews = allNumView()
        var alreadyCreated = false
        for numView in numViews{
            if numView.tag-1 != 12+(numView.tag-1)%4{
                var desfloor = [Int:Int]()
                desfloor[(numView.tag-1)%4] = 3
                for i in (numView.tag-1)/4...3{
                    let curmappos = i*4+((numView.tag)%4==0 ? 4 : (numView.tag)%4)
                    if let mapnumView = self.view.viewWithTag(curmappos){
                        if mapnumView.tag != numView.tag{
                            desfloor[(numView.tag-1)%4]! -= 1
                            if mapnumView.tag == (desfloor[(numView.tag-1)%4]!*4+((numView.tag)%4==0 ? 4 : (numView.tag)%4)) || mapnumView.tag-4 == numView.tag{
                                let mapnum = (mapnumView.viewWithTag(-1) as! UILabel).text
                                let curnum = (numView.viewWithTag(-1) as! UILabel).text
                                print(mapnum!+","+curnum!)
                                if mapnum == curnum{
                                    mapnumView.removeFromSuperview()
                                    (numView.viewWithTag(-1) as! UILabel).text = "\(Int(curnum!)!*2)"
                                    numView.backgroundColor = numColorBG(Int(curnum!)!*2)
                                    (numView.viewWithTag(-1) as! UILabel).textColor = numColor(Int(curnum!)!*2)
                                    desfloor[(numView.tag-1)%4]! += 1
                                }
                            }
                        }
                    }
                }
                
                if desfloor[(numView.tag-1)%4] == (numView.tag-1)/4{
                    continue
                }
                let despos = desfloor[(numView.tag-1)%4]!*4+(numView.tag-1)%4
                
                poshasvalue[numView.tag-1] = false
                poshasvalue[despos] = true
                numView.tag = despos+1
                
                UIView.animateWithDuration(0.2, animations: {
                    numView.frame.origin.y = self.pos(despos).y
                    }, completion: {
                        (Bool) -> Void in
                        if !alreadyCreated{
                            self.createRandomNum((Int(arc4random()%2)+1)*2)
                            alreadyCreated = true
                        }
                        
                })
            }
        }
    }
    
    func left(){
        self.createRandomNum((Int(arc4random()%2)+1)*2)
    }
    
    func right(){
        
    }
    
    func pos(serialnum:Int) -> CGPoint{
        let pos = CGPointMake(8+CGFloat(serialnum%4)*(8+(gameframe.width-40)/4), 8+CGFloat(serialnum/4)*(8+(gameframe.width-40)/4))
        return pos
    }
    
    func startGame(){
        createRandomNum(2)
    }
    
    func gameOver(){
        print("gameOver")
    }
    
    func createRandomNum(number:Int){
        var numpos = Int(arc4random()%16)
        var curposnum = 0
        
        for point in poshasvalue{
            if point.1{
                curposnum++
            }
        }
        if curposnum == 16{
            gameOver()
            return
        }else{
            if poshasvalue[numpos]!{
                while poshasvalue[numpos]!{
                    numpos = Int(arc4random()%16)
                }
            }
        }
        let Point = pos(numpos)
        //设置数字视图
        let Num = UIView(frame: CGRectMake(Point.x,Point.y,(gameframe.width-40)/4,(gameframe.width-40)/4))
        Num.layer.cornerRadius = 8
        Num.tag = numpos+1
        //设置数字Label
        let NumLabel = UILabel(frame: CGRectMake(0,0,(gameframe.width-40)/4,(gameframe.width-60)/4))
        NumLabel.tag = -1
        NumLabel.text = "\(number)"
        NumLabel.textColor = numColor(number)
        NumLabel.font = UIFont.boldSystemFontOfSize(30)
        NumLabel.textAlignment = .Center
        Num.backgroundColor = numColorBG(number)
        Num.addSubview(NumLabel)
        gameBGView.addSubview(Num)
        poshasvalue[numpos] = true
    }
    
    func numColor(number:Int) -> UIColor{
        return number<=4 ? Color2048.txt1 : Color2048.txt2
    }
    
    func numColorBG(number:Int) -> UIColor{
        switch number{
        case 2:return Color2048.bg2
        case 4:return Color2048.bg4
        case 8:return Color2048.bg8
        case 16:return Color2048.bg16
        case 32:return Color2048.bg32
        case 64:return Color2048.bg64
        default:return Color2048.bgother
        }
    }
    
    func drawGameArea(){
        //绘制游戏区域
        gameBGView = UIView(frame: gameframe)
        gameBGView.layer.cornerRadius = 10
        gameBGView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(gameBGView)
        //绘制记分板
        let scoreView = UIView(frame: CGRectMake(gameframe.width/6,-70,gameframe.width/1.5,50))
        scoreView.backgroundColor = UIColor.blackColor()
        scoreView.layer.cornerRadius = 10
        scoreLabel = UILabel(frame: CGRectMake(90,10,140,30))
        scoreLabel.font = UIFont.boldSystemFontOfSize(25)
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.textAlignment = .Center
        scoreLabel.text = "0"
        let scoretxtLabel = UILabel(frame: CGRectMake(10,10,90,30))
        scoretxtLabel.text = "SCORE:"
        scoretxtLabel.font = UIFont.boldSystemFontOfSize(20)
        scoretxtLabel.textColor = UIColor.whiteColor()
        scoretxtLabel.textAlignment = .Center
        scoreView.addSubview(scoretxtLabel)
        scoreView.addSubview(scoreLabel)
        gameBGView.addSubview(scoreView)
        //添加16个方块
        for i in 0...15{
            let numpos = pos(i)
            let numframe = CGRectMake(numpos.x,numpos.y, (gameframe.width-40)/4, (gameframe.width-40)/4)
            let numView = UIView(frame: numframe)
            numView.layer.cornerRadius = 8
            numView.backgroundColor = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1)
            gameBGView.addSubview(numView)
        }
        //移动游戏区域到视图中
        UIView.animateWithDuration(0.2, animations: {
            self.gameBGView.frame.origin.y = self.view.frame.height/3.3
            },completion:{
                (Bool) -> Void in
                //向视图添加手势识别
                let up = UISwipeGestureRecognizer(target: self, action: Selector("up"))
                up.direction = .Up
                let down = UISwipeGestureRecognizer(target: self, action: Selector("down"))
                down.direction = .Down
                let left = UISwipeGestureRecognizer(target: self, action: Selector("left"))
                left.direction = .Left
                let right = UISwipeGestureRecognizer(target: self, action: Selector("right"))
                right.direction = .Right
                self.view.addGestureRecognizer(up)
                self.view.addGestureRecognizer(down)
                self.view.addGestureRecognizer(left)
                self.view.addGestureRecognizer(right)
                
                self.startGame()
        })
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

