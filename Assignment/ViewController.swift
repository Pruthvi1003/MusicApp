//
//  ViewController.swift
//  Assignment
//
//  Created by Pruthvi  on 12/03/18.
//  Copyright © 2018 Pruthvi . All rights reserved.
//

import UIKit
import MediaPlayer

struct searchItem{
    var name : String!
    var number : Int!
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var musicLibTable: UITableView!
     var musicPlayerItems = [MPMediaItem]()
    
     var searchResultArray = [searchItem]()
     var songtitleArray = [String]()
     var isSearchResult = false
   
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkForLibraryAuth()
    
    }
    
    
    
    func checkForLibraryAuth() {
        
        let status = MPMediaLibrary.authorizationStatus()
        switch  status {
        case .authorized:
           loadAMusicLib()
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.loadAMusicLib()
                    }
                }
            }
        case .restricted:
            
            break
        case .denied:
            
            break
        }
    }
    
    func loadAMusicLib(){
        musicPlayerItems = MPMediaQuery.songs().items!
        if musicPlayerItems.count != 0 {
        for item in musicPlayerItems{
            
            songtitleArray.append(item.title!)
        }
        }
        musicLibTable.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchResultArray.removeAll(keepingCapacity: true)
        let searchingText = searchBar.text
        for name : String in songtitleArray {
            if (name as NSString).contains(searchingText!){
                //finds the index of an object in menuArray
                let indexofItem = songtitleArray.index(of: name)!
                isSearchResult = true
                searchResultArray.append(searchItem(name: name, number: indexofItem))
            }
        }
        if searchResultArray.isEmpty {
            let alert = UIAlertController(title: "\(String(describing: searchingText)) is not found", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            searchBar.text = ""
        }
        musicLibTable.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.text = ""
        searchResultArray.removeAll(keepingCapacity: true)
        isSearchResult = false
        musicLibTable.reloadData()
        searchBar.showsCancelButton = false
        let val = true
        searchBar.endEditing(val)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        searchResultArray.removeAll(keepingCapacity: true)
        isSearchResult = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if isSearchResult == true {
           return searchResultArray.count
        }else {
            return musicPlayerItems.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell : UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.textColor = UIColor.brown
        cell.textLabel?.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 35.0)
        cell.backgroundColor = musicLibTable.backgroundColor
        if isSearchResult == true {
            cell.textLabel?.text = searchResultArray[indexPath.row].name
        }else {
            cell.textLabel?.text = songtitleArray[indexPath.row]
            
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
       
       // let moveToPlayView : PlayMusic = self.storyboard?.instantiateViewController(withIdentifier: "playView") as! PlayMusic
        
        let theTitle = songtitleArray[indexPath.row]
        print("items is \(theTitle)")
        //moveToPlayView.theLabel.text = theTitle
        if isSearchResult == true {
            let indexIs = searchResultArray[indexPath.row].number
            let songIS = musicPlayerItems.remove(at: indexIs!)
            musicPlayerItems.insert(songIS, at: 0)
            
        }else {
            let songSelected = musicPlayerItems.remove(at: indexPath.row)
            musicPlayerItems.insert(songSelected, at: 0)
        }
        performSegue(withIdentifier: "pushToPlay", sender: self)
        //self.navigationController?.pushViewController(moveToPlayView, animated: true)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "pushToPlay"{
            
            let moveToPlayView = segue.destination as! PlayMusic
            moveToPlayView.mediaItems = musicPlayerItems
            
            
        }
    }

}

