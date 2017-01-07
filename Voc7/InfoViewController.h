//
//  InfoViewController.h
//  Voc7
//
//  Created by Maximilian Scheurer on 13.04.14.
//  Copyright (c) 2014 Maximilian Scheurer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface InfoViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
enum {
    Entwickler,
    Kontakt
};
}
@end
