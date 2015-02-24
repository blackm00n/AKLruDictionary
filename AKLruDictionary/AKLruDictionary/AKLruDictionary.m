//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "AKLruDictionary.h"
#import "AKLruNode.h"

#define POSTCONDITION_ASSERT(a) NSAssert(a, @"Postcondition")

@interface AKLruDictionary()

@property (nonatomic) NSMapTable* mapTable;
@property (nonatomic) NSUInteger count;
@property (nonatomic) NSUInteger cost;
@property (nonatomic) AKLruNode* head;
@property (nonatomic, weak) AKLruNode* tail;

@end

@implementation AKLruDictionary

@synthesize countLimit = _countLimit, perObjectCostLimit = _perObjectCostLimit , costLimit = _costLimit;

- (instancetype)init
{
    [NSException raise:NSInternalInconsistencyException
                format:@"Instance of %@ should be initialized with designated initializer",
                       NSStringFromClass([self class])];
    return nil;
}

- (instancetype)initWithCountLimit:(NSUInteger)countLimit perObjectCostLimit:(NSUInteger)perObjectCostLimit costLimit:(NSUInteger)costLimit
{
    self = [super init];
    if( self == nil ) {
        return nil;
    }

    _countLimit = countLimit;
    _costLimit = costLimit;
    _perObjectCostLimit = MIN(costLimit, perObjectCostLimit);

    _mapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                          valueOptions:NSPointerFunctionsStrongMemory
                                              capacity:0];

    return self;
}

- (void)setObject:(id)object forKey:(id)key cost:(NSUInteger)cost
{
    NSParameterAssert(object != nil && key != nil);

    if( cost > self.perObjectCostLimit ) {
        return;
    }

    AKLruNode* node = [self.mapTable objectForKey:key];
    if( node != nil ) {
        if( object != node.nodeData.object ) {
            self.cost += ((NSInteger)cost - node.nodeData.cost);
            node.nodeData.cost = cost;
            node.nodeData.object = object;
        }
    } else {
        node = [AKLruNode new];
        node.nodeData = ({
            AKLruNodeData* nodeData = [AKLruNodeData new];
            nodeData.cost = cost;
            nodeData.key = key;
            nodeData.object = object;
            nodeData;
        });
        [self.mapTable setObject:node forKey:key];
        self.cost += node.nodeData.cost;
        self.count += 1;
    }

    [self markNodeUsed:node];

    while( self.cost > self.costLimit || self.count > self.countLimit ) {
        AKLruNode* tail = self.tail;
        [self detachNode:tail];
        [self.mapTable removeObjectForKey:tail.nodeData.key];
        self.count -= 1;
        self.cost -= tail.nodeData.cost;
    }

    POSTCONDITION_ASSERT((node.nodeData.cost > self.costLimit && self.head == nil && self.tail == nil)
        || ([self.head.nodeData.key isEqual:key] && self.tail != nil));
    POSTCONDITION_ASSERT(self.tail.nextNode == nil);
    POSTCONDITION_ASSERT(self.count <= 1 || self.tail.previousNode != nil);
}

- (void)setObject:(id)object forKey:(id)key
{
    [self setObject:object forKey:key cost:0];
}

- (id)objectForKey:(id)key
{
    NSParameterAssert(key != nil);

    AKLruNode* node = [self.mapTable objectForKey:key];
    if( node == nil ) {
        return nil;
    }
    [self markNodeUsed:node];
    return node.nodeData.object;
}

- (void)removeObjectForKey:(id<NSCopying>)key
{
    NSParameterAssert(key != nil);

    AKLruNode* node = [self.mapTable objectForKey:key];
    if( node != nil ) {
        [self.mapTable removeObjectForKey:node.nodeData.key];
        self.count -= 1;
        self.cost -= node.nodeData.cost;
    }
    [self detachNode:node];
}

- (void)removeAllObjects
{
    [self.mapTable removeAllObjects];
    self.count = 0;
    self.cost = 0;
    self.head = nil;
    self.tail = nil;
}

#pragma mark - NSObject

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"%@\nsize: %@/%@ count: %@/%@\ndictionary:%@", [super description],
                                      @(self.cost), @(self.costLimit), @(self.count), @(self.countLimit),
                                      self.mapTable];
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
    POSTCONDITION_ASSERT(self.count <= 1 || self.tail.previousNode != nil);
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