//
//  ALGroupCreationViewController.m
//  Applozic
//
//  Created by Divjyot Singh on 13/02/16.
//  Copyright © 2016 applozic Inc. All rights reserved.
//

//groupNameInput
//groupIcon

#define DEFAULT_GROUP_ICON_IMAGE ([UIImage imageNamed:@"applozic_group_icon.png"])

#import "ALGroupCreationViewController.h"
#import "ALNewContactsViewController.h"
#import "ALChatViewController.h"
#import "ALConnection.h"
#import "ALConnectionQueueHandler.h"
#import "UIImage+Utility.h"
#import "ALApplozicSettings.h"
#import "ALUtilityClass.h"
#import "ALConnection.h"
#import "ALConnectionQueueHandler.h"
#import "ALUserDefaultsHandler.h"
#import "ALImagePickerHandler.h"
#import "ALRequestHandler.h"
#import "ALResponseHandler.h"
#import "ALNotificationView.h"
#import "ALDataNetworkConnection.h"
#import "ALRegisterUserClientService.h"
#import "UIImageView+WebCache.h"
#import "ALContactService.h"

/* - - - */
#import "ALNewContactCell.h"
#import "ALDBHandler.h"
#import "DB_CONTACT.h"
#import "ALContact.h"
#import "ALMessagesViewController.h"
#import "ALColorUtility.h"
#import "ALGroupDetailViewController.h"
#import "ALContactDBService.h"
#import "TSMessage.h"
#import "ALUserService.h"

#define DEFAULT_TOP_LANDSCAPE_CONSTANT -34
#define DEFAULT_TOP_PORTRAIT_CONSTANT  -64

#define SHOW_CONTACTS   101
#define SHOW_GROUP      102


/* - - - */

@interface ALGroupCreationViewController () 

@property (nonatomic,strong)    UIImagePickerController         * mImagePicker;
@property (nonatomic,strong)    NSString                        * mainFilePath;
@property (weak, nonatomic)     IBOutlet UIActivityIndicatorView* activityIndicator;

/* - - - */
@property (strong, nonatomic)   NSMutableArray                  * contactList;
@property (strong, nonatomic)   IBOutlet UISearchBar            * searchBar;
@property (strong, nonatomic)   NSMutableArray                  * filteredContactList;
@property (strong, nonatomic)   NSString                        * stopSearchText;
@property                       NSUInteger                        lastSearchLength;
@property (strong,nonatomic)    NSMutableSet                    * groupMembers;
@property (strong,nonatomic)    ALChannelService                * creatingChannel;
@property (strong,nonatomic)    NSNumber                        * groupOrContacts;
@property (strong, nonatomic)   NSMutableArray                  * alChannelsList;
@property (nonatomic)           NSInteger                         selectedSegment;
@property (strong, nonatomic)   UILabel                         * emptyConversationText;
/* - - - */


@end

@implementation ALGroupCreationViewController{
    //UIBarButtonItem         * nextContacts;
    UIBarButtonItem         * barButtonItem;
}

@synthesize delegate;

