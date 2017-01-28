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
@property (nonatomic, strong) NSOperationQueue * operationQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register uitableviewcell with identifier
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // initialize array
    _facts = [[NSMutableArray alloc] init];
    
    self.operationQueue = [[NSOperationQueue alloc]init];
    
    // make request when view did load
    [self requestWebservice];
    
    // add refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(requestWebservice) forControlEvents:UIControlEventValueChanged];
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
                        if([self.facts containsObject:fact] == NO){
                            [self.facts addObject:fact];
                        }
                    }
                }
            }
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
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
        NSOperation * operation = [[NSInvocationOperation alloc]initWithTarget:fact selector:@selector(requestImage) object:nil];
        [self.operationQueue addOperation:operation];
        [fact addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    }

    return cell;
}

- (void) observeValueForKeyPath:(NSString *)path ofObject:(id) object change:(NSDictionary *) change context:(void *)context{

    if ([object isMemberOfClass:[Fact class]] && [path isEqualToString:@"image"]){
        Fact * fact = (Fact *)object;
        NSUInteger row = [self.facts indexOfObject:fact];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if(cell){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                cell.imageView.image = [UIImage imageWithData:fact.image];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            });
        }
    }
}

@end






























