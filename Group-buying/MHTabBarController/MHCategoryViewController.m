//
//  ViewController.m
//  MHTabBar
//
//  Created by Tarena on 15/1/14.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import "MHCategoryViewController.h"
#define LeftWidth 32*5
#define RightWidth 32*5
#define TableViewHeight 260
#define TABBAR_HEIGHT 44
#define TOPIC_COLOR [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]
#define TEXT_COLOR_WHITE [UIColor whiteColor]
#define MENU_COLOR_LightGray [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
#define MENU_TEXT_DeepGray [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]
#define MENU_TEXT_FONT [UIFont fontWithName:@"黑体-简" size:11]

@interface MHCategoryViewController ()
@property(copy,nonatomic)NSString * selectKey;
@end

@implementation MHCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//左侧tableview
    self.selectKey = 0;
    self.dataDict= [[NSMutableDictionary alloc] init];
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LeftWidth, TableViewHeight) style:UITableViewStylePlain];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    [self.view addSubview:self.leftTableView];
    //右侧tableview
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(LeftWidth, 0, RightWidth, TableViewHeight) style:UITableViewStylePlain];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    [self.view addSubview:self.rightTableView];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return [self.dataDict allKeys].count;
    }
    else {
        return [[self.dataDict objectForKey:self.selectKey] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if (tableView == self.leftTableView) {
        NSString *currentKey;
        if (indexPath.row == 0) {
            currentKey = self.title;
        }
        else{
            currentKey = [[self.dataDict allKeys] objectAtIndex:indexPath.row-1];
        }
        cell.textLabel.text = currentKey;
        NSArray *currentArray=[self.dataDict objectForKey:currentKey];
        if ([currentArray count]>0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)currentArray.count];
        }
        [tableView setSeparatorColor:[UIColor clearColor]];
        [self setLeftCellStyle:cell];
    }
    else if (tableView == self.rightTableView)
    {
        NSArray *valueArray =[self.dataDict objectForKey:self.selectKey];
        cell.textLabel.text = [valueArray objectAtIndex:indexPath.row];
        [self setRightCellStyle:cell];
    }
    cell.textLabel.textColor = MENU_TEXT_DeepGray;
    cell.textLabel.font = MENU_TEXT_FONT;
    cell.detailTextLabel.font = MENU_TEXT_FONT;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.leftTableView)
    {
        self.selectKey = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        if ([[self.dataDict objectForKey:self.selectKey] count] == 0) {
            self.selectedText = self.selectKey;
        }
        [self.rightTableView reloadData];
    }
    if(tableView == self.rightTableView)
    {
        self.selectedText = [[self.dataDict objectForKey:self.selectKey] objectAtIndex:indexPath.row];
    }
}

//左侧cell
- (void) setLeftCellStyle:(UITableViewCell *) cell
{
    UIView *selectionColor = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 2)];
    selectionColor.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = selectionColor;
    cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
}


//右侧
- (void) setRightCellStyle:(UITableViewCell *) cell
{
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectionColor;
    cell.textLabel.highlightedTextColor = TOPIC_COLOR;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
