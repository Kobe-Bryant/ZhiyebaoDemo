//
//  PostViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#define KEYBOARD_HEIGHT 216.0


#import "PostViewController.h"
#import "Macros.h"
#import "PublishSellViewController.h"
#import "SystemSetting.h"
#import "Result.h"
#import "ManagerMember.h"
#import "House.h"
#import "NSString+Validator.h"
#import "RentYear.h"
#import "CustomMarcos.h"
#import "DACircularProgressView.h"
#import "AFNetworking.h"




@interface PostViewController ()
{
    UIImage* rentImage;
    UIImage* sellImage;
    UIImageView* rentImageView;
    UIImageView* sellImageView;
    UILabel* moneyLabel;
    UITextField* moneyField;
    UILabel* rentYearLabel;
    UITextField* rentYearField;
    
    

    UILabel* rentLable;
    UILabel* sellLable;
    
    UIScrollView* postSellScrollView;
    
    
    UITextField* areaNameField;
    UITextField* areaField;
    UITextField* numberField;
    UITextField* yearField;
    UITextField* floorField;
    UITextField* direactionField;
    UITextField* typeHouseField;
    UITextField* situationField;
    UITextField* proportionField;
    
    
    //数据源
    NSArray* areaArray;
    NSArray* areaNameArray;
    NSArray* forwardArray;
    NSArray* houseTypeArray;
    NSArray* decorationArray;
    NSArray* facilityArray;
    NSMutableArray* selectedFacilityIDArray;
    NSArray* rentYearArray;
    
    
    
    NSNumber* selectedAreaID;
    NSNumber* selectedAreaNameID;
    NSNumber* selectedForwardID;
    NSNumber* selectedApartmentID;
    NSNumber* selectedDecorationID;
    int selectedRentYearID;
    
    
    
    UIPickerView* areaPickView;
    UIPickerView* areaNamePickView;
    UIPickerView* towardsPickView;
    UIPickerView* apartmentPickView;
    UIPickerView* decorationPickView;
    UIPickerView* yearPickView;
    UIPickerView* rentYearPickView;
    
    
    BOOL isViewWillAppeared;
    NSDate *uploadDate;
    NSInteger imageCount;
    BOOL isShowedKeyboard;
    BOOL isResetingOffset;
    HouseImage* houseImage;
    //装imageView的数组，用于排序
    NSMutableArray* imageViewArray;
    NSMutableArray* imageArray;
    BOOL postImageSuccess;
    dispatch_semaphore_t semaphore;
    
    
    
}

//将需要选择的数据请求下来。
- (void)loadSelectData;

//提交刊登信息
- (void)submitPostRentInfomation:(UIButton *)button;

@end

@implementation PostViewController

