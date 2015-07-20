//
//  DropDownListView.m
//  KDropDownMultipleSelection
//
//  Created by macmini17 on 03/01/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import "DropDownListView.h"
#import "DropDownViewCell.h"

#define DROPDOWNVIEW_SCREENINSET 0
#define DROPDOWNVIEW_HEADER_HEIGHT 50.
#define RADIUS 0


@interface DropDownListView (private)

- (void)fadeIn;
- (void)fadeOut;
@end
@implementation DropDownListView

NSInteger indexSelectedInTable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple
{
    isMultipleSelection=isMultiple;
    CGRect rect = [[UIScreen mainScreen] bounds];//CGRectMake(point.x, point.y,size.width,size.height);
    
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        UIView *viewBlack = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        viewBlack.backgroundColor = [UIColor blackColor];
        viewBlack.alpha = 0.7;
        [self addSubview:viewBlack];
        
        _kTitleText = [aTitle copy];
        _kDropDownOption = [aOptions copy];
        self.arryData=[[NSMutableArray alloc]init];
        _kTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x + 20, rect.origin.y + 60, rect.size.width - 40, rect.size.height - 120)];
//                       CGRectMake(DROPDOWNVIEW_SCREENINSET,
//                                                                    DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT,
//                                                                   rect.size.width - 2 * DROPDOWNVIEW_SCREENINSET,
//                                                                   rect.size.height - 2 * DROPDOWNVIEW_SCREENINSET - DROPDOWNVIEW_HEADER_HEIGHT - RADIUS)];
        _kTableView.separatorColor = [UIColor grayColor]; // [UIColor colorWithWhite:1 alpha:.2];
        [_kTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _kTableView.backgroundColor =  [UIColor blueColor];
        _kTableView.dataSource = self;
        _kTableView.delegate = self;
        _kTableView.layer.cornerRadius = 4;
        _kTableView.clipsToBounds = YES;
        
        [self addSubview:_kTableView];
        if (isMultipleSelection) {
            UIButton *btnDone=[UIButton  buttonWithType:UIButtonTypeCustom];
            [btnDone setFrame:CGRectMake(rect.origin.x+182,rect.origin.y-45, 82, 31)];
            [btnDone setImage:[UIImage imageNamed:@"done@2x.png"] forState:UIControlStateNormal];
            [btnDone addTarget:self action:@selector(Click_Done) forControlEvents: UIControlEventTouchUpInside];
            [self addSubview:btnDone];
        }

        
    }
    return self;
}
-(void)Click_Done{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DropDownListView:Datalist:)]) {
        NSMutableArray *arryResponceData=[[NSMutableArray alloc]init];
        pr(@"%@",self.arryData);
        for (int k=0; k<self.arryData.count; k++) {
            NSIndexPath *path=[self.arryData objectAtIndex:k];
            [arryResponceData addObject:[_kDropDownOption objectAtIndex:path.row]];
            pr(@"pathRow=%ld",(long)path.row);
        }
    
        [self.delegate DropDownListView:self Datalist:arryResponceData];
        
    }
    // dismiss self
    [self fadeOut];
}
#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
        [_kTableView reloadData];
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
    
}

// gds method
- (void)showInView:(UIView *)aView animated:(BOOL)animated withSelectedIndex:(NSInteger)index {
    indexSelectedInTable = index;
    if (indexSelectedInTable != -1) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexSelectedInTable inSection:0];
        [_kTableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    
    [self showInView:aView animated:YES];
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_kDropDownOption count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"DropDownViewCell";
    
    UITableViewCell *cell;//  = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil)
    {
        cell = [[DropDownViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    NSInteger row = indexPath.row;
    UIImageView *imgarrow=[[UIImageView alloc]init ];
    
    if(indexSelectedInTable == indexPath.row){
        imgarrow.frame=CGRectMake(IS_iPad?650:240,9, 24, 24);
        imgarrow.image=[UIImage imageNamed:@"checkbox-active"];
	} else
        imgarrow.image=nil;
    
    [cell addSubview:imgarrow];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    cell.textLabel.text = [_kDropDownOption[row] objectForKey:@"name"] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isMultipleSelection) {
        if([self.arryData containsObject:indexPath]){
            [self.arryData removeObject:indexPath];
        } else {
            [self.arryData addObject:indexPath];
        }
        [tableView reloadData];

    }
    else{
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(DropDownListView:didSelectedIndex:)]) {
            [self.delegate DropDownListView:self didSelectedIndex:[indexPath row]];
        }
        // dismiss self
        [self fadeOut];
    }
	
}

#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    
    [self fadeOut];
}

#pragma mark - DrawDrawDraw
- (void)drawRect:(CGRect)rect
{
    CGRect bgRect = CGRectInset(rect, DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET);
    CGRect titleRect = CGRectMake(DROPDOWNVIEW_SCREENINSET + 200, DROPDOWNVIEW_SCREENINSET + 10 + 5,
                                  rect.size.width -  2 * (DROPDOWNVIEW_SCREENINSET + 10), 30);
    CGRect separatorRect = CGRectMake(DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * DROPDOWNVIEW_SCREENINSET, 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:1.0].CGColor);
    [[UIColor colorWithRed:R/255 green:G/255 blue:B/255 alpha:A] setFill];
    
    float x = DROPDOWNVIEW_SCREENINSET;
    float y = DROPDOWNVIEW_SCREENINSET;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow

    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithWhite:1 alpha:1.] setFill];
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.0];
        UIColor *cl=[UIColor brownColor];
        
        
        NSDictionary *attributes = @{ NSFontAttributeName: font,NSForegroundColorAttributeName:cl};
        
        [_kTitleText drawInRect:titleRect withAttributes:attributes];
    }
    else
     // [_kTitleText drawInRect:titleRect withFont:[GSFont systemFontOfSize:16.]];
    
    CGContextFillRect(ctx, separatorRect);
    
}


-(void)SetBackGroundDropDwon_R:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alph{
    R=r;
    G=g;
    B=b;
    A=alph;
}

@end
