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
///Controller vor the SearchView
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
    /**
     searchBar click event which calls getLiveMatch from ApiCalls
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ApiCalls.getLiveMatch(summonerName: searchBar.text!, viewController: self)
    }
    /**
        Limits the searchBar charachter count to 16
        because a summoner name has only 16 characters
     */
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 16
    }
    /**
     setting uo the data for the segeus
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gdvc = segue.destination as? GameDataViewController {
            gdvc.gameInfo = gameInfo
        }
        if let spvc = segue.destination as? SummonerProfileViewController {
            spvc.summoner = summoner
        }
    }
    /**
     reloading the ViewController
     */
    func restartApplication () {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
        let navCtrl = UINavigationController(rootViewController: viewController)
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
            else {
                return
        }
        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
    }
    /**
     Shows an alert with the reload action
     */
    func showAlert(errorMsg: String) {
        let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.restartApplication()
            }
        }))
        DispatchQueue.main.async {
            self.present( alert, animated: true, completion: nil)
        }
    }
}
extension UIViewController {
    /**
     creating a toast
     
     - Parameters:
        - controller: viewController to be displayed
        - message: message of the toast
        - seconds: duration of the toast
     */
    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.gray
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
