//
//  FormViewController.m
//  SwiftForms
//
//  Created by Miguel Angel Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import "FormSectionDescriptor.h"
#import "FormBaseCell.h"

@implementation FormViewController

-(id)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(id)initWithForm:(FormDescriptor *)form{
    self = [super init];
    if (self) {
        self.form = form;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.form.sections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [((FormSectionDescriptor*)self.form.sections[section]).rows count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FormRowDescriptor * rowDescriptor = [self formRowDescriptorAtIndexPath:indexPath];
    Class formBaseClassClass = [rowDescriptor formBaseCellClassFromRowDescriptor];

    NSString * reuseIdentifier = NSStringFromClass(formBaseClassClass);
    
    FormBaseCell * cell = (FormBaseCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[formBaseClassClass alloc] initWithStyle:rowDescriptor.cellStyle reuseIdentifier:reuseIdentifier];
        [cell configure];
    }
    
    [cell setRowDescriptor:rowDescriptor];
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return ((FormSectionDescriptor*)self.form.sections[section]).headerTitle;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return ((FormSectionDescriptor*)self.form.sections[section]).footerTitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    FormRowDescriptor * rowDescriptor = [self formRowDescriptorAtIndexPath:indexPath];
    if ([rowDescriptor formBaseCellClassFromRowDescriptor] != nil) {
        return [[rowDescriptor formBaseCellClassFromRowDescriptor] formRowCellHeight];
    }
    return [super tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    FormRowDescriptor * rowDescriptor = [self formRowDescriptorAtIndexPath:indexPath];

    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[FormBaseCell class]]) {
        FormBaseCell * selectedRow = (FormBaseCell*)[tableView cellForRowAtIndexPath:indexPath];
        [[rowDescriptor formBaseCellClassFromRowDescriptor] formViewController:self didSelectRow:selectedRow];
    }

    if ([((id)self.delegate) conformsToProtocol:@protocol(FormViewControllerDelegate)] == YES) {
        if ([((id)self.delegate) respondsToSelector:@selector(formViewController:didSelectRowDescriptor:)]) {
            [self.delegate formViewController:self didSelectRowDescriptor:rowDescriptor];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

-(FormRowDescriptor*)formRowDescriptorAtIndexPath:(NSIndexPath*)indexPath{
    FormSectionDescriptor * section = (FormSectionDescriptor*)self.form.sections[indexPath.section];
    
    return (FormRowDescriptor*)section.rows[indexPath.row];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
