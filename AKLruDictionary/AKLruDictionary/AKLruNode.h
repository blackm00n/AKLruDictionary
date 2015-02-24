//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@interface AKLruNodeData : NSObject

@property(nonatomic) NSUInteger cost;
@property(nonatomic) id key;
@property(nonatomic) id object;

@end


@interface AKLruNode : NSObject

@property(nonatomic) AKLruNode* nextNode;
@property(nonatomic, weak) AKLruNode* previousNode;

@property(nonatomic) AKLruNodeData* nodeData;

-(void)insertBefore:(AKLruNode*)node;
-(void)detach;

@end