//
//  RecordingViewController.swift
//  FinalGetWell2
//
//  Created by Keron Williams on 1/7/16.
//  Copyright © 2016 Keron. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var affirmationGoal: UITextField!
    
    @IBOutlet weak var affirmationListButton: UIButton!
    
    var dad: MediaPlayerVC2?
    
    // an instance of AVAudioRecorder and AVAudioPlayer (to play the recording sound)
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    
    var lastAudioFileURL: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        recordingLabel.isHidden = true
        //affirmationListButton.hidden = true
        
        setUpAudioRecord()
        
        if timerCount%2 == 1
        {
            dad?.togglePlayback(true)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if timerCount%2 == 1
        {
            dad?.togglePlayback(true)
        }
    }

    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "affirmationCell", for: indexPath) as! RecordingTableViewCell
        
    return cell
    }
    


    func setUpAudioRecord()
    {
        //            let audiOFile = ParseHelper.uploadSoundFileToParse("documents/var..","myRecording1")
        // set up the audio file
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        // rename file using a method to change string to random
        let audioFileURL = directoryURL.appendingPathComponent("MyMemo.m4a")
        self.lastAudioFileURL = audioFileURL.absoluteString
        // set up the audio session
        // the audio session acts as the middle man between the app and the system's media service
        // answers question like should the app stops the currently playing music, should be allowed to play back the recording
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        } catch let error {
            print(error)
        }
        
        
        // define the recorder setting
        
        let recorderSettings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey : 44100.0, AVNumberOfChannelsKey : 2 as NSNumber] as [String : Any]
        
        // initiate and prepare the recorder
        do {
            audioRecorder  = try AVAudioRecorder(url: audioFileURL, settings: recorderSettings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch let error {
            print(error)
        }
    }
    
    func play()
    {
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                return
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
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
            if player.isPlaying {
                player.stop()
                
            }
        }
        
        // if we are not recording the start recording!
        if let recorder = audioRecorder {
            if !recorder.isRecording {
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
    func alert(_ title: String, msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - AVAudioRecorderDelegate

extension RecordingViewController : AVAudioRecorderDelegate
{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.alert("Excellent!", msg: "Successfully recorded your affirmation")
        }
    }
}


// MARK: - AVAudioPlayerDelegate

extension RecordingViewController : AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if flag {
            self.alert("Sounds Great!", msg: "Finished playing your affirmation")
            
        }
    }
    
    @IBAction func recordTapped(_ sender: UIButton)
    {
        record()
        recordingLabel.isHidden = false
        
        
    }
    
    @IBAction func cancelTapped(_ sender: UIButton)
    {
        cancel()
        recordingLabel.isHidden = true
        let nameOfFileTwo:String = "Wow"
        ParseHelper.uploadSoundFileToParse(self.lastAudioFileURL!, nameOfFile:nameOfFileTwo)
 
        
    }
    
    @IBAction func playTapped(_ sender: UIButton)
    {
        play()
        
        
//        let nameOfFileTwo:String = "Wow"
//        ParseHelper.uploadSoundFileToParse(self.lastAudioFileURL!, nameOfFile:nameOfFileTwo)
        //            dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
}
