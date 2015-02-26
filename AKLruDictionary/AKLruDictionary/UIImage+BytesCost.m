//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "UIImage+BytesCost.h"

@implementation UIImage(BytesCost)

- (NSUInteger)ak_bytesCost
{
    return CGImageGetBytesPerRow(self.CGImage) * CGImageGetHeight(self.CGImage);
}

@end