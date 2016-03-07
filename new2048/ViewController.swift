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
        
        
        
        
    }
    
    func tprint(){
        print(poshasvalue)
    }
    
    func reset(){
        for i in 1...16{
            poshasvalue[i] = false
            if let box = self.gameBGView.viewWithTag(i){
                box.removeFromSuperview()
            }
        }
        createRandomNum(false)
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
                        //添加输出poshasvalue信息
                        let testbtn = UIButton(frame: CGRectMake(20,self.view.frame.height-70,80,50))
                        testbtn.addTarget(self, action: Selector("tprint"), forControlEvents: .TouchUpInside)
                        testbtn.backgroundColor = UIColor.blackColor()
                        testbtn.layer.cornerRadius = 10
                        testbtn.setTitle("测试按钮", forState: .Normal)
                        self.view.addSubview(testbtn)
                        
                        //添加清空按钮
                        let clearbtn = UIButton(frame: CGRectMake(self.view.frame.width-100,self.view.frame.height-70,80,50))
                        clearbtn.addTarget(self, action: Selector("reset"), forControlEvents: .TouchUpInside)
                        clearbtn.backgroundColor = UIColor.redColor()
                        clearbtn.layer.cornerRadius = 10
                        clearbtn.setTitle("清空", forState: .Normal)
                        self.view.addSubview(clearbtn)
                })
                
        })
    }
    
    func up(){
        udmove(false)
    }
    
    func down(){
        udmove(true)
    }
    
    
    func left(){
        lrmove(false)
    }
    
    func right(){
        lrmove(true)
        
    }
    
    func lrmove(isright:Bool){
        var ablecreatenew = true
        for i in 0...3{
            var numViews = [UIView]()
            for j in 0...3{
                if !isright{
                    if let numView = self.gameBGView.viewWithTag(4-j+i*4){
                        numViews.append(numView)
                    }
                }else{
                    if let numView = self.gameBGView.viewWithTag(1+j+i*4){
                        numViews.append(numView)
                    }
                }
            }
            
            if numViews.count != 0{
                for i in 0...(numViews.count-1){
                    let j = i-1
                    if j != -1{
                        print("\(i):\((numViews[i].viewWithTag(-1) as! UILabel).text)")
                        print("\(j):\((numViews[j].viewWithTag(-1) as! UILabel).text)")
                        if (numViews[i].viewWithTag(-1) as! UILabel).text == (numViews[j].viewWithTag(-1) as! UILabel).text{
                            UIView.animateWithDuration(0.2, animations: {
                                numViews[j].frame.origin.x = numViews[i].frame.origin.x
                                },completion: {
                                    (Bool) -> Void in
                                    numViews[j].removeFromSuperview()
                                    (numViews[i].viewWithTag(-1) as! UILabel).text = "\(Int((numViews[i].viewWithTag(-1) as! UILabel).text!)!*2)"
                                    numViews[i].backgroundColor = self.numColorBG(Int((numViews[i].viewWithTag(-1) as! UILabel).text!)!)
                                    (numViews[i].viewWithTag(-1) as! UILabel).textColor = self.numColor(Int((numViews[i].viewWithTag(-1) as! UILabel).text!)!)
                                    self.setposhasvalue()
                            })
                        }
                    }
                }
                
                for numViewindex in 0...(numViews.count-1){
                    UIView.animateWithDuration(0.5, animations: {
                        if isright{
                            numViews[numViews.count-1-numViewindex].frame.origin.x = self.pos(3-numViewindex).x
                            numViews[numViews.count-1-numViewindex].tag = 4-numViewindex+i*4
                        }else{
                            numViews[numViews.count-1-numViewindex].frame.origin.x = self.pos(numViewindex).x
                            numViews[numViews.count-1-numViewindex].tag = 1+numViewindex+i*4
                        }
                        
                        },completion: {
                            (Bool) -> Void in
                            if ablecreatenew{
                                ablecreatenew = false
                                self.createRandomNum(true)
                            }
                    })
                }
            }
        }
        setposhasvalue()
    }
    
    func setposhasvalue(){
        for i in 1...16{
            if let _ = self.gameBGView.viewWithTag(i){
                poshasvalue[i] = true
            }else{
                poshasvalue[i] = false
            }
        }
    }
    
    func udmove(isdown:Bool){
        var ablecreatenew = true
        for i in 0...3{
            var numViews = [UIView]()
            for j in 0...3{
                if !isdown{
                    if let numView = self.gameBGView.viewWithTag(4-i+j*4){
                        numViews.append(numView)
                    }
                }else{
                    if let numView = self.gameBGView.viewWithTag(1+i+j*4){
                        numViews.append(numView)
                    }
                }
            }
            
            if numViews.count != 0{
                for i in 0...(numViews.count-1){
                    let j = i-1
                    if j != -1{
                        print("\(i):\((numViews[i].viewWithTag(-1) as! UILabel).text)")
                        print("\(j):\((numViews[j].viewWithTag(-1) as! UILabel).text)")
                        if (numViews[i].viewWithTag(-1) as! UILabel).text == (numViews[j].viewWithTag(-1) as! UILabel).text{
                            UIView.animateWithDuration(0.2, animations: {
                                numViews[j].frame.origin.y = numViews[i].frame.origin.y
                                },completion: {
                                    (Bool) -> Void in
                                    numViews[j].removeFromSuperview()
                                    (numViews[i].viewWithTag(-1) as! UILabel).text = "\(Int((numViews[i].viewWithTag(-1) as! UILabel).text!)!*2)"
                                    numViews[i].backgroundColor = self.numColorBG(Int((numViews[i].viewWithTag(-1) as! UILabel).text!)!)
                                    (numViews[i].viewWithTag(-1) as! UILabel).textColor = self.numColor(Int((numViews[i].viewWithTag(-1) as! UILabel).text!)!)
                                    self.setposhasvalue()
                            })
                        }
                    }
                }
                
                for numViewindex in 0...(numViews.count-1){
                    UIView.animateWithDuration(0.5, animations: {
                        if isdown{
                            numViews[numViews.count-1-numViewindex].frame.origin.y = self.pos(12-numViewindex*4).y
                            numViews[numViews.count-1-numViewindex].tag = 13-numViewindex*4+i
                        }else{
                            numViews[numViews.count-1-numViewindex].frame.origin.y = self.pos(numViewindex*4).y
                            numViews[numViews.count-1-numViewindex].tag = 1+numViewindex*4+i
                        }
                        
                        },completion: {
                            (Bool) -> Void in
                            if ablecreatenew{
                                ablecreatenew = false
                                self.createRandomNum(true)
                            }
                    })
                }
            }
        }
        setposhasvalue()
        

    }
    
    func pos(serialnum:Int) -> CGPoint{
        let pos = CGPointMake(8+CGFloat(serialnum%4)*(8+(gameframe.width-40)/4), 8+CGFloat(serialnum/4)*(8+(gameframe.width-40)/4))
        return pos
    }
    
    func startGame(){
        createRandomNum(false)
    }
    
    func gameOver(){
        print("gameOver")
    }
    
    func createInPos(serialnum:Int,number:Int){
        let pos = CGPointMake(8+CGFloat(serialnum%4)*(8+(gameframe.width-40)/4), 8+CGFloat(serialnum/4)*(8+(gameframe.width-40)/4))
        //设置数字视图
        let Num = UIView(frame: CGRectMake(pos.x,pos.y,(gameframe.width-40)/4,(gameframe.width-40)/4))
        Num.layer.cornerRadius = 8
        Num.tag = serialnum+1
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
        poshasvalue[serialnum+1] = true
    }
    
    func createRandomNum(random:Bool){
        var number = 2
        if random{
            number = (Int(arc4random()%2)+1)*2
        }
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
            if poshasvalue[numpos+1]!{
                while poshasvalue[numpos+1]!{
                    numpos = Int(arc4random()%16)
                }
            }
        }
        let Point = pos(numpos)
        //点击print当前tag
        let tagtap = UITapGestureRecognizer(target: self, action: Selector("ptag:"))
        
        //设置数字视图
        let Num = UIView(frame: CGRectMake(Point.x+(gameframe.width-40)/8,Point.y+(gameframe.width-40)/8,5,5))
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
        UIView.animateWithDuration(0.2, animations: {
            Num.frame = CGRectMake(Point.x,Point.y,(self.gameframe.width-40)/4, (self.gameframe.width-40)/4)
        })
        poshasvalue[numpos+1] = true
        
        
        Num.addGestureRecognizer(tagtap)
    }
    
    func ptag(sender:UITapGestureRecognizer){
        print(sender.view?.tag)
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
                self.setposhasvalue()
                self.startGame()
        })
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

