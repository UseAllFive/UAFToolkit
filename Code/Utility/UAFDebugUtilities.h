//
//  UAFDebugUtilities.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2013UseAllFive. See license.
//
//  http://stackoverflow.com/q/969130

#ifndef DEBUG_LOG
#   define DEBUG_LOG 1
#endif

//-- AlwaysLog
#define ALog(fmt, ...) NSLog((@"\n\n%s [Line %d]\n" fmt @"\n\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//-- DebugLog
#if defined(DEBUG) || defined(UAF_FORCE_DEBUG)
#   define DLog(...) ALog(__VA_ARGS__)
#   define NLog(...) { if (DHasAspect(UAFDebugAspectNetworking)) ALog(__VA_ARGS__); }
#   define SLog(...) { if (DHasAspect(UAFDebugAspectStyling)) ALog(__VA_ARGS__); }
#   define MLog(...) { if (DHasAspect(UAFDebugAspectMedia)) ALog(__VA_ARGS__); }
//-- UIAlertViewLog
#   define ULog(fmt, ...) { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#   if !DEBUG_LOG
#     undef DLog
#     define DLog(...)
#   endif
#else
#   define DLog(...)
#   define NLog(...)
#   define SLog(...)
#   define MLog(...)
#   define ULog(...)
#endif

//-- Set options as needed and use respective log macros.
//   Can also be used to control library and framework loggers.
typedef NS_OPTIONS(NSUInteger, UAFDebugAspect) {
  UAFDebugAspectNone        = 0,
  UAFDebugAspectNetworking  = 1 << 0,
  UAFDebugAspectStyling     = 1 << 1,
  UAFDebugAspectMedia       = 1 << 2,
  UAFDebugAspectDebug       = 1 << 3,
};

extern UAFDebugAspect kUAFDebugAspect;
#pragma unused (kUAFDebugAspect)

#define DHasAspect(aspect) !!(kUAFDebugAspect & aspect)
#define DAddAspect(aspect) kUAFDebugAspect |= aspect
