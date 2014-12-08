//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import <libkern/OSAtomic.h>
#import "AKThreadSafeLruDictionary.h"
#import "AKLruDictionary.h"

@interface AKThreadSafeLruDictionary() {
    OSSpinLock _lock;
}

@property (nonatomic) AKLruDictionary* lruDictionary;

@end

@implementation AKThreadSafeLruDictionary

- (instancetype)initWithMaxObjectsCount:(size_t)maxCount maxTotalSize:(size_t)maxSize maxElementSize:(size_t)maxElementSize
{
    self = [super init];
    if( self == nil ) {
        return nil;
    }

    _lock = OS_SPINLOCK_INIT;
    _lruDictionary = [[AKLruDictionary alloc] initWithMaxObjectsCount:maxCount maxTotalSize:maxSize maxElementSize:maxElementSize];

    return self;
}

- (void)removeObjectForKey:(id<NSCopying>)key
{
    OSSpinLockLock(&_lock);

    [self.lruDictionary removeObjectForKey:key];

    OSSpinLockUnlock(&_lock);
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key
{
    OSSpinLockLock(&_lock);

    [self.lruDictionary setObject:object forKey:key];

    OSSpinLockUnlock(&_lock);
}

- (id)objectForKey:(id<NSCopying>)key
{
    id result = nil;

    OSSpinLockLock(&_lock);

    result = [self.lruDictionary objectForKey:key];

    OSSpinLockUnlock(&_lock);

    return result;
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key
{
    [self setObject:object forKey:key];
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key
{
    return [self objectForKey:key];
}

- (void)removeAllObjects
{
    OSSpinLockLock(&_lock);

    [self.lruDictionary removeAllObjects];

    OSSpinLockUnlock(&_lock);
}

@end