//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@import UIKit;

@implementation UIImage(AKLruDictionaryObject)

- (size_t)ak_bytesSize
{
    return CGImageGetBytesPerRow(self.CGImage) * CGImageGetHeight(self.CGImage);
}

@end