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

- (instancetype)initWithCountLimit:(NSUInteger)countLimit perObjectCostLimit:(NSUInteger)perObjectCostLimit costLimit:(NSUInteger)costLimit;
{
    self = [super init];
    if( self == nil ) {
        return nil;
    }

    _lock = OS_SPINLOCK_INIT;
    _lruDictionary = [[AKLruDictionary alloc] initWithCountLimit:countLimit perObjectCostLimit:perObjectCostLimit costLimit:costLimit];

    return self;
}

- (NSUInteger)countLimit
{
    return self.lruDictionary.countLimit;
}

- (NSUInteger)perObjectCostLimit
{
    return self.lruDictionary.perObjectCostLimit;
}

- (NSUInteger)costLimit
{
    return self.lruDictionary.costLimit;
}

- (void)setObject:(id)object forKey:(id)key cost:(NSUInteger)cost
{
    OSSpinLockLock(&_lock);

    [self.lruDictionary setObject:object forKey:key cost:cost];

    OSSpinLockUnlock(&_lock);
}

- (void)setObject:(id)object forKey:(id)key
{
    OSSpinLockLock(&_lock);

    [self.lruDictionary setObject:object forKey:key];

    OSSpinLockUnlock(&_lock);
}

- (id)objectForKey:(id)key
{
    id result = nil;

    OSSpinLockLock(&_lock);

    result = [self.lruDictionary objectForKey:key];

    OSSpinLockUnlock(&_lock);

    return result;
}

- (void)removeObjectForKey:(id)key
{
    OSSpinLockLock(&_lock);

    [self.lruDictionary removeObjectForKey:key];

    OSSpinLockUnlock(&_lock);
}

- (void)removeAllObjects
{
    OSSpinLockLock(&_lock);

    [self.lruDictionary removeAllObjects];

    OSSpinLockUnlock(&_lock);
}

@end