//
//  FlowView.m
//  LinCore
//
//  Created by lin on 8/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "FlowView.h"
#import "LinUtil/util.h"


@interface FlowLayouter : NSObject{
    @package
    Stack * leftViews;
    Stack * rightViews;
    CGRect _rect;
    float lastY;
    float lastX;
    CGSize _space;
}

-(void)place:(UIView*)child view:(UIView*)view;

@end

@implementation FlowLayouter


-(void)place:(UIView *)child view:(UIView*)view{
    
//}
//private Stack leftViews;
//private Stack rightViews;
//
//void place(View child){
//    Position pos;
//    child.layout(); // 子节点先进行布局

    
    CGRect rect = child.bounds;
    
    float w = view.bounds.size.width;
    
    if (lastX + rect.size.width > w) {
        lastX = 0;
        lastY += rect.size.height + _space.height;
    }
    
    child.frame = CGRectMake(lastX, lastY, rect.size.width, rect.size.height);
    
    lastX += rect.size.width + _space.width;
    
    [child layoutSubviews];
    
//    rect = [child convertRect:rect toView:_scrollView];
    
//    while(!this.spaceFits(child)){
//        if(child.floatLeft){
//            View view = this.leftViews.pop();
//            pos = view.pos;
//            // 当被移除的节点比其它节点更高时, 继续移除
//            while(pos.y > this.leftViews.last.y){
//                View view = this.leftViews.pop();
//                pos = view.pos;
//            }
//        }
//        if(child.floatRight){
//            View view = this.rightViews.pop();
//            pos = view.pos;
//            // 当被移除的节点比其它节点更高时, 继续移除
//            while(pos.y > this.rightViews.last.y){
//                View view = this.rightViews.pop();
//                pos = view.pos;
//            }
//        }
//    }
//    
//    // place child here
//    child.pos = pos;
//    
//    if(child.floatLeft){
//        this.leftViews.push(child.pos);
//    }
//    if(child.floatRight){
//        this.rightViews.push(child.pos);
//    }
}

@end


@interface FlowView(){
    FlowLayouter * _layouter;
    CGSize _space;
}

@end
@implementation FlowView

-(instancetype)init{
    self = [super init];
    
    if (self) {
        _layouter = [[FlowLayouter alloc] init];
    }
    
    return self;
}

-(CGSize)space{
    return _space;
}

-(void)setSpace:(CGSize)space{
    if (space.width == _space.width && space.height == _space.height) {
        return;
    }
    _space = space;
    [self setNeedsLayout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//private FlowLayouter layouter;

// 当控件发生 frame 改变后, 调用此方法标记为需要重新布局
//void setNeedsLayout(){
//    View view = this;
//    while(view){
//        view.markNeedsLayout();
//        // 当控件需要重新布局时, 一般地, 它的父节点也需要重新布局
//        view = view.parent;
//    }
//}
-(void)setNeedsLayout{
    UIView * view = [self superview];
    while (view) {
//        [view setNeedsLayout];
        view = [view superview];
    }
}

//void layout(){
//    for(View child in this.children){
//        this.layouter.place(child);
//    }
-(void)layoutSubviews{
    _layouter->lastX = 0;
    _layouter->lastY = 0;
    _layouter->_space = _space;
    for (UIView * child in [self subviews]) {
        [_layouter place:child view:self];
    }
}

@end
