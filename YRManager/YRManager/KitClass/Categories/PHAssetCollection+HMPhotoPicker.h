//
//  PHAssetCollection+HMPhotoPicker.h
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/7.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAssetCollection (HMPhotoPicker)

+ (PHAssetCollectionType)assetPickerAssetCollectionTypeOfSubtype:(PHAssetCollectionSubtype)subtype;

- (NSUInteger)assetPikcerCountOfAssetsFetchedWithOptions:(PHFetchOptions *)fetchOptions;

@end
