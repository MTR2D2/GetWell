//
//  MediaPlayerVC2.swift
//  GetWell
//
//  Created by Michael Reynolds on 1/12/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

//
//  MediaPlayerViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import QuartzCore

protocol DatePickerDelegate
{
    func dateWasChosen(_ date: Date)
}

class MediaPlayerVC2: UIViewController, UIPopoverPresentationControllerDelegate, DatePickerDelegate
{
    
    var song: Song?
    
    // an instance of AVAudioRecorder and AVAudioPlayer (to play the recording sound)
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet var meditationCountdown: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var albumArtwork: UIImageView!
    //    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var setReminderButton: UIBarButtonItem!
    @IBOutlet weak var nextMeditation: UILabel!
    
    //    let avQueuePlayer = AVQueuePlayer()
    var player = AVQueuePlayer()
    var songs = Array<Song>()
    var currentSong: Song?
    var nowPlaying: Bool = false
    
    var timer: Timer?
    var originalCount = 0
    
    var whichSegment = 0
    
    var flashTimer: Timer?
    var flashCount = 0
    var flashing = true
    
    var timesTapped = 0
    
    
    var delegate: MainViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //        self.navigationController!.navigationBar.topItem!.title = "Cancel"
        
//        recordingLabel.hidden = true
        
        //        setUpAudioRecord()
        
        backButton.isEnabled = false
        
        pulse(playPauseButton)
        morePulse(playPauseButton)
        
        //plusButton.hidden = true
        
        timerCount = 0
        originalCount = 300
        meditationCountdown.text = "05:00"
        