- (void)viewDidLoad{
    
    [super viewDidLoad];
    //nextContacts = [[UIBarButtonItem alloc] init];
    //[nextContacts setStyle:UIBarButtonItemStylePlain];
    //[nextContacts setTarget:self];
    //self.navigationItem.rightBarButtonItem = nextContacts;
    if(self.isViewForUpdatingGroup){
        [self setTitle:@"Group Update"];
        //[nextContacts setTitle:@"Update"];
        //[nextContacts setAction:@selector(updateGroupInfo:)];
    }
    else{
        //[nextContacts setTitle:@"Next"];
        //[nextContacts setAction:@selector(launchContactSelection:)];
    }
    self.automaticallyAdjustsScrollViewInsets = NO; //setting to NO helps show UITextView's text at view load
    [self setupGroupIcon];
    self.mImagePicker                   = [[UIImagePickerController alloc] init];
    self.mImagePicker.delegate          = self;
    self.mImagePicker.allowsEditing     = YES;
    self.mImagePicker.navigationBar.tintColor    = [UIColor whiteColor];
    self.mImagePicker.navigationBar.barTintColor = [UIColor colorWithRed:218.0/255.0 green:67.0/255.0 blue:20.0/255.0 alpha:1.0];
    
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.loadingIndicator setHidesWhenStopped:YES];
    
    /* - - - */
    [[self loadingIndicator] startAnimating];
    self.selectedSegment = 0;
    self.contactList     = [NSMutableArray new];
    [self handleFrameForOrientation];
    
    [self.searchBar setImage:[UIImage imageNamed:@"search_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [self.searchBar setUserInteractionEnabled:NO];
    [self.searchBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.backgroundColor = [UIColor whiteColor];
        [((UIView*)obj).subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            
            NSLog(@"%@", obj1);
            obj1.backgroundColor = [UIColor whiteColor];
            
        }];
        
    }];
    if([ALApplozicSettings getFilterContactsStatus])
    {
        ALUserService * userService = [ALUserService new];
        [userService getListOfRegisteredUsersWithCompletion:^(NSError *error) {
            
            [self.searchBar setUserInteractionEnabled:YES];
            if(error)
            {
                [self.loadingIndicator stopAnimating];
                [self.emptyConversationText setHidden:NO];
                [self.emptyConversationText setText:@"Unable to fetch contacts"];
                [self onlyGroupFetch];
                return;
            }
            [self subProcessContactFetch];
        }];
    }
    else if([ALApplozicSettings getOnlineContactLimit]){
        [self processFilterListWithLastSeen];
        [self onlyGroupFetch];
        [self.searchBar setUserInteractionEnabled:YES];
    }
    else{
        [self subProcessContactFetch];
        [self.searchBar setUserInteractionEnabled:YES];
    }
    
    barButtonItem       = [[UIBarButtonItem alloc] initWithCustomView:[self setCustomBackButton:@"Back"]];
    self.colors         = [[NSArray alloc] initWithObjects:@"#617D8A",@"#628B70",@"#8C8863",@"8B627D",@"8B6F62", nil];
    self.groupMembers   = [[NSMutableSet alloc] init];
    //[self emptyConversationAlertLabel];
    _contactsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    /* - - - */

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.groupNameInput becomeFirstResponder];
    self.descriptionTextView.hidden                 = NO;
    self.descriptionTextView.userInteractionEnabled = NO;
    [self.tabBarController.tabBar setHidden:YES];
    // self.alNewContactViewController.delegateGroupCreation = self;
    
    
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithRed:218.0/255.0 green:67.0/255.0 blue:20.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor: [UIColor redColor]];
    
    /* - - - */
    self.groupOrContacts = [NSNumber numberWithInt:SHOW_CONTACTS]; //default
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"Contacts";
    [self.tabBarController.tabBar setHidden: [ALUserDefaultsHandler isBottomTabBarHidden]];
    BOOL groupRegular = [self.forGroup isEqualToNumber:[NSNumber numberWithInt:REGULAR_CONTACTS]];
    if((!groupRegular && self.forGroup != NULL)){
        [self updateView];
    }
    
    if(![ALApplozicSettings getGroupOption]){
        [self.navigationItem setTitle:@"Contacts"];
        [self.segmentControl setSelectedSegmentIndex:0];
        [self.segmentControl setHidden:YES];
    }
    
    [self.navigationItem setLeftBarButtonItem: barButtonItem];
    float y = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    self.searchBar.frame = CGRectMake(0,y, self.view.frame.size.width, 40);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUser:) name:@"USER_DETAIL_OTHER_VC" object:nil];
    /* - - - */
}

/* - - - */
-(void) viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden: NO];
    //self.forGroup = [NSNumber numberWithInt:0];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_DETAIL_OTHER_VC" object:nil];
}
/* - - - */

#pragma mark - NAVIGATION RIGHT BUTTON SELECTORS : CREATION/UPDATE

- (void)launchContactSelection:(id)sender{
    
    // Check if group name text is empty //
    if([self.groupNameInput.text isEqualToString:@""]){
        
        UIAlertController   * alertController = [UIAlertController alertControllerWithTitle:@"Group Name" message:@"Please give the group name." preferredStyle:UIAlertControllerStyleAlert];
        [ALUtilityClass setAlertControllerFrame:alertController andViewController:self];
        UIAlertAction       * okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    // Moving forward to member selection //
    UIStoryboard     * storyboard       = [UIStoryboard storyboardWithName:@"Applozic" bundle:[NSBundle bundleForClass:ALGroupCreationViewController.class]];
    UIViewController * groupCreation    = [storyboard instantiateViewControllerWithIdentifier:@"ALNewContactsViewController"];
    
    // Setting groupName and forGroup flag //
    ((ALNewContactsViewController *)groupCreation).forGroup         = [NSNumber numberWithInt:GROUP_CREATION];
    ((ALNewContactsViewController *)groupCreation).groupName        = self.groupNameInput.text;
    ((ALNewContactsViewController *)groupCreation).groupImageURL    = self.groupImageURL;
    
    //Moving to contacts view for group member selection //
    [self.navigationController pushViewController:groupCreation animated:YES];
}

- (void)updateGroupInfo:(id)sender{
    
    if(!self.groupNameInput.text.length && !self.groupImageURL.length){
        [ALUtilityClass showAlertMessage:@"You haven't update anything" andTitle:@"Wait!!!"];
        return;
    }
    [self.loadingIndicator startAnimating];
    ALChannelService * channelService = [ALChannelService new];
    [channelService updateChannel:self.channelKey andNewName:self.groupNameInput.text
                      andImageURL:self.groupImageURL orClientChannelKey:nil withCompletion:^(NSError *error) {
        
          if(!error){
              
              [ALUtilityClass showAlertMessage:@"Group information successfully updated" andTitle:@"Response"];
              [self.navigationController popViewControllerAnimated:YES];
              [self.grpInfoDelegate updateGroupInformation];
          }
          [self.loadingIndicator stopAnimating];
    }];
}

#pragma mark - GROUP ICON VIEW SETUP

-(void)setupGroupIcon{
    
    dispatch_async(dispatch_get_main_queue(), ^{
          self.groupIconView.layer.cornerRadius = self.groupIconView.frame.size.width/2;
          self.groupIconView.layer.masksToBounds = YES;
          self.groupIconView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    });
    
    UITapGestureRecognizer * singleTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage)];
    singleTap.numberOfTapsRequired      = 1;
    [self.groupIconView addGestureRecognizer:singleTap];
}

