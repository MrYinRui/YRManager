//
//  PHAssetCollection+HMPhotoPicker.m
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/7.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "PHAssetCollection+HMPhotoPicker.h"

@implementation PHAssetCollection (HMPhotoPicker)

+ (PHAssetCollectionType)assetPickerAssetCollectionTypeOfSubtype:(PHAssetCollectionSubtype)subtype
{
    return (subtype >= PHAssetCollectionSubtypeSmartAlbumGeneric) ? PHAssetCollectionTypeSmartAlbum : PHAssetCollectionTypeAlbum;
}

- (NSUInteger)assetPikcerCountOfAssetsFetchedWithOptions:(PHFetchOptions *)fetchOptions
{
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self options:fetchOptions];
    return result.count;
}

@end
