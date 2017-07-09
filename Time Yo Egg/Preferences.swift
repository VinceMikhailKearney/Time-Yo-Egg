//
//  Preferences.swift
//  Time Yo Egg
//
//  Created by Vince Kearney on 08/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import Cocoa

struct Preferences
{
    static var selectedTime: TimeInterval
    {
        get {
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 { return savedTime }
            return 240
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
        }
    }
}