@synthesize uploadImageViewArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"PostViewController viewDidLoad");

    self.view.backgroundColor = [UIColor whiteColor];
    
    //将需要选择的数据请求下来。
    [self loadSelectData];
    imageViewArray = [NSMutableArray array];
    imageArray = [NSMutableArray array];
    uploadDate = [NSDate date];
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"PostViewController viewWillAppear");

    
    if (isViewWillAppeared) {
        return;
    } else {
        isViewWillAppeared = YES;
    }
    
    self.mainScrollview.frame = CGRectMake(0.0,
                                           0.0,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height);
    self.mainScrollview.contentSize = CGSizeMake(self.view.frame.size.width, 1100.0);
    self.mainScrollview.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
    self.mainScrollview.delegate = self;
    
    
    
    self.pictureView.layer.cornerRadius = 8.0;
    [self.pictureView.layer setBorderWidth:0.5];
    [self.pictureView.layer setBorderColor:UIColorFromRGB(185.0, 185.0, 185.0).CGColor];
    
    self.uploadImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(takePhoto:)];
    tapGestureRecongnizer.numberOfTapsRequired = 1;
    tapGestureRecongnizer.numberOfTouchesRequired = 1;
    [self.uploadImage addGestureRecognizer:tapGestureRecongnizer];
    
    
    

    
    UIImage* selectAreaImage = [UIImage imageNamed:@"selectAreaImage.png"];
    UIImageView* selectAreaImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                        (self.pictureView.frame.origin.x,
                                         190.0+25.0,
                                         selectAreaImage.size.width ,
                                         selectAreaImage.size.height)];
    selectAreaImageView.image = selectAreaImage;
    selectAreaImageView.userInteractionEnabled = YES;
    [self.mainScrollview addSubview:selectAreaImageView];
    
    
    UILabel* areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.0,
                                                                  10.0,
                                                                  60.0,
                                                                  30.0)];
    areaLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    areaLabel.font = [UIFont systemFontOfSize:15.0];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.textAlignment = NSTextAlignmentCenter;
    areaLabel.text = @"片区：";
    [selectAreaImageView addSubview:areaLabel];
    
    areaField = [[UITextField alloc] init];
    areaField.frame = CGRectMake(60.0, 1.0, 230.0, selectAreaImage.size.height);
    areaField.tag = 1;
    areaField.delegate = self;
    areaField.font = [UIFont systemFontOfSize:15.0];
    areaField.textColor = UIColorFromRGB(219.0, 87.0, 16.0);
    areaField.placeholder = @"请选择片区";
    areaField.delegate = self;
    
    areaPickView = [[UIPickerView alloc] init];
    areaField.inputView = areaPickView;
    areaPickView.tag = 1;
    areaPickView.delegate = self;
    areaPickView.dataSource = self;
    [selectAreaImageView addSubview:areaField];
    
    
    UIImageView* areaNameImageView = [[UIImageView alloc] init];
    areaNameImageView.frame = CGRectMake(self.pictureView.frame.origin.x,
                                         190.0 + 25 + selectAreaImage.size.height + 12.0,
                                         selectAreaImage.size.width,
                                         selectAreaImage.size.height);
    areaNameImageView.image = selectAreaImage;
    areaNameImageView.userInteractionEnabled = YES;
    [self.mainScrollview addSubview:areaNameImageView];
    
    
    UILabel* areaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0,
                                                                       10.0,
                                                                       80.0,
                                                                       30.0)];
    areaNameLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    areaNameLabel.font = [UIFont systemFontOfSize:15.0];
    areaNameLabel.backgroundColor = [UIColor clearColor];
    areaNameLabel.textAlignment = NSTextAlignmentCenter;
    areaNameLabel.text = @"小区名称：";
    [areaNameImageView addSubview:areaNameLabel];
    
    areaNameField = [[UITextField alloc] initWithFrame:CGRectMake(90.0,
                                                                  1.0,
                                                                  200.0,
                                                                  selectAreaImage.size.height)];
    areaNameField.tag = 2;
    areaNameField.delegate = self;
    areaNameField.font = [UIFont systemFontOfSize:15.0];
    areaNameField.placeholder = @"请选择小区名称";
    areaNameField.delegate = self;
    areaNamePickView = [[UIPickerView alloc] init];
    areaNameField.inputView = areaNamePickView;
    areaNamePickView.tag = 2;
    areaNamePickView.delegate = self;
    areaNamePickView.dataSource = self;
    [areaNameImageView addSubview:areaNameField];
    
    
    
    UIImage* numberImage = [UIImage imageNamed:@"number.png"];
    UIImageView* numberImageView = [[UIImageView alloc] init];
    numberImageView.frame = CGRectMake(self.pictureView.frame.origin.x,
                                       190.0 + 25.0 + selectAreaImage.size.height + 12.0 + selectAreaImage.size.height + 12.0,
                                       numberImage.size.width,
                                       numberImage.size.height);
    numberImageView.image = numberImage;
    numberImageView.userInteractionEnabled = YES;
    [self.mainScrollview addSubview:numberImageView];
    
    
    UILabel* numberLabel = [[UILabel alloc] init];
    numberLabel.frame = CGRectMake(7.0, 10.0, 30.0, 30.0);
    numberLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    numberLabel.font = [UIFont systemFontOfSize:15.0];
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"栋：";
    [numberImageView addSubview:numberLabel];
    
    
    numberField = [[UITextField alloc] initWithFrame:CGRectMake(35.0,
                                                                1.0,
                                                                100.0,
                                                               selectAreaImage.size.height)];
    numberField.tag = 3;
    numberField.font = [UIFont systemFontOfSize:15.0];
    numberField.placeholder = @"请输入栋号";
    numberField.delegate = self;
    [numberImageView addSubview:numberField];
    
    
    
    
    UIImage* floorImage = [UIImage imageNamed:@"floorImage.png"];
    
    UIImageView* floorImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                   (self.pictureView.frame.origin.x+numberImage.size.width+5,
                                    190.0+25.0+ selectAreaImage.size.height+12.0+selectAreaImage.size.height+12.0,
                                    floorImage.size.width,
                                    floorImage.size.height)];
    floorImageView.image = floorImage;
    floorImageView.userInteractionEnabled = YES;
    [self.mainScrollview addSubview:floorImageView];
    
    UILabel*floorLabel = [[UILabel alloc]initWithFrame:CGRectMake(7.0,
                                                                  10.0,
                                                                  30.0,
                                                                  30.0)];
    floorLabel.textColor = UIColorFromRGB(90.0,89.0, 89.0);
    floorLabel.font = [UIFont systemFontOfSize:15.0];
    floorLabel.backgroundColor = [UIColor clearColor];
    floorLabel.textAlignment = NSTextAlignmentCenter;
    floorLabel.text = @"层：";
    
    [floorImageView addSubview:floorLabel];
    
    floorField = [[UITextField alloc]initWithFrame:CGRectMake(35.0,
                                                              1.0,
                                                              100.0,
                                                             selectAreaImage.size.height)];
    floorField.tag = 4;
    floorField.font = [UIFont systemFontOfSize:15.0];
    floorField.placeholder = @"请输入楼层";
    floorField.delegate = self;
    [floorImageView addSubview:floorField];
    
    
    UIImageView* direactionImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                        (self.pictureView.frame.origin.x,
                                         251.0+ selectAreaImage.size.height+selectAreaImage.size.height+floorImage.size.height,
                                         selectAreaImage.size.width ,
                                         selectAreaImage.size.height)];
    direactionImageView.image = selectAreaImage;
    direactionImageView.userInteractionEnabled = YES;
    [self.mainScrollview addSubview:direactionImageView];
    
    UILabel* direactionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0,
                                                                        10.0,
                                                                        50.0,
                                                                        30.0)];
    direactionLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    direactionLabel.font = [UIFont systemFontOfSize:15.0];
    direactionLabel.backgroundColor = [UIColor clearColor];
    direactionLabel.textAlignment = NSTextAlignmentCenter;
    direactionLabel.text = @"朝向：";
    [direactionImageView addSubview:direactionLabel];
    
    
    
    
    direactionField = [[UITextField alloc]initWithFrame:CGRectMake(55.0,
                                                                   1.0,
                                                                   230.0,
                                                                  selectAreaImage.size.height)];
    direactionField.tag = 5;
    direactionField.font = [UIFont systemFontOfSize:15.0];
    direactionField.placeholder = @"请选择朝向";
    direactionField.delegate = self;
    [direactionImageView addSubview:direactionField];
    towardsPickView = [[UIPickerView alloc]init];
    direactionField.inputView = towardsPickView;
    towardsPickView.tag = 5;
    towardsPickView.delegate = self;
    towardsPickView.dataSource = self;
    
    UIImageView* moneyImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                   (self.pictureView.frame.origin.x,
                                    455.0,
                                    selectAreaImage.size.width ,
                                    selectAreaImage.size.height)];
    moneyImageView.userInteractionEnabled = YES;
    
    moneyImageView.image = selectAreaImage;
    [self.mainScrollview addSubview:moneyImageView];
    
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0,
                                                          10.0,
                                                          80.0,
                                                          30.0)];
    moneyLabel.textColor = UIColorFromRGB(90.0,89.0, 89.0);
    moneyLabel.font = [UIFont systemFontOfSize:15.0];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = @"目标租金：";
    [moneyImageView addSubview:moneyLabel];
    
    moneyField = [[UITextField alloc]initWithFrame:CGRectMake(80.0,
                                                              1.0,
                                                              210.0,
                                                               selectAreaImage.size.height)];
    moneyField.tag = 6;
    moneyField.font = [UIFont systemFontOfSize:15.0];
    moneyField.placeholder = @"请输入租金";
    moneyField.delegate = self;
    [moneyImageView addSubview:moneyField];
    
    
    UIImageView* typeHouseImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                       (self.pictureView.frame.origin.x,
                                        455.0+selectAreaImage.size.height+12.0,
                                        selectAreaImage.size.width ,
                                        selectAreaImage.size.height)];
    
    typeHouseImageView.userInteractionEnabled = YES;
    typeHouseImageView.image = selectAreaImage;
    [self.mainScrollview addSubview:typeHouseImageView];
    
    
    UILabel* typeHouseLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0,
                                                                       10.0,
                                                                       80.0,
                                                                       30.0)];
    typeHouseLabel.textColor = UIColorFromRGB(90.0,89.0, 89.0);
    typeHouseLabel.font = [UIFont systemFontOfSize:15.0];
    typeHouseLabel.backgroundColor = [UIColor clearColor];
    typeHouseLabel.textAlignment = NSTextAlignmentCenter;
    typeHouseLabel.text = @"房屋户型：";
    [typeHouseImageView addSubview:typeHouseLabel];
    
    
    
    typeHouseField = [[UITextField alloc]initWithFrame:CGRectMake(80.0,
                                                                  1.0,
                                                                  210.0,
                                                                   selectAreaImage.size.height)];
    typeHouseField.tag = 7;
    typeHouseField.font = [UIFont systemFontOfSize:15.0];
    typeHouseField.placeholder = @"请选择户型";
    
    apartmentPickView = [[UIPickerView alloc]init];
    typeHouseField.inputView = apartmentPickView;
    apartmentPickView.tag = 7;
    apartmentPickView.delegate = self;
    apartmentPickView.dataSource = self;
    [typeHouseImageView addSubview:typeHouseField];
    
    
    UIImageView* situationImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                       (self.pictureView.frame.origin.x,
                                        455.0+selectAreaImage.size.height+12.0+ selectAreaImage.size.height+12.0,
                                        selectAreaImage.size.width ,
                                        selectAreaImage.size.height)];
    situationImageView.userInteractionEnabled = YES;
    situationImageView.image = selectAreaImage;
    [self.mainScrollview addSubview:situationImageView];
    
    
    
    
    
    UILabel* situationLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0,
                                                                       10.0,
                                                                       80.0,
                                                                       30.0)];
    situationLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    situationLabel.font = [UIFont systemFontOfSize:15.0];
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.textAlignment = NSTextAlignmentCenter;
    situationLabel.text = @"装修情况：";
    [situationImageView addSubview:situationLabel];
    
    situationField = [[UITextField alloc]initWithFrame:CGRectMake(80.0,
                                                                  1.0,
                                                                  210.0,
                                                                   selectAreaImage.size.height)];
    situationField.tag = 8;
    situationField.font = [UIFont systemFontOfSize:15.0];
    situationField.placeholder = @"请选择装修情况";
    situationField.delegate = self;
    
    decorationPickView = [[UIPickerView alloc]init];
    situationField.inputView = decorationPickView;
    decorationPickView.tag = 8;
    decorationPickView.delegate= self;
    decorationPickView.dataSource =self;
    [situationImageView addSubview:situationField];
    
    
    
    UIImageView* yearImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                  (self.pictureView.frame.origin.x,
                                   635.0,
                                   selectAreaImage.size.width ,
                                   selectAreaImage.size.height)];
    yearImageView.userInteractionEnabled = YES;
    yearImageView.image = selectAreaImage;
    
    
    UILabel* yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0,
                                                                  10.0,
                                                                  80.0,
                                                                  30.0)];
    yearLabel.textColor = UIColorFromRGB(90.0,89.0, 89.0);
    yearLabel.font = [UIFont systemFontOfSize:15.0];
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.text = @"装修年份：";
    [yearImageView addSubview:yearLabel];
    
    yearField = [[UITextField alloc]initWithFrame:CGRectMake(80.0,
                                                             1.0,
                                                             210.0,
                                                             selectAreaImage.size.height)];
    yearField.tag = 9;
    yearField.font = [UIFont systemFontOfSize:15.0];
    yearField.placeholder = @"请输入装修年份";
    yearField.delegate = self;
    [yearImageView addSubview:yearField];
    [self.mainScrollview addSubview:yearImageView];
    
    
    UIImageView* proportionImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                        (self.pictureView.frame.origin.x,
                                         635.0+selectAreaImage.size.height+10.0,
                                         selectAreaImage.size.width ,
                                         selectAreaImage.size.height)];
    proportionImageView.userInteractionEnabled = YES;
    proportionImageView.image = selectAreaImage;
    
    
    NSLog(@"%f", 635.0+selectAreaImage.size.height+10.0+selectAreaImage.size.height);
    
    UILabel* proportionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0,
                                                                        10.0,
                                                                        80.0,
                                                                        30.0)];
    proportionLabel.textColor = UIColorFromRGB(90.0,89.0, 89.0);
    proportionLabel.font = [UIFont systemFontOfSize:15.0];
    proportionLabel.backgroundColor = [UIColor clearColor];
    proportionLabel.textAlignment = NSTextAlignmentCenter;
    proportionLabel.text = @"房屋面积：";
    [proportionImageView addSubview:proportionLabel];
    
    proportionField = [[UITextField alloc]initWithFrame:CGRectMake(80.0,
                                                                   1.0,
                                                                   210.0,
                                                                   selectAreaImage.size.height)];
    proportionField.tag = 10;
    proportionField.font = [UIFont systemFontOfSize:15.0];
    proportionField.placeholder = @"请输入房屋面积";
    proportionField.delegate = self;
    [proportionImageView addSubview:proportionField];
    
    
    [self.mainScrollview addSubview:proportionImageView];
    
    
    
    //下面是小矩形
    self.furnitureView.layer.cornerRadius = 5.0;
    [self.furnitureView.layer setBorderWidth:0.5];
    [self.furnitureView.layer setBorderColor:UIColorFromRGB(185.0, 185.0, 185.0).CGColor];

    
    
    UIImageView* rentYearImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      (self.pictureView.frame.origin.x,
                                       922.0+55.0,
                                       selectAreaImage.size.width,
                                       selectAreaImage.size.height)];
    rentYearImageView.image = selectAreaImage;
    rentYearImageView.userInteractionEnabled = YES;
    [self.mainScrollview addSubview:rentYearImageView];
    
    
    rentYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0,
                                                             10.0,
                                                             80.0,
                                                             30.0)];
    rentYearLabel.textColor = UIColorFromRGB(90.0,89.0, 89.0);
    rentYearLabel.font = [UIFont systemFontOfSize:15.0];
    rentYearLabel.backgroundColor = [UIColor clearColor];
    rentYearLabel.textAlignment = NSTextAlignmentCenter;
    rentYearLabel.text = @"出租年限：";
    [rentYearImageView addSubview:rentYearLabel];
    
    rentYearField = [[UITextField alloc]initWithFrame:CGRectMake(80.0,
                                                                 1.0,
                                                                 210.0,
                                                                 selectAreaImage.size.height)];
    rentYearField.tag = 10;
    rentYearField.font = [UIFont systemFontOfSize:15.0];
    rentYearField.placeholder = @"请输入出租年限";
    rentYearField.delegate = self;
    rentYearPickView = [[UIPickerView alloc] init];
    rentYearField.inputView = rentYearPickView;
    rentYearPickView.tag = 10;
    rentYearPickView.delegate = self;
    rentYearPickView.dataSource = self;
    [rentYearImageView addSubview:rentYearField];
    
    
    
    
    
    UIImage* submitPostImage = [UIImage imageNamed:@"submitPostImage"];
    UIButton *submitButton = [[UIButton alloc] init];
    submitButton.frame = CGRectMake(self.pictureView.frame.origin.x,
                                    922.0 + selectAreaImage.size.height + 12.0 + 55.0,
                                    submitPostImage.size.width,
                                    submitPostImage.size.height);
    [submitButton setImage:submitPostImage forState:UIControlStateNormal];
    [submitButton addTarget:self
                     action:@selector(submitPostRentInfomation:)
           forControlEvents:UIControlEventTouchUpInside];
    submitButton.userInteractionEnabled = YES;
    [self.mainScrollview addSubview:submitButton];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* result = [SystemSetting request];
        if (result.isSuccess)  {
            NSDictionary* dict = result.data;
            facilityArray = [dict objectForKey:FACILITY];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                for (Facility* facility in facilityArray) {
                    
                    UIButton *checkButton = [[UIButton alloc] init];
                    
                    
                    NSUInteger index = [facilityArray indexOfObject:facility];
                    CGFloat x = (index + 1) % 3 * 100.0;
                    NSUInteger row = floor((index + 1) / 3);
                    CGFloat y = row * 45.0 + 8.0;
                    
                    checkButton.frame = CGRectMake(x, y, 100.0, 45.0);
                    [checkButton setBackgroundImage:[UIImage imageNamed:@"PostUnselectedButtonBackground"]
                                           forState:UIControlStateNormal];
                    NSLog(@"%f",[UIImage imageNamed:@"PostUnselectedButtonBackground"].size.width);
                    
                    [checkButton setBackgroundImage:[UIImage imageNamed:@"PostSelectedButtonBackground"]
                                           forState:UIControlStateSelected];
                    [checkButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
                   [checkButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
                    [checkButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                  //  checkButton.titleLabel.frame = CGRectMake(x/2.5+30.0*row, y, 100.0, 45.0);

                    [checkButton setTitleColor:UIColorFromRGB(66.0, 66.0, 66.0)
                                      forState:UIControlStateNormal];
                    [checkButton setTitle:facility.title forState:UIControlStateNormal];
                    [checkButton addTarget:self
                                    action:@selector(facilityButtonPressed:)
                          forControlEvents:UIControlEventTouchUpInside];
                    checkButton.tag = index;
                    [self.furnitureView addSubview:checkButton];
                  
                }
            });
        }
    });
}


