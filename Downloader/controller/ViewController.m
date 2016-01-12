//
//  ViewController.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "ViewController.h"
#import "SSFNetWork.h"
#import "AppDelegate+signInAndOut.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)signInButtonPressed:(id)sender {
    [[SSFNetWork sharedNetWork] signInWithEmail:self.nameTextField.text password:self.passwordTextField.text completion:^(NSString *obj,NSData *resumeData) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (dic && [dic[@"response_code"] integerValue] == 100) {
            [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:SIGN_IN_USER_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate showMainTableView];
        }
    }];
}

@end
