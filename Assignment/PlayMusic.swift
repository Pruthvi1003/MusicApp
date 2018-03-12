//
//  PlayMusic.swift
//  Assignment
//
//  Created by Pruthvi  on 12/03/18.
//  Copyright © 2018 Pruthvi . All rights reserved.
//

import UIKit
import MediaPlayer


class PlayMusic : UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    let player = MPMusicPlayerController.systemMusicPlayer
    var mediaItems = [MPMediaItem]()
    
    @IBOutlet weak var theLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.backItem?.backBarButtonItem
        // Do any additional setup after loading the view, typically from a nib.
        //checkForLibraryAuth()
        let mediaCollection = MPMediaItemCollection(items: mediaItems)
        print("the media count is \(mediaCollection.count)")
        player.setQueue(with: mediaCollection)
        //let query = MPMediaQuery(
        player.prepareToPlay()
        player.play()
        theLabel.text = player.nowPlayingItem?.title!
        theLabel.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 35.0)
        theLabel.textColor = UIColor.brown
        self.view.backgroundColor = UIColor.yellow
        
        playPauseButton.setTitle("Pause", for: .normal)
        
    }
    
    
    
    @IBAction func playTheMusic(_ sender: Any) {
        let isPlaying = player.playbackState
        if isPlaying == MPMusicPlaybackState.playing{
            print("player going to be paused")
            player.pause()
            //playPauseButton.titleLabel?.text = "Play"
           playPauseButton.setTitle("Play", for: .normal)
            
        }else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func pauseTheMusic(_ sender: Any) {
        
        //func to pause music
        let isPlaying = player.playbackState
        if isPlaying == MPMusicPlaybackState.playing{
            print("player going to be paused")
            player.pause()
        }
    }
    
    
    @IBAction func nextSong(_ sender: Any) {
        
        //func to play next music
        print("plays the next song")
        player.skipToNextItem()
        theLabel.text = player.nowPlayingItem?.title
    }
    
    
    @IBAction func prevSong(_ sender: Any) {
        
        //func to play prev music
        print("plays the prev song")
        player.skipToPreviousItem()
        theLabel.text = player.nowPlayingItem?.albumTitle
    }
}