static int imageLocation;
//删除上传的图片
- (void)deletePhoto:(UITapGestureRecognizer*)tap
{

    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"确定删除图片"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    [alertView show];
    
    imageLocation = tap.view.tag;
}

#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"imageLocation = %d",imageLocation);
    
    if (buttonIndex==1) {
  
        UIImageView* deleteImageView = (UIImageView*)[imageViewArray objectAtIndex:imageLocation];
        NSLog(@"%@",deleteImageView);
        
        //最后一张图片
        if (imageLocation == imageViewArray.count -1) {
            
            
            [imageViewArray removeObject:deleteImageView];
            [imageArray removeObject:imageArray[imageLocation]];
            NSLog(@"%d",imageViewArray.count);
            UIImageView* imageView = [self.uploadImageViewArray objectAtIndex:imageLocation];
            imageView.image = nil;
            imageCount--;
        } else  {
            
            //在数组中删除改图片
            [imageViewArray removeObject:deleteImageView];
            [imageArray removeObject:imageArray[imageLocation]];
            
            for (UIImageView* imageView  in self.uploadImageViewArray) {
                
              imageView.image = nil;
                
            }
            //重新排版图片
            for (UIImageView* imageView in imageViewArray) {
                
                NSInteger index = [imageViewArray indexOfObject:imageView];
                NSLog(@"index = %d",index);
                UIImageView* orginImageView =(UIImageView*)[self.uploadImageViewArray objectAtIndex:index];
                orginImageView.image = imageArray[index];
                NSLog(@"%@",orginImageView.image);
            }
            imageCount--;
}
        
        //删除图片
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
        
            Result* result = [ManagerMember deleteImage:houseImage.houseImageID];
            NSLog(@"result.isSuccess = %d",result.isSuccess);
            if (result.isSuccess) {
                NSLog(@"result.isSuccess = %d",result.isSuccess);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
            }
        });

     }
}

