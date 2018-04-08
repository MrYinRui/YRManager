//
//  ScrollImageView.m
//  ScrollImageView
//
//  Created by xun on 9/26/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "ScrollImageView.h"

#define kScrollImageViewCellIdentifier @"XUN_SCROLL_IMAGE_VIEW"
#define kPageControlTag     1025

@interface ScrollImageView ()

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ScrollImageView

+ (instancetype)scrollViewWithFrame:(CGRect)frame
                             images:(NSArray *)images
{
    return [self scrollViewWithFrame:frame images:images autoScroll:YES];
}

+ (instancetype)scrollViewWithFrame:(CGRect)frame
                             images:(NSArray *)images
                         autoScroll:(BOOL)autoScroll
{
    
    ScrollImageView *view = [[[self class] alloc] initWithFrame:frame];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    layout.itemSize = frame.size;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    view.collectionView = (id)[[UICollectionView alloc] initWithFrame:view.bounds collectionViewLayout:layout];
    [view.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kScrollImageViewCellIdentifier];
    view.collectionView.showsHorizontalScrollIndicator = NO;
    view.collectionView.dataSource = view;
    view.collectionView.delegate = view;
    view.collectionView.pagingEnabled = YES;
    view.collectionView.bounces = NO;
    [view addSubview:view.collectionView];
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (NSString *path in images)
    {
        [arr addObject:[[NSBundle mainBundle] pathForResource:path.stringByDeletingPathExtension ofType:path.pathExtension]];
    }
    
    view.images = arr;
    view.currentPage = 1;
    
    if (arr.count > 1)
    {
        NSString *first = arr.firstObject;
        NSString *last = arr.lastObject;
        [arr insertObject:last atIndex:0];
        [arr addObject:first];
        [view.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, frame.size.height - 22, frame.size.width, 15);
    pageControl.numberOfPages = images.count;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    pageControl.tag = kPageControlTag;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [view addSubview:pageControl];
    pageControl.hidden = view.images.count <= 1;
    if(!autoScroll){
        pageControl.hidden = YES;
    }
    
    if (autoScroll)
    {
        view.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:view selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
        [view start];
    }
    
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScrollImageViewCellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = [cell.contentView viewWithTag:1024];
    if (!imageView)
    {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = 1024;
        [cell.contentView addSubview:imageView];
    }
    imageView.image = [UIImage imageWithContentsOfFile:self.images[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if(self.images.count > 1)
    //    {
    //        [self handleScrollViewScroll:(id)scrollView];
    //    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(self.images.count > 1)
    {
        [self handleScrollViewScroll:(id)scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //  人为拖动会调用此方法
    
    self.currentPage = (scrollView.contentOffset.x + 10) / scrollView.width;
    
    [self handleScrollViewScroll:scrollView];
    [self start];
}

- (void)start
{
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
}

- (void)stop
{
    _timer.fireDate = [NSDate distantFuture];
}

- (void)end
{
    [_timer invalidate];
}

- (void)handleScrollViewScroll:(UIScrollView *)sv
{
    //为了计算有误差，一般都都会加减合理数值进行大小比较，而不是进行相等比较，类似于模糊算法
    //    if (sv.contentSize.width - sv.contentOffset.x <= sv.frame.size.width)
    //    {
    //        sv.contentOffset = CGPointMake(sv.frame.size.width, 0);
    //    }
    //    else if(sv.contentOffset.x == 0)
    //    {
    //        sv.contentOffset = CGPointMake(sv.contentSize.width - sv.frame.size.width * 2, 0);
    //    }
    
    sv.contentOffset = CGPointMake(sv.frame.size.width * _currentPage, 0);
    UIPageControl *pageControl = [self viewWithTag:kPageControlTag];
    pageControl.currentPage = (sv.contentOffset.x + 10) / sv.frame.size.width - 1;
    
    if(_scrollBlock)
    {
        _scrollBlock(pageControl.currentPage + 1);
    }
}

#pragma mark - Interface Method

- (void)scrollToLastPage
{
    if (_images.count == 1)
    {
        return;
    }
    
    [_collectionView setContentOffset:CGPointMake(_collectionView.contentOffset.x - _collectionView.frame.size.width, 0) animated:YES];
    
    self.currentPage -= 1;
}

- (void)scrollToNextPage
{
    if (_images.count == 1)
    {
        return;
    }
    
    [_collectionView setContentOffset:CGPointMake(_collectionView.contentOffset.x + _collectionView.frame.size.width, 0) animated:YES];
    
    self.currentPage += 1;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    if (_currentPage == _images.count - 1)
    {
        _currentPage = 1;
    }
    
    else if (_currentPage == 0)
    {
        _currentPage = _images.count - 2;
    }
}

- (void)dealloc
{
    [self end];
}

@end
