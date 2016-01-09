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
        
        @IBOutlet weak var playButtonImageView: UIImageView!
        @IBOutlet weak var cancelButtonImageView: UIImageView!
        @IBOutlet weak var recordButtonImageView: UIImageView!
        
        // an instance of AVAudioRecorder and AVAudioPlayer (to play the recording sound)
        var audioRecorder: AVAudioRecorder!
        var audioPlayer: AVAudioPlayer!
        var audioURL = NSURL()
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
//            
//            let audioData = NSFileManager.defaultManager().contentsAtPath(self.audioURL.path!)
//            let audioFile = PFFile(data: (audioData)!)
//            
//            let sound = PFObject(className: "sound")
//            sound.setObject(PFUser.currentUser()!, forKey: "User")
//            sound.setObject(audioFile!, forKey: "Audio")
//            
//            sound.saveInBackgroundWithBlock { (sucess: Bool, error: NSError?) -> Void in
//            if sucess == true
//            {
//                let audioFile = PFFile(name: "mysound.caf", data: NSData(contentsOfURL: self.audioURL)!)
//                sound["audioFile"] = audioFile
//                
//            }
//            if sucess == false
//            {
//                print("Sucesses")
//            }
//            else
//            {
//                print("Nice Try")
//            }
//            }
//            
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
            let playTap = UITapGestureRecognizer(target: self, action: "play")
            playButtonImageView.addGestureRecognizer(playTap)
            
            let cancelTap = UITapGestureRecognizer(target: self, action: "cancel")
            cancelButtonImageView.addGestureRecognizer(cancelTap)
            
            let recordTap = UITapGestureRecognizer(target: self, action: "record")
            recordButtonImageView.addGestureRecognizer(recordTap)

            // disable the stop and play buttons when we start
            self.configureImageView(cancelButtonImageView, alpha: 0.5, userInteractionEnabled: false)
            self.configureImageView(playButtonImageView, alpha: 0.5, userInteractionEnabled: false)
            
            // let's set up the audio recorder and player
            setUpAudioRecord()

            
        }
        
        func configureImageView(imageView: UIImageView, alpha: CGFloat, userInteractionEnabled: Bool) {
            imageView.alpha = alpha
            imageView.userInteractionEnabled = userInteractionEnabled
        }
        
        func setUpAudioRecord()
        {
            // set up the audio file
            let directoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
            let audioFileURL = directoryURL.URLByAppendingPathComponent("MyMemo.m4a")
            
            // set up the audio session
            // the audio session acts as the middle man between the app and the system's media service
            // answers question like should the app stops the currently playing music, should be allowed to play back the recording
            let audioSession = AVAudioSession.sharedInstance()
            
            do
            {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            }
            catch let error
            {
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
            }
            catch let error
            {
                print(error)
            }
        }
        
        func play()
        {
            if let player = audioPlayer
            {
                if player.playing
                {
                    player.stop()
                    playButtonImageView.image = UIImage(named: "Play")
                    return
                }
            }
            
            if let recorder = audioRecorder
            {
                if !recorder.recording
                {
                    do
                    {
                        audioPlayer = try AVAudioPlayer(contentsOfURL: recorder.url)
                        audioPlayer?.delegate = self
                        audioPlayer?.play()
                        
                        // change the play button. enable it and change the image
                        playButtonImageView.image = UIImage(named: "Cancel")
                        playButtonImageView.userInteractionEnabled = true
                        
                        // disable the cancel button image view
                        configureImageView(cancelButtonImageView, alpha: 0.5, userInteractionEnabled: false)
                    }
                    catch let error
                    {
                        print(error)
                    }
                }
            }
            
            
        }
        
        func cancel()
        {
            recordButtonImageView.image = UIImage(named: "Record")
            // enable play button image view
            self.configureImageView(playButtonImageView, alpha: 1, userInteractionEnabled: true)
            
            // stop the audio recorder
            audioRecorder?.stop()
            
            // deactivate the audio session
            do
            {
                try AVAudioSession.sharedInstance().setActive(false)
            }
            catch let error
            {
                print(error)
            }
        }
        
        func record()
        {
            // stop the audio player before recording
            if let player = audioPlayer
            {
                if player.playing
                {
                    player.stop()
                    playButtonImageView.image = UIImage(named: "Play")
                    playButtonImageView.userInteractionEnabled = false
                }
            }
            
            // if we are not recording the start recording!
            if let recorder = audioRecorder
            {
                if !recorder.recording
                {
                    do
                    {
                        let audioSession = AVAudioSession.sharedInstance()
                        try audioSession.setActive(true)    // make the recorder work
                        
                        // start recording
                        recorder.record()
                        recordButtonImageView.image = UIImage(named: "Start-Recording")
                        configureImageView(recordButtonImageView, alpha: 1.0, userInteractionEnabled: true)
                    }
                    catch let error
                    {
                        print(error)
                    }
                }
                else
                {
                    // pause the recording
                    recorder.pause()
                    recordButtonImageView.image = UIImage(named: "Record")
                }
            }
            
            // enable the cancel button image view
            self.configureImageView(cancelButtonImageView, alpha: 1.0, userInteractionEnabled: true)
            
            // disable play button
            self.configureImageView(playButtonImageView, alpha: 0.5, userInteractionEnabled: false)
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
        func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
        {
            if flag
            {
                self.alert("Finish recording", msg: "Successfully recorded the audio")
            }
        }
    }
    
    
    // MARK: - AVAudioPlayerDelegate
    
    extension RecordingViewController : AVAudioPlayerDelegate
    {
        func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
        {
            if flag
            {
                self.alert("Finish Playing", msg: "Finish playing the recording")
                
                playButtonImageView.image = UIImage(named: "Play")
            }
        }
}
