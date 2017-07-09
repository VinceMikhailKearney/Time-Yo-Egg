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
    private static var audioManager : AudioManager?
    private var player : AVAudioPlayer?
    
    public static func sharedInstance() -> AudioManager {
        if self.audioManager == nil {
            self.audioManager = AudioManager()
        }
        return self.audioManager!
    }
    
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
