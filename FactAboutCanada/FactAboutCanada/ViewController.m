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
#define MAX_IMAGE_WIDTH 0.35 // max percent of imageview width

@interface ViewController ()

#pragma mark - properties
@property (nonatomic, strong) NSMutableArray * facts;

@end

@implementation ViewController

#pragma mark - view life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register uitableviewcell with identifier
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
    
    // initialize array
    _facts = [[NSMutableArray alloc] init];

    // make request when view did load
    [self requestWebservice];
    
    // add refresh control for further request
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(requestWebservice)
                  forControlEvents:UIControlEventValueChanged];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Fact * fact = [self.facts objectAtIndex:indexPath.row];
    CGFloat height = 0; //initalize return value 0
    
    if(fact.image){
        // if object has image, layout image with title and content
        // 1. add margin
        height += cell.contentView.layoutMargins.top;
        height += cell.contentView.layoutMargins.bottom;
        
        UIImage * image = [UIImage imageWithData:fact.image];
        
        CGFloat imageWidth = 0; // set max image width
        if (image.size.width > cell.contentView.frame.size.width * MAX_IMAGE_WIDTH){
            // 2. if image width great than max width, using the max width
            imageWidth = cell.contentView.frame.size.width * MAX_IMAGE_WIDTH;
        }else{
            // 3. if image width less than max width, using the image width
            imageWidth = image.size.width;
        }

        //1. calculate title height
        if(fact.title){
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            CGRect rect = [fact.title boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - imageWidth - 48, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributes
                                                   context:nil];
            height += rect.size.height;
            
            // add margin
            height += cell.textLabel.layoutMargins.top;
            height += cell.textLabel.layoutMargins.bottom;
        }
        
        //2. calculate content height
        if(fact.content){
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
            CGRect rect = [fact.content boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - imageWidth - 48, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes
                                                     context:nil];
            height += rect.size.height;
            
            // add margin
            height += cell.detailTextLabel.layoutMargins.top;
            height += cell.detailTextLabel.layoutMargins.bottom;
        }
    }else{
        //1. calculate title height
        if(fact.title){
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            CGRect rect = [fact.title boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - 32, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributes
                                                   context:nil];
            height += rect.size.height;
        }
        
        //2. calculate content height
        if(fact.content){
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
            CGRect rect = [fact.content boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - 32, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes
                                                     context:nil];
            height += rect.size.height;
            
            // add margin
            height += cell.detailTextLabel.layoutMargins.top;
            height += cell.detailTextLabel.layoutMargins.bottom;
        }
        
        // add margin
        height += cell.contentView.layoutMargins.top;
        height += cell.contentView.layoutMargins.bottom;
        
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    Fact * fact = [self.facts objectAtIndex:indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = fact.title;
    if(fact.content){
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text = fact.content;
    }
    
    if(fact.image){
        UIImage * image = [UIImage imageWithData:fact.image];
        //CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageWidth = 0;
        CGFloat imageHeight = 0;
        if (image.size.width > cell.contentView.frame.size.width * MAX_IMAGE_WIDTH){
            imageWidth = cell.contentView.frame.size.width * MAX_IMAGE_WIDTH;
            imageHeight = (image.size.height * cell.contentView.frame.size.width * MAX_IMAGE_WIDTH) / image.size.width;
        }else{
            imageWidth = image.size.width;
            imageHeight = image.size.height;
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
        [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }else if(fact.imageHref){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [fact addObserver:self forKeyPath:@"image"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
            [fact requestImage];
        }];
    }


    return cell;
}

#pragma mark - observer for Fact object set image
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([object isMemberOfClass:[Fact class]] && [keyPath isEqualToString:@"image"]){
        Fact * fact = (Fact *)object;
        
        NSUInteger row = [self.facts indexOfObject:fact];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if(cell){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //display image with animations
                cell.imageView.image = [UIImage imageWithData:fact.image];
                if([self.tableView.visibleCells containsObject:cell]){
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                }
                
            });
        }
    }
}

@end






























