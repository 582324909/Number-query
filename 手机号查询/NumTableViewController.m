//
//  NumTableViewController.m
//  手机号查询
//
//  Created by 张伟伟 on 2016/11/22.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "NumTableViewController.h"
#import "AFNetworking.h"

static NSString *key = @"fc595eb36ca0";

@interface NumTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *num;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *cityCode;
@property (weak, nonatomic) IBOutlet UILabel *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *operator;

@end

@implementation NumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)searchClick:(id)sender
{
    [self checkNum];
}

-(void)checkNum
{
    if (self.num.text ==nil || self.num.text.length < 1) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
    }else {
        [self searchNum];
    }
}

-(void)searchNum
{
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"http://apicloud.mob.com/v1/mobile/address/query?key=%@&phone=%@",key,self.num.text];
    NSDictionary *parameters = [NSDictionary dictionary];
    parameters = @{@"key":key,@"phone":self.num.text};
    
    [httpSession GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.city.text = [NSString stringWithFormat:@"%@  %@",dic[@"result"][@"province"],dic[@"result"][@"city"]];
        self.cityCode.text = dic[@"result"][@"cityCode"];
        self.zipCode.text = dic[@"result"][@"zipCode"];
        self.operator.text = dic[@"result"][@"operator"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
