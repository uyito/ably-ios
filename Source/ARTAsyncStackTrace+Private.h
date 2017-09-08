//
//  ARTAsyncStackTrace+Private.h
//  Ably
//
//  Created by Toni Cárdenas on 08/09/2017.
//  Copyright © 2017 Ably. All rights reserved.
//

#ifndef ARTAsyncStackTrace_Private_h
#define ARTAsyncStackTrace_Private_h

#import "ARTAsyncStackTrace.h"

NSArray<NSString *> *ART_getAsyncStackTraceArray();
void ART_recoverAsyncStackTrace(NSArray<NSString *> *traces, dispatch_block_t block);

#endif /* ARTAsyncStackTrace_Private_h */
