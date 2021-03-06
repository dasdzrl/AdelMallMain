//
//  ADPlaceOrderViewController.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//  下单页面

#import "ADPlaceOrderViewController.h"
#import "DCHomeRefreshGifHeader.h"
#import "ADOrderTopToolView.h"
#import "ADGoodsListViewCell.h"
#import "ADReceivingAddressViewCell.h"
#import "ADReceivingAddressViewCell.h"
#import "ADOrderPublicViewCell.h"
#import "ADTotalViewCell.h"
#import "ADBottomView.h"
#import "ADPaymentOrderViewController.h"

@interface ADPlaceOrderViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 顶部Nva */
@property (strong , nonatomic)ADOrderTopToolView *topToolView;
/* 底部View */
@property (strong , nonatomic)ADBottomView *bottomView;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@end

static NSString *const ADGoodsListViewCellID = @"ADGoodsListViewCell";
static NSString *const ADReceivingAddressViewCellID = @"ADReceivingAddressViewCell";
static NSString *const ADOrderPublicViewCellID = @"ADOrderPublicViewCell";
static NSString *const ADTotalViewCellID = @"ADTotalViewCell";

@implementation ADPlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpBase];
    [self setUpGIFRrfresh];
    [self setUpNavTopView];
    [self setupCustomBottomView];
    [self countPrice];

}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _topToolView.hidden = NO;
    [_topToolView setTopTitleWithNSString:KLocalizableStr(@"购物车")];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //    _topToolView.rightItemClickBlock = ^{
    //        NSLog(@"点击设置");
    //    };
    
    [self.view addSubview:_topToolView];
    
}

#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    WEAKSELF
    _bottomView = [[ADBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight -  50, kScreenWidth, 50)];
    _bottomView.rightBtnClickBlock = ^{
        //跳转到支付页面
        ADPaymentOrderViewController *placeOrderVC = [[ADPaymentOrderViewController alloc] init];
        [weakSelf.navigationController pushViewController:placeOrderVC animated:YES];
    };
    
    [self.view addSubview:_bottomView];
}

- (NSMutableAttributedString*)LZSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计（不含运费）:%@元",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计（不含运费）:"];
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:rang];
    return LZString;
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算商品总金额
 */
-(void)countPrice {
    double totlePrice = 0.0;
    
//    for (LZGoodsModel *model in self.selectedArray) {
//
//        double price = [model.price doubleValue];
//
//        totlePrice += price * model.count;
//    }
    totlePrice = 7450;
    NSString *string = [NSString stringWithFormat:@"%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self LZSetString:string];
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight -64);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        [_collectionView registerClass:[ADGoodsListViewCell class] forCellWithReuseIdentifier:ADGoodsListViewCellID];
        [_collectionView registerClass:[ADReceivingAddressViewCell class] forCellWithReuseIdentifier:ADReceivingAddressViewCellID];
        [_collectionView registerClass:[ADOrderPublicViewCell class] forCellWithReuseIdentifier:ADOrderPublicViewCellID];
        [_collectionView registerClass:[ADTotalViewCell class] forCellWithReuseIdentifier:ADTotalViewCellID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - initialize
- (void)setUpBase
{
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 设置头部header
- (void)setUpGIFRrfresh
{
    self.collectionView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpRecData)];
}

#pragma mark - 刷新
- (void)setUpRecData
{
    WEAKSELF
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleHeavy];
        [generator prepare];
        [generator impactOccurred];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //手动延迟
        [weakSelf.collectionView.mj_header endRefreshing];
    });
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        ADGoodsListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADGoodsListViewCellID forIndexPath:indexPath];
        //            cell.gridItem = _gridItem[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;

    }
    else if (indexPath.section == 1) {//收货地址
        ADReceivingAddressViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADReceivingAddressViewCellID forIndexPath:indexPath];
        //            cell.gridItem = _gridItem[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;
    }
    else if (indexPath.section == 2) {//评价商品
        ADOrderPublicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADOrderPublicViewCellID forIndexPath:indexPath];
        //            cell.gridItem = _gridItem[indexPath.row];
        [cell setTopTitleWithNSString:@"评价商品"];
        [cell setButtonTitleWithNSString:@"默认（韵达）"];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;
    }else if (indexPath.section == 3) {//发票
        ADOrderPublicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADOrderPublicViewCellID forIndexPath:indexPath];
        //            cell.gridItem = _gridItem[indexPath.row];
        [cell setTopTitleWithNSString:@"发票"];
        [cell setButtonTitleWithNSString:@"普通发票（纸质）"];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;
    }else if (indexPath.section == 4) {//优惠券
        ADOrderPublicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADOrderPublicViewCellID forIndexPath:indexPath];
        //            cell.gridItem = _gridItem[indexPath.row];
        [cell setTopTitleWithNSString:@"优惠券"];
        [cell setButtonTitleWithNSString:@"请选择"];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;
    }else if (indexPath.section == 5) {//统计信息
        ADTotalViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADTotalViewCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;
    }
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
//    if (indexPath.section == 0) {
//        ADOrderStateView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ADOrderStateViewID forIndexPath:indexPath];
//        //        headerView.imageGroupArray = GoodsHomeSilderImagesArray;
//        reusableview = headerView;
//    }
    return reusableview;
}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//商品信息
        return CGSizeMake(kScreenWidth, 273);
    }
    if (indexPath.section == 1) {//收货地址
        return CGSizeMake(kScreenWidth, 60);
    }
    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4) {//评价商品||发票||优惠券
        return CGSizeMake(kScreenWidth, 40);
    }
    if (indexPath.section == 5) {//统计信息
        return CGSizeMake(kScreenWidth, 90);
    }
//    if (indexPath.section == 4) {//商品清单
//        return CGSizeMake(kScreenWidth, 50+109*2+110);
//    }
    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (section == 0) {//
//        return CGSizeMake(kScreenWidth, 40);
//    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 6) ? 4 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 6) ? 4 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 15, 0);//分别为上、左、下、右
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
