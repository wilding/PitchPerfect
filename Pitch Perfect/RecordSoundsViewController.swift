//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Wilding Threlfall on 12/4/14.
//  Copyright (c) 2014 Wilding Threlfall. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //declare button outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordinglabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    // declare audio recorder
    var audioRecorder: AVAudioRecorder!
    
    //declare variable for recorded audio of a class that we created
    var recordedAudio: RecordedAudio!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //default view
    override func viewWillAppear(animated: Bool) {
       
        //disable the stop button by default
        stopButton.hidden = true
        
        //enable mic by default
        recordButton.enabled = true
        
        //set default label
        recordinglabel.hidden = false
        recordinglabel.text = "Tap to Record"
        recordinglabel.textColor = UIColor(red: 0.101961, green: 0.219608, blue: 0.360784, alpha: 1)
    }
    
   

    
    
    
    // when you press the mic
    @IBAction func recordAudio(sender: UIButton) {
        
        //show text "recording"
        recordinglabel.text = "Recording..."
        recordinglabel.textColor = UIColor.redColor()
        
        //enable stop button
        stopButton.hidden = false
        
        //disable microphone
        recordButton.enabled = false
        
        //record the user's voice
        // set up file path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // set up audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    // when recording is done
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag) {
            
            //save recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url!, title: recorder.url.lastPathComponent!)
        
            //perform a segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        
        } else {
            println("Recording was not successful")
            //default view
            recordButton.enabled = true
            stopButton.hidden = true
            recordinglabel.hidden = false
            recordinglabel.text = "Tap to Record"
            recordinglabel.textColor = UIColor(red: 0.101961, green: 0.219608, blue: 0.360784, alpha: 1)
        }
    }
    
    //pass recording to playSoundsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            }
    }

    // when you press stop
    @IBAction func stopRecording(sender: UIButton) {
        
        //default view
        recordButton.enabled = true
        stopButton.hidden = true
        recordinglabel.hidden = false
        recordinglabel.text = "Tap to Record"
        recordinglabel.textColor = UIColor(red: 0.101961, green: 0.219608, blue: 0.360784, alpha: 1)
        
        //stop recording
        audioRecorder.stop()
        
        //deactivate audio session
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    }