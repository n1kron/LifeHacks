//
//  CalendarViewController.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit
import Kingfisher

class CalendarViewController: UIViewController {
    @IBOutlet weak var lifeHacksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LifeHacksData.shared.getData()
        NotificationCenter.default.addObserver(forName: Notification.Name("hacks"), object: nil, queue: nil) { [weak self] (notification) in
            self?.lifeHacksTableView.reloadData()
        }
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


extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LifeHacksData.shared.lifeHacksList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HackTableViewCell", for: indexPath) as! HackTableViewCell
        let content = LifeHacksData.shared.lifeHacksList[indexPath.row]
        cell.titleLabel.text = content.title
        cell.hackImageView.kf.setImage(with: URL(string: content.image), completionHandler: { (image, error, cacheType, imageUrl) in
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(LifeHacksData.shared.lifeHacksList[indexPath.row].id)
        performSegue(withIdentifier: "ShowLifeHack", sender: LifeHacksData.shared.lifeHacksList[indexPath.row].id)
    }
}
