//
//  ARTAsyncStackTrace.m
//  Ably
//
//  Created by Toni Cárdenas on 08/09/2017.
//  Copyright © 2017 Ably. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTAsyncStackTrace+Private.h"
#include <pthread.h>

pthread_key_t ART_getStackTracesKey() {
    static pthread_key_t key;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_key_create(&key, NULL);
    });
    return key;
}

void ART_recoverAsyncStackTrace(NSArray<NSString *> *trace, dispatch_block_t block) {
    pthread_key_t key = ART_getStackTracesKey();
    CFTypeRef v = CFBridgingRetain(trace);
    pthread_setspecific(key, v);
    block();
    pthread_setspecific(key, NULL);
    CFBridgingRelease(v);
}

NSArray<NSString *> *ART_getAsyncStackTraceArray() {
    pthread_key_t key = ART_getStackTracesKey();
    NSArray<NSString *> *traces = (__bridge NSMutableArray*)pthread_getspecific(key);
    NSMutableArray<NSString *> *newTraces = [[NSMutableArray alloc] init];
    [newTraces addObject:[[NSThread callStackSymbols] componentsJoinedByString:@"\n"]];
    [newTraces addObjectsFromArray:traces];
    return newTraces;
}

void ART_dispatch_async(dispatch_queue_t queue, dispatch_block_t block) {
    NSArray<NSString *> *trace = ART_getAsyncStackTraceArray();
    dispatch_async(queue, ^{
        ART_recoverAsyncStackTrace(trace, block);
    });
}

NSString *ART_getAsyncStackTrace() {
    return [ART_getAsyncStackTraceArray() componentsJoinedByString:@"\n\n--dispatch_async call --\n\n"];
}
