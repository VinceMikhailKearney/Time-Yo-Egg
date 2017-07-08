//
//  ViewController.swift
//  Time Yo Egg
//
//  Created by Vince Kearney on 08/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import AVFoundation
import Cocoa

class TimerViewController: NSViewController
{
    // MARK: Properties
    private var eggTimer : TheTimer?
    private var prefs : Preferences?
    fileprivate var soundPlayer: AVAudioPlayer?
    // MARK: Outlets
    @IBOutlet weak var eggTimeTextLabel : NSTextField!
    @IBOutlet weak var eggTimerImageView : NSImageView!
    @IBOutlet weak var startButton : NSButton!
    @IBOutlet weak var stopButton : NSButton!
    @IBOutlet weak var restartButton : NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefs = Preferences()
        self.eggTimer = TheTimer()
        self.eggTimer?.delegate = self
        self.setupPrefs()
    }

    /// TODO - Need to figure out what this is exactly
    override var representedObject: Any?
    {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Preferences
    
    func setupPrefs()
    {
        self.updateDisplay(for: self.prefs!.selectedTime)
        
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil)
        { (notification) in
            self.checkForResetAfterPrefsChange()
        }
    }
    
    func updateFromPrefs() {
        self.eggTimer?.duration = self.prefs!.selectedTime
        self.clickRestart(self)
    }
    
    func checkForResetAfterPrefsChange()
    {
        if self.eggTimer!.isStopped || self.eggTimer!.isPaused
        {
            self.updateFromPrefs()
        }
        else
        {
            let alert = NSAlert()
            alert.messageText = "Reset timer with the new settings?"
            alert.informativeText = "This will stop your current timer!"
            alert.alertStyle = .warning
            
            alert.addButton(withTitle: "Reset")
            alert.addButton(withTitle: "Cancel")
            
            let response = alert.runModal()
            if response == NSAlertFirstButtonReturn {
                self.updateFromPrefs()
            }
        }
    }
    
    // MARK: Display
    
    func updateDisplay(for timeRemaining: TimeInterval) {
        self.eggTimeTextLabel.stringValue = textToDisplay(for: timeRemaining)
        self.eggTimerImageView.image = imageToDisplay(for: timeRemaining)
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
        let percentageComplete = 100 - (timeRemaining / self.prefs!.selectedTime * 100)
        
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
        
        self.startButton.isEnabled = enableStart
        self.stopButton.isEnabled = enableStop
        self.restartButton.isEnabled = enableReset
        
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
            self.eggTimer?.duration = self.prefs!.selectedTime
            self.eggTimer?.startTimer()
        }
        self.configureButtonsAndMenus()
        self.prepareSound()
    }
    
    @IBAction func clickStop(_ sender : Any) {
        self.eggTimer?.stopTimer()
        self.configureButtonsAndMenus()
    }
    
    @IBAction func clickRestart(_ sender : Any) {
        self.eggTimer?.resetTimer()
        self.updateDisplay(for: self.prefs!.selectedTime)
        self.configureButtonsAndMenus()
    }
}

extension TimerViewController: TheTimerProtocol
{
    func timeRemainingOnTimer(_ timer: TheTimer, timeRemaining: TimeInterval) {
        self.updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: TheTimer) {
        self.updateDisplay(for: 0)
        self.playSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.clickRestart(self)
        }
    }
}

extension TimerViewController
{
    func prepareSound()
    {
        guard let audioFileUrl = NSDataAsset(name: "ding") else {
            print("Did not find audio file")
            return
        }
        
        do {
            self.soundPlayer = try AVAudioPlayer(data: audioFileUrl.data, fileTypeHint: AVFileTypeMPEGLayer3)
            self.soundPlayer?.prepareToPlay()
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        self.soundPlayer?.play()
    }

}
