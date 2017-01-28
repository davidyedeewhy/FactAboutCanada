//
//  ViewController.m
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import "ViewController.h"
#import "WebserviceClient.h"
#import "Fact.h"

#define WEBSERVICE_CONNECTION @"https://dl.dropboxusercontent.com/u/746330/facts.json"

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
    
    // make request when view did load
    [self requestWebservice];
}

-(void)requestWebservice{
    WebserviceClient * client = [[WebserviceClient alloc]init];
    [client requestWithConnection:WEBSERVICE_CONNECTION completionHandler:^(NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if([result valueForKey:@"title"]){
                self.navigationItem.title = [NSString stringWithFormat:@"%@", [result valueForKey:@"title"]];
            }
            
            if([result valueForKey:@"rows"]){
                for(NSDictionary * dictionary in (NSArray *)[result valueForKey:@"rows"]){
                    if([dictionary valueForKey:@"title"] != [NSNull null]){
                        Fact * fact = [[Fact alloc] initWithDictionary:dictionary];
                        if(![self.facts containsObject:fact]){
                            [self.facts addObject:fact];
                        }
                    }
                }
                [self.tableView reloadData];
            }
        });
    }];
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
    
    Fact * fact = [self.facts objectAtIndex:indexPath.row];
    cell.textLabel.text = fact.title;
    cell.detailTextLabel.text = fact.content;
    
    if(fact.image){
        cell.imageView.image = [UIImage imageWithData:fact.image];
    }else if(fact.imageHref){
        WebserviceClient * client = [[WebserviceClient alloc]init];
        [client requestImageWithConnection:fact.imageHref completionHandler:^(NSData *image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
                fact.image = image;
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UITableViewCell * _cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    _cell.imageView.image = [UIImage imageWithData:image];
                    [_cell.imageView setNeedsDisplay];
                });
            });
        }];
    }
    
    return cell;
}

@end






























