//
//  ShareViewController.m
//  bernievshillary
//
//  Created by Haider Khan on 5/24/16.
//
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup our Facebook Share button here
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentTitle = @"Bernie vs. Hillary Results";
    // TODO : load in results here to content.contentDescription
    
    // Set our image to the content
    FBSDKSharePhoto *sharePhoto = [[FBSDKSharePhoto alloc] init];
    // TODO : set image from resultsController
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = self;
//    dialog.content = content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
