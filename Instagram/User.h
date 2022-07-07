//
//  User.h
//  Pods
//
//  Created by Rodjina Pierre Louis on 7/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
//@property (nonatomic, strong)

@property (nonatomic, strong) User *sharedInstance;
@end

NS_ASSUME_NONNULL_END