#pragma mark UIPickViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    if (pickerView.tag == 1) {
        
        return areaArray.count;
        
    }
    if (pickerView.tag == 2) {
        
        
        return areaNameArray.count;
        
    }
    if (pickerView.tag == 5) {
        
        return forwardArray.count;
        
    }
    if (pickerView.tag == 7) {
        
        
        return houseTypeArray.count;
        
    }
    if (pickerView.tag == 8) {
        
        return decorationArray.count;
        
    }
    if (pickerView.tag == 10) {
        
        return rentYearArray.count;
        
    }
    return 0;
}

#pragma mark UIPickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        Area* area = [areaArray objectAtIndex:row];
        return  area.title;
    }
    if (pickerView.tag == 2) {
        Project* project = [areaNameArray objectAtIndex:row];
        return project.title;
    }
    if (pickerView.tag == 5) {
        Forward* forward = [forwardArray objectAtIndex:row];
        return forward.title;
    }
    if (pickerView.tag == 7) {
        HouseType* houseType = [houseTypeArray objectAtIndex:row];
        return houseType.title;
    }
    if (pickerView.tag == 8) {
        Decoration* decoration = [decorationArray objectAtIndex:row];
        return  decoration.title;
    }
    if (pickerView.tag == 10) {
        RentYear* rentYear = [rentYearArray objectAtIndex:row];
        return  rentYear.title;
    }
    
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
//    NSLog(@"didSelectRow%@", pickerView.inputView);
    
    if (pickerView.tag == 1) {
        
        
        NSInteger selectRow  = [pickerView selectedRowInComponent:0];
        
        Area* area = [areaArray objectAtIndex:selectRow];
        
        //记录选择的ID
        selectedAreaID = area.areaID;
         areaField.text = area.title;
        [areaField resignFirstResponder];
        
    }
    
    if (pickerView.tag == 2) {
        
        
        NSInteger selectRow  = [pickerView selectedRowInComponent:0];
        
        Project* project = [areaNameArray objectAtIndex:selectRow];
        
        selectedAreaNameID = project.projectId;
        
        areaNameField.text = project.title;
        [areaNameField resignFirstResponder];
    }
    
    if (pickerView.tag == 5) {
        
        
        NSInteger selectRow  = [pickerView selectedRowInComponent:0];
        
        Forward* forward = [forwardArray objectAtIndex:selectRow];
        
        selectedForwardID = forward.forwardsId;
        direactionField.text = forward.title;
        [direactionField resignFirstResponder];
    }
    
    if (pickerView.tag == 7) {
        
        
        NSInteger selectRow  = [pickerView selectedRowInComponent:0];
        
        HouseType* houseType = [houseTypeArray objectAtIndex:selectRow];
        
        selectedApartmentID = houseType.houseTypeID;
        
        
        typeHouseField.text = houseType.title;
        [typeHouseField resignFirstResponder];
    }
    if (pickerView.tag == 8) {
        
        
        NSInteger selectRow  = [pickerView selectedRowInComponent:0];
        
        Decoration* decoration = [decorationArray objectAtIndex:selectRow];
        
        selectedDecorationID = decoration.decorationId;
        
        situationField.text = decoration.title;
        [situationField resignFirstResponder];
    }
    if (pickerView.tag == 10) {
        
        
        NSInteger selectRow  = [pickerView selectedRowInComponent:0];
        
        RentYear* rentYear = [rentYearArray objectAtIndex:selectRow];
        
        selectedRentYearID = [rentYear.rentYearId intValue];
        
        rentYearField.text = rentYear.title;
        [rentYearField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isResetingOffset) {
       
        [areaNameField resignFirstResponder];
        [areaField resignFirstResponder];
        [numberField resignFirstResponder];
        [yearField resignFirstResponder];
        [floorField resignFirstResponder];
        [direactionField resignFirstResponder];
        [typeHouseField resignFirstResponder];
        [situationField resignFirstResponder];
        [rentYearField resignFirstResponder];
        [moneyField resignFirstResponder];
        [proportionField resignFirstResponder];

    }
    
    
    
}

