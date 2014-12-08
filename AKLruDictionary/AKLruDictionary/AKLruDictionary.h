//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@protocol AKLruDictionaryObject

- (size_t)ak_bytesSize;

@end


@interface AKLruDictionary : NSObject

- (instancetype)initWithMaxObjectsCount:(size_t)maxCount maxTotalSize:(size_t)maxSize maxElementSize:(size_t)maxElementSize;

- (void)removeObjectForKey:(id<NSCopying>)key __attribute__((nonnull));

- (void)setObject:(id)object forKey:(id<NSCopying>)key __attribute__((nonnull));
- (id)objectForKey:(id<NSCopying>)key __attribute__((nonnull));

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key __attribute__((nonnull));
- (id)objectForKeyedSubscript:(id<NSCopying>)key __attribute__((nonnull));

- (void)removeAllObjects;

@end