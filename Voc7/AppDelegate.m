//
//  AppDelegate.m
//  Voc7
//
//  Created by Maximilian Scheurer on 04.04.14.
//  Copyright (c) 2014 Maximilian Scheurer. All rights reserved.
//

#import "AppDelegate.h"
#import "Day.h"
#import "Kategorie.h"
#import "Vokabel.h"

NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
NSMutableArray *graphArray;
NSMutableArray *languages;
BOOL sortingChanged;
BOOL firstLaunch;

int rightVocCount;
int vocCount;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    for (int i = 0; i < tabController.tabBar.items.count; i++) {
        switch (i) {
            case 0:
                [[tabController.tabBar.items objectAtIndex:i] setTitle:NSLocalizedString(@"Abfrage", nil)];
                break;
            case 1:
                [[tabController.tabBar.items objectAtIndex:i] setTitle:NSLocalizedString(@"Listen", nil)];
                break;
            case 2:
                [[tabController.tabBar.items objectAtIndex:i] setTitle:NSLocalizedString(@"Sammlungen", nil)];
                break;
            case 3:
                [[tabController.tabBar.items objectAtIndex:i] setTitle:NSLocalizedString(@"Statistik", nil)];
                break;
            case 4:
                [[tabController.tabBar.items objectAtIndex:i] setTitle:NSLocalizedString(@"Einstellungen", nil)];
                break;
            default:
                break;
        }
    }
    mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"kategorieArray"]) {
        kategorieArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"kategorieArray"]];
    } else {
        kategorieArray = [[NSMutableArray alloc] init];
    }
    
    
    if ([defaults objectForKey:@"collectionArray"]) {
        collectionArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"collectionArray"]];
    } else {
        collectionArray = [[NSMutableArray alloc] init];
    }
    
    
    if ([defaults objectForKey:@"graphArray"]) {
        graphArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"graphArray"]];
    } else {
        graphArray = [[NSMutableArray alloc] init];
    }
    
    if ([defaults objectForKey:@"languages"]) {
        languages = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"languages"]];
    } else {
        languages = [[NSMutableArray alloc] init];
        [languages addObject:NSLocalizedString(@"Sprache 1", nil)];
        [languages addObject:NSLocalizedString(@"Sprache 2", nil)];
        [languages addObject:NSLocalizedString(@"Sprache 3", nil)];
        [languages addObject:NSLocalizedString(@"Sprache 4", nil)];
        [languages addObject:NSLocalizedString(@"Sprache 5", nil)];
        [languages addObject:NSLocalizedString(@"Sprache 6", nil)];
        [languages addObject:NSLocalizedString(@"Sprache 7", nil)];
    }
    
    if (![defaults integerForKey:@"rightNumber"]) {
        [defaults setInteger:3 forKey:@"rightNumber"];
    }
    
    if (![defaults boolForKey:@"homeStringWillBeDisplayedFirst"]) {
        [defaults setBool:NO forKey:@"homeStringWillBeDisplayedFirst"];
    }
    
    if (![defaults objectForKey:@"sorting"]) {
        [defaults setObject:@"none" forKey:@"sorting"];
    }
    
    if (![defaults objectForKey:@"sortingOrder"]) {
        [defaults setObject:@"ascending" forKey:@"sortingOrder"];
    }
    
    if (![defaults integerForKey:@"hideVocs"]) {
        [defaults setInteger:0 forKey:@"hideVocs"];
    }
    
    if (![defaults integerForKey:@"hidePictures"]) {
        [defaults setInteger:0 forKey:@"hidePictures"];
    }
    
    if (![defaults objectForKey:@"homeLanguage"]) {
        [defaults setObject:@"English" forKey:@"homeLanguage"];
    }
    
    if (![defaults integerForKey:@"launches"]) {
        firstLaunch = YES;
        [defaults setInteger:1 forKey:@"launches"];
    } else {
        firstLaunch = NO;
        [defaults setInteger:[defaults integerForKey:@"launches"] + 1 forKey:@"launches"];
    }
    
