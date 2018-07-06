//
//  FingerLockDetailController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class FingerLockDetailController: UIViewController {

    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var bgview: UIView!
    
    let data = ["Thumb","Middle","Thumb","Thumb","Middle","Thumb"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgview.layer.shadowColor = UIColor.shadowColor.cgColor
        self.bgview.layer.shadowOffset = CGSize(width: 4, height: 7)
        self.bgview.layer.shadowOpacity = 0.7
        self.bgview.layer.shadowRadius = 5
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 84)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        
        self.collectView.collectionViewLayout = layout
        self.collectView.delegate = self
        self.collectView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FingerLockDetailController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.fingerprintListCollectCell.identifier, for: indexPath) as! FingerPrintListCollectionCell
        cell.tagLab.text = data[indexPath.row]
        return cell
    }
}
