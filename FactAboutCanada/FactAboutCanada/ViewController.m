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

static NSString * const WebserviceConnection = @"https://dl.dropboxusercontent.com/u/746330/facts.json";
const CGFloat MaxImageWidthRatio = 0.35;

@interface ViewController ()
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

#pragma mark - functions
- (void)requestWebservice{
    WebserviceClient * client = [[WebserviceClient alloc]init];
    [client requestWithConnection:WebserviceConnection completionHandler:^(NSDictionary *result) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if([result valueForKey:@"title"]){
                //update navigation item title with response
                self.navigationItem.title = [NSString stringWithFormat:@"%@", [result valueForKey:@"title"]];
            }
            
            if([result valueForKey:@"rows"]){
                // 1. create objects based on responsed array
                for(NSDictionary * dictionary in (NSArray *)[result valueForKey:@"rows"]){
                    if([dictionary valueForKey:@"title"] != [NSNull null]){
                        Fact * fact = [[Fact alloc] initWithDictionary:dictionary];
                    
                        if([self.facts containsObject:fact] == NO){
                            // 2. if array doesn't contains the object, add object to array
                            [self.facts addObject:fact];
                        }else{
                            // 3. else if object exists in array, update object if it has new content or image url
                            [self.facts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if([[obj valueForKey:@"title"] isEqualToString:[dictionary valueForKey:@"title"]]){
                                    Fact * existObject = (Fact *)obj;
                                    [existObject updateWithDictionary:dictionary];
                                    *stop = YES;
                                }
                            }];
                        }
                    }
                }
            }
            
            // 4. when finish loading, update tableview with array
            [self.tableView reloadData];
            // 5. end refresh control
            if(self.refreshControl.isRefreshing){
                [self.refreshControl endRefreshing];
            }
        });
    }];
}

#pragma mark - Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _facts.count;
}

#pragma mark - Tableview delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Fact * fact = [self.facts objectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    CGFloat margin = [[UIScreen mainScreen] bounds].size.height < 667 ? 10 : 8;
    
    if(fact.imageData){
        // if object has image, layout image with title and content
        height += margin * 2;
        
        UIImage * image = [UIImage imageWithData:fact.imageData];
        
        // set max image width
        // if image width great than max width, using the max width
        // if image width less than max width, using the image width
        CGFloat imageWidth = 0;
        if (image.size.width > cell.contentView.frame.size.width * MaxImageWidthRatio){
            imageWidth = cell.contentView.frame.size.width * MaxImageWidthRatio;
        }else{
            imageWidth = image.size.width;
        }

        //1. calculate title height
        if(fact.title){
            NSDictionary * titleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            CGRect titleRect = [fact.title boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - imageWidth - 3 * margin, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:titleAttributes
                                                   context:nil];
            height += titleRect.size.height;
            height += margin;
        }
        
        //2. calculate content height
        if(fact.content){
            NSDictionary * contentAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
            CGRect contentRect = [fact.content boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - imageWidth - 3 * margin, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes: contentAttributes
                                                     context:nil];
            height += contentRect.size.height;
            height += margin;
        }
    }else{
        //1. calculate title height
        if(fact.title){
            NSDictionary *titleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            CGRect titleRect = [fact.title boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - 2 * margin, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:titleAttributes
                                                   context:nil];
            height += titleRect.size.height;
            height += margin * 2;
        }
        
        //2. calculate content height
        if(fact.content){
            NSDictionary * contentAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
            CGRect contentRect = [fact.content boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - 3 * margin, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes: contentAttributes
                                                     context:nil];
            height += contentRect.size.height;
            height += margin;
        }
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    Fact * fact = [self.facts objectAtIndex:indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = fact.title;
    
    if(fact.content){
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text = fact.content;
    }
    
    if(fact.imageData){
        // draw image in certain frame
        UIImage * image = [UIImage imageWithData:fact.imageData];
        CGFloat imageWidth = 0;
        CGFloat imageHeight = 0;
        if (image.size.width > cell.contentView.frame.size.width * MaxImageWidthRatio){
            // if image's width is great than certain width, shrink it to max width
            imageWidth = cell.contentView.frame.size.width * MaxImageWidthRatio;
            imageHeight = (image.size.height * cell.contentView.frame.size.width * MaxImageWidthRatio) / image.size.width;
        }else{
            // else keep image's original size
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
            // request image with object's image url
            WebserviceClient * client = [[WebserviceClient alloc]init];
            [client requestImageWithObject:fact];
        }];
    }

    return cell;
}

#pragma mark - NSKeyValueObserving. observer for Fact object set image
- (void)observeValueForKeyPath:(NSString *)keyPath
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
                cell.imageView.image = [UIImage imageWithData:fact.imageData];
                if([self.tableView.visibleCells containsObject:cell]){
                    // if cell's visible, reload the cell with image
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                }
                
            });
        }
    }
}

@end






























