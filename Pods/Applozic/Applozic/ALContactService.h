//
//  ALContactService.h
//  ChatApp
//
//  Created by Devashish on 23/10/15.
//  Copyright © 2015 AppLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALContact.h"
#import "DB_CONTACT.h"



@interface ALContactService : NSObject



-(BOOL)purgeListOfContacts:(NSArray *)contacts;

-(BOOL)purgeContact:(ALContact *)contact;

-(BOOL)purgeAllContact;

-(BOOL)updateListOfContacts:(NSArray *)contacts;

-(BOOL)updateContact:(ALContact *)contact;

-(BOOL)addListOfContacts:(NSArray *)contacts;

-(BOOL)addContact:(ALContact *)userContact;

- (ALContact *)loadContactByKey:(NSString *) key value:(NSString*) value;

- (ALContact *)loadOrAddContactByKeyWithDisplayName:(NSString *) contactId value:(NSString*) displayName;

- (void) insertInitialContacts;

-(BOOL)setUnreadCountInDB:(ALContact*)contact;

-(NSNumber *)getOverallUnreadCountForContact;

-(BOOL) isContactExist:(NSString *) value;

@end
