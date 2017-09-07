//
//  ViewController.m
//  pingpang
//
//  Created by 极光 on 2017/9/7.
//  Copyright © 2017年 jiguang. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
//运动管理    - 动画管理员
@property (nonatomic, strong) UIDynamicAnimator      * myDynamicAnimator;
//动画元素行为 - 物理仿真器
@property (nonatomic, strong) UIDynamicItemBehavior  * myDynamicItemBehavior;
//碰撞行为
@property (nonatomic, strong) UICollisionBehavior    * myCollisionBehavior;
//重力行为
@property (nonatomic, strong) UIGravityBehavior      * myGravityBehavior;
//实现motion（陀螺仪、加速度、屏幕的motion等等）
@property (nonatomic, strong) CMMotionManager        * myManger;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self run];
}

- (void)run {
    
    self.view.backgroundColor = [UIColor colorWithRed:188/255.0 green:201/255.0 blue:180/255.0 alpha:1.0];
    
    [self initConfiguration];
    
    [self setUpUI];
    
    [self upDateDeviceMotion];
}

- (void)initConfiguration {
    
    //实现动画
    _myDynamicAnimator      = [[UIDynamicAnimator       alloc] initWithReferenceView:self.view];
    
    _myDynamicItemBehavior  = [[UIDynamicItemBehavior   alloc] init];
    //碰撞
    _myCollisionBehavior    = [[UICollisionBehavior     alloc] init];
    //重力
    _myGravityBehavior      = [[UIGravityBehavior       alloc] init];
    //实现屏幕motion
    _myManger               = [[CMMotionManager         alloc] init];
    //弹力系数
    _myDynamicItemBehavior.elasticity = 0;
    //刚体碰撞
    _myCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    //把行为放进动画里
    [_myDynamicAnimator addBehavior:_myDynamicItemBehavior];
    
    [_myDynamicAnimator addBehavior:_myCollisionBehavior];
    
    [_myDynamicAnimator addBehavior:_myGravityBehavior];
}

- (void)setUpUI {
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 23; i++) {
        
        [imageArray addObject:[NSString stringWithFormat:@"%d",i]];
        
        CGFloat x = arc4random() % (NSInteger)self.view.bounds.size.width;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, 20, 20)];
        
        imageView.image = [UIImage imageNamed:imageArray[i]];
        
        [self.view addSubview:imageView];
        
        //添加行为
        [_myDynamicItemBehavior addItem:imageView];
        
        [_myGravityBehavior addItem:imageView];
        
        [_myCollisionBehavior addItem:imageView];
    }
}

- (void)upDateDeviceMotion {
    //实时刷新屏幕的motion
    if (self.myManger.deviceMotionAvailable == YES && self.myManger.accelerometerAvailable == YES) {
        self.myManger.deviceMotionUpdateInterval = 10.0/60.0;
        [self.myManger startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            _myGravityBehavior.gravityDirection = CGVectorMake(motion.gravity.x, -motion.gravity.y);
        }];
    } else {
        // Motion / Accelerometer services unavailable
    }
}

@end
