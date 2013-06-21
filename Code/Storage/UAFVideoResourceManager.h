//
//  UAFVideoResourceManager.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <RestKit/Network/RKHTTPRequestOperation.h>

#import "UAFLocalStorage.h"

#import "UAFDebugUtilities.h"

/**
 Additional requirements for a <UAFLocallyStoredDataObject> for storing video assets.
 */
@protocol UAFVideoableDataObject <UAFLocallyStoredDataObject>
/**
 Full remote url.
 */
@property (weak, nonatomic, readonly, getter = videoURL) NSURL *videoURL;
/**
 Full local url.
 @note It's suggested to use the appropriate <[UAFLocalStorage diskStoragePath]>
 and <videoFileName> if available.
 */
@property (weak, nonatomic, readonly, getter = localVideoURL) NSURL *localVideoURL;

@optional
/**
 Helper for getting the file name.
 */
@property (weak, nonatomic, readonly, getter = videoFileName) NSString *videoFileName;

@end

/**
 Singleton that manages video assets. See <UAFLocalStorage> interface.
 */
@interface UAFVideoResourceManager : NSObject

<UAFLocalStorage>

/**
 Wraps <[UAFLocalStorage operationToDownloadFileAsNeededForDataObject:atURL:toURL:]>.
 @param object Object that conforms to <UAFVideoableDataObject>.
 */
- (RKHTTPRequestOperation *)operationToDownloadVideoAsNeededForDataObject:(NSObject<UAFVideoableDataObject> *)object;
/**
 The singleton.
 */
+ (UAFVideoResourceManager *)sharedManager;

@end
