//
//  ResourcesManagerViewController.h
//  qupai
//
//  Created by Worthy on 14/11/27.
//  Copyright (c) 2014年 duanqu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^pasterEditBlock)(BOOL edit);
typedef void (^editFontBlock)(BOOL fontEdit);
@protocol QPResourcesManagerViewControllerDelegate <NSObject>

@optional
- (void)resourcesManagerViewControllerClose;

@end

@interface QPResourcesManagerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viewEmpty;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewEmpty;
@property (weak, nonatomic) IBOutlet UILabel *labelEmpty;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsViewLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewTopTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewTopHeight;

@property (weak, nonatomic) id<QPResourcesManagerViewControllerDelegate> delegate;

- (IBAction)buttonCloseClick:(id)sender;

@end


