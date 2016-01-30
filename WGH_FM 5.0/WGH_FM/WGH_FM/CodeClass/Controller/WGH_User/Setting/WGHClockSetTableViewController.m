//
//  WGHClockSetTableViewController.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHClockSetTableViewController.h"

@interface WGHClockSetTableViewController ()<CZPickerViewDataSource, CZPickerViewDelegate>
//列表Arr
@property(strong,nonatomic)NSArray *array;
//时间picker
@property(strong,nonatomic)UIDatePicker *clockDatePicker;
//重复picker
@property(strong,nonatomic) NSArray *weeks;
@property(strong,nonatomic) NSArray *weeksImages;
@property(strong,nonatomic) CZPickerView *pickerWithImage;
//时间选择Arr
@property(strong,nonatomic)NSMutableArray *weeksArr;
//选中时间
@property(strong,nonatomic)NSDate *selectedDate;

@end
static NSString *const clockCellID=@"clockCellID";
@implementation WGHClockSetTableViewController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self=[super initWithStyle:style]) {
        
        self.navigationItem.title = @"编辑闹钟";
        
        self.array=@[@"时间",@"重复",@"铃声"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
        
        self.weeks = @[@"周一", @"周二", @"周三", @"周四", @"周五",@"周六",@"周日"];
        self.weeksImages = @[[UIImage imageNamed:@"weeks1"], [UIImage imageNamed:@"weeks2"], [UIImage imageNamed:@"weeks3"], [UIImage imageNamed:@"weeks4"], [UIImage imageNamed:@"weeks5"],[UIImage imageNamed:@"weeks6"], [UIImage imageNamed:@"weeks7"]];
        
    }
    return self;
}

-(void)saveAction{
    
    
    
}

- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{
    
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:self.weeks[row]
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return self.weeks[row];
}

- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row {
    if([pickerView isEqual:self.pickerWithImage]) {
        return self.weeksImages[row];
    }
    return nil;
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.weeks.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    DLog(@"%@ is chosen!", self.weeks[row]);
}

-(void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows{
    self.weeksArr = [[NSMutableArray alloc]initWithCapacity:self.weeks.count];
    for(NSNumber *n in rows){
        NSInteger row = [n integerValue];
        DLog(@"%@ is chosen!", self.weeks[row]);
        //加载所选重复时间
        [self.weeksArr addObject:self.weeks[row]];
    }
    DLog(@"%@",self.weeksArr);
    //重新加载
    [self.tableView reloadData];
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    DLog(@"Canceled.");
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    //注册cell
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:clockCellID];
    [self.tableView registerClass:[WGHClockSetTableViewCell class] forCellReuseIdentifier:clockCellID];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.clockDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 160)];
    if (self.selectedDate == nil) {
        self.clockDatePicker.date = [NSDate date];
    }
    else
    {
        self.clockDatePicker.date = self.selectedDate;
    }
    self.clockDatePicker.datePickerMode = UIDatePickerModeTime;
    [self.clockDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    return self.clockDatePicker;
}

-(void)datePickerValueChanged:(id)sender
{
    self.selectedDate = [self.clockDatePicker date];
    DLog(@"date: %@", self.selectedDate);
    [self.tableView reloadData];
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clockCellID forIndexPath:indexPath];
    WGHClockSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clockCellID forIndexPath:indexPath];
    
    // Configure the cell...
    cell.titleLabel.text = self.array[indexPath.row];
    if (indexPath.row == 0) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
        [dateFormatter setDateFormat:@"HH:mm"];
        cell.detailLabel.text = [dateFormatter stringFromDate:self.selectedDate];
    }
    else if (indexPath.row == 1) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSUInteger totalCount = self.weeksArr.count;
        switch (totalCount) {
            case 0:
            {
                cell.detailLabel.text = @"不重复";
                break;
            }
            case 2:
            {
                int weeksDayCount = 0;
                NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
                for (NSString *str in self.weeksArr) {
                    if ([str isEqualToString:@"周六"] || [str isEqualToString:@"周日"]) {
                        weeksDayCount ++;
                    }
                    [weeksStr appendFormat:@" %@",str];
                }
                if (weeksDayCount == 2) {
                    cell.detailLabel.text = @"周末";
                }
                else
                {
                    cell.detailLabel.text = weeksStr;
                }
                break;
            }
            case 5:
            {
                int weeksDayCount = 0;
                NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
                for (NSString *str in self.weeksArr) {
                    if (![str isEqualToString:@"周六"] && ![str isEqualToString:@"周日"]) {
                        weeksDayCount ++;
                    }
                    [weeksStr appendFormat:@" %@",str];
                }
                if (weeksDayCount == 5) {
                    cell.detailLabel.text = @"工作日";
                }
                else
                {
                    cell.detailLabel.text = weeksStr;
                }
                break;
            }
            case 7:
            {
                cell.detailLabel.text = @"每天";
                break;
            }
            default:
            {
                NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
                for (NSString *str in self.weeksArr) {
                    [weeksStr appendFormat:@" %@",str];
                }
                cell.detailLabel.text = weeksStr;
                break;
            }
        }
        /*
        //重复
        if (totalCount == 7) {
            cell.detailLabel.text = @"每天";
        }
        else if(totalCount == 0)
        {
            cell.detailLabel.text = @"不重复";
        }
        else if(totalCount == 5)
        {
            int weeksDayCount = 0;
            NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
            for (NSString *str in self.weeksArr) {
                if (![str isEqualToString:@"周六"] && ![str isEqualToString:@"周日"]) {
                    weeksDayCount ++;
                }
                [weeksStr appendFormat:@" %@",str];
            }
            if (weeksDayCount == 5) {
                cell.detailLabel.text = @"工作日";
            }
            else
            {
                cell.detailLabel.text = weeksStr;
            }
        }
        else
        {
            NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
            for (NSString *str in self.weeksArr) {
                [weeksStr appendFormat:@" %@",str];
            }
            cell.detailLabel.text = weeksStr;
             
        }
         */
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        //重复
        CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"重复设置" cancelButtonTitle:@"取消" confirmButtonTitle:@"确认"];
        picker.delegate = self;
        picker.dataSource = self;
        picker.allowMultipleSelection = YES;
        [picker show];

    }
    else
    {
        
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