-(void)uploadImage{
    
    UIAlertController * alertController     = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ALUtilityClass setAlertControllerFrame:alertController andViewController:self];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self uploadByPhotos];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self uploadByCamera];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)uploadByPhotos{
    
    self.mImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.mImagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self presentViewController:self.mImagePicker animated:YES completion:nil];
}

-(void)uploadByCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted){
                    self.mImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.mImagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                    [self presentViewController:self.mImagePicker animated:YES completion:nil];
                }
                else{
                    [ALUtilityClass permissionPopUpWithMessage:@"Enable Camera Permission" andViewController:self];
                }
            });
        }];
    }
    else{
        [ALUtilityClass showAlertMessage:@"Camera is not Available !!!" andTitle:@"OOPS !!!"];
    }
}

#pragma mark - IMAGE PICKER DELEGATES

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * rawImage          = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage * normalizedImage   = [ALUtilityClass getNormalizedImage:rawImage];
    [self.groupIconView setImage:normalizedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.mainFilePath           = [self getImageFilePath:normalizedImage];
    [self confirmUserForGroupImage:normalizedImage];
}

-(NSString *)getImageFilePath:(UIImage *)image{
    NSString * filePath = [ALImagePickerHandler saveImageToDocDirectory:image];
    return filePath;
}

-(void)confirmUserForGroupImage:(UIImage *)image{
    
    image = [image getCompressedImageLessThanSize:1];
    UIAlertController * alert  = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure to upload?" preferredStyle:UIAlertControllerStyleAlert];
    [ALUtilityClass setAlertControllerFrame:alert andViewController:self];
    
    UIAlertAction     * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self.groupIconView setImage:DEFAULT_GROUP_ICON_IMAGE];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* upload = [UIAlertAction actionWithTitle:@"Upload" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if(![ALDataNetworkConnection checkDataNetworkAvailable]){
            ALNotificationView * notification = [ALNotificationView new];
            [notification noDataConnectionNotificationView];;
            return;
        }
        
        NSString * uploadUrl     = [KBASE_URL stringByAppendingString:IMAGE_UPLOAD_URL];
        self.groupImageUploadURL = uploadUrl;
        //TODO: Call From Delegate !!
        [self proessUploadImage:image uploadURL:uploadUrl withdelegate:self];
    }];
    
    [alert addAction:cancel];
    [alert addAction:upload];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)proessUploadImage:(UIImage *)profileImage uploadURL:(NSString *)uploadURL withdelegate:(id)delegate{
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.activityIndicator startAnimating];
    NSString *filePath = self.mainFilePath;
    NSMutableURLRequest * request = [ALRequestHandler createPOSTRequestWithUrlString:uploadURL paramString:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        //Create boundary, it can be anything //
        NSString *boundary = @"------ApplogicBoundary4QuqLuM1cE5lMwCy";
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        // post body
        NSMutableData *body = [NSMutableData data];
        NSString *FileParamConstant = @"file";
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
        NSLog(@"IMAGE_DATA :: %f",imageData.length/1024.0);
        
        //Assuming data is not nil we add this to the multipart form //
        if (imageData){
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", FileParamConstant, @"imge_123_profile"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type:%@\r\n\r\n", @"image/jpeg"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //Close off the request with the boundary //
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the request //
        [request setHTTPBody:body];
        // Set URL //
        [request setURL:[NSURL URLWithString:uploadURL]];
        ALConnection * connection = [[ALConnection alloc] initWithRequest:request delegate:delegate startImmediately:YES];
        connection.connectionType = CONNECTION_TYPE_GROUP_IMG_UPLOAD;
        [[[ALConnectionQueueHandler sharedConnectionQueueHandler] getCurrentConnectionQueue] addObject:connection];
        
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [self.activityIndicator stopAnimating];
        UIAlertController   * alert     = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Unable to locate file on device" preferredStyle:UIAlertControllerStyleAlert];
        [ALUtilityClass setAlertControllerFrame:alert andViewController:self];
        UIAlertAction       * cancel    = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma NSURL CONNECTION DELEGATES + HELPER METHODS

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"GROUP_IMAGE UPLOAD_ERROR :: %@",error.description);
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.activityIndicator stopAnimating];
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    NSLog(@"GROUP_IMAGE UPLOAD PROGRESS :: %lu out of %lu",totalBytesWritten,totalBytesExpectedToWrite);
}

-(void)connectionDidFinishLoading:(ALConnection *)connection{
    
    NSLog(@"CONNNECTION_FINISHED");
    [[[ALConnectionQueueHandler sharedConnectionQueueHandler] getCurrentConnectionQueue] removeObject:connection];
    if([connection.connectionType isEqualToString:CONNECTION_TYPE_GROUP_IMG_UPLOAD]){
        
        NSString * imageLinkFromServer  = [[NSString alloc] initWithData:connection.mData encoding:NSUTF8StringEncoding];
        NSLog(@"GROUP_IMAGE_LINK :: %@",imageLinkFromServer);
        self.groupImageURL              = imageLinkFromServer;
    }
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.activityIndicator stopAnimating];
}

