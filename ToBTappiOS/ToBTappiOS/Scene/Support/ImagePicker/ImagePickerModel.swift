//
//  ImagePickerViewModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/10.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import Photos
import RxSwift

struct ImageAlbumItem {
    //相簿名称
    var title: String?
    //相簿内的资源
    var fetchResult: PHFetchResult<PHAsset>

}


class ImagePickerModel: NSObject {


    public var rx_collections = Variable(Array<ImageAlbumItem>())
    public var rx_collection: Variable<ImageAlbumItem?> = Variable(nil)

    public var imageManager: PHCachingImageManager?
    
    override init() {
        super.init()
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0, execute: {
            self.loadCollections()

        })
    }
    
    //加载PHAssetCollection 参考PHAsset
    private func loadCollections() {
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in

            if status != .authorized {
                return
            }
            self.imageManager = PHCachingImageManager()
        
            let smartOptions = PHFetchOptions()
            let smartCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                    subtype: .albumRegular,
                    options: smartOptions)
            self.convertCollection(collection: smartCollections)

            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)

        }


    }
    //加载相册  参考PHAsset
    private func convertCollection(collection: PHFetchResult<PHAssetCollection>) {
        for i in 0..<collection.count {
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                    ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                    PHAssetMediaType.image.rawValue)
            let c = collection[i]

            if c.isKind(of: PHAssetCollection.self){
                let assetsFetchResult = PHAsset.fetchAssets(in: c, options: resultsOptions)
                //没有图片的空相簿不显示
                
                if assetsFetchResult.count > 0 {
                    rx_collections.value.append(ImageAlbumItem(title: c.localizedTitle,
                                                               fetchResult: assetsFetchResult))
                    if self.rx_collection.value == nil {
                        self.rx_collection.value = ImageAlbumItem(title: c.localizedTitle,
                                                                  fetchResult: assetsFetchResult)
                        
                    }
                    
                }
            }
        }
    }


}
