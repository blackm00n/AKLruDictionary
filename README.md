LRUDictionary
=============

LRU (least recently used) memory cache data structure with a similar API as NSMutableDictionary

Usage
-----

```objc
// Create cache for UIImage objects with total max size of 2 MB, objects exceeding size of 150 KB will be ignored
self.cache = [[AKLruDictionary alloc] initWithMaxObjectsCount:SIZE_T_MAX
                                                 maxTotalSize:2 * 1024 * 1024
                                               maxElementSize:150 * 1024];

...

- (UIImage*)imageWithMagicText:(NSString*)magicText
{
    NSParameterAssert(magicText != nil);
    
    UIImage* image = self.cache[magicText];
    if( image == nil ) {
        self.cache[magicText] = image = [MagicClass drawImageWithMagicText:magicText];
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
