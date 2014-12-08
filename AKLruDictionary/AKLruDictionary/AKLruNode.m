//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "AKLruNode.h"

@implementation AKLruNodeData
@end


@implementation AKLruNode

- (void)insertBefore:(AKLruNode*)node
{
    NSParameterAssert(node != self);

    node.previousNode.nextNode = self;
    self.previousNode = node.previousNode;
    node.previousNode = self;
    self.nextNode = node;
}

- (void)detach
{
    AKLruNode* next = self.nextNode;
    AKLruNode* previous = self.previousNode;
    previous.nextNode = next;
    next.previousNode = previous;
    self.nextNode = nil;
    self.previousNode = nil;
}

@end