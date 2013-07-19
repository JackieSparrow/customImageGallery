//
//  customImageLibrary.m
//  ZipYap
//
//  Created by Mohit on 11/07/13.
//  Copyright (c) 2013 Mohit. All rights reserved.
//

#import "customImageLibrary.h"
#import <QuartzCore/QuartzCore.h>

@interface customImageLibrary ()

@end

static int count=0;
NSString *photoName;
NSString *photoUrl;
@implementation customImageLibrary

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    mutableArray =[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    [self.navigationController.navigationBar setHidden:YES];
    self.m_titleLabel.font=[UIFont fontWithName:@"Raleway-Light" size:18];
    self.m_indiView.layer.cornerRadius=5.0f;
    [self.m_indiView setHidden:NO];
    [self.m_indicator startAnimating];
    [self getAllPictures];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(ShowImageLibrary) withObject:nil afterDelay:2.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Create thumbnails in scroll View

-(void)ShowImageLibrary
{
    
        CGFloat y_axis=5;
        CGFloat x_axix=5;
        CGFloat imageViewheight=0.0;
        int count=0;
        NSInteger numberofRow;
        int rowCount=imageArray.count%3;
        if(rowCount==0)
        {
            numberofRow=imageArray.count/3;
        }
        else
        {
            numberofRow=imageArray.count/3;
            numberofRow=numberofRow+1;
        }
        
        for (int i=0;i<numberofRow;i++)
        {
            
            for (int j=0; j<3;j++)
            {
                if(count<=imageArray.count-1)
                {
                    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(x_axix, y_axis, 100,100)];
                    imageView.tag=count;
                    imageView.layer.borderWidth=1.5;
                    imageView.image=[imageArray objectAtIndex:count];
                    
                    checkImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
                    [checkImageView setImage:[UIImage imageNamed:@""]];
                    checkImageView.tag=count+500;
                    [imageView addSubview:checkImageView];
                    
                    
                    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
                    [tapGesture setNumberOfTapsRequired:1];
                    [tapGesture setNumberOfTouchesRequired:1];
                    [imageView addGestureRecognizer:tapGesture];
                    [imageView setUserInteractionEnabled:YES];
                    [_m_ScrollViewLib addSubview:imageView];
                    x_axix+=imageView.frame.size.width+5;
                    count++;
                    imageViewheight=imageView.frame.size.height;
                    
                    [imageView release];
                    [tapGesture release];
                    
                }
            }
            x_axix=5;
            y_axis+=imageViewheight+5;
        }
        
        float sizeOfContent = 0;
        int i;
        for (i = 0; i < numberofRow+3; i++) {
            sizeOfContent = sizeOfContent+100;
        }
        [_m_ScrollViewLib setContentSize:CGSizeMake(0,sizeOfContent)];
    
    [self.m_indiView setHidden:YES];
    [self.m_indicator stopAnimating];
    }

-(void)handleTap:(UIGestureRecognizer *)recognizer
{
    
    UIImageView *imageView=(UIImageView*)recognizer.view;
    UIImageView *check=(UIImageView*)[self.view viewWithTag:imageView.tag+500];
    
    [check setImage:[UIImage imageNamed:@"check_YES_White.png"]];

    
}

//Get All images from photo Library

-(void)getAllPictures
{

    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             
                             if ([mutableArray count]==count)
                             {
                                 imageArray=[[NSArray alloc] initWithArray:mutableArray];
                                // NSLog(@"imaegArray.Count%d",imageArray.count);
                             }
                         }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count=[group numberOfAssets];
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
    
    
}

- (void)dealloc {
    [_m_ScrollViewLib release];
    [_m_titleLabel release];
    [_m_indiView release];
    [_m_indicator release];
    [super dealloc];
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
