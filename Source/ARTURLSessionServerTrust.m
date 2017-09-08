//
//  ARTURLSessionServerTrust.m
//  ably
//
//  Created by Ricardo Pereira on 20/11/15.
//  Copyright © 2015 Ably. All rights reserved.
//

#import "ARTURLSessionServerTrust.h"
#import "ARTAsyncStackTrace+Private.h"

@interface ARTURLSessionServerTrust() {
    NSURLSession *_session;
    dispatch_queue_t _queue;
}

@end

@implementation ARTURLSessionServerTrust

- (instancetype)init:(dispatch_queue_t)queue {
    if (self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        _queue = queue;
    }
    return self;
}

- (void)finishTasksAndInvalidate {
    [_session finishTasksAndInvalidate];
}

void ART_dispatch_async(dispatch_queue_t queue, dispatch_block_t block);

- (void)get:(NSURLRequest *)request completion:(void (^)(NSHTTPURLResponse *__art_nullable, NSData *__art_nullable, NSError *__art_nullable))callback {
    NSArray<NSString *> *trace = ART_getAsyncStackTraceArray();
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        ART_recoverAsyncStackTrace(trace, ^{
            ART_dispatch_async(_queue, ^{
                callback((NSHTTPURLResponse *)response, data, error);
            });
        });
    }];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if (challenge.protectionSpace.serverTrust) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust]);
    }
    else {
        [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}

@end
