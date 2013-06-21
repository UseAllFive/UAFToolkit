//
//  UAFPurchaseableDataObject.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <StoreKit/StoreKit.h>
#import <CoreData/CoreData.h>

/**
 Required functionality for a model class that supports In-App Purchasing.
 
 Use of `CargoBay` is suggested.
 */
@protocol UAFPurchaseableDataObject <NSObject>

/**
 The IAP product identifier. Make dynamic as needed, eg. data object is
 <NSManagedObject>. Suggested to be part of the server-side response.
 */
@property (strong, nonatomic) NSString *productID;
/**
 Property that is usually evaluated. Make dynamic as needed, eg. data object is
 an `NSManagedObject`. Should be updated after a successful transaction. This
 allows the overall purchasing history to be persistent. Suggested to not be
 part of the server-side response, since tracking user purchases should be
 Apple's responsibility.
 */
@property (nonatomic) BOOL isPurchased;
/**
 Property to store the product data. Should be set on all purchaseable instances.
 Should be used with <purchase>.
 */
@property (strong, nonatomic) SKProduct *product;

/**
 Main method to fill in IAP related functionality. While CoreData use is
 suggested, it's not required. Transactions should be set as finished after
 callbacks are called.
 @param list List of data objects. Each object will be made purchaseable upon
 store setup completion. If an object isn't purchaseable (is invalid), then it
 should be removed.
 @param completion Completion callback for store setup.
 @param error Error callback in case store setup failed.
 @param success Successful transaction callback, suggested to be called after
 receipt is verified.
 @param failure Failed transaction callback.
 @param cancellation Cancelled transaction callback.
 @param restoreSuccess Callback for when all restorable transactions are
 restored. Works with `[SKPaymentQueue restoreCompletedTransactions]`. A list of
 restored volumes is provided.
 @param restoreError Callback for failure of restoring all all restorable
 transactions.
 @return If the setup procedure succeeded. For example, redundant setup directly
 shorts with `YES`, while if payments are disabled, then `NO`.
 @note It is suggested to make a 'product table' from <list>, indexed by
 <productID>, for easier integration with the `SKProduct` instances.
 */
+ (BOOL)setupStoreAsNeededForList:(NSArray *)list
                   withCompletion:(void (^)(NSArray *products, NSArray *invalidIdentifiers))completion
                     errorHandler:(void (^)(NSError *error))error
        transactionSuccessHandler:(void (^)(SKPaymentTransaction *transaction, NSManagedObject<UAFPurchaseableDataObject> *dataObject))success
        transactionFailureHandler:(void (^)(SKPaymentTransaction *transaction, NSManagedObject<UAFPurchaseableDataObject> *dataObject))failure
   transactionCancellationHandler:(void (^)(SKPaymentTransaction *transaction, NSManagedObject<UAFPurchaseableDataObject> *dataObject))cancellation
restoreTransactionsSuccessHandler:(void (^)(NSArray *volumes))restoreSuccess
  restoreTransactionsErrorHandler:(void (^)(NSError *error))restoreError;
/**
 Standard teardown procedure.
 @return If the teardown procedure succeeded.
 */
+ (BOOL)teardownStore;
/**
 Send POST request to server for transaction receipt, which should come directly
 from the `SKPaymentTransaction` object.
 @param receipt `transaction.transactionReceipt.base64EncodedString`.
 @param completion Callback for successful verification, one without validation
 and network errors.
 @param errorHandler Callback for any form of failed verification.
 */
+ (void)verifyTransactionReceipt:(NSData *)receipt withCompletion:(void(^)(void))completion
                 andErrorHandler:(void (^)(NSError *error))onError;
/**
 Should simply add a payment to the payment queue, but only as needed.
 @return If purchase request has been sent.
 @see product
 @see isPurchased
 */
- (BOOL)purchase;

@end