//
//  TheTImer.swift
//  Time Yo Egg
//
//  Created by Vince Kearney on 08/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import Cocoa

protocol TheTimerProtocol {
    func timeRemainingOnTimer(_ timer: TheTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: TheTimer)
}

class TheTimer
{
    // MARK: Properties
    var timer: Timer?
    var startTime: Date?
    var duration: TimeInterval = 0
    var elapsedTime: TimeInterval = 0
    var delegate: TheTimerProtocol?
    // MARK: Computed Properties
    var isStopped: Bool { return timer == nil && elapsedTime == 0 }
    var isPaused: Bool { return timer == nil && elapsedTime > 0 }
    
    dynamic func timerAction()
    {
        guard let startTime = startTime else { return }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func setUpTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        self.setUpTimer()
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        self.setUpTimer()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerAction()
    }
    
    func resetTimer()
    {
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        duration = 0
        elapsedTime = 0
        
        timerAction()
    }
}
