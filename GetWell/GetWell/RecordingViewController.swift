//
//  RecordingViewController.swift
//  FinalGetWell2
//
//  Created by Keron Williams on 1/7/16.
//  Copyright © 2016 Keron. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController
{
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    // an instance of AVAudioRecorder and AVAudioPlayer (to play the recording sound)
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    
    var lastAudioFileURL: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        recordingLabel.hidden = true
        
        setUpAudioRecord()
        
    }
    
    func setUpAudioRecord()
    {
        //            let audiOFile = ParseHelper.uploadSoundFileToParse("documents/var..","myRecording1")
        // set up the audio file
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        // rename file using a method to change string to random
        let audioFileURL = directoryURL.URLByAppendingPathComponent("MyMemo.m4a")
        self.lastAudioFileURL = audioFileURL.absoluteString
        // set up the audio session
        // the audio session acts as the middle man between the app and the system's media service
        // answers question like should the app stops the currently playing music, should be allowed to play back the recording
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        } catch let error {
            print(error)
        }
        
        
        // define the recorder setting
        
        let recorderSettings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey : 44100.0, AVNumberOfChannelsKey : 2 as NSNumber]
        
        // initiate and prepare the recorder
        do {
            audioRecorder  = try AVAudioRecorder(URL: audioFileURL, settings: recorderSettings)
            audioRecorder?.delegate = self
            audioRecorder?.meteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch let error {
            print(error)
        }
    }
    
    func play()
    {
        if let player = audioPlayer {
            if player.playing {
                player.stop()
                return
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.recording {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOfURL: recorder.url)
                    audioPlayer?.delegate = self
                    audioPlayer?.play()
                    
                    // change the play button. enable it and change the image
                    
                    
                    // disable the cancel button image view
                } catch let error {
                    print(error)
                }
            }
        }
        
        
    }
    
    func cancel()
    {
        // stop the audio recorder
        audioRecorder?.stop()
        
        // deactivate the audio session
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            print(error)
        }
    }
    
    func record()
    {
        // stop the audio player before recording
        if let player = audioPlayer {
            if player.playing {
                player.stop()
                
            }
        }
        
        // if we are not recording the start recording!
        if let recorder = audioRecorder {
            if !recorder.recording {
                do {
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setActive(true)    // make the recorder work
                    
                    // start recording
                    recorder.record()
                    
                } catch let error {
                    print(error)
                }
            } else {
                // pause the recording
                recorder.pause()
            }
        }
        
        
    }
    
    // MARK: - Helper method
    
    // this just presents an alert view with the given title and message (msg)
    func alert(title: String, msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - AVAudioRecorderDelegate

extension RecordingViewController : AVAudioRecorderDelegate
{
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.alert("Finish recording", msg: "Successfully recorded the audio")
        }
    }
}


// MARK: - AVAudioPlayerDelegate

extension RecordingViewController : AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        if flag {
            self.alert("Finish Playing", msg: "Finish playing the recording")
            
        }
    }
    
    @IBAction func recordTapped(sender: UIButton)
    {
        record()
        recordingLabel.hidden = false
        
        
    }
    
    @IBAction func cancelTapped(sender: UIButton)
    {
        cancel()
        recordingLabel.hidden = true
        let nameOfFileTwo:String = "Wow"
        ParseHelper.uploadSoundFileToParse(self.lastAudioFileURL!, nameOfFile:nameOfFileTwo)
 
        
    }
    
    @IBAction func playTapped(sender: UIButton)
    {
        play()
//        let nameOfFileTwo:String = "Wow"
//        ParseHelper.uploadSoundFileToParse(self.lastAudioFileURL!, nameOfFile:nameOfFileTwo)
        //            dismissViewControllerAnimated(true, completion: nil)
    }
}
