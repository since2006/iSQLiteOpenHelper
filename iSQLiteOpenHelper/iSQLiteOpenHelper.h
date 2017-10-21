//
//  iSQLiteOpenHelper.h
//  iSQLiteOpenHelper
//
//  Created by Xuz on 10/22/17.
//  Copyright © 2017 since2006. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>

@interface iSQLiteOpenHelper : NSObject {
    
}

@property (nonatomic, retain) FMDatabase *database;

@property (nonatomic, retain) NSString *databaseName;

@property (nonatomic) int databaseVersion;

- (id)initWithDbFile:(NSString *)path version:(int)version;

- (id)initWithDbName:(NSString *)name version:(int)version;

- (void)onCreate:(FMDatabase *)db;

- (void)onUpgrade:(FMDatabase *)db oldVersion:(int)oldVersion newVersion:(int)newVersion;

- (void)checkError;

- (int)getLastInsertRowId;

- (int)getAffectedRows;

- (FMDatabase *)getWritableDatabase;

- (void)close;

@end
