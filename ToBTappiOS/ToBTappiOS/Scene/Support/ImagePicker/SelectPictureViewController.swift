//
//  SelectPictureViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/10.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import Photos
import TOCropViewController
import PKHUD

//import WXImageCompress

class SelectPictureViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TOCropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let pickerModel = ImagePickerModel.init()
    var collection: PHFetchResult<PHAsset>? = nil
   
    @IBOutlet weak var collectionView: UICollectionView!

    //设置Uploader用于调用不同的上传请求
   
    
    var _uploader: Uploader?
    var uploader: Uploader? {
        set {
            _uploader = newValue
            _uploader?.rx_sucess.asObservable().filter {
                        $0 != nil
                    }
                    .subscribe(onNext: { [weak self] success in
                        HUD.hide()
                        if success! && self != nil {
                            self?.navigationController?.setNavigationBarHidden(false, animated: true)
                            self?.navigationController?.popToViewController(self!.topViewController!, animated: true)
                        }

                    }).disposed(by: rx.disposeBag)
        }
        get {
            return _uploader
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
 
     
        
        pickerModel.rx_collection.asDriver().drive(onNext: { [weak self] model in
            self?.collection = model?.fetchResult
            self?.collectionView.reloadData()
        }).disposed(by: rx.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let number = collection?.count {
            return number + 1
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.selectPictureCameraCell.identifier, for: indexPath)
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.selectPicturePhotoCell, for: indexPath)!
            if let asset = collection?[indexPath.item - 1] {
                        pickerModel.imageManager?.requestImage(for: asset, targetSize: CGSize.init(width: 80 * UIScreen.main.scale, height: 80 * UIScreen.main.scale),
                                contentMode: .aspectFill, options: nil) {
                            (image, nfo) in
                            cell.imageView.image = image
                        }
                
                
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击相机动作
        if indexPath.item == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController: UIImagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = false//true为拍照、选择完进入图片编辑模式
                imagePickerController.delegate = self
                imagePickerController.videoQuality = .typeMedium
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: {
                })
            }
        }
        //点击相片动作
        else if let asset = collection?[indexPath.item - 1] {
            let option = PHImageRequestOptions.init()
            option.isSynchronous = true
            option.isNetworkAccessAllowed = true;

            pickerModel.imageManager?.requestImage(for: asset,
                    targetSize: CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight),
                    contentMode: .aspectFill,
                    options: option) {
                (image, nfo) in
                let cropVc = TOCropViewController.init(croppingStyle: TOCropViewCroppingStyle.circular, image: image!)
                cropVc.setAspectRatioPresent(TOCropViewControllerAspectRatioPreset.presetSquare, animated: true)
                self.navigationController?.pushViewController(cropVc, animated: true)
                cropVc.onDidCropToCircleImage = { [weak self] image, _, _ in
                    self?.uploader?.upload(image: image)
                    
                    HUD.show(.progress)
                }

            }
        }

    }

    //相机照相成功的回掉
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: false) {
            let image = info[UIImagePickerControllerOriginalImage]
            let cropVc = TOCropViewController.init(croppingStyle: TOCropViewCroppingStyle.circular, image: image as! UIImage)
            cropVc.setAspectRatioPresent(TOCropViewControllerAspectRatioPreset.presetSquare, animated: true)
            self.navigationController?.pushViewController(cropVc, animated: true)
            cropVc.onDidCropToCircleImage = { image, _, _ in
                self.uploader?.upload(image: image)
                HUD.show(.progress)
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addNewLockIntroduceSegue = R.segue.selectPictureViewController.photoAlbumSegue(segue: segue) {
            addNewLockIntroduceSegue.destination.pickerModel = self.pickerModel
        }
    }
}
