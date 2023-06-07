//
//  VHNetworkSpeedMonitor.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/24.
//

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "VHNetworkSpeedMonitor.h"

@interface VHNetworkSpeedMonitor ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, assign) uint64_t lastBytesSent;
@property (nonatomic, assign) uint64_t lastBytesReceived;

@end

@implementation VHNetworkSpeedMonitor

- (instancetype)initWithUpdateInterval:(NSTimeInterval)interval {
    self = [super init];

    if (self) {
        _updateInterval = interval;
    }

    return self;
}

- (void)startMonitoring {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval
                                                      target:self
                                                    selector:@selector(updateNetworkSpeed)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopMonitoring {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateNetworkSpeed {
    uint64_t bytesSent = 0;
    uint64_t bytesReceived = 0;

    struct ifaddrs *ifaddr;

    if (getifaddrs(&ifaddr) == 0) {
        struct ifaddrs *ifa = ifaddr;

        while (ifa != NULL) {
            if (ifa->ifa_addr->sa_family == AF_LINK) {
                const struct sockaddr_dl *sdl = (const struct sockaddr_dl *)ifa->ifa_addr;

                if (sdl != NULL) {
                    const struct if_data *networkStatisc = (const struct if_data *)ifa->ifa_data;
                    bytesSent += networkStatisc->ifi_obytes;
                    bytesReceived += networkStatisc->ifi_ibytes;
                }
            }

            ifa = ifa->ifa_next;
        }
        freeifaddrs(ifaddr);
    }

    uint64_t sentSpeed = (bytesSent - self.lastBytesSent) * 8 / 1024;
    uint64_t receivedSpeed = (bytesReceived - self.lastBytesReceived) * 8 / 1024;

    self.lastBytesSent = bytesSent;
    self.lastBytesReceived = bytesReceived;

    NSLog(@"Sent: %llukbps, Received: %llukbps", sentSpeed, receivedSpeed);
}

@end
