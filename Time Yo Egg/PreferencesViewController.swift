//
//  PreferencesViewController.swift
//  Time Yo Egg
//
//  Created by Vince Kearney on 08/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController
{
    // MARK: Properties
    private var prefs : Preferences?
    // MARK: Outlets
    @IBOutlet weak var popUp: NSPopUpButton!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var eggTimeTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefs = Preferences()
        self.showExistingPrefs()
    }
    
    func showExistingPrefs()
    {
        let selectedTimeInMinutes = Int(self.prefs!.selectedTime) / 60
        
        self.popUp.selectItem(withTitle: "Custom")
        self.slider.isEnabled = true
        
        for item in popUp.itemArray
        {
            if item.tag == selectedTimeInMinutes {
                popUp.select(item)
                slider.isEnabled = false
                break
            }
        }
        
        self.slider.integerValue = selectedTimeInMinutes
        showSliderValueAsText()
    }
    
    func showSliderValueAsText() {
        let newTimerDuration = self.slider.integerValue
        self.eggTimeTextField.stringValue = "\(newTimerDuration) \((newTimerDuration == 1) ? "minute" : "minutes")"
    }
    
    func saveNewPrefs() {
        self.prefs!.selectedTime = self.slider.doubleValue * 60
        NotificationCenter.default.post(name: Notifications.prefsChanged, object: nil)
    }
    
    // MARK: Actions
    @IBAction func popUpValueChanged(_ sender: NSPopUpButton)
    {
        if sender.selectedItem?.title == "Custom" {
            self.slider.isEnabled = true
            return
        }
        
        let newTimerDuration = sender.selectedTag()
        self.slider.integerValue = newTimerDuration
        showSliderValueAsText()
        self.slider.isEnabled = false
    }
    
    @IBAction func okButtonClicked(_ sender: AnyObject) {
        self.saveNewPrefs()
        self.view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        self.view.window?.close()
    }
    
    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        self.showSliderValueAsText()
    }
}
