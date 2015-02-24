//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@protocol AKLruDictionary

- (id)initWithCountLimit:(NSUInteger)countLimit perObjectCostLimit:(NSUInteger)perObjectCostLimit costLimit:(NSUInteger)costLimit;

@property (nonatomic, readonly) NSUInteger countLimit;
@property (nonatomic, readonly) NSUInteger perObjectCostLimit;
@property (nonatomic, readonly) NSUInteger costLimit;

- (void)setObject:(id)object forKey:(id)key cost:(NSUInteger)cost;
// When omitted, cost is presumed to be 0
- (void)setObject:(id)object forKey:(id)key;

- (id)objectForKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

@end


@interface AKLruDictionary : NSObject<AKLruDictionary>

@end