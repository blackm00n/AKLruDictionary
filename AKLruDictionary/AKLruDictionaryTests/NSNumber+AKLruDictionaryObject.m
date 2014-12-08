//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@import Foundation;

#import "AKLruDictionary.h"

@interface NSNumber(AKLruDictionaryObject)<AKLruDictionaryObject>
@end

@implementation NSNumber(AKLruDictionaryObject)

- (size_t)ak_bytesSize
{
    return (size_t)[self longLongValue];
}

@end