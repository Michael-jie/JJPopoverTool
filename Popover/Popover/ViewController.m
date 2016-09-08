//
//  ViewController.m
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "JJPopoverTool.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreItem;
@property (weak, nonatomic) IBOutlet UIButton *a;
@property (weak, nonatomic) IBOutlet UIButton *b;
@property (weak, nonatomic) IBOutlet UIButton *c;
@property (weak, nonatomic) IBOutlet UIButton *d;
@property (weak, nonatomic) IBOutlet UIButton *e;

@property (weak, nonatomic)  UITableView *tableView;
@end

@implementation ViewController

- (IBAction)moreClick:(UIButton *)sender {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 44 * 3)];
    tableView.dataSource =self;
    tableView.delegate = self;
    [JJPopoverTool presentContentView:tableView
                            pointToItem:sender
                            passThroughViews:@[self.a, self.b]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.textLabel.text = @"测试123";
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [JJPopoverTool dismiss];
}

- (IBAction)a:(UIButton *)sender {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 44 * 3)];
    tableView.dataSource =self;
    tableView.delegate = self;
    
    [JJPopoverTool presentContentView:tableView pointToItem:sender passThroughViews:@[self.moreItem.customView]];
}

- (IBAction)b:(UIButton *)sender {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 44 * 3)];
    tableView.dataSource =self;
    tableView.delegate = self;
    
    [JJPopoverTool presentContentView:tableView pointToItem:sender passThroughViews:nil];
}
- (IBAction)c:(UIButton *)sender {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 44 * 3)];
    tableView.dataSource =self;
    tableView.delegate = self;
    
    [JJPopoverTool presentContentView:tableView pointToItem:sender passThroughViews:nil];
}
- (IBAction)d:(UIButton *)sender {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 44 * 3)];
    tableView.dataSource =self;
    tableView.delegate = self;
    
    [JJPopoverTool presentContentView:tableView pointToItem:sender passThroughViews:nil];
}
- (IBAction)e:(UIButton *)sender {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 44 * 3)];
    tableView.dataSource =self;
    tableView.delegate = self;
    
    [JJPopoverTool presentContentView:tableView pointToItem:sender passThroughViews:nil];
}

@end
