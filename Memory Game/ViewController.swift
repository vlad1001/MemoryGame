//  Vlad Babitsky
//  Guy Isakov
//  ViewController.swift
//  Memory Game
//
//  Created by Mac Pro on 19/03/2016.
//  Copyright © 2016 MacPro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var card1: UIButton!
    @IBOutlet weak var card2: UIButton!
    @IBOutlet weak var card3: UIButton!
    @IBOutlet weak var card4: UIButton!
    @IBOutlet weak var card5: UIButton!
    @IBOutlet weak var card6: UIButton!
    @IBOutlet weak var card7: UIButton!
    @IBOutlet weak var card8: UIButton!
    @IBOutlet weak var card9: UIButton!
    @IBOutlet weak var card10: UIButton!
    @IBOutlet weak var card11: UIButton!
    @IBOutlet weak var card12: UIButton!
    @IBOutlet weak var card13: UIButton!
    @IBOutlet weak var card14: UIButton!
    @IBOutlet weak var card15: UIButton!
    @IBOutlet weak var card16: UIButton!
    @IBOutlet weak var card17: UIButton!
    @IBOutlet weak var card18: UIButton!
    @IBOutlet weak var card19: UIButton!
    @IBOutlet weak var card20: UIButton!

    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    
    var timer = NSTimer()

    var isFirstClick = true
    var firstChoice:Int = 0
    var firstButton: UIButton!
    var goodCounter = 0
    var timeCounter = 0
    var isPlayingNow = true

    var cardList: [Int] = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10]
    var discoverList: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    @IBOutlet var btns: Array<UIButton>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
        
        
        for btn in btns! {
            btn.addTarget(self,action:"cardClickListener:",forControlEvents:.TouchUpInside);
        }

        restartGame();
        
    }
    
    @IBAction func onPausePlay(sender: AnyObject) {
        if (isPlayingNow) {
            isPlayingNow = false
            timer.invalidate()
            pauseBtn.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        }
        else {
            isPlayingNow = true
            timer.invalidate()// just in case this button is tapped multiple times
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
            pauseBtn.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        }
    }

    @IBAction func onRestartClick(sender: AnyObject) {
        timeCounter = 0
        timeLbl.text = "\(timeCounter) Seconds"
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
        restartGame()
    }
    func cardClickListener(sender : UIButton) {
        let currentChoice = sender.tag - 1
        let imageUrl: String = "card\(cardList[currentChoice])"
        sender.setImage(UIImage(named: imageUrl), forState: UIControlState.Normal)
        sender.userInteractionEnabled = false
        
        if (isFirstClick) {
            firstButton = sender
            isFirstClick = false
            firstChoice = currentChoice
            
//            sender.enabled = false
        }
        else {
            isFirstClick = true
            
            if (cardList[currentChoice] == cardList[firstChoice]) {
                discoverList[firstChoice] = true
                discoverList[currentChoice] = true
                goodCounter = goodCounter + 1
                if (goodCounter == 10) {
                    winGame();
                    print("GooD")
                }
                clicableCards(true)

            }
            else {
                clicableCards(false)
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.clicableCards(true)
                    self.firstButton.setImage(UIImage(named: "card0"), forState: UIControlState.Normal)
                    sender.setImage(UIImage(named: "card0"), forState: UIControlState.Normal)
                }
                

            }
            
        }
    }

    func clicableCards(value: Bool) {
        if (value) {
            for var i=0; i < discoverList.count; i = i + 1 {  // In swift 3 i++ will not work
                if (discoverList[i] == false) {
                    btns![i].userInteractionEnabled = true
                }
            }
        }
        else {
            for btn in btns! {
                btn.userInteractionEnabled = false
            }
        }
        
    }
    
    func winGame() {
        isPlayingNow = false
        pauseBtn.enabled = false
        timer.invalidate()
        timeLbl.text = "Well done! You do it \(timeCounter) seconds \n Press restart to play again"
    }
    
    func restartGame() {
        isPlayingNow = true
        pauseBtn.enabled = true
        cardList.shuffleInPlace()
        print(cardList)
        timeCounter = 0

        for var i=0; i < discoverList.count; i = i + 1 {  // In swift 3 i++ will not work
            discoverList[i] = false
            isFirstClick = true
            btns![i].setImage(UIImage(named: "card0"), forState: UIControlState.Normal)
            btns![i].userInteractionEnabled = true  // Also now can call clicableCards(true)
        }
    }
    
    func update() {
        timeCounter = timeCounter + 1
        timeLbl.text = "\(timeCounter) seconds"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Copy from web, good for shuffle
extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

