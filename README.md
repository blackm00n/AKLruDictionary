LRUDictionary
=============

LRU (least recently used) memory cache data structure with a similar API as NSCache

Usage
-----

```objc
// Create cache for UIImage objects with total max size of 2 MB, objects exceeding size of 150 KB will be ignored
self.cache = [[AKLruDictionary alloc] initWithCountLimit:NSUIntegerMax
                                      perObjectCostLimit:2 * 1024 * 1024
                                               costLimit:150 * 1024];

...

- (UIImage*)imageWithMagicText:(NSString*)magicText
{
    NSParameterAssert(magicText != nil);
    
    UIImage* image = [self.cache objectForKey:magicText];
    if( image == nil ) {
        image = [MagicClass drawImageWithMagicText:magicText];
        [self.cache setObject:image forKey:magicText cost:[image ak_bytesCost]];
    }
    return image;
}
```

Thread-safety
-------------

Instances of `AKLruDictionary` class are not thread-safe, you can use `AKThreadSafeLruDictionary` (just wrapper with spinlock) if you need one.

Installation
------------

The best approach is to use [CocoaPods](http://cocoapods.org/).

Install CocoaPods gem if it's not installed yet and setup its enviroment:

    $ [sudo] gem install cocoapods
    $ pod setup

Go to the directory containing your project's .xcodeproj file and create Podfile:

    $ cd ~/Projects/MyProject
    $ vim Podfile
  
Add the following lines to Podfile:

```ruby
platform :ios
pod 'AKLruDictionary'
```
  
Finally install your pod dependencies:

    $ [sudo] pod install
    
That's all, now open just created .xcworkspace file

Contact
-------
Aleksey Kozhevnikov
* [blackm00n on GitHub](https://github.com/blackm00n)
* aleksey.kozhevnikov@gmail.com
* [@kozhevnikoff](https://twitter.com/kozhevnikoff)
