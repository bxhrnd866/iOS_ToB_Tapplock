//
//  YourGroupController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/20.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension YourGroupController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectCell", for: indexPath) as! GroupCollectionViewCell
        cell.tagLab.text = data[indexPath.row]
        return cell
    }
    
    //设定指定Cell的尺寸
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = data[indexPath.row]
        let size = text.boundingRect(with: CGSize(width: mScreenW - 40, height: 40), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil).size
        
        return CGSize(width: size.width + 30, height: 40)
    }
    
    
}
