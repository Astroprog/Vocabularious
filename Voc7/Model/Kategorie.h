//
//  Kategorie.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kategorie : NSObject <NSCoding> {
    
}

- (id)initWithKategorieName:(NSString *)name date:(NSDate *)date andLanguage:(NSString *)language;
- (id)initWithKategorieName:(NSString *)name array:(NSMutableArray *)tempArray;
- (id)initWithKategorie:(Kategorie *)tempKategorie;

@property (strong) NSMutableArray *vocArray;
@property (strong) NSString *foreignLanguage;
@property (strong) NSString *homeLanguage;
@property (strong) NSString *kategorieName;
@property (readwrite) int date;
@property (readwrite) int rightGesamt;
@property (readwrite) int falseGesamt;
@property (readwrite) int schuljahr;
@end
