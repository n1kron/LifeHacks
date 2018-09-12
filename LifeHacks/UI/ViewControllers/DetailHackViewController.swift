//
//  DetailHackViewController.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class DetailHackViewController: UIViewController {
    @IBOutlet weak var detailLifeHacksTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var currentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LifeHackDetailData.shared.getData(id: currentId)
        detailLifeHacksTableView.rowHeight = UITableViewAutomaticDimension
        detailLifeHacksTableView.estimatedRowHeight = 80
        navBar.topItem?.title = currentId
        NotificationCenter.default.addObserver(forName: Notification.Name("steps"), object: nil, queue: nil) { [weak self] (notification) in
            self?.detailLifeHacksTableView.reloadData()
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailHackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LifeHackDetailData.shared.lifeHacksSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHackTableViewCell", for: indexPath) as! DetailHackTableViewCell
        let content = LifeHackDetailData.shared.lifeHacksSteps[indexPath.row]
        cell.titleLabel.text = content.text
        if let image = content.images.first {
            cell.hackImageView.kf.setImage(with: URL(string: image), completionHandler: { (image, error, cacheType, imageUrl) in
            })
        }
        return cell
    }
}
