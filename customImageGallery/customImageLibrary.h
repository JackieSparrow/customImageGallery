//
//  customImageLibrary.h
//  ZipYap
//
//  Created by Mohit on 11/07/13.
//  Copyright (c) 2013 Mohit. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AssetsLibrary/AssetsLibrary.h>

@interface customImageLibrary : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
    UIImageView *checkImageView;
}
@property (retain, nonatomic) IBOutlet UIScrollView *m_ScrollViewLib;
@property (retain, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (retain, nonatomic) IBOutlet UIView *m_indiView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *m_indicator;

-(void)allPhotosCollected:(NSArray*)imgArray;
- (IBAction)backAction:(id)sender;
- (IBAction)cameraAction:(id)sender;

@end
