//
//  VHSpeedMonitor.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/24.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "VHSpeedMonitor.h"

@interface VHSpeedMonitor ()

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign) uint32_t lastBytes;
@property (nonatomic, assign) time_t lastTime;

@end

@implementation VHSpeedMonitor

- (void)dealloc
{
    [self.reachability stopNotifier];
}

- (instancetype)init {
    self = [super init];

    if (self) {
        self.reachability = [Reachability reachabilityForInternetConnection];
        self.lastBytes = 0;
        self.lastTime = time(NULL); // 或者 _lastTime = 0;
    }

    return self;
}

- (void)startNotifier
{
    [self.reachability startNotifier];
}

- (void)stopNotifier
{
    [self.reachability stopNotifier];
}

- (void)getNetwork
{
    NetworkStatus status = [self.reachability currentReachabilityStatus];

    switch (status) {
        case NotReachable:
            VHLog(@"无网络连接");
            break;

        case ReachableViaWiFi:
            VHLog(@"WiFi网络");
            break;

        case ReachableViaWWAN: {
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;

            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                VHLog(@"4G网络");
            } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
                       [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                VHLog(@"2G网络");
            } else {
                VHLog(@"3G网络");
            }

            break;
        }
    }
}

- (float)getInterfaceSpeedInKbps
{
    struct ifaddrs *ifa_list = 0, *ifa;

    if (getifaddrs(&ifa_list) == -1) {
        return 0.0;
    }

    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    uint32_t speed = 0;
    time_t current_time;
    static time_t last_time;
    float kbps = 0.0;

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) {
            continue;
        }

        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
            continue;
        }

        if (ifa->ifa_data == 0) {
            continue;
        }

        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }

    freeifaddrs(ifa_list);

    current_time = time(NULL);

    if (last_time == 0) {
        last_time = current_time;
    }

    speed = ((iBytes + oBytes) - _lastBytes) / (current_time - _lastTime);
    kbps = speed / 1024.0 * 8.0;
    _lastBytes = iBytes + oBytes;
    _lastTime = current_time;

    return kbps;
}

@end
