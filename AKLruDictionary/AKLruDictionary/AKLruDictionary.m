//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "AKLruDictionary.h"
#import "AKLruNode.h"

#define POSTCONDITION_ASSERT(a) NSAssert(a, @"Postcondition")

@interface AKLruDictionary()

@property (nonatomic, readonly) size_t maxElementSize;
@property (nonatomic, readonly) size_t maxCount;
@property (nonatomic, readonly) size_t maxSize;

@property (nonatomic) NSMutableDictionary* dictionary;
@property (nonatomic) size_t totalCount;
@property (nonatomic) size_t totalSize;
@property (nonatomic) AKLruNode* head;
@property (nonatomic, weak) AKLruNode* tail;

@end

@implementation AKLruDictionary

- (instancetype)init
{
    [NSException raise:NSInternalInconsistencyException
                format:@"Instance of %@ should be initialized with designated initializer",
                       NSStringFromClass([self class])];
    return nil;
}

- (instancetype)initWithMaxObjectsCount:(size_t)maxCount maxTotalSize:(size_t)maxSize maxElementSize:(size_t)maxElementSize
{
    self = [super init];
    if( self == nil ) {
        return nil;
    }

    _maxElementSize = MIN(maxSize, maxElementSize);
    _maxCount = maxCount;
    _maxSize = maxSize;

    _dictionary = [NSMutableDictionary dictionary];

    return self;
}

- (void)removeObjectForKey:(id<NSCopying>)key
{
    NSParameterAssert(key != nil);

    AKLruNode* node = self.dictionary[key];
    if( node != nil ) {
        [self.dictionary removeObjectForKey:node.nodeData.key];
        self.totalCount -= 1;
        self.totalSize -= node.nodeData.dataSize;
    }
    [self detachNode:node];
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key
{
    NSParameterAssert(object != nil && key != nil);

    size_t dataSize = 0;
    if( [object conformsToProtocol:@protocol(AKLruDictionaryObject)] ) {
        dataSize = [object ak_bytesSize];
    }
    if( dataSize > self.maxElementSize ) {
        return;
    }
    AKLruNode* node = self.dictionary[key];
    if( node != nil ) {
        if( object != node.nodeData.object ) {
            self.totalSize += (dataSize - node.nodeData.dataSize);
            node.nodeData.dataSize = dataSize;
            node.nodeData.object = object;
        }
    } else {
        node = [AKLruNode new];
        node.nodeData = ({
            AKLruNodeData* nodeData = [AKLruNodeData new];
            nodeData.dataSize = dataSize;
            nodeData.key = key;
            nodeData.object = object;
            nodeData;
        });
        self.dictionary[key] = node;
        self.totalSize += node.nodeData.dataSize;
        self.totalCount += 1;
    }

    [self markNodeUsed:node];

    while( self.totalSize > self.maxSize || self.totalCount > self.maxCount ) {
        AKLruNode* tail = self.tail;
        [self detachNode:tail];
        [self.dictionary removeObjectForKey:tail.nodeData.key];
        self.totalCount -= 1;
        self.totalSize -= tail.nodeData.dataSize;
    }

    POSTCONDITION_ASSERT((node.nodeData.dataSize > self.maxSize && self.head == nil && self.tail == nil)
        || ([self.head.nodeData.key isEqual:key] && self.tail != nil));
    POSTCONDITION_ASSERT(self.tail.nextNode == nil);
    POSTCONDITION_ASSERT(self.totalCount <= 1 || self.tail.previousNode != nil);
}

- (id)objectForKey:(id<NSCopying>)key
{
    NSParameterAssert(key != nil);

    AKLruNode* node = self.dictionary[key];
    if( node == nil ) {
        return nil;
    }
    [self markNodeUsed:node];
    return node.nodeData.object;
}

- (void)removeAllObjects
{
    [self.dictionary removeAllObjects];
    self.totalCount = 0;
    self.totalSize = 0;
    self.head = nil;
    self.tail = nil;
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key
{
    [self setObject:object forKey:key];
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key
{
    return [self objectForKey:key];
}

#pragma mark - NSObject

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"%@\nsize: %@/%@ count: %@/%@\ndictionary:%@", [super description],
                                      @(self.totalSize), @(self.maxSize), @(self.totalCount), @(self.maxCount),
                                      self.dictionary];
}

#pragma mark - Private

- (void)markNodeUsed:(AKLruNode*)node
{
    NSParameterAssert(node != nil);

    if( self.head != node ) {
        [self detachNode:node];
        [node insertBefore:self.head];
        self.head = node;
        if( self.tail == nil ) {
            self.tail = self.head;
        }
    }

    POSTCONDITION_ASSERT(self.head == node);
    POSTCONDITION_ASSERT(self.head.previousNode == nil);
    POSTCONDITION_ASSERT(self.tail.nextNode == nil);
    POSTCONDITION_ASSERT(self.totalCount <= 1 || self.tail.previousNode != nil);
}

- (void)detachNode:(AKLruNode*)node
{
    if( self.tail == node ) {
        self.tail = node.previousNode;
    }
    if( self.head == node ) {
        self.head = node.nextNode;
    }
    [node detach];
}

@end