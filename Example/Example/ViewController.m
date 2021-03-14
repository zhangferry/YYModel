//
//  ViewController.m
//  Example
//
//  Created by zhangferry on 2021/3/14.
//

#import "ViewController.h"
#import <YYModel/YYModel.h>
#import "GitHubUser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self parseData];
}

- (void)parseData {
    /// get json data
    NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    GitHubUser *user = [GitHubUser yy_modelWithJSON:json];
    NSLog(@"%@", user);
    
    NSDictionary *dic = @{@"company": user.company,
                          @"email"  : user.email,
                          @"customArray": user.customArray,
                          @"customInterger": [NSString stringWithFormat:@"%ld", (long)user.customInteger]
    };
    NSLog(@"%@", dic);
}

@end
