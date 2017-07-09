//
//  AudioManager.swift
//  Time Yo Egg
//
//  Created by Vince Kearney on 09/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import AVFoundation
import Cocoa

class AudioManager: NSObject
{
    // MARK: Properties
    public static let sharedInstance : AudioManager = AudioManager()
    private var player : AVAudioPlayer?
    
    public func prepareSound()
    {
        guard let audioFileUrl = NSDataAsset(name: "ding") else {
            print("Did not find audio file")
            return
        }
        
        do {
            self.player = try AVAudioPlayer(data: audioFileUrl.data, fileTypeHint: AVFileTypeMPEGLayer3)
            self.player?.prepareToPlay()
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    public func play() {
        self.player?.play()
    }
}
