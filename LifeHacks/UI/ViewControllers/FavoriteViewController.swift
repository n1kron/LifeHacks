//
//  FavoriteViewController.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var goldCollectionView: UICollectionView!
    @IBOutlet weak var silverCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == goldCollectionView {
            return Consts.goldPlace.all.count
        }
        return Consts.silverPlace.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == goldCollectionView {
            let content = LifeHacksData.shared.lifeHacksList.first(where: {$0.id == Consts.goldPlace.all[indexPath.row]})
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldCollectionViewCell", for: indexPath) as! GoldCollectionViewCell
            cell.titleLabel.text = content?.title
            cell.hackImageView.kf.setImage(with: URL(string: (content?.image)!), completionHandler: { (image, error, cacheType, imageUrl) in
            })
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SilverCollectionViewCell", for: indexPath) as! SilverCollectionViewCell
            if let content = LifeHacksData.shared.lifeHacksList.first(where: {$0.id == Consts.silverPlace.all[indexPath.row]}) {
                cell.titleLabel.text = content.title
                cell.hackImageView.kf.setImage(with: URL(string: content.image), completionHandler: { (image, error, cacheType, imageUrl) in
                })
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == goldCollectionView {
            return CGSize(width: UIScreen.main.bounds.size.width / 1.2, height: UIScreen.main.bounds.size.height/3)
        }
        return CGSize(width: UIScreen.main.bounds.size.width / 2.5, height: UIScreen.main.bounds.size.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if SubscriptionManager.shared.isSubscriptionActive != true {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            self.present(storyboard.instantiateViewController(withIdentifier: "BuySubscriptionController"), animated: true, completion: nil)
        } else {
            if collectionView == goldCollectionView {
                performSegue(withIdentifier: "ShowLifeHack", sender: Consts.goldPlace.all[indexPath.row])
            }
            performSegue(withIdentifier: "ShowLifeHack", sender: Consts.silverPlace.all[indexPath.row])
        }
    }
}
