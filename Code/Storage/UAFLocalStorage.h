//
//  UAFLocalStorage.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

@class RKHTTPRequestOperation;

/**
 Requirements for a data-object whose parts can be persisted to disk as needed
 based on time updated.
 */
@protocol UAFLocallyStoredDataObject <NSObject>

/**
 Storage path relative to the client's <[UAFLocalStorage diskStoragePath]>.
 @return The path.
 @note It's suggested the path lack starting and trailing slashes.
 */
- (NSString *)relativeDiskStoragePath;
/**
 Should compare <dateUpdated> and <previousDateUpdated>.
 @return The comparison result.
 */
- (BOOL)needsUpdate;
/**
 Date the data-object was last updated. Should be server-backed and persist with
 data-object as fit.
 */
@property (strong, nonatomic) NSDate *dateUpdated;
/**
 For checking against <dateUpdated>. Should persist with data-object as fit.
 Gets updated after a new download.
 @note It's suggested this be a non-server-backed attribute.
 */
@property (strong, nonatomic) NSDate *previousDateUpdated;

@end

/**
 Requirements for a storage client that persists server data to disk and keeps
 it in sync. Works with data-objects conforming to <UAFLocallyStoredDataObject>.
 */
@protocol UAFLocalStorage <NSObject>

/**
 The full path to the main storage directory. Required for anything to work.
 @note It's suggested the directory be named `LocalStorage`.
 */
@property (strong, nonatomic) NSString *diskStoragePath;
/**
 Collection of url lists indexed by relative paths (<[UAFLocallyStoredDataObject
 relativeDiskStoragePath]>). Url lists track new downloads and should get created /
 modified as such.
 */
@property (strong, nonatomic) NSMutableDictionary *remotelyMirroredFiles;
/**
 Keeps track of running or queued downloads.
 */
@property (strong, nonatomic) NSMutableArray *activeDownloadOperations;
/**
 Background queue for download operations.
 */
@property (nonatomic) dispatch_queue_t backgroundQueue;
/**
 Checks with <[UAFLocallyStoredDataObject needsUpdate]> and downloads file as needed.
 @param object Object that conforms to <UAFLocallyStoredDataObject>.
 @param sourceURL Full remote URL.
 @param destinationURL Full local URL.
 @return The initialized but unstarted request operation.
 */
- (RKHTTPRequestOperation *)operationToDownloadFileAsNeededForDataObject:(NSObject<UAFLocallyStoredDataObject> *)object
                                                                   atURL:(NSURL *)sourceURL
                                                                   toURL:(NSURL *)destinationURL;
/**
 Walks path and remove orphan files (for given data-object).
 @param path Relative path key for the url list.
 @note It's suggested to get the url list from <remotelyMirroredFiles> and check against it to
 determine if a file is orphaned.
 */
- (void)cleanDownloadedFilesForDataObjectsOfRelativePath:(NSString *)path;

@end