# iSQLiteOpenHelper
iOS iSQLiteOpenHelper Just like Android SQLiteOpenHelper

### CocoaPods

```ruby
pod 'iSQLiteOpenHelper'
```

## Usage

Override method:
```objective-c
- (void)onCreate:(FMDatabase *)db;
- (void)onUpgrade:(FMDatabase *)db oldVersion:(int)oldVersion newVersion:(int)newVersion;
```
