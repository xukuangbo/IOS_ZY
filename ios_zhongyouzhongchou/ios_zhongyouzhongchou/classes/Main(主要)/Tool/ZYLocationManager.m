//
//  ZYLocationManager.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/15.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface ZYLocationManager ()<CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ZYLocationManager


- (void)getCurrentLacation
{
    // 判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue]>= 8.0) {
            //如果大于ios大于8.0，就请求获取地理位置授权
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager requestWhenInUseAuthorization];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter
            = 10.0f;//
            [self.locationManager startUpdatingLocation];
        }else{
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    } else {
        if (_getCurrentLocationResult) {
            _getCurrentLocationResult(NO,nil,nil);
        }
    }
}

#pragma mark - 获取用户所在位置代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        DDLog(@"placemarks:%@",placemarks);
        
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            
            NSString *city = placeMark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placeMark.administrativeArea;
            }
            
            if (_getCurrentLocationResult) {
            
                _getCurrentLocationResult(YES,city,placeMark.name);
            }
            DDLog(@"addressDictionary:%@",placeMark.addressDictionary);
            DDLog(@"name:%@",placeMark.name);
            DDLog(@"locality:%@",placeMark.locality);
            DDLog(@"subLocality:%@",placeMark.subLocality);
            DDLog(@"administrativeArea:%@",placeMark.administrativeArea);
            DDLog(@"subAdministrativeArea:%@",placeMark.subAdministrativeArea);
            DDLog(@"postalCode:%@",placeMark.postalCode);
            DDLog(@"ISOcountryCode:%@",placeMark.ISOcountryCode);
            DDLog(@"country:%@",placeMark.country);
            DDLog(@"inlandWater:%@",placeMark.inlandWater);
            DDLog(@"ocean:%@",placeMark.ocean);
            DDLog(@"areasOfInterest:%@",placeMark.areasOfInterest);
        }
        else if (error == nil && placemarks.count == 0)
        {
            DDLog(@"No location and error returned");
            
            if (_getCurrentLocationResult) {
                _getCurrentLocationResult(NO,nil,nil);
            }

        }
        else if (error) {
            DDLog(@"Location error: %@", error);
            
            if (_getCurrentLocationResult) {
                _getCurrentLocationResult(NO,nil,nil);
            }
        }
    }];
    
    [manager stopUpdatingLocation];
}

//获取用户位置数据失败的回调方法，在此通知用户

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_getCurrentLocationResult) {
        _getCurrentLocationResult(NO,nil,nil);
    }
    //被拒绝
    if ([error code] == kCLErrorDenied)
    {
        DDLog(@"获取位置权限被拒绝");
    }
    //未知错误
    if ([error code] == kCLErrorLocationUnknown) {
        
    }
}



@end
