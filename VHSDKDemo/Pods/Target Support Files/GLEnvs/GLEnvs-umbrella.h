#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GLEnvs.h"
#import "GLEnvsCustomController.h"
#import "GLEnvsProtocol.h"

FOUNDATION_EXPORT double GLEnvsVersionNumber;
FOUNDATION_EXPORT const unsigned char GLEnvsVersionString[];

