//
//  TotalViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import UIKit
import Kingfisher

class TotalViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = ProfileViewModel()
    var cellSize: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetting()
    }

    func collectionViewSetting() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        self.collectionView.backgroundColor = UIColor.white
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
