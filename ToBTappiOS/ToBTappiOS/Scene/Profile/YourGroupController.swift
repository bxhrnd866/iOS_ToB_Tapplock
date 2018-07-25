//
//  YourGroupController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/20.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class YourGroupController: UIViewController {

    let data = ["xfasxx","ggg","asdfax sfasdfas","xfaqhreheh","Soft xfaqhreheh","xfaqhreheh ware","Soft xfaqhreheh","Soft xfaqhreheh ware"]
    
   
    
    
    @IBOutlet weak var collectView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80,height: 35)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 20

        
        self.collectView.collectionViewLayout = layout
        self.collectView.delegate = self
        self.collectView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension YourGroupController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (ConfigModel.default.user.value?.rx_groups.value.count)!
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectCell", for: indexPath) as! GroupCollectionViewCell
        cell.tagLab.text = data[indexPath.row]
        
//        let model = ConfigModel.default.user.value?.rx_groups.value[indexPath.row]
//        cell.tagLab.text = model?.groupName
        return cell
    }
    
    //设定指定Cell的尺寸
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = data[indexPath.row]
//        let model = ConfigModel.default.user.value?.rx_groups.value[indexPath.row]
//        let text = model?.groupName ?? "xxxx"
        
        let size = text.boundingRect(with: CGSize(width: mScreenW - 40, height: 40), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil).size
        
        return CGSize(width: size.width + 30, height: 40)
    }
    
    
}
