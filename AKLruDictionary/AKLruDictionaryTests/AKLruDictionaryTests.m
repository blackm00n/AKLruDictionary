//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@import XCTest;

#import "AKLruDictionary.h"

@interface AKLruDictionaryTests : XCTestCase
@end

@implementation AKLruDictionaryTests

-(void)setUp
{
    [super setUp];
}

-(void)tearDown
{
    [super tearDown];
}

-(void)test
{
    AKLruDictionary* lruDictionary = [[AKLruDictionary alloc] initWithMaxObjectsCount:3
                                                                         maxTotalSize:10
                                                                       maxElementSize:9];
    [lruDictionary setObject:@(1) forKey:@"1"]; // 1
    [lruDictionary setObject:@(2) forKey:@"2"]; // 2, 1
    [lruDictionary setObject:@(3) forKey:@"3"]; // 3, 2, 1
    [lruDictionary setObject:@(4) forKey:@"4"]; // 4, 3, 2
    XCTAssertNil([lruDictionary objectForKey:@"1"]); // 4, 3, 2
    XCTAssertEqualObjects(@(2), [lruDictionary objectForKey:@"2"]); // 2, 4, 3
    XCTAssertEqualObjects(@(3), [lruDictionary objectForKey:@"3"]); // 3, 2, 4
    XCTAssertEqualObjects(@(4), [lruDictionary objectForKey:@"4"]); // 4, 3, 2

    [lruDictionary setObject:@(5) forKey:@"5"]; // 5, 4
    XCTAssertNil([lruDictionary objectForKey:@"2"]); // 5, 4
    XCTAssertNil([lruDictionary objectForKey:@"3"]); // 5, 4
    XCTAssertEqualObjects(@(4), [lruDictionary objectForKey:@"4"]); // 4, 5
    XCTAssertEqualObjects(@(5), [lruDictionary objectForKey:@"5"]); // 5, 4

    [lruDictionary setObject:@(3) forKey:@"3"]; // 3, 5
    XCTAssertEqualObjects(@(5), [lruDictionary objectForKey:@"5"]); // 5, 3
    XCTAssertEqualObjects(@(3), [lruDictionary objectForKey:@"3"]); // 3, 5

    [lruDictionary setObject:@(6) forKey:@"6"]; // 6, 3
    XCTAssertEqualObjects(@(6), [lruDictionary objectForKey:@"6"]); // 6, 3
    XCTAssertEqualObjects(@(3), [lruDictionary objectForKey:@"3"]); // 3, 6

    [lruDictionary setObject:@(10) forKey:@"10"]; // 3, 6
    XCTAssertNil([lruDictionary objectForKey:@"10"]); // 3, 6
    XCTAssertEqualObjects(@(6), [lruDictionary objectForKey:@"6"]); // 6, 3
    XCTAssertEqualObjects(@(3), [lruDictionary objectForKey:@"3"]); // 3, 6

    [lruDictionary setObject:@(9) forKey:@"9"]; // 9
    XCTAssertNil([lruDictionary objectForKey:@"6"]); // 9
    XCTAssertNil([lruDictionary objectForKey:@"3"]); // 9
    XCTAssertEqualObjects(@(9), [lruDictionary objectForKey:@"9"]); // 9

    [lruDictionary setObject:@(10) forKey:@"10"]; // 9
    XCTAssertNil([lruDictionary objectForKey:@"10"]); // 9
    XCTAssertEqualObjects(@(9), [lruDictionary objectForKey:@"9"]); // 9

    [lruDictionary removeObjectForKey:@"9"]; // none
    XCTAssertNil([lruDictionary objectForKey:@"9"]); // none

    [lruDictionary setObject:@(1) forKey:@"1"]; // 1
    [lruDictionary setObject:@(2) forKey:@"2"]; // 2, 1
    [lruDictionary setObject:@(3) forKey:@"3"]; // 3, 2, 1
    [lruDictionary removeObjectForKey:@"2"]; // 3, 1
    [lruDictionary setObject:@(4) forKey:@"4"]; // 4, 3, 1
    XCTAssertNil([lruDictionary objectForKey:@"2"]); // 4, 3, 1
    XCTAssertEqualObjects(@(1), [lruDictionary objectForKey:@"1"]); // 1, 4, 3
    XCTAssertEqualObjects(@(3), [lruDictionary objectForKey:@"3"]); // 3, 1, 4
    XCTAssertEqualObjects(@(4), [lruDictionary objectForKey:@"4"]); // 4, 3, 1
}

@end