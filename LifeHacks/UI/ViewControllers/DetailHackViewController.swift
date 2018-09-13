//
//  DetailHackViewController.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit
import Kingfisher

class DetailHackViewController: UIViewController {
    @IBOutlet weak var detailLifeHacksTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var currentId: String = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(Notification.Name("steps"))
        let cache = KingfisherManager.shared.cache
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.cleanExpiredDiskCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailLifeHacksTableView.isHidden = true
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Utiles.delay(time: 1.0, action: { [weak self] in
            self?.detailLifeHacksTableView.reloadData()
            self?.detailLifeHacksTableView.isHidden = false
            self?.activityIndicator.stopAnimating()
        })
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
        cell.removeImages()
        let content = LifeHackDetailData.shared.lifeHacksSteps[indexPath.row]
        cell.titleLabel.text = content.text
        
        for image in content.images {
            cell.addImage(image: image)
        }
        
        return cell
    }
}
