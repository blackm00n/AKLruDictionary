//
// Created by Alexey Kozhevnikov on 24.02.15.
// Copyright (c) 2015 Aleksey Kozhevnikov. All rights reserved.
//

#import "UIImage+BytesCost.h"

@implementation UIImage(BytesCost)

- (NSUInteger)ak_bytesCost
{
    return CGImageGetBytesPerRow(self.CGImage) * CGImageGetHeight(self.CGImage);
}

@end