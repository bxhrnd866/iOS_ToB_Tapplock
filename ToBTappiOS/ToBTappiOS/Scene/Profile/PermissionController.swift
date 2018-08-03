//
//  PermissionController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/20.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class PermissionController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: mScreenW/2 - 20,height:25)
//        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension PermissionController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ConfigModel.default.user.value?.permissions != nil ? (ConfigModel.default.user.value?.permissions?.count)! : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.permissionCell.identifier, for: indexPath) as! PermissionCollectionCell
        let model = ConfigModel.default.user.value?.permissions![indexPath.row]
        cell.taglab.text = model?.permissionName
        
        return cell
    }
}
