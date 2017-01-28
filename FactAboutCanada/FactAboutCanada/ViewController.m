//
//  ViewController.m
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray * facts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register uitableviewcell with identifier
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // initialize array
    _facts = [[NSMutableArray alloc] init];
}

#pragma mark - Tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _facts.count;
}

#pragma mark - Tableview delegates
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    return cell;
}

@end