-(void)connection:(ALConnection *)connection didReceiveData:(NSData *)data{
    
    [connection.mData appendData:data];
}





-(void)subProcessContactFetch
{
    ALChannelDBService * alChannelDBService = [[ALChannelDBService alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchConversationsGroupByContactId];
        self.alChannelsList = [NSMutableArray arrayWithArray:[alChannelDBService getAllChannelKeyAndName]];
    });
}

-(void)onlyGroupFetch
{
    ALChannelDBService * alChannelDBService = [[ALChannelDBService alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alChannelsList = [NSMutableArray arrayWithArray:[alChannelDBService getAllChannelKeyAndName]];
    });
}

- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
}


- (void)updateView
{
    [self.tabBarController.tabBar setHidden:YES];
    [self.segmentControl setSelectedSegmentIndex:0];
    [self.segmentControl setHidden:YES];
    
    self.contactsTableView.editing=YES;
    self.contactsTableView.allowsMultipleSelectionDuringEditing = YES;
    
    /*BOOL groupCreation = [self.forGroup isEqualToNumber:[NSNumber numberWithInt:GROUP_CREATION]];
    if (groupCreation)
    {
        self.contactsTableView.editing=YES;
        self.contactsTableView.allowsMultipleSelectionDuringEditing = YES;
        self.done = [[UIBarButtonItem alloc]
                     initWithTitle:@"Done"
                     style:UIBarButtonItemStylePlain
                     target:self
                     action:@selector(createNewGroup:)];
        
        self.navigationItem.rightBarButtonItem = self.done;
    }*/
}
-(IBAction)createNewGroupAction:(id)sender{
    
    if(![ALDataNetworkConnection checkDataNetworkAvailable]){
        [self noDataNotificationView];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Applozic"
                                                         bundle:[NSBundle bundleForClass:[self class]]];
    ALGroupCreationViewController * groupCreation = (ALGroupCreationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ALGroupCreationViewController"];
    groupCreation.isViewForUpdatingGroup = NO;
    [self.navigationController pushViewController:groupCreation animated:YES];
    
}

-(void)noDataNotificationView
{
    ALNotificationView * notification = [ALNotificationView new];
    [notification noDataConnectionNotificationView];
}

-(void)updateUser:(NSNotification *)notifyObj
{
    ALUserDetail *userDetail = (ALUserDetail *)notifyObj.object;
    ALNewContactCell *newContactCell = [self getCell:userDetail.userId];
    if(newContactCell && self.selectedSegment == 0)
    {
        [newContactCell.contactPersonImageView sd_setImageWithURL:[NSURL URLWithString:userDetail.imageLink]];
        newContactCell.contactPersonName.text = [userDetail getDisplayName];
    }
}

-(ALNewContactCell *)getCell:(NSString *)key
{
    int index = (int)[self.filteredContactList indexOfObjectPassingTest:^BOOL(id element, NSUInteger idx, BOOL *stop) {
        
        ALContact *contact = (ALContact *)element;
        if([contact.userId isEqualToString:key])
        {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    ALNewContactCell *contactCell = (ALNewContactCell *)[self.contactsTableView cellForRowAtIndexPath:path];
    
    return contactCell;
}

-(void)emptyConversationAlertLabel
{
    if(self.filteredContactList.count)
    {
        return;
    }
    
    self.emptyConversationText = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                           self.view.frame.origin.y + self.view.frame.size.height/2,
                                                                           self.view.frame.size.width, 30)];
    [self.view addSubview:self.emptyConversationText];
    
    [self setTextForEmpty];
    [self.emptyConversationText setTextAlignment:NSTextAlignmentCenter];
    [self.emptyConversationText setHidden:YES];
}

-(void)setTextForEmpty
{
    NSString *msgText = @"No contact found";
    if(self.selectedSegment == 1)
    {
        msgText = @"No group found";
    }
    [self.emptyConversationText setText:msgText];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactsTableView?1:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = self.filteredContactList.count;
    if(self.selectedSegment == 1)
    {
        count = self.filteredContactList.count;
    }
    if(count == 0)
    {
        if(![self.activityIndicator isAnimating]){
            [self.emptyConversationText setHidden:NO];
            [self setTextForEmpty];
        }
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *individualCellIdentifier = @"NewContactCell";
    ALNewContactCell *newContactCell = (ALNewContactCell *)[tableView dequeueReusableCellWithIdentifier:individualCellIdentifier];
    NSUInteger randomIndex = random()% [self.colors count];
    UILabel* nameIcon = (UILabel*)[newContactCell viewWithTag:101];
    [nameIcon setTextColor:[UIColor whiteColor]];
    [nameIcon setHidden:YES];
    [newContactCell.contactPersonImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    newContactCell.contactPersonName.text = @"";
    [newContactCell.contactPersonImageView setHidden:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        newContactCell.contactPersonImageView.layer.cornerRadius = newContactCell.contactPersonImageView.frame.size.width/2;
        newContactCell.contactPersonImageView.layer.masksToBounds = YES;
    });
    
    [self.emptyConversationText setHidden:YES];
    [self.contactsTableView setHidden:NO];
    
    @try {
        
        switch (self.groupOrContacts.intValue)
        {
            case SHOW_CONTACTS:
            {
                ALContact *contact = (ALContact *)[self.filteredContactList objectAtIndex:indexPath.row];
                newContactCell.contactPersonName.text = [contact getDisplayName];
                
                
                if (contact)
                {
                    if (contact.contactImageUrl)
                    {
                        [newContactCell.contactPersonImageView sd_setImageWithURL:[NSURL URLWithString:contact.contactImageUrl]];
                    }
                    else
                    {
                        [nameIcon setHidden:NO];
                        [newContactCell.contactPersonImageView setImage:[ALColorUtility imageWithSize:CGRectMake(0, 0, 55, 55)
                                                                                        WithHexString:self.colors[randomIndex]]];
                        [newContactCell.contactPersonImageView addSubview:nameIcon];
                        [nameIcon  setText:[ALColorUtility getAlphabetForProfileImage:[contact getDisplayName]]];
                    }
                    
                    if(self.forGroup.intValue == GROUP_ADDITION && [self.contactsInGroup containsObject:contact.userId])
                    {
                        newContactCell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
                        newContactCell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    }
                    else if(self.forGroup.intValue == GROUP_CREATION && [contact.userId isEqualToString:[ALUserDefaultsHandler getUserId]]){
                        [self disableOrRemoveCell:newContactCell];
                    }
                    else
                    {
                        newContactCell.backgroundColor = [UIColor whiteColor];
                        newContactCell.selectionStyle = UITableViewCellSelectionStyleGray ;
                    }
                    
                    for (NSString * userID in  self.groupMembers) {
                        if([userID isEqualToString:contact.userId]){
                            
                            
                            [self.contactsTableView selectRowAtIndexPath:indexPath
                                                                animated:YES
                                                          scrollPosition:UITableViewScrollPositionNone];
                            [self tableView:self.contactsTableView didSelectRowAtIndexPath:indexPath];
                            
                            NSLog(@"SELECTED:%@",contact.userId);
                            
                        }else{
                            NSLog(@"NOT SELECTED :%@",contact.userId);
                        }
                    }
                }
            }break;
            case SHOW_GROUP:
            {
                if(self.filteredContactList.count)
                {
                    ALChannel * channel = (ALChannel *)[self.filteredContactList objectAtIndex:indexPath.row];
                    newContactCell.contactPersonName.text = [channel name];
                    [newContactCell.contactPersonImageView setImage:[UIImage imageNamed:@"applozic_group_icon.png"]];
                    NSURL * imageUrl = [NSURL URLWithString:channel.channelImageURL];
                    if(imageUrl)
                    {
                        [newContactCell.contactPersonImageView sd_setImageWithURL:imageUrl];
                    }
                    [nameIcon setHidden:YES];
                }
                else
                {
                    [self.contactsTableView setHidden:YES];
                    [self.emptyConversationText setHidden:NO];
                    [self setTextForEmpty];
                }
            }break;
            default:
                break;
        }
        
    } @catch (NSException *exception) {
        
        NSLog(@"RAISED_EXP :: %@",exception.description);
    }
    
    
    
    return newContactCell;
}
-(void)disableOrRemoveCell:(ALNewContactCell*)contactCell{
    contactCell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [contactCell setUserInteractionEnabled:NO];
    
}

-(void)maskOutCell:(ALNewContactCell*)contactCell{
    contactCell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    contactCell.selectionStyle = UITableViewCellSelectionStyleNone ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.forGroup.intValue)
    {
        case GROUP_CREATION:
        {
            ALContact *contact = [self.filteredContactList objectAtIndex:indexPath.row];
            [self.groupMembers addObject:contact.userId];
        }break;
        case GROUP_ADDITION:
        {
            if(![self checkInternetConnectivity:tableView andIndexPath:indexPath])
            {
                return;
            }
            
            ALContact * contact = self.filteredContactList[indexPath.row];
            
            if([self.contactsInGroup containsObject:contact.userId])
            {
                return;
            }
            
            [self turnUserInteractivityForNavigationAndTableView:NO];
            [delegate addNewMembertoGroup:contact withCompletion:^(NSError *error, ALAPIResponse *response) {
                
                if(error)
                {
                    [TSMessage showNotificationWithTitle:@"Unable to add new member" type:TSMessageNotificationTypeError];
                    [self setUserInteraction:YES];
                }
                else
                {
                    
                    [self backToDetailView];
                    [self turnUserInteractivityForNavigationAndTableView:YES];
                    [self setUserInteraction:YES];
                }
                
            }];
        }break;
        case IMAGE_SHARE:{
            // TODO : Send Image
            /* ALContact * contact = self.filteredContactList[indexPath.row];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"SHARE_IMAGE" object:contact];
             */
        }break;
        default:
        { //DEFAULT : Launch contact!
            NSNumber * key = nil;
            NSString * userId = @"";
            if(self.selectedSegment == 0)
            {
                ALContact * selectedContact = self.filteredContactList[indexPath.row];
                userId = selectedContact.userId;
            }
            else
            {
                ALChannel * selectedChannel = self.filteredContactList[indexPath.row];
                key = selectedChannel.key;
                userId = nil;
            }
            [self launchChatForContact:userId withChannelKey:key];
        }
            
    }
}

-(void)setUserInteraction:(BOOL)flag
{
    [self.contactsTableView setUserInteractionEnabled:flag];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.forGroup isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        ALContact * contact = [self.filteredContactList objectAtIndex:indexPath.row];
        [self.groupMembers removeObject:contact.userId];
    }
}

-(BOOL)checkInternetConnectivity:(UITableView*)tableView andIndexPath:(NSIndexPath *)indexPath
{
    if(![ALDataNetworkConnection checkDataNetworkAvailable])
    {
        [[self activityIndicator] stopAnimating];
        ALNotificationView * notification = [ALNotificationView new];
        [notification noDataConnectionNotificationView];
        if(tableView)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        return NO;
    }
    return YES;
}

-(void) fetchConversationsGroupByContactId
{
    
    ALDBHandler * theDbHandler = [ALDBHandler sharedInstance];
    
    // get all unique contacts
    
    NSFetchRequest * theRequest = [NSFetchRequest fetchRequestWithEntityName:@"DB_CONTACT"];
    
    [theRequest setReturnsDistinctResults:YES];
    
    if(![ALUserDefaultsHandler getLoginUserConatactVisibility])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId!=%@",[ALUserDefaultsHandler getUserId]];
        [theRequest setPredicate:predicate];
    }
    
    NSArray * theArray = [theDbHandler.managedObjectContext executeFetchRequest:theRequest error:nil];
    
    for (DB_CONTACT *dbContact in theArray)
    {
        
        ALContact *contact = [[ALContact alloc] init];
        
        contact.userId = dbContact.userId;
        contact.fullName = dbContact.fullName;
        contact.contactNumber = dbContact.contactNumber;
        contact.displayName = dbContact.displayName;
        contact.contactImageUrl = dbContact.contactImageUrl;
        contact.email = dbContact.email;
        contact.localImageResourceName = dbContact.localImageResourceName;
        
        [self.contactList addObject:contact];
    }
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.filteredContactList = [NSMutableArray arrayWithArray:[self.contactList sortedArrayUsingDescriptors:descriptors]];
    [self.contactList removeAllObjects];
    self.contactList = [NSMutableArray arrayWithArray:self.filteredContactList];
    
    [[self loadingIndicator] stopAnimating];
    [self.contactsTableView reloadData];
    
}