//将需要选择的数据请求下来。
- (void)loadSelectData
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        Result* result = [SystemSetting request];
        
        if (result.isSuccess)  {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSDictionary* dic = result.data;
                areaArray = [dic objectForKey:AREA_KEY];
                areaNameArray = [dic objectForKey:PROJECT_KEY];
                forwardArray = [dic objectForKey:FORWARDS_KEY];
                houseTypeArray = [dic objectForKey:HOUSE_TYPE_KEY];
                decorationArray = [dic objectForKey:DECORATION_KEY];
                facilityArray = [dic objectForKey:FACILITY];
                rentYearArray = [dic objectForKey:RENTYEAR];

                
            });
            
        }
        
    });
    
}

//提交刊登信息
- (void)submitPostRentInfomation:(UIButton *)button
{
    NSLog(@"submitPostRentInfomation");
    
   //不传图片的情况处理
    for (UIImageView* imageView  in self.uploadImageViewArray) {
        
        if (imageView.image ==nil) {
            
            semaphore = dispatch_semaphore_create(0);
            postImageSuccess = YES;
            dispatch_semaphore_signal(semaphore);
            break;
        }else{
            semaphore = dispatch_semaphore_create(0);
            postImageSuccess = YES;
            dispatch_semaphore_signal(semaphore);
              break;
        }
    }
    
    NSUInteger uploadImageCount = 0;
    for (UIImageView *uploadImageView in self.uploadImageViewArray) {
        if (uploadImageView.image != nil) {
            uploadImageCount++;
        }
    }
    
    if (selectedAreaID.integerValue <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:areaField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (selectedAreaNameID.integerValue <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:areaNameField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (selectedAreaNameID.integerValue <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:areaNameField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }

    if (numberField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:numberField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (floorField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:floorField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (selectedForwardID.integerValue <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:direactionField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    
    if (moneyField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:moneyField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([moneyField.text isNumeric] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"租金金额格式错误，请输入数字格式。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (selectedApartmentID.integerValue <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:typeHouseField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }

    if (selectedDecorationID.integerValue <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:situationField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (yearField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:yearField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([yearField.text isNumeric] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"装修年份格式错误，请输入数字格式。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }

    
    if (proportionField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:proportionField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([proportionField.text isNumeric] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"房屋面积格式错误，请输入数字格式。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (rentYearField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:rentYearField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([rentYearField.text isNumeric] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"出租年限格式错误，请输入数字格式。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    

    button.enabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{

        
        //保存出租年限数据
        [[NSUserDefaults standardUserDefaults] setObject:rentYearField.text forKey:RENT_YEAR_TEXT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString* userId = [[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
        
        Result* result;
        
  

       dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        
        NSLog(@"postImageSuccess = %d",postImageSuccess);
        
        if (postImageSuccess) {
            
            
    
            result = [ManagerMember postRentHouse:[userId intValue]
                                                  houseId:@""
                                                    title:@""
                                                projectId:selectedAreaID.integerValue
                                                    price:moneyField.text
                                                   areaId:selectedAreaNameID.integerValue
                                              apartmentId:selectedApartmentID.integerValue
                                                 building:numberField.text
                                                    level:floorField.text
                                               proportion:proportionField.text
                                           decorationYear:yearField.text
                                             decorationId:selectedDecorationID.integerValue
                                                 rentYear:[NSNumber numberWithInt:selectedRentYearID]
                                                forwardId:selectedForwardID.integerValue
                                               facilities:selectedFacilityIDArray
                                                    times:uploadDate];
            
        }
        

        if (result.isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIImageView *uploadImageView in self.uploadImageViewArray) {
                    uploadImageView.image = nil;
                }
                imageCount = 0;
                selectedAreaID = @0;
                areaField.text = @"";
                selectedAreaNameID = @0;
                areaNameField.text = @"";
                numberField.text = @"";
                floorField.text = @"";
                selectedForwardID = @0;
                direactionField.text = @"";
                moneyField.text = @"";
                selectedApartmentID = @0;
                typeHouseField.text = @"";
                selectedDecorationID = @0;
                situationField.text = @"";
                yearField.text = @"";
                proportionField.text = @"";
                selectedFacilityIDArray = [[NSMutableArray alloc] init];
                for (UIButton *checkButton in self.furnitureView.subviews) {
                    if ([checkButton isMemberOfClass:[UIButton class]]) {
                        checkButton.selected = NO;
                    }
                }
                rentYearField.text = @"";
                
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"已成功提交"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                postImageSuccess = NO;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[result.error localizedDescription]
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        button.enabled = YES;
    });


}

- (void)takePhoto:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"takePhoto %@", gestureRecognizer);
    //
    
    NSLog(@"imageCount %i", imageCount);
    
    if (imageCount >= [self.uploadImageViewArray count]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"你最多只能上传七张图片"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"拍照"];
        [actionSheet addButtonWithTitle:@"从手机相册选择"];
        [actionSheet addButtonWithTitle:@"取消"];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
    NSLog(@"buttonIndex %i", buttonIndex);
    
    NSLog(@"11111111111");
    
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        // image picker needs a delegate,
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen

       
        [self presentModalViewController:imagePickerController animated:YES];
        
        
        
        
    } else if (buttonIndex == 1) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        // image picker needs a delegate,
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"imagePickerController");
    NSLog(@"info %@", info);
    
    //    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    //    NSLog(@"imagePath %@", [imageURL path]);
    //    NSURL *fileURL = [NSURL fileURLWithPath:imagePath];
    //    NSLog(@"fileURL %@", fileURL);
    //
    //
    //    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    //
    //    imageview.image = [UIImage imageWithData:data];
    NSLog(@"imageCount %i", imageCount);
    
    UIImage *origImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    
    NSLog(@"origImage = %@",origImage);
    
    UIImage* changeImage  = [UIImage imageWithCGImage:(__bridge CGImageRef)((CIImage*)origImage) scale:1.0 orientation:UIImageOrientationUp];
    
    NSLog(@"image = %@",changeImage);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"completion");
    }];
    
 
    
    UIView* blackView = [[UIView alloc]init];
    blackView.frame = CGRectMake(0.0, 0.0, 69.0, 60.0);
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.7;
    DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0,0.0, 20.0, 20.0)];
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.trackTintColor = UIColorFromRGB(105.0, 105.0, 105.0);
        progressView.progressTintColor = UIColorFromRGB(237.0, 120.0, 51.0);
        progressView.progress = 0.0;
        progressView.center = blackView.center;
        [blackView addSubview:progressView];
    });
    
    
    NSInteger indexImageView = 0 ;
    
    for (UIImageView* imageView in self.uploadImageViewArray) {
        if (imageView.image ==nil) {
            
            indexImageView = [self.uploadImageViewArray indexOfObject:imageView];
            
            
            imageView.image = origImage;
            [imageView addSubview:blackView];
            
            [blackView addSubview:progressView];
            break;
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        // load data
        Result *result = [ManagerMember uploadImage:HouseMessageTypeRent
                                     imageFieldName:@"photoFileName"
                                              image:origImage
                                         uploadDate:uploadDate
                                      progressBlock:^(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                                          
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          NSLog(@"%d",totalBytesWritten);
                          NSLog(@"%d",totalBytesExpectedToWrite);
                          NSLog(@"%f",((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite));
                         [progressView setProgress:((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite) animated:YES];
    
                          
                      });
                                          
                }];
        
        
        if (result.isSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

               houseImage = (HouseImage*)result.data;
               imageCount++;

                CGSize thumbImageSize = CGSizeMake(69.0, 60.0);
                UIGraphicsBeginImageContextWithOptions(thumbImageSize, NO, 0);
                [origImage drawInRect:CGRectMake(0.0, 0.0, thumbImageSize.width, thumbImageSize.height)];
                CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
                UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSLog(@"imageCount =  %d",imageCount);
                
    
                //添加手势
                UIImageView* imageView = (UIImageView*)[self.uploadImageViewArray objectAtIndex:imageCount-1];
                UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                        action:@selector(deletePhoto:)];
                tapGestureRecongnizer.numberOfTapsRequired = 1;
                tapGestureRecongnizer.numberOfTouchesRequired = 1;
                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:tapGestureRecongnizer];
                tapGestureRecongnizer.view.tag = imageCount-1;
                
                //收集imageView
                [imageViewArray addObject:imageView];
                [imageArray addObject:thumbImage];
                
                //将背景图片清空
                UIImageView* cancelImageView =self.uploadImageViewArray[indexImageView];
                cancelImageView.image = nil;
                
                //信号量
                semaphore = dispatch_semaphore_create(0);

                for (UIImageView *uploadImageView in self.uploadImageViewArray) {
           
                  if (uploadImageView.image ==nil) {
                        NSLog(@"YES");
                        uploadImageView.image = thumbImage;
                      postImageSuccess = YES;
                      dispatch_semaphore_signal(semaphore);
                      break;
                    }
                }

            });
        }
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [progressView setProgress:1.0 animated:YES];
        [progressView removeFromSuperview];
        [blackView removeFromSuperview];
    });
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing %@", textField);
    
    CGPoint point = [textField convertPoint:textField.frame.origin toView:self.view];
    NSLog(@"point %@", NSStringFromCGPoint(point));
    if (point.y > self.view.frame.size.height - KEYBOARD_HEIGHT) {
        NSLog(@"YES xxxx");
        isResetingOffset = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.mainScrollview.contentOffset = CGPointMake(self.mainScrollview.contentOffset.x,
                                                            self.mainScrollview.contentOffset.y + KEYBOARD_HEIGHT);
        } completion:^(BOOL finished) {
            if (finished) {
                isResetingOffset = NO;
            }
        }];
    }
}


- (void)facilityButtonPressed:(UIButton *)button
{
    Facility *facility = [facilityArray objectAtIndex:button.tag];
    if (selectedFacilityIDArray == nil) {
        selectedFacilityIDArray = [[NSMutableArray alloc] init];
    }
    if ([selectedFacilityIDArray indexOfObject:facility.facilityID] != NSNotFound) {
        [selectedFacilityIDArray removeObject:facility.facilityID];
    } else {
        [selectedFacilityIDArray addObject:facility.facilityID];
    }
    NSLog(@"selectedFacilityIDArray %@", selectedFacilityIDArray);
    
    button.selected = !button.selected;
}

@end
