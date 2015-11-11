//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Wilding Threlfall on 12/12/14.
//  Copyright (c) 2014 Wilding Threlfall. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {

    

    
    //declare recieved audio that was passed from recordSoundsViewController
    var receivedAudio:RecordedAudio!
    
    //declare audioplayer
    var audioPlayer : AVAudioPlayer! = nil
    
    //declare audioengine (group of audio nodes)
    var audioEngine: AVAudioEngine!
    
    //declare audioFile
    var audioFile: AVAudioFile!
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize audioplayer with NSURL from receivedAudio, enable rate changes
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        //initialize audioengine
        audioEngine = AVAudioEngine()
        
        //initialize audio file from NSURL of our recording
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        //use loud speakers not built-in
        NSNotificationCenter.defaultCenter().addObserverForName(AVAudioSessionRouteChangeNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            (note:NSNotification!) in
            //println("change route\(note.userInfo)")
            println("current output :\(AVAudioSession.sharedInstance().currentRoute.outputs[0].UID)")
            if (AVAudioSession.sharedInstance().currentRoute.outputs[0].UID) == "Built-In Receiver" {
                AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    // play clip at certain rate
    func playAudioWithVariableRate(playRate: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // play clip with a certain pitch
    func playAudioWithVariablePitch(pitch: Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // create nodes, add them to audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //connect nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }






    // when you press the snail
    @IBAction func playSlowAudio(sender: UIButton) {
        //play recording at half speed
        playAudioWithVariableRate(0.5)
    }

    // when you press rabbit
    @IBAction func playFastAudio(sender: UIButton) {
        //play recording at double speed
        playAudioWithVariableRate(2.0)
    }
    
    // when you press the chipmunk
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //play recording with high pitch
        playAudioWithVariablePitch(1000)
    }
    
    // when you press Darth Vader
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        //play recording with low pitch
        playAudioWithVariablePitch(-1000)
    }
    
    // when you press stop
    @IBAction func stopButton(sender: UIButton) {
        // stop audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
