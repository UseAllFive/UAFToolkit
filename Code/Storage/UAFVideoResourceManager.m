//
//  UAFVideoResourceManager.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UAFVideoResourceManager.h"

#define kDefaultDownloadTimeoutInterval 10.0f;

static UAFVideoResourceManager *manager;

@implementation UAFVideoResourceManager

//-- UAFLocalStorage
@synthesize diskStoragePath, remotelyMirroredFiles, activeDownloadOperations, backgroundQueue;

//-- UAFObject
@synthesize shouldDebug;

- (id)init
{
  self = [super init];
  if (self) {
    self.remotelyMirroredFiles = [NSMutableDictionary dictionary];
    self.activeDownloadOperations = [NSMutableArray array];
    self.downloadTimeoutInterval = kDefaultDownloadTimeoutInterval;
  }
  return self;
}

- (RKHTTPRequestOperation *)operationToDownloadVideoAsNeededForDataObject:(NSObject<UAFVideoableDataObject> *)object
{
  return [self operationToDownloadFileAsNeededForDataObject:object atURL:object.videoURL toURL:object.localVideoURL];
}

#pragma mark - UAFLocalStorage

- (RKHTTPRequestOperation *)operationToDownloadFileAsNeededForDataObject:(NSObject<UAFLocallyStoredDataObject> *)object atURL:(NSURL *)sourceURL toURL:(NSURL *)destinationURL;
{
  NSAssert(self.diskStoragePath, @"Disk storage path is required.");
  if (!self.diskStoragePath) {
    return nil;
  }
  NSError *error = nil;
  BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:
                  [[UAFVideoResourceManager sharedManager].diskStoragePath stringByAppendingPathComponent:object.relativeDiskStoragePath]
                                           withIntermediateDirectories:YES attributes:nil error:&error];
  if (!success) {
    ALog(@"ERROR: Failed to create directory: %@", error);
  }
  void (^registerFile)(void) = ^{
    NSString *key = object.relativeDiskStoragePath;
    if (!self.remotelyMirroredFiles[key]) {
      self.remotelyMirroredFiles[key] = [NSMutableArray array];
    }
    [self.remotelyMirroredFiles[key] addObject:destinationURL];
  };
  if (!object.needsUpdate) {
    registerFile();
    if (self.shouldDebug) DLog(@"Guarded.");
    return nil;
  }
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sourceURL
                                                         cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                     timeoutInterval:self.downloadTimeoutInterval];
  RKHTTPRequestOperation *operation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
  operation.outputStream = [NSOutputStream outputStreamWithURL:destinationURL append:NO];
  [self.activeDownloadOperations addObject:operation];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (self.shouldDebug) DLog(@"Downloaded file at %@", sourceURL);
    registerFile();
    [object setValue:object.dateUpdated.copy forKey:@"previousDateUpdated"];
    [self.activeDownloadOperations removeObject:operation];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    ALog(@"ERROR: Couldn't download file for %@ at %@: %@ because %@", object, sourceURL, error.localizedDescription, error.localizedFailureReason);
    [self.activeDownloadOperations removeObject:operation];
  }];
  return operation;
}

- (void)cleanDownloadedFilesForDataObjectsOfRelativePath:(NSString *)path
{
  NSAssert(self.backgroundQueue, @"Background dispatch-queue is required.");
  if (!self.backgroundQueue) {
    return;
  }
  NSArray *classFiles = self.remotelyMirroredFiles[path];
  if (!classFiles) {
    if (self.shouldDebug) DLog(@"Guarded.");
    return;
  }
  NSFileManager *fs = [NSFileManager defaultManager];
  NSString *fullPath = [self.diskStoragePath stringByAppendingPathComponent:path];
  NSDirectoryEnumerator *enumerator = [fs enumeratorAtPath:fullPath];
  //-- Do this async for performance.
  dispatch_async(self.backgroundQueue, ^{
    NSString *fileName = nil;
    while (fileName = [enumerator nextObject]) {
      NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
      NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
      NSError *error = nil;
      if ([classFiles indexOfObject:fileURL] == NSNotFound) {
        BOOL didRemove = [fs removeItemAtPath:filePath error:&error];
        if (didRemove) {
          if (self.shouldDebug) DLog(@"Deleted file: %@", fileURL);
        } else {
          ALog(@"ERROR: Failed to delete file: %@", error);
        }
      }
    }
  });
}

#pragma mark - Singleton

+ (void)initialize
{
  static BOOL initialized = NO;
  if (!initialized) {
    initialized = YES;
    manager = [UAFVideoResourceManager new];
  }
}

+ (UAFVideoResourceManager *)sharedManager
{
  return manager;
}

@end
