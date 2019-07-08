//
//  ViewController.swift
//  LiveMatch
//
//  Created by ema on 24.06.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
import SDWebImage
import LeagueAPI

class ViewController: UIViewController, UISearchBarDelegate {
    var summoner: Summoner?
    var gameInfo: GameInfo?
    var progressHUD: ProgressHUD?
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.isUserInteractionEnabled = false
        searchBar.autocapitalizationType = .none
        
        progressHUD = ProgressHUD(text: "fetching data")
        self.view.addSubview(progressHUD!)
        ApiCalls.getChampions(viewController: self)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("test")
        ApiCalls.getLiveMatch(summonerName: searchBar.text!, viewController: self)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 16
    }    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gdvc = segue.destination as? GameDataViewController {
            gdvc.gameInfo = gameInfo
        }
        if let spvc = segue.destination as? SummonerProfileViewController {
            spvc.summoner = summoner
        }
    }
}
