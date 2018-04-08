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
//  INVSBleManager.m
//  HotelManager-Pad
//
//  Created by xun on 16/12/9.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "INVSBleManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Alert.h"
#import "UIApplication+LPOpenURL.h"

typedef enum {
    
    CONNECT_FAILED,
    DISCONNECT
} UnconnectReason;

@interface INVSBleManager () </*BR_Callback,*/ CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) NSMutableArray *peripheralArr;
@property (nonatomic, strong) NSMutableArray *unavaliableArr;   //!<不可用设备
@property (nonatomic, strong) NSTimer *readTimer;

@end

@implementation INVSBleManager
{
    UnconnectReason unconnectReason;
    BOOL isConnect;
}

+ (instancetype)manager
{
    return [INVSBleManager managerWithDelegate:nil];
}

+ (instancetype)managerWithDelegate:(id<INVSBleManagerDelegate>)delegate
{
    static INVSBleManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [INVSBleManager new];
//        manager.cManager = [[CBCentralManager alloc] initWithDelegate:manager queue:nil];
//        manager.bleTool = [[INVSBleTool alloc] init:manager];
    });
    
//    manager.delegate = delegate;
    
    return manager;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBManagerStatePoweredOn:
            
            [self discoverPeripheral];
            break;
            
        case CBManagerStateUnauthorized:
            /*
            [Alert alertWithTitle:@"提示" msg:@"住客通尚未获取蓝牙权限，是否立马设置" action:xun_action(@"取消", nil) action:xun_action(@"开启", ^{
                
                [UIApplication openURL:UIApplicationOpenSettingsURLString];
            })];*/
            
            [Alert alertWithTitle:@"" msg:@"" action:xun_action(@"取消", nil) action:xun_action(@"开启",^(UIAlertAction *action){
                
                [UIApplication openURL:UIApplicationOpenSettingsURLString];
            })];
            break;

        case CBManagerStatePoweredOff:
            [Alert alertWithMsg:@"蓝牙设备未开启"];
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![peripheral.name hasPrefix:@"INVS300"])
    {
        return;
    }
    
//    if (!_lastPeripheral ||
//        _lastPeripheral != peripheral)
//    {
//        _peripheral = peripheral;
//        [self connectPeripheral:peripheral];
//        [_cManager stopScan];
//    }
}

#pragma mark - BR_Callback

- (void)BR_connectResult:(BOOL)isconnected
{
    isConnect = isconnected;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (isconnected)
        {
            self.readTimer.fireDate = [NSDate distantPast];
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
        else
        {
            [self.readTimer invalidate];
            self.readTimer = nil;
        }
    });
    
    @try
    {
//        if ([_delegate respondsToSelector:@selector(connectedPeripheral:success:)])
//        {
//            [_delegate connectedPeripheral:_peripheral success:isconnected];
//        }
    } @catch (NSException *exception) {
    } @finally {
    }
}

#pragma mark - Interface Method

- (void)discoverPeripheral
{
    [self discoverPeripheralWithTimeLimited:30];
}

- (void)discoverPeripheralWithTimeLimited:(NSInteger)limited
{
//    if (_cManager.isScanning) return;
//    
//    _peripheral = nil;
//    
//    [_cManager scanForPeripheralsWithServices:nil options:nil];
//    
//    if ([_delegate respondsToSelector:@selector(beginDiscover)])
//    {
//        @try {
//            
//            [_delegate beginDiscover];
//            
//        } @catch (NSException *exception) {
//            
//        } @finally {
//        }
//    }
    
    [self performSelector:@selector(endDiscover) withObject:nil afterDelay:limited];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    dispatch_queue_t queue = dispatch_queue_create("com.invs", nil);
    dispatch_async(queue, ^{
        
//        _peripheral = peripheral;
//        [_bleTool connectBt:peripheral];
        unconnectReason = CONNECT_FAILED;
    });
    
}

- (void)connectPeripheralWithCharacteristic:(NSString *)characteristic
{
//    for (CBPeripheral *peripheral in self.peripheralArr)
//    {
        /*if ([_peripheral.name isEqualToString:characteristic])
        {
            dispatch_queue_t queue = dispatch_queue_create("com.invs", nil);
            dispatch_async(queue, ^{
                
//                _peripheral = peripheral;
                [_bleTool connectBt:_peripheral];
            });
//            break;
        }*/
//    }
}

- (void)disconnect
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
//        [_bleTool disconnectBt];
        isConnect = NO;
        unconnectReason = DISCONNECT;
    });
}

- (void)endDiscover
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
//        [_cManager stopScan];
//        if ([_delegate respondsToSelector:@selector(stopDiscover)])
//        {
//            [_delegate stopDiscover];
//        }
    });
}

#pragma mark - Private Method

- (void)readCardInfo
{
    dispatch_queue_t queue = dispatch_queue_create("com.invs", nil);
    
    dispatch_async(queue, ^{
        
//        NSDictionary *dict = [_bleTool readCard];
//        
//        if ([_delegate respondsToSelector:@selector(readInfoSuccess:info:)])
//        {
//            if ([dict[@"resultFlag"] intValue] == -1)
//            {
//                [_delegate readInfoSuccess:NO info:nil];
//            }
//            else
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                   
//                    [self.readTimer invalidate];
//                    self.readTimer = nil;
//                });
//                [_delegate readInfoSuccess:YES info:dict];
//            }
//        }
    });
}

#pragma mark - lazy init

- (NSMutableArray *)peripheralArr
{
    if (! _peripheralArr)
    {
        _peripheralArr = [NSMutableArray new];
    }
    return _peripheralArr;
}

- (NSMutableArray *)unavaliableArr
{
    if(! _unavaliableArr)
    {
        _unavaliableArr = [NSMutableArray new];
    }
    return _unavaliableArr;
}

- (NSTimer *)readTimer
{
    if (! _readTimer)
    {
        _readTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(readCardInfo) userInfo:nil repeats:YES];
    }
    return _readTimer;
}

- (void)dealloc
{
    
}

@end