#pragma mark orientation method
//=============================
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self handleFrameForOrientation];
    
}

-(void)handleFrameForOrientation
{
    UIInterfaceOrientation toOrientation   = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone &&
        (toOrientation == UIInterfaceOrientationLandscapeLeft || toOrientation == UIInterfaceOrientationLandscapeRight))
    {
        self.mTableViewTopConstraint.constant = DEFAULT_TOP_LANDSCAPE_CONSTANT;
    }
    else
    {
        self.mTableViewTopConstraint.constant = DEFAULT_TOP_PORTRAIT_CONSTANT;
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
    ALChatViewController * theVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ALChatViewController"];
    theVC.contactIds = searchBar.text;
}

#pragma mark - Search Bar Delegate Methods -
//========================================
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.stopSearchText = searchText;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getSerachResult:searchText];
    });
    
}

-(void)getSerachResult:(NSString*)searchText
{
    
    if (searchText.length != 0)
    {
        NSPredicate * searchPredicate;
        
        if(self.selectedSegment == 0)
        {
            searchPredicate = [NSPredicate predicateWithFormat:@"email CONTAINS[cd] %@ OR userId CONTAINS[cd] %@ OR contactNumber CONTAINS[cd] %@ OR fullName CONTAINS[cd] %@ OR displayName CONTAINS[cd] %@", searchText, searchText, searchText, searchText,searchText];
        }
        else
        {
            searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
        }
        
        if(self.lastSearchLength > searchText.length)
        {
            NSArray * searchResults;
            if(self.selectedSegment == 0)
            {
                searchResults = [self.contactList filteredArrayUsingPredicate:searchPredicate];
            }
            else
            {
                searchResults = [self.alChannelsList filteredArrayUsingPredicate:searchPredicate];
            }
            [self.filteredContactList removeAllObjects];
            [self.filteredContactList addObjectsFromArray:searchResults];
        }
        else
        {
            NSArray *searchResults;
            if(self.selectedSegment == 0)
            {
                searchResults = [self.contactList filteredArrayUsingPredicate:searchPredicate];
            }
            else
            {
                searchResults = [self.alChannelsList filteredArrayUsingPredicate:searchPredicate];
            }
            [self.filteredContactList removeAllObjects];
            [self.filteredContactList addObjectsFromArray:searchResults];
        }
    }
    else
    {
        [self.filteredContactList removeAllObjects];
        if(self.selectedSegment == 0)
        {
            [self.filteredContactList addObjectsFromArray:self.contactList];
        }
        else
        {
            [self.filteredContactList addObjectsFromArray:self.alChannelsList];
        }
        
    }
    
    self.lastSearchLength = searchText.length;
    [self.contactsTableView reloadData];
}


