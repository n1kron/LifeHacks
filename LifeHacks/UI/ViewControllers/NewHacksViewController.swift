//
//  NewHacksViewController.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 12.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class NewHacksViewController: UIViewController {
    @IBOutlet weak var lifeHacksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LifeHacksData.shared.newList.shuffle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLifeHack" {
            if let nextViewController = segue.destination as? DetailHackViewController {
                if let id = sender as? String {
                    nextViewController.currentId = id
                }
            }
        }
    }
}


extension NewHacksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LifeHacksData.shared.newList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HackTableViewCell", for: indexPath) as! HackTableViewCell
        if let content = LifeHacksData.shared.lifeHacksList.first(where: {$0.id == LifeHacksData.shared.newList[indexPath.row]}) {
            cell.titleLabel.text = content.title
            cell.hackImageView.kf.setImage(with: URL(string: content.image), completionHandler: { (image, error, cacheType, imageUrl) in
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if SubscriptionManager.shared.isSubscriptionActive != true {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            self.present(storyboard.instantiateViewController(withIdentifier: "BuySubscriptionController"), animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "ShowLifeHack", sender: LifeHacksData.shared.newList[indexPath.row])
        }
    }
}
