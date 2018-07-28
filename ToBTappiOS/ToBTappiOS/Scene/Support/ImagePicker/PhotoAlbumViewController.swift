//
//  PhotoAlbumViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/10.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import Photos

//相册列表页面
class PhotoAlbumViewController: UIViewController {
    var pickerModel: ImagePickerModel? = nil

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerModel?.rx_collections.asDriver()
                .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.photoAlbumCell.identifier,
                        cellType: ImagePickerTableViewCell.self)) { (indexPath, model, cell) in
                    cell.label?.text = model.title
                    PHCachingImageManager().requestImage(for: model.fetchResult.firstObject!, targetSize: CGSize.init(width: 50 * UIScreen.main.scale, height: 50 * UIScreen.main.scale),
                            contentMode: .aspectFill, options: nil) {
                        (image, nfo) in
                        cell.previewImageView?.image = image
                    }
                }
                .disposed(by: rx.disposeBag)

        tableView.rx.modelSelected(ImageAlbumItem.self)
                .subscribe(onNext: { [weak self] model in
                    self?.pickerModel?.rx_collection.value = model
                    self?.navigationController?.popViewController(animated: true)
                    print(model)
                })
                .disposed(by: rx.disposeBag)
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