-(void)back:(id)sender
{
    if(self.directContactVCLaunch)
    {
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIViewController * viewControllersFromStack = [self.navigationController popViewControllerAnimated:YES];
        if(!viewControllersFromStack){
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(void)launchChatForContact:(NSString *)contactId  withChannelKey:(NSNumber*)channelKey
{
    if(self.directContactVCLaunch)  // IF DIRECT CONTACT VIEW LAUNCH FROM ALCHATLAUNCHER
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Applozic"
                                    
                                                             bundle:[NSBundle bundleForClass:ALChatViewController.class]];
        
        ALChatViewController *chatView = (ALChatViewController *) [storyboard instantiateViewControllerWithIdentifier:@"ALChatViewController"];
        chatView.alMessage = self.alMessage;
        chatView.individualLaunch = YES;
        
        switch (self.selectedSegment)
        {
                
            case 0:
            {
                chatView.channelKey = nil;
                chatView.contactIds = contactId;
                [self.navigationController pushViewController:chatView animated:YES];
                [self removeFromParentViewController];
            }
                break;
            case 1:
            {
                chatView.channelKey = channelKey;
                chatView.contactIds = contactId;
                [self.navigationController pushViewController:chatView animated:YES];
                [self removeFromParentViewController];
                
            }
                break;
            default:
                break;
        }
        return;
    }
    
    BOOL isFoundInBackStack = false;
    NSMutableArray *viewControllersFromStack = [self.navigationController.viewControllers mutableCopy];
    for (UIViewController *currentVC in viewControllersFromStack)
    {
        if ([currentVC isKindOfClass:[ALMessagesViewController class]])
        {
            [(ALMessagesViewController*)currentVC setChannelKey:channelKey];
            NSLog(@"IN_NAVIGATION-BAR :: found in backStack .....launching from current vc");
            [(ALMessagesViewController*) currentVC createDetailChatViewController:contactId];
            isFoundInBackStack = true;
        }
    }
    
    if(!isFoundInBackStack)
    {
        NSLog(@"NOT_FOUND_IN_BACKSTACK_OF_NAVIAGTION");
        self.tabBarController.selectedIndex=0;
        UINavigationController * uicontroller =  self.tabBarController.selectedViewController;
        NSMutableArray *viewControllersFromStack = [uicontroller.childViewControllers mutableCopy];
        
        for (UIViewController *currentVC in viewControllersFromStack)
        {
            if ([currentVC isKindOfClass:[ALMessagesViewController class]])
            {
                [(ALMessagesViewController*)currentVC setChannelKey:channelKey];
                NSLog(@"IN_TAB-BAR :: found in backStack .....launching from current vc");
                [(ALMessagesViewController*) currentVC createDetailChatViewController:contactId];
                isFoundInBackStack = true;
            }
        }
    }
    else
    {
        //remove ALNewContactsViewController from back stack...
        
        viewControllersFromStack = [self.navigationController.viewControllers mutableCopy];
        if(viewControllersFromStack.count >=2 &&
           [[viewControllersFromStack objectAtIndex:viewControllersFromStack.count -2] isKindOfClass:[ALNewContactsViewController class]])
        {
            [viewControllersFromStack removeObjectAtIndex:viewControllersFromStack.count -2];
            self.navigationController.viewControllers = viewControllersFromStack;
        }
    }
}

-(UIView *)setCustomBackButton:(NSString *)text
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [ALUtilityClass getImageFromFramworkBundle:@"bbb.png"]];
    [imageView setFrame:CGRectMake(-10, 0, 30, 30)];
    [imageView setTintColor:[UIColor whiteColor]];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - 5, imageView.frame.origin.y + 5 , @"back".length, 15)];
    [label setTextColor: [ALApplozicSettings getColorForNavigationItem]];
    [label setText:text];
    [label sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width + label.frame.size.width, imageView.frame.size.height)];
    view.bounds=CGRectMake(view.bounds.origin.x+8, view.bounds.origin.y-1, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:imageView];
    [view addSubview:label];
    
    UIButton *button=[[UIButton alloc] initWithFrame:view.frame];
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
    
}