//    Kategorie *tempKategorie = [kategorieArray objectAtIndex:0];
//    [tempKategorie.vocArray removeAllObjects];
//
//    Vokabel *test1 = [[Vokabel alloc] init];
//    Vokabel *test2 = [[Vokabel alloc] init];
//    Vokabel *test3 = [[Vokabel alloc] init];
//    Vokabel *test4 = [[Vokabel alloc] init];
//    Vokabel *test5 = [[Vokabel alloc] init];
//    Vokabel *test6 = [[Vokabel alloc] init];
//    Vokabel *test7 = [[Vokabel alloc] init];
//    Vokabel *test8 = [[Vokabel alloc] init];
//    Vokabel *test9 = [[Vokabel alloc] init];
//    Vokabel *test10 = [[Vokabel alloc] init];
//    Vokabel *test11 = [[Vokabel alloc] init];
//    Vokabel *test12 = [[Vokabel alloc] init];
//    Vokabel *test13 = [[Vokabel alloc] init];
//    Vokabel *test14 = [[Vokabel alloc] init];
//    Vokabel *test15 = [[Vokabel alloc] init];
//    Vokabel *test16 = [[Vokabel alloc] init];
//    Vokabel *test17 = [[Vokabel alloc] init];
//    Vokabel *test18 = [[Vokabel alloc] init];
//    Vokabel *test19 = [[Vokabel alloc] init];
//    Vokabel *test20 = [[Vokabel alloc] init];
//    Vokabel *test21 = [[Vokabel alloc] init];
//    Vokabel *test22 = [[Vokabel alloc] init];
//    Vokabel *test23 = [[Vokabel alloc] init];
//    Vokabel *test24 = [[Vokabel alloc] init];
//    Vokabel *test25 = [[Vokabel alloc] init];
//
//    test1.homeString = @"Baum";
//    test2.homeString = @"Licht";
//    test3.homeString = @"Test";
//    test4.homeString = @"Tisch";
//    test5.homeString = @"Stuhl";
//    test6.homeString = @"Gardine";
//    test7.homeString = @"Fenster";
//    test8.homeString = @"Apfel";
//    test9.homeString = @"Boden";
//    test10.homeString = @"Decke";
//    test11.homeString = @"Wand";
//    test12.homeString = @"Bett";
//    test13.homeString = @"Klavier";
//    test14.homeString = @"Flasche";
//    test15.homeString = @"Deckel";
//    test16.homeString = @"Ecke";
//    test17.homeString = @"Sofa";
//    test18.homeString = @"Sessel";
//    test19.homeString = @"Lautsprecher";
//    test20.homeString = @"Kopfhörer";
//    test21.homeString = @"Mikrofon";
//    test22.homeString = @"Ton";
//    test23.homeString = @"Pflanze";
//    test24.homeString = @"Tier";
//    test25.homeString = @"Erde";
//
//    test1.addDate = test1.addDate - 1 * 86400;
//    test2.addDate = test2.addDate - 1 * 86400;
//    test3.addDate = test3.addDate - 2 * 86400;
//    test4.addDate = test4.addDate - 2 * 86400;
//    test5.addDate = test5.addDate - 2 * 86400;
//    test6.addDate = test6.addDate - 1 * 86400;
//    test7.addDate = test7.addDate - 1 * 86400;
//    test8.addDate = test8.addDate - 4 * 86400;
//    test9.addDate = test9.addDate - 4 * 86400;
//    test10.addDate = test10.addDate - 4 * 86400;
//    test11.addDate = test11.addDate - 1 * 86400;
//    test12.addDate = test12.addDate - 5 * 86400;
//    test13.addDate = test13.addDate - 2 * 86400;
//    test14.addDate = test14.addDate - 3 * 86400;
//    test15.addDate = test15.addDate - 4 * 86400;
//    test16.addDate = test16.addDate - 3 * 86400;
//    test17.addDate = test17.addDate - 7 * 86400;
//    test18.addDate = test18.addDate - 3 * 86400;
//    test19.addDate = test19.addDate - 4 * 86400;
//    test20.addDate = test20.addDate - 1 * 86400;
//    test21.addDate = test21.addDate - 2 * 86400;
//    test22.addDate = test22.addDate - 3 * 86400;
//    test23.addDate = test23.addDate - 2 * 86400;
//    test24.addDate = test24.addDate - 2 * 86400;
//    test25.addDate = test25.addDate - 2 * 86400;
//
//    [tempKategorie.vocArray addObject:test1];
//    [tempKategorie.vocArray addObject:test2];
//    [tempKategorie.vocArray addObject:test3];
//    [tempKategorie.vocArray addObject:test4];
//    [tempKategorie.vocArray addObject:test5];
//    [tempKategorie.vocArray addObject:test6];
//    [tempKategorie.vocArray addObject:test7];
//    [tempKategorie.vocArray addObject:test8];
//    [tempKategorie.vocArray addObject:test9];
//    [tempKategorie.vocArray addObject:test10];
//    [tempKategorie.vocArray addObject:test11];
//    [tempKategorie.vocArray addObject:test12];
//    [tempKategorie.vocArray addObject:test13];
//    [tempKategorie.vocArray addObject:test14];
//    [tempKategorie.vocArray addObject:test15];
//    [tempKategorie.vocArray addObject:test16];
//    [tempKategorie.vocArray addObject:test17];
//    [tempKategorie.vocArray addObject:test18];
//    [tempKategorie.vocArray addObject:test19];
//    [tempKategorie.vocArray addObject:test20];
//    [tempKategorie.vocArray addObject:test21];
//    [tempKategorie.vocArray addObject:test22];
//    [tempKategorie.vocArray addObject:test23];
//    [tempKategorie.vocArray addObject:test24];
//    [tempKategorie.vocArray addObject:test25];
//
//    [kategorieArray replaceObjectAtIndex:0 withObject:tempKategorie];
    
    
//    [graphArray removeAllObjects];
    
     
//     
//     Day *test = [[Day alloc] init];
//     Day *test2 = [[Day alloc] init];
//     Day *test3 = [[Day alloc] init];
//     Day *test4 = [[Day alloc] init];
//     Day *test5 = [[Day alloc] init];
//     Day *test6 = [[Day alloc] init];
//     Day *test7 = [[Day alloc] init];
//     Day *test8 = [[Day alloc] init];
//     
//     test.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 86400;
//     test2.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 12 * 86400;
//     test3.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 23 * 86400;
//     test4.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 43 * 86400;
//     test5.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 45 * 86400;
//     test6.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 55 * 86400;
//     test7.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 66 * 86400;
//     test8.time = (int)CFAbsoluteTimeGetCurrent() - (int)CFAbsoluteTimeGetCurrent() % 86400 - 67 * 86400;
//     
//     test.wrongVocs = 3;
//     test2.wrongVocs = 5;
//     test3.wrongVocs = 2;
//     test4.wrongVocs = 6;
//     test5.wrongVocs = 1;
//     test6.wrongVocs = 8;
//     test7.wrongVocs = 5;
//     test8.wrongVocs = 3;
//     
//     
//     test.rightVocs = 3;
//     test2.rightVocs = 6;
//     test3.rightVocs = 6;
//     test4.rightVocs = 8;
//     test5.rightVocs = 2;
//     test6.rightVocs = 4;
//     test7.rightVocs = 1;
//     test8.rightVocs = 3;
//     
//     [graphArray addObject:test8];
//     [graphArray addObject:test7];
//     [graphArray addObject:test6];
//     [graphArray addObject:test5];
//     [graphArray addObject:test4];
//     [graphArray addObject:test3];
//     [graphArray addObject:test2];
//     [graphArray addObject:test];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:kategorieArray];
    NSData *collectionData = [NSKeyedArchiver archivedDataWithRootObject:collectionArray];
    NSData *graphData = [NSKeyedArchiver archivedDataWithRootObject:graphArray];
    NSData *languageData = [NSKeyedArchiver archivedDataWithRootObject:languages];
    [defaults setObject:languageData forKey:@"languages"];
    [defaults setObject:collectionData forKey:@"collectionArray"];
    [defaults setObject:data forKey:@"kategorieArray"];
    [defaults setObject:graphData forKey:@"graphArray"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:kategorieArray];
    NSData *collectionData = [NSKeyedArchiver archivedDataWithRootObject:collectionArray];
    NSData *graphData = [NSKeyedArchiver archivedDataWithRootObject:graphArray];
    NSData *languageData = [NSKeyedArchiver archivedDataWithRootObject:languages];
    [defaults setObject:languageData forKey:@"languages"];
    [defaults setObject:collectionData forKey:@"collectionArray"];
    [defaults setObject:data forKey:@"kategorieArray"];
    [defaults setObject:graphData forKey:@"graphArray"];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"MEMORY WARNING");
}

@end
