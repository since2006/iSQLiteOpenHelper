//
//  iSQLiteOpenHelper.m
//  iSQLiteOpenHelper
//
//  Created by Xuz on 10/22/17.
//  Copyright © 2017 since2006. All rights reserved.
//

#import "iSQLiteOpenHelper.h"

@implementation iSQLiteOpenHelper

@synthesize databaseName = _databaseName;
@synthesize databaseVersion = _databaseVersion;

- (id)initWithDbFile:(NSString *)path version:(int)version {
    self = [super init];
    
    if (self) {
        self.databaseName = [path lastPathComponent];
        self.databaseVersion = version;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex: 0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent: self.databaseName];
        BOOL exists =[fm fileExistsAtPath: dbPath];
        
        NSLog(@"dbPath: %@", dbPath);
        
        if (!exists) {
            NSError *error;
            BOOL success = [fm copyItemAtPath:path toPath:dbPath error:&error];
            if (!success) {
                NSLog(@"%@", [error description]);
            }
            
            self.database = [FMDatabase databaseWithPath:dbPath];
            if (![self.database open]) {
                NSLog(@"Failed to open database.");
                [self checkError];
            } else {
                [self.database setShouldCacheStatements: YES];
            }
            
            [self onCreate:self.database];
            
            [self updateDatabase];
        } else {
            self.database = [FMDatabase databaseWithPath:dbPath];
            if (![self.database open]) {
                NSLog(@"Failed to open database.");
                [self checkError];
            } else {
                [self.database setShouldCacheStatements: YES];
            }
            
            [self updateDatabase];
        }
    }
    
    return self;
}

- (id)initWithDbName:(NSString *)name version:(int)version {
    
    self = [super init];
    
    if (self) {
        self.databaseName = name;
        self.databaseVersion = version;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex: 0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent: self.databaseName];
        BOOL exists = [fm fileExistsAtPath: dbPath];
        
        self.database = [FMDatabase databaseWithPath:dbPath];
        
        if (![self.database open]) {
            NSLog(@"Failed to open database.");
            [self checkError];
        } else {
            [self.database setShouldCacheStatements: YES];
        }
        
        if (!exists) {
            [self onCreate:self.database];
            [self _setDbVersion:self.databaseVersion];
        } else {
            [self updateDatabase];
        }
    }
    
    return self;
}

- (void)onCreate:(FMDatabase *)db {
}

- (void)onUpgrade:(FMDatabase *)db oldVersion:(int)oldVersion newVersion:(int)newVersion {
}

-(void)checkError {
    if ([self.database hadError]) {
        NSLog(@"Err %d: %@", [self.database lastErrorCode], [self.database lastErrorMessage]);
    }
}

- (FMDatabase *)getWritableDatabase {
    return self.database;
}

- (void)close {
    [self.database close];
}

- (int)getLastInsertRowId {
    int rowId = 0;
    
    FMResultSet *rs = [self.database executeQuery:@"select last_insert_rowid() as rowId"];
    
    if (rs == nil) {
        [self checkError];
        rowId = 0;
    }
    
    if ([rs next]) {
        rowId = [rs intForColumn:@"rowId"];
    }
    
    [rs close];
    
    return rowId;
}

- (int)getAffectedRows {
    int rows = 0;
    
    FMResultSet *rs = [self.database executeQuery:@"select changes() as rows"];
    
    if (rs == nil) {
        [self checkError];
        rows = 0;
    }
    
    if ([rs next]) {
        rows = [rs intForColumn:@"rows"];
    }
    
    [rs close];
    
    return rows;
}

// -----------------------------------------------------------------------------

- (void)updateDatabase {
    int currentVersion = [self _getDbVersion];
    NSLog(@"database oldVersion: %d newVersion: %d", currentVersion, self.databaseVersion);
    
    if (currentVersion < self.databaseVersion) {
        [self onUpgrade:self.database oldVersion:currentVersion newVersion:self.databaseVersion];
        [self _setDbVersion:self.databaseVersion];
    }
}

- (int)_getDbVersion {
    FMResultSet *rs = [self.database executeQuery:@"pragma user_version"];
    
    if (rs == nil) {
        [self checkError];
    }
    
    int version = 0;
    
    if ([rs next]) {
        version = [rs intForColumn:@"user_version"];
    }
    
    return version;
}

- (void)_setDbVersion:(int)version {
    NSString *sql = [NSString stringWithFormat:@"pragma user_version = %d", version];
    
    BOOL result = [self.database executeUpdate:sql];
    
    if (!result) {
        [self checkError];
    }
}

@end