#pragma mark- Segment Control
//===========================
- (IBAction)segmentControlAction:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    self.selectedSegment = segmentedControl.selectedSegmentIndex;
    [self.filteredContactList removeAllObjects];
    
    if (self.selectedSegment == 0)
    {
        //toggle the Contacts view to be visible
        self.groupOrContacts = [NSNumber numberWithInt:SHOW_CONTACTS];
        self.filteredContactList = [NSMutableArray arrayWithArray: self.contactList];
    }
    else
    {
        //toggle the Group view to be visible
        self.groupOrContacts = [NSNumber numberWithInt:SHOW_GROUP];
        self.filteredContactList = [NSMutableArray arrayWithArray: self.alChannelsList];
    }
    [self.contactsTableView reloadData];
}

#pragma mark - Create group method

-(IBAction)createNewGroup:(id)sender
{
    if(![self checkInternetConnectivity:nil andIndexPath:nil]){
        return;
    }
    
    [self turnUserInteractivityForNavigationAndTableView:NO];
    
    
    if (self.groupNameInput.text == @"") {
        
        [self turnUserInteractivityForNavigationAndTableView:YES];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Group Title"
                                              message:@"Please enter Group title"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [ALUtilityClass setAlertControllerFrame:alertController andViewController:self];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }

    
    
    //check whether at least two memebers selected
    if(self.groupMembers.count < 2)
    {
        [self turnUserInteractivityForNavigationAndTableView:YES];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Group Members"
                                              message:@"Please select minimum two members"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [ALUtilityClass setAlertControllerFrame:alertController andViewController:self];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }
    
    
    
    //Server Call
    self.creatingChannel = [[ALChannelService alloc] init];
    NSMutableArray * memberList = [NSMutableArray arrayWithArray:self.groupMembers.allObjects];
    [self.creatingChannel createChannel:self.groupNameInput.text orClientChannelKey:nil andMembersList:memberList andImageLink:self.groupImageURL
                         withCompletion:^(ALChannel *alChannel) {
                             
                             if(alChannel)
                             {
                                 //Updating view, popping to MessageList View
                                 NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                                 
                                 for (UIViewController *aViewController in allViewControllers)
                                 {
                                     if ([aViewController isKindOfClass:[ALMessagesViewController class]])
                                     {
                                         ALMessagesViewController * messageVC = (ALMessagesViewController *)aViewController;
                                         [messageVC insertChannelMessage:alChannel.key];
                                         [self.navigationController popToViewController:aViewController animated:YES];
                                     }
                                 }
                             }
                             else
                             {
                                 [TSMessage showNotificationWithTitle:@"Unable to create group. Please try again" type:TSMessageNotificationTypeError];
                                 [self turnUserInteractivityForNavigationAndTableView:YES];
                             }
                             
                             [[self activityIndicator] stopAnimating];
                             
                         }];
    
    if(![ALDataNetworkConnection checkDataNetworkAvailable])
    {
        [self turnUserInteractivityForNavigationAndTableView:YES];
    }
}

