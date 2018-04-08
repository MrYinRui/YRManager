//
//  \\      //     ||          ||     ||\        ||
//   \\    //      ||          ||     ||\\       ||
//    \\  //       ||          ||     || \\      ||
//     \\//        ||          ||     ||  \\     ||
//      /\         ||          ||     ||   \\    ||
//     //\\        ||          ||     ||    \\   ||
//    //  \\       ||          ||     ||     \\  ||
//   //    \\      ||          ||     ||      \\ ||
//  //      \\      \\        //      ||       \\||
// //        \\      \\======//       ||        \||
//
//
//  INVSBleManager.h
//  HotelManager-Pad
//
//  Created by xun on 16/12/9.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <INVSSDK/INVSSDK.h>

@protocol INVSBleManagerDelegate <NSObject>
/**
 开始扫描
 */
- (void)beginDiscover;

/**
 没有查找到设备，停止扫描
 */
- (void)stopDiscover;

/**
 扫描到设备
 
 @param peripherals 设备容器
 */
//- (void)discoverPeripherals:(NSArray *)peripherals;


/**
 读取信息完毕回调
 
 @param success  是否成功读取
 @param readInfo 返回结果
 */
- (void)readInfoSuccess:(BOOL)success info:(NSDictionary *)readInfo;


/**
 连接设备完毕回调
 
 @param peripheral 外围设备
 @param success    是否成功
 */
//- (void)connectedPeripheral:(CBPeripheral *)peripheral success:(BOOL)success;

@end

/**
 蓝牙连接设备逻辑
 1.检测蓝牙设备状态，如果蓝牙有开启，则开始扫描蓝牙设备
 2.开始扫描，如果有扫描到peripheral，则立马连接peripheral
 （若连接失败，该periphreal放置在不可用数组中，下次扫描到该peripheral，忽略）
 3.连接成功后，以3s/次连接频率读取设备上信息，读取成功后，断开连接，释放读取信息定时器
 */

@interface INVSBleManager : NSObject

//@property (nonatomic, strong) INVSBleTool *bleTool;
//@property (nonatomic, strong) CBCentral *central;
//@property (nonatomic, strong) CBCentralManager *cManager;
//@property (nonatomic, strong) CBPeripheral *peripheral;
//@property (nonatomic, assign) id <INVSBleManagerDelegate> delegate;
//
///// 上一次连接设备
//@property (nonatomic, strong) CBPeripheral *lastPeripheral;

/**
 初始化蓝牙管理器（单例）
 
 @return 蓝牙管理器
 */
+ (instancetype)manager;
+ (instancetype)managerWithDelegate:(id <INVSBleManagerDelegate>)delegate;
- (instancetype)init NS_UNAVAILABLE;


/**
 连接外围设备
 
 @param peripheral 外围设备
 */
//- (void)connectPeripheral:(CBPeripheral *)peripheral;

/**
 根据外围设备的特征去连接
 
 @param characteristic 特征（设备名、设备mac地址）
 */
- (void)connectPeripheralWithCharacteristic:(NSString *)characteristic;

/**
 查找外围设备
 
 @param limited 查找时间限制
 */
- (void)discoverPeripheralWithTimeLimited:(NSInteger)limited;
- (void)discoverPeripheral;

- (void)disconnect;

@end
