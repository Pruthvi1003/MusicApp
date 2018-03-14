//
//  PlayMusic.swift
//  Assignment
//
//  Created by Pruthvi  on 12/03/18.
//  Copyright © 2018 Pruthvi . All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation


class PlayMusic : UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    //let player = MPMusicPlayerController.systemMusicPlayer
    let anAVPlayer = AVPlayer()
    var mediaItems = [MPMediaItem]()
    var urlArray = [URL]()
    var anAvPlayerItemArray = [AVPlayerItem]()
    //var anAVPlayerQueue = AVQueuePlayer()
    var currentTrack = 0
    var songName = [String]()
    
    @IBOutlet weak var theLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //audio to play in background
        playAudioInBackground()
        
        //getting acess from control centere and lock screen
        toGetControlFromLocakScreen()
        
        //creating an AVplayerItems
        createAVQueuePlayer()
        
        theLabel.text = songName[currentTrack]
        theLabel.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 35.0)
        theLabel.textColor = UIColor.brown
        self.view.backgroundColor = UIColor.yellow
        
        playPauseButton.setTitle("Pause", for: .normal)
        
    }
    
    func createAVQueuePlayer() {
        
        for anItem in mediaItems {
            urlArray.append(anItem.assetURL!)
            
        }
        for anItem in urlArray{
            
            anAvPlayerItemArray.append(AVPlayerItem(url: anItem))
        }
        //anAVPlayerQueue = AVQueuePlayer(items: anAvPlayerItemArray)
        
         playTrack()
    }
    
    func playTrack() {
        
        if anAvPlayerItemArray.count > 0 {
            anAVPlayer.replaceCurrentItem(with: anAvPlayerItemArray[currentTrack])
            anAVPlayer.play()
        }
    }
    
    func toGetControlFromLocakScreen(){
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            //call the playMusic func
            self.playTheMusic(self.playPauseButton)
            return .success
        }
        
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            
            self.playTheMusic(self.playPauseButton)
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget{(event) -> MPRemoteCommandHandlerStatus in
            
            self.nextSong(event)
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget{(event)-> MPRemoteCommandHandlerStatus in
           
            self.prevSong(event)
            return .success
        }
        
    }
    
    func playAudioInBackground(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
           
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    @IBAction func playTheMusic(_ sender: Any) {
        
       let isAudioPlaying = anAVPlayer.timeControlStatus
        if isAudioPlaying == AVPlayerTimeControlStatus.playing{
            anAVPlayer.pause()
            //print("player going to be paused")
            playPauseButton.setTitle("Play", for: .normal)
            
        }else{
            //print("player going to be played")
            playTrack()
            playPauseButton.setTitle("Pause", for: .normal)
            
        }
        
    }
    
    
    @IBAction func nextSong(_ sender: Any) {
        
        //func to play next music
        if currentTrack + 1 > anAvPlayerItemArray.count {
            currentTrack = 0
        } else {
            currentTrack += 1;
        }
        
        playTrack()
        theLabel.text = songName[currentTrack]
    }
    
    
    @IBAction func prevSong(_ sender: Any) {
        
        //func to play prev music
        if currentTrack - 1 < 0 {
            currentTrack = (anAvPlayerItemArray.count - 1) < 0 ? 0 : (anAvPlayerItemArray.count - 1)
        } else {
            currentTrack -= 1
        }
        
        playTrack()
        theLabel.text = songName[currentTrack]
    }
    
   
}