-(void)turnUserInteractivityForNavigationAndTableView:(BOOL)option
{
    [self.contactsTableView setUserInteractionEnabled:option];
    [[[self navigationController] navigationBar] setUserInteractionEnabled:option];
    [[self searchBar] setUserInteractionEnabled:option];
    [[self searchBar] resignFirstResponder];
    if(option == YES){
        [[self loadingIndicator] stopAnimating];
    }
    else{
        [[self loadingIndicator] startAnimating];
    }
    
}


# pragma mark - Dummy group message method
//========================================
-(void) addDummyMessage:(NSNumber *)channelKey
{
    ALDBHandler * theDBHandler = [ALDBHandler sharedInstance];
    ALMessageDBService* messageDBService = [[ALMessageDBService alloc]init];
    
    ALMessage * theMessage = [ALMessage new];
    theMessage.createdAtTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
    theMessage.deviceKey = [ALUserDefaultsHandler getDeviceKeyString];
    theMessage.sendToDevice = NO;
    theMessage.shared = NO;
    theMessage.fileMeta = nil;
    theMessage.key = @"welcome-message-temp-key-string";
    theMessage.fileMetaKey = @"";//4
    theMessage.contentType = 0;
    theMessage.type = @"101";
    theMessage.message = @"You have created a new group, Say Hi to members :)";
    theMessage.groupId = channelKey;
    theMessage.status = [NSNumber numberWithInt:DELIVERED_AND_READ];
    theMessage.sentToServer = TRUE;
    
    //UI update...
    NSMutableArray* updateArr=[[NSMutableArray alloc] initWithObjects:theMessage, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:updateArr];
    
    //db insertion..
    [messageDBService createMessageEntityForDBInsertionWithMessage:theMessage];
    [theDBHandler.managedObjectContext save:nil];
    
}

#pragma mar - Member Addition to group
//====================================
-(void)backToDetailView{
    
    self.forGroup = [NSNumber numberWithInt:0];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[ALGroupDetailViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
}

-(void)processFilterListWithLastSeen
{
    ALUserService * userService = [ALUserService new];
    [userService fetchOnlineContactFromServer:^(NSMutableArray * array, NSError * error) {
        
        if(error)
        {
            [self.activityIndicator stopAnimating];
            [self.emptyConversationText setHidden:NO];
            [self.emptyConversationText setText:@"Unable to fetch contacts"];
            return;
        }
        
        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastSeenAt" ascending:NO];
        NSArray * descriptors = [NSArray arrayWithObject:sortDescriptor];
        self.filteredContactList = [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:descriptors]];
        NSLog(@"ARRAY_COUNT : %lu",(unsigned long)self.filteredContactList.count);
        [[self activityIndicator] stopAnimating];
        [self.contactsTableView reloadData];
        [self emptyConversationAlertLabel];
        
    }];
}







@end
// TextView     = 100
// ImageView    = 102
// Text Field   = 103
