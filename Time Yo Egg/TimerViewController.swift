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
    @IBOutlet weak var eggTimeTextLabel : NSTextField!
    @IBOutlet weak var eggTimerImageView : NSImageView!
    @IBOutlet weak var startButton : NSButton!
    @IBOutlet weak var stopButton : NSButton!
    @IBOutlet weak var restartButton : NSButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    /// TODO - Need to figure out what this is exactly
    override var representedObject: Any?
    {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Actions
    @IBAction func clickStart(_ sender : Any) {
        print("Clicked the start button")
    }
    
    @IBAction func clickStop(_ sender : Any) {
        print("Clicked the stop button")
    }
    
    @IBAction func clickRestart(_ sender : Any) {
        print("Clicked the restart button")
    }
}

