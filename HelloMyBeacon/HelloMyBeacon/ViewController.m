//
//  ViewController.m
//  HelloMyBeacon
//
//  Created by Lai Zih Ci on 2017/2/10.
//  Copyright © 2017年 ZihCi. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLBeaconRegion *beaconRegion1;
    CLBeaconRegion *beaconRegion2;
    CLBeaconRegion *beaconRegion3;
}
@property (weak, nonatomic) IBOutlet UILabel *info1Label;
@property (weak, nonatomic) IBOutlet UILabel *info2Label;
@property (weak, nonatomic) IBOutlet UILabel *info3Label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Prepare locationManager
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    
    NSUUID *beacon1UUID = [[NSUUID alloc] initWithUUIDString:@"94278BDA-B644-4520-8F0C-720EAF059935"];
    NSUUID *beacon2UUID = [[NSUUID alloc] initWithUUIDString:@"84278BDA-B644-4520-8F0C-720EAF059935"];
    NSUUID *beacon3UUID = [[NSUUID alloc] initWithUUIDString:@"84288BDA-6688-4567-88CC-7654AF068835"];//@"64278BDA-B644-4520-8F0C-720EAF059935"];
    
    beaconRegion1 = [[CLBeaconRegion alloc] initWithProximityUUID:beacon1UUID identifier:@"beacon1"];
    beaconRegion1.notifyOnEntry = true;
    beaconRegion1.notifyOnExit = true;
    
    beaconRegion2 = [[CLBeaconRegion alloc] initWithProximityUUID:beacon2UUID identifier:@"beacon2"];
    beaconRegion2.notifyOnEntry = true;
    beaconRegion2.notifyOnExit = true;
    
    beaconRegion3 = [[CLBeaconRegion alloc] initWithProximityUUID:beacon3UUID identifier:@"beacon3"];
    beaconRegion3.notifyOnEntry = true;
    beaconRegion3.notifyOnExit = true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)scanEnableValueChanged:(id)sender {
    if([sender isOn]) {
        [locationManager startMonitoringForRegion:beaconRegion1];
        [locationManager startMonitoringForRegion:beaconRegion2];
        [locationManager startMonitoringForRegion:beaconRegion3];
    } else {
        [locationManager stopMonitoringForRegion:beaconRegion1];
        [locationManager stopRangingBeaconsInRegion:beaconRegion1];
        
        [locationManager stopMonitoringForRegion:beaconRegion2];
        [locationManager stopRangingBeaconsInRegion:beaconRegion2];
        
        [locationManager stopMonitoringForRegion:beaconRegion3];
        [locationManager stopRangingBeaconsInRegion:beaconRegion3];
    }
}
-(void) showLocalNotificationWithMessage:(NSString*) message {
    NSLog(@"localnotification");
    UILocalNotification *notification = [UILocalNotification new];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    notification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
#pragma mark - CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [locationManager requestStateForRegion:region];
}
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    NSString *message = nil;
    
    if(state == CLRegionStateInside) {
        message = [NSString stringWithFormat:@"Beacon inside region: %@",region.identifier];
        [locationManager startRangingBeaconsInRegion:(CLBeaconRegion*) region];
    } else {
        // outside
        message = [NSString stringWithFormat:@"Beacon outside region: %@", region.identifier];
        [locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
        
    }
    [self showLocalNotificationWithMessage:message];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    for(CLBeacon *beacon in beacons) {
        NSString *proximityString;
        switch (beacon.proximity) {
            case CLProximityImmediate:
                proximityString = @"Immediate";
                break;
            case CLProximityNear:
                proximityString = @"Near";
                break;
            case CLProximityFar:
                proximityString = @"Far";
                break;
            case CLProximityUnknown:
                proximityString = @"UnKnown";
                break;
            default:
                break;
        }
        // Prepare info string
        NSString *info = [NSString stringWithFormat:@"%@,%@,RSSI:%ld,Acc:%.1f",region.identifier,proximityString,beacon.rssi,beacon.accuracy];
        
        if ([region.identifier isEqualToString:beaconRegion1.identifier]) {
            _info1Label.text = info;
        } else if ([region.identifier isEqualToString:beaconRegion2.identifier]) {
            _info2Label.text = info;
        } else if ([region.identifier isEqualToString:beaconRegion3.identifier]) {
            _info3Label.text = info;
        }
    }
}
@end
