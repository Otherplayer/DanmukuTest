//
//  ViewController.m
//  DanmakuProject
//
//  Created by __无邪_ on 2017/6/9.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "ViewController.h"
#import "FDanmakuView.h"
#import "FDcontroller.h"

static int x = 0;

@interface ViewController ()<FDanmakuDataSource,FDanmakuDelegate>

@property (nonatomic, strong)FDanmakuView *danmakuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.danmakuView = [[FDanmakuView alloc] initWithFrame:CGRectMake(0, 100, 375, 300)];
    self.danmakuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.danmakuView.dataSource = self;
    self.danmakuView.delegate = self;
    [self.view addSubview:self.danmakuView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BarrageFile" ofType:@"plist"];
    NSArray *barrages = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    for (NSDictionary *info in barrages) {
        FdanmakuModel *model = [[FdanmakuModel alloc] init];
        model.message = info[@"message"];
        [datas addObject:model];
    }
    
    [self.danmakuView insertModels:datas];
    [self.danmakuView startAnimation];
//    [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        FdanmakuModel *model = [[FdanmakuModel alloc] init];
//        model.message = @"abcdefggggggggggg";
//        [self.danmakuView insertModel:model];
//    }];
}

- (CGFloat)heightForItemInDanmakuView:(FDanmakuView *)danmakuView{
    return 45;
}
- (NSUInteger)numberOfRowsInBarrageView:(FDanmakuView *)barrageView{
    return 5;
}
- (FDanmakuCell *)barrageView:(FDanmakuView *)barrageView cellForModel:(FdanmakuModel *)model{
    FDanmakuCell *cell = [barrageView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell) {
        NSLog(@"NO----%@",@(x++));
        cell = [[FDanmakuCell alloc] initWithIdentifier:@"identifier"];
    }
    [cell.labMessage setText:model.message];
    
    return cell;
}
- (IBAction)sendAction:(id)sender {
    FDcontroller *controller = [[FDcontroller alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
