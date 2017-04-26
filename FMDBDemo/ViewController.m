//
//  ViewController.m
//  FMDBDemo
//
//  Created by happi on 2017/4/26.
//  Copyright © 2017年 xishan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    BOOL isUpdateTables;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(UIButton *)sender {
    if (!isUpdateTables) {
        DatabaseCenter *db = [[DatabaseCenter alloc] init];
        if ([db getDB]) {
            [db insertUser:@"呵呵" Age:18 Sex:@"男的"];
            [db closeDB];
        }
    } else {
        DatabaseCenter *db = [[DatabaseCenter alloc] init];
        if ([db getDB]) {
            [db insertUser:@"☺️😝" Age:22 Sex:@"女的" Height:1.76 Weight:55.34 Autograph:@"我就是我 一样的烟火"];
            [db closeDB];
        }
    }
    
}
- (IBAction)det:(UIButton *)sender {
    DatabaseCenter *db = [[DatabaseCenter alloc] init];
    if ([db getDB]) {
        [db deleteUserID:1];
        [db closeDB];
    }
}
- (IBAction)update:(UIButton *)sender {
    DatabaseCenter *db = [[DatabaseCenter alloc] init];
    if ([db getDB]) {
        [db updateUserName:@"呵呵" Age:33];
        [db closeDB];
    }
}
- (IBAction)select:(UIButton *)sender {
    NSMutableArray *users;
    DatabaseCenter *db = [[DatabaseCenter alloc] init];
    if ([db getDB]) {
        users = [db getUser];
        [db closeDB];
    }
    NSLog(@"user=>%@",users);
}
- (IBAction)updateTable:(UIButton *)sender {
    
//    DatabaseCenter *db = [[DatabaseCenter alloc] init];
//    if ([db getDB]) {
//        [db updateTables];
//        [db closeDB];
//        isUpdateTables = YES;
//    }
    
}



@end
