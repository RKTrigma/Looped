//
//  ALGroupCreationViewController.h
//  Applozic
//
//  Created by Divjyot Singh on 13/02/16.
//  Copyright © 2016 applozic Inc. All rights reserved.
//


/* - - - */
#define IMAGE_SHARE         3
#define GROUP_CREATION      1
#define GROUP_ADDITION      2
#define REGULAR_CONTACTS    0
/* - - - */

#import <UIKit/UIKit.h>

/* - - - */
#import "ALChannelService.h"
#import "ALMessageDBService.h"
/* - - - */

@protocol ALGroupInfoDelegate <NSObject>
@optional
-(void)updateGroupInformation;
@end

/* - - - */

@protocol ALContactDelegate <NSObject>
@optional
-(void)addNewMembertoGroup:(ALContact *)alcontact withCompletion:(void(^)(NSError *error,ALAPIResponse *response))completion;

@end
/* - - - */

@interface ALGroupCreationViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate , UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITextField    * groupNameInput;
@property (weak, nonatomic) IBOutlet UIImageView    * groupIconView;
@property (weak, nonatomic) IBOutlet UITextView     * descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView    * mTableView;
@property (strong,nonatomic) NSString               * groupImageUploadURL;

/**************************************
 CASE IF UPDATING GROUP INFORMATION
 UPDATING GROUP NAME/IMAGE
 **************************************/

@property (nonatomic)           BOOL                           isViewForUpdatingGroup;
@property (nonatomic, strong)   NSNumber                     * channelKey;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * loadingIndicator;
@property (nonatomic, strong) id <ALGroupInfoDelegate> grpInfoDelegate;

/* - - - */
@property (weak, nonatomic)   IBOutlet UITableView           * contactsTableView;
@property (weak, nonatomic)   IBOutlet NSLayoutConstraint    * mTableViewTopConstraint;
@property (nonatomic,strong)  NSArray                        * colors;
@property (nonatomic, weak)   IBOutlet UISegmentedControl    * segmentControl;
@property (nonatomic, strong) NSNumber                       * forGroup;
@property (nonatomic, strong) UIBarButtonItem                * done;
@property (nonatomic, strong) NSString                       * groupImageURL;
@property (nonatomic, strong) NSNumber                       * forGroupAddition;
@property (nonatomic, strong) NSMutableArray                 * contactsInGroup;
@property (nonatomic, assign) id <ALContactDelegate> delegate;
@property (nonatomic) BOOL directContactVCLaunch;
@property(nonatomic,strong) ALMessage                        * alMessage;

- (IBAction)segmentControlAction:(id)sender;
- (UIView *)setCustomBackButton:(NSString *)text;

/* - - - */

@end