        setupAudioSession()
        configurePlaylist()
        loadCurrentSong()
        
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
        }
        catch let error as NSError
        {
            print("Failed to set audio session category. Error: \(error)")
        }
        //        let fileNames = ["betterdaysahead", "mindPowerAffirmation", "leaveswind", "mytomorrow", "thebeautifulbeach", "rainy", "coldsnowstorm", "rainOntheRooftop", "relaxingnovember", "heavywetrain", "busygreenforest", "gentlewetcreek", "thunderlight", "littlebirds" ]
        //
        //        let songs = fileNames.map {AVPlayerItem(URL: NSBundle.mainBundle().URLForResource($0 , withExtension: "mp3")!)}
        //        player = AVQueuePlayer(items: songs)
        //        player.actionAtItemEnd = .Advance
        //        player.addObserver(self, forKeyPath: "currentItem", options: [.New, .Initial], context: nil)
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "currentItem", let player = object as? AVPlayer, let currentItem = player.currentItem?.asset as? AVURLAsset
        {
            songTitleLabel.text = currentItem.url.lastPathComponent 
            
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        resetTimer()
    }
    
    @IBAction func segmentedIndexTapped(_ sender: UISegmentedControl)
    {
        
        if sender.selectedSegmentIndex == 0
        {
            originalCount = 300
            meditationCountdown.text = "05:00"
            whichSegment = 0
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 1
        {
            originalCount = 600
            meditationCountdown.text = "10:00"
            whichSegment = 1
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 2
        {
            originalCount = 900
            meditationCountdown.text = "15:00"
            whichSegment = 2
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 3
        {
            originalCount = 1200
            meditationCountdown.text = "20:00"
            whichSegment = 3
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        
    }
    
    func morePulse(_ button: UIButton)
    {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 3
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1.3
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        button.layer.add(pulseAnimation, forKey: nil)
    }
    
    func pulse(_ button: UIButton)
    {
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 10
        pulseAnimation.fromValue = NSNumber(value: 0.7 as Float)
        pulseAnimation.toValue = NSNumber(value: 1.2 as Float)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        button.layer.add(pulseAnimation, forKey: "layerAnimation")
    }
    
    
    func startTimer()
    {
        if timerCount % 2 == 0
        {
            timer?.invalidate()
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MediaPlayerVC2.updateUI), userInfo: nil, repeats: true)
            updateUI()
        }
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
    }
    
    func updateUI()
    {
        originalCount = originalCount - 1
        //        let newMinuteCount = originalCount/60
        //        let newSecondCount = originalCount%60
        //        meditationCountdown.text = String("\(newMinuteCount):\(newSecondCount)")
        timerDisplay()
        print(originalCount)
        
        if originalCount == 0
        {
            timer?.invalidate()
            flashTimer = Timer
                .scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(MediaPlayerVC2.flashLabel) , userInfo: nil, repeats: true)
            playNotification()
        }
    }
    
    func timerDisplay()
    {
        let dFormat = "%02d"
        let newMinuteCount = originalCount/60
        let newSecondCount = originalCount%60
        let s = "\(String(format: dFormat, newMinuteCount)):\(String(format: dFormat, newSecondCount))"
        meditationCountdown.text = s
    }
    
    func flashLabel()
    {
        flashing = !flashing
        if flashing
        {
            meditationCountdown.textColor = UIColor.white
        }
        else
        {
            meditationCountdown.textColor = UIColor.yellow
        }
        flashCount += 1
        
        if flashCount > 100
        {
            flashTimer?.invalidate()
        }
    }
    
    func playNotification()
    {
        let soundURL = Bundle.main.url(forResource: "SessionOver", withExtension: "m4a")!
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton)
    {
//        timerCount = timerCount + 1
        timerCount += 1

        if originalCount <= 1
        {
            flashTimer?.invalidate()
            meditationCountdown.textColor = UIColor.white
            resetTimer()
            togglePlayback(true)
        }
//        updatePlayPauseButton()
        startTimer()
        togglePlayback(!nowPlaying)
        backButton.isHidden = false
        backButton.isEnabled = true
        meditationCountdown.textColor = UIColor.white
    }
    
    @IBAction func skipForwardTapped(_ sender: UIButton)
    {
        meditationCountdown.textColor = UIColor.white
        let currentSongIndex = (songs as NSArray).index(of: currentSong!)
        let nextSong: Int
        
        if currentSongIndex + 1 >= songs.count
        {
            nextSong = 0
        }
        else
        {
            nextSong = currentSongIndex + 1
        }
        currentSong = songs[nextSong]
        loadCurrentSong()
        //        togglePlayback(true)
    }
    
    @IBAction func skipBackTapped(_ sender: UIButton)
    {
        if nowPlaying
        {
            meditationCountdown.textColor = UIColor.white
            timesTapped = timesTapped + 1
            
            if timesTapped % 2 == 1
            {
                player.seek(to: CMTimeMakeWithSeconds(0.0, 1))
            }
            else if timesTapped % 2 == 0
            {
                let currentSongIndex = (songs as NSArray).index(of: currentSong!)
                let nextSong: Int
                if currentSongIndex != 0
                {
                    nextSong = currentSongIndex - 1
                }
                else
                {
                    nextSong = songs.count - 1
                }
                currentSong = songs[nextSong]
                loadCurrentSong()
                togglePlayback(true)
            }
        }
        else
        {
            backButton.isEnabled = false
        }
        
    }
    
    func configurePlaylist()
    {
        let mindpowerDict: NSDictionary = [
            "title": "Mind Power",
            "artist" : "Benjamin Tissot",
            "filename" : "betterdaysahead",
            "albumArtwork" : "newChillImg"
        ]
        let mindpowerSong = Song(dictionary: mindpowerDict)
        songs.append(mindpowerSong)
        currentSong = mindpowerSong
        
        let mindpowerAffDict: NSDictionary = [
            "title": "Mind Power Affirmation",
            "artist": "Benjamin Tissot",
            "filename": "gwNewMindPower",
            "albumArtwork": "newMindPowerImg"
        ]
        let mindpowerAff = Song(dictionary: mindpowerAffDict)
        songs.append(mindpowerAff)
        
        let autumDict: NSDictionary = [
            "title": "Fall",
            "artist": "Benjamin Tissot",
            "filename": "leaveswind",
            "albumArtwork": "newWindLeavesImg"
        ]
        let autum = Song(dictionary: autumDict)
        songs.append(autum)
        
        let tomorrowDict: NSDictionary = [
            "title": "The Future",
            "artist": "Benjamin Tissot",
            "filename": "mytomorrow",
            "albumArtwork": "newTomorrowImg"
        ]
        let tomorrow = Song(dictionary: tomorrowDict)
        songs.append(tomorrow)
        
        let beachDict: NSDictionary = [
            "title": "Sea Shore",
            "artist": "Benjamin Tissot",
            "filename": "thebeautifulbeach",
            "albumArtwork": "newBeachImg"
        ]
        let beach = Song(dictionary: beachDict)
        songs.append(beach)
        
        let rainDict: NSDictionary = [
            "title": "Rain",
            "artist": "Benjamin Tissot",
            "filename": "rainy",
            "albumArtwork": "newRainImg"
        ]
        let rain = Song(dictionary: rainDict)
        songs.append(rain)
        
        let snowDict: NSDictionary = [
            "title": "Winter",
            "artist": "Benjamin Tissot",
            "filename": "coldsnowstorm",
            "albumArtwork": "newSnowStormImg"
        ]
        let snow = Song(dictionary: snowDict)
        songs.append(snow)
        
        let roofDict: NSDictionary = [
            "title": "Roof Top",
            "artist": "Benjamin Tissot",
            "filename": "rainOntheRooftop",
            "albumArtwork": "newRooftopImg"
        ]
        let roof = Song(dictionary: roofDict)
        songs.append(roof)
        
        let relaxDict: NSDictionary = [
            "title": "Calm",
            "artist": "Benjamin Tissot",
            "filename": "relaxingnovember",
            "albumArtwork": "newRelaxingImg"
        ]
        let relax = Song(dictionary: relaxDict)
        songs.append(relax)
        
        let relaxCalm: NSDictionary = [
            "title": "Calm Affirmation",
            "artist": "Benjamin Tissot",
            "filename": "calmPeace",
            "albumArtwork": "newCalmAffirmation"
        ]
        let calm = Song(dictionary: relaxCalm)
        songs.append(calm)
        
        let pouringDict: NSDictionary = [
            "title": "Drench",
            "artist": "Benjamin Tissot",
            "filename": "heavywetrain",
            "albumArtwork": "newHeavyRain"
        ]
        let pouring = Song(dictionary: pouringDict)
        songs.append(pouring)
        
        let lushDict: NSDictionary = [
            "title": "Lush",
            "artist": "Benjamin Tissot",
            "filename": "busygreenforest",
            "albumArtwork": "newForestImg"
        ]
        let lush = Song(dictionary: lushDict)
        songs.append(lush)
        
        let streamDict: NSDictionary = [
            "title": "Soft Creek",
            "artist": "Benjamin Tissot",
            "filename": "gentlewetcreek",
            "albumArtwork": "newCreekImg"
        ]
        let stream = Song(dictionary: streamDict)
        songs.append(stream)
        
        let heavenDict: NSDictionary = [
            "title": "Rage",
            "artist": "Benjamin Tissot",
            "filename": "thunderlight",
            "albumArtwork": "newThunderImg"
        ]
        let heaven = Song(dictionary: heavenDict)
        songs.append(heaven)
        
        let tweetsDict: NSDictionary = [
            "title": "Happy",
            "artist": "Benjamin Tissot",
            "filename": "littlebirds",
            "albumArtwork": "newBirdsImg"
        ]
        let tweets = Song(dictionary: tweetsDict)
        songs.append(tweets)
        
    }
    
    func loadCurrentSong()
    {
        player.removeAllItems()
        if let song = currentSong
        {
            song.playerItem.seek(to: CMTimeMakeWithSeconds(0.0, 1))
            player.insert(song.playerItem, after: nil)
            songTitleLabel.text = song.title
            //            artistLabel.text? = song.artist
            albumArtwork.image = UIImage(named: song.albumArtworkName)
            
        }
    }
    
    func updatePlayPauseButton()
    {
        if timerCount % 2 == 1
        {
            playPauseButton.setImage(UIImage(named:"PauseB"), for:UIControlState())
            playPauseButton.setImage(UIImage(named: "PlayPauseB"), for: .highlighted)
        }
        else
        {
            playPauseButton.setImage(UIImage(named: "PlayPauseB"), for: UIControlState())
        }
        
    }
    
    func setupAudioSession()
    {
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted
            {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                } catch _ {
                }
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch _ {
                }
            }
            else
            {
                print("Audio session could not be configured; user denied permission.")
            }
        })
    }
    
    func togglePlayback(_ play: Bool)
    {
        nowPlaying = play
        if play
        {
            //            playPauseButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            player.play()
        }
        else
        {
            //            playPauseButton.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            player.pause()
        }
    }
    
    func resetTimer()
    {
        timer?.invalidate()
        meditationCountdown.textColor = UIColor.white
        
        if whichSegment == 0
        {
            originalCount = 300
            meditationCountdown.text = "05:00"
        }
        if whichSegment == 1
        {
            originalCount = 600
            meditationCountdown.text = "10:00"
        }
        if whichSegment == 2
        {
            originalCount = 900
            meditationCountdown.text = "15:00"
        }
        if whichSegment == 3
        {
            originalCount = 1200
            meditationCountdown.text = "20:00"
        }
        
        stopTimer()
        timerCount = 0
        timesTapped = 1
        loadCurrentSong()
        togglePlayback(false)
    }
    
    @IBAction func resetPressed(_ sender: UIButton!)
    {
        resetTimer()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if timerCount%2 == 1
        {
            togglePlayback(true)
        }
        
        if let recordPlaylistVC = segue.destination as? PlaylistTableViewController
        {
            recordPlaylistVC.dad = self
            recordPlaylistVC.songs = songs
        }
        
        if segue.identifier == "PlaylistSegue2"
        {
            let destVC = segue.destination as! PlaylistTableViewController
            destVC.popoverPresentationController?.delegate = self
            destVC.dad = self
            destVC.preferredContentSize = CGSize(width: 410.0, height: 216.0)
            //            destVC = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0)
            let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
            self.preferredContentSize = CGSize(width: frameSize.x,height: frameSize.y);
        }
        
        if segue.identifier == "AffirmationSegue"
        {
            let destVC = segue.destination as! MySavedAffirmationViewController
            destVC.popoverPresentationController?.delegate = self
            destVC.dad = self
            destVC.preferredContentSize = CGSize(width: 410.0, height: 216.0)
            //            destVC = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0)
            let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
            self.preferredContentSize = CGSize(width: frameSize.x,height: frameSize.y);
        }
        
        if segue.identifier == "SetReminderSegue"
        {
            let destVC = segue.destination as! SetReminderPopOverViewController
            destVC.popoverPresentationController?.delegate = self
            destVC.delegate = self
            destVC.preferredContentSize = CGSize(width: 410.0, height: 216.0)
        }
        
        //        if let loginVC = segue.destinationViewController as? LoginViewController
        //        {
        //            loginVC.dismissDelegate = self
        //
        //        }
    }
    
    func unwindFromLogin()
    {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - UIPopoverPresentationController Delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    // MARK: DatePicker Delegate
    
    func dateWasChosen(_ date: Date)
    {
        nextMeditation.text = "Next session: \(dateFormat(date))"
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        print(Date())
        print(localNotification.fireDate)
        localNotification.timeZone = TimeZone.autoupdatingCurrent
        localNotification.alertBody = "Time to Relax"
        localNotification.alertAction = "Open App"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    
    func dateFormat(_ x: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMM dd yyyy HH:mm", options: 0, locale: Locale.current)
        let formattedTime = formatter.string(from: x).uppercased()
        
        return String(formattedTime)
    }
    
    
    
    //        if let nav = segue.destinationViewController as? UINavigationController
    //        {
    //            if let searchVC = nav.topViewController as? MapViewController
    //            {
    //                searchVC.parent = self
    //            }
    //        }
    
    //    }
    
    //    func setUpAudioRecord()
    //    {
    //        // set up the audio file
    //        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
    //        let audioFileURL = directoryURL.URLByAppendingPathComponent("MyMemo.m4a")
    //
    //        // set up the audio session
    //        // the audio session acts as the middle man between the app and the system's media service
    //        // answers question like should the app stops the currently playing music, should be allowed to play back the recording
    //        let audioSession = AVAudioSession.sharedInstance()
    //
    //        do {
    //            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
    //        } catch let error {
    //            print(error)
    //        }
    //
    //
    //        // define the recorder setting
    //
    //        let recorderSettings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey : 44100.0, AVNumberOfChannelsKey : 2 as NSNumber]
    //
    //        // initiate and prepare the recorder
    //        do {
    //            audioRecorder  = try AVAudioRecorder(URL: audioFileURL, settings: recorderSettings)
    //            audioRecorder?.delegate = self
    //            audioRecorder?.meteringEnabled = true
    //            audioRecorder?.prepareToRecord()
    //        } catch let error {
    //            print(error)
    //        }
    //    }
    //
    //    func play()
    //    {
    //        if let player = audioPlayer {
    //            if player.playing {
    //                player.stop()
    //                return
    //            }
    //        }
    //
    //        if let recorder = audioRecorder {
    //            if !recorder.recording {
    //                do {
    //                    audioPlayer = try AVAudioPlayer(contentsOfURL: recorder.url)
    //                    audioPlayer?.delegate = self
    //                    audioPlayer?.play()
    //
    //                    // change the play button. enable it and change the image
    //
    //
    //                    // disable the cancel button image view
    //                } catch let error {
    //                    print(error)
    //                }
    //            }
    //        }
    //
    //
    //    }
    //
    //    func cancel()
    //    {
    //        // stop the audio recorder
    //        audioRecorder?.stop()
    //
    //        // deactivate the audio session
    //        do {
    //            try AVAudioSession.sharedInstance().setActive(false)
    //        } catch let error {
    //            print(error)
    //        }
    //    }
    //
    //    func record()
    //    {
    //        // stop the audio player before recording
    //        if let player = audioPlayer {
    //            if player.playing {
    //                player.stop()
    //
    //            }
    //        }
    //
    //        // if we are not recording the start recording!
    //        if let recorder = audioRecorder {
    //            if !recorder.recording {
    //                do {
    //                    let audioSession = AVAudioSession.sharedInstance()
    //                    try audioSession.setActive(true)    // make the recorder work
    //
    //                    // start recording
    //                    recorder.record()
    //
    //                } catch let error {
    //                    print(error)
    //                }
    //            } else {
    //                // pause the recording
    //                recorder.pause()
    //            }
    //        }
    //
    //
    //    }
    //
    // MARK: - Helper method
    
    // this just presents an alert view with the given title and message (msg)
    //    func alert(title: String, msg: String)
    //    {
    //        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
    //        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    //        self.presentViewController(alertController, animated: true, completion: nil)
    //    }
    //
    //}
    
    // MARK: - AVAudioRecorderDelegate
    
    //extension MediaPlayerVC2 : AVAudioRecorderDelegate
    //{
    //    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    //        if flag {
    //            self.alert("Congratulations!", msg: "Successfully recorded the audio")
    //        }
    //    }
    //}
    
    
    // MARK: - AVAudioPlayerDelegate
    
    //extension MediaPlayerVC2 : AVAudioPlayerDelegate
    //{
    //    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    //    {
    //        if flag {
    //            self.alert("Try out GetWell Pro", msg: "To save your affirmations!")
    //
    //        }
    //    }
    //
    //    @IBAction func recordTapped(sender: UIButton)
    //    {
    //        record()
    //        recordingLabel.hidden = false
    //
    //    }
    //
    //    @IBAction func cancelTapped(sender: UIButton)
    //    {
    //        cancel()
    //        recordingLabel.hidden = true
    //
    //    }
    //
    //    @IBAction func playTapped(sender: UIButton)
    //    {
    //        play()
    //    }
    //
    
    
}
