//
//  ViewController.swift
//  Time Yo Egg
//
//  Created by Vince Kearney on 08/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import Cocoa

class TimerViewController: NSViewController
{
    // MARK: Properties
    private var eggTimer : TheTimer?
    // MARK: Outlets
    @IBOutlet weak var eggTimeTextLabel : NSTextField!
    @IBOutlet weak var eggTimerImageView : NSImageView!
    @IBOutlet weak var startButton : NSButton!
    @IBOutlet weak var stopButton : NSButton!
    @IBOutlet weak var restartButton : NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eggTimer = TheTimer()
        self.eggTimer?.delegate = self
    }

    /// TODO - Need to figure out what this is exactly
    override var representedObject: Any?
    {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Display
    
    func updateDisplay(for timeRemaining: TimeInterval) {
        eggTimeTextLabel.stringValue = textToDisplay(for: timeRemaining)
        eggTimerImageView.image = imageToDisplay(for: timeRemaining)
    }
    
    private func textToDisplay(for timeRemaining: TimeInterval) -> String
    {
        if timeRemaining == 0 { return "Done!" }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        return "\(Int(minutesRemaining)):\(String(format: "%02d", Int(secondsRemaining)))"
    }
    
    private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage?
    {
        let percentageComplete = 100 - (timeRemaining / Preferences().selectedTime * 100)
        
        if self.eggTimer!.isStopped {
            let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
            return NSImage(named: stoppedImageName)
        }
        
        let imageName: String
        switch percentageComplete
        {
            case 0 ..< 25:
                imageName = "0"
            case 25 ..< 50:
                imageName = "25"
            case 50 ..< 75:
                imageName = "50"
            case 75 ..< 100:
                imageName = "75"
            default:
                imageName = "100"
        }
        
        return NSImage(named: imageName)
    }
    
    func configureButtonsAndMenus()
    {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        
        if self.eggTimer!.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false
        } else if self.eggTimer!.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true
        } else {
            enableStart = false
            enableStop = true
            enableReset = false
        }
        
        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        restartButton.isEnabled = enableReset
        
        if let appDel = NSApplication.shared().delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
        }
    }
    
    // MARK: Actions
    @IBAction func clickStart(_ sender : Any)
    {
        if self.eggTimer!.isPaused {
            self.eggTimer?.resumeTimer()
        } else {
            self.eggTimer?.duration = Preferences().selectedTime
            self.eggTimer?.startTimer()
        }
        self.configureButtonsAndMenus()
    }
    
    @IBAction func clickStop(_ sender : Any) {
        self.eggTimer?.stopTimer()
        self.configureButtonsAndMenus()
    }
    
    @IBAction func clickRestart(_ sender : Any) {
        self.eggTimer?.resetTimer()
        self.updateDisplay(for: Preferences().selectedTime)
        self.configureButtonsAndMenus()
    }
}

extension TimerViewController: TheTimerProtocol
{
    func timeRemainingOnTimer(_ timer: TheTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: TheTimer) {
        updateDisplay(for: 0)
    }
}

