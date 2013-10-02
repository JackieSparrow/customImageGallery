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

/*
 
 #pragma mark - TextView delegate Method
 
 -(void)textViewDidChange:(UITextView *)textView
 {
 
 [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
 UIFont *font=[UIFont fontWithName:fontName size:fontsize];
 CGSize size = [_m_TextLabel.text sizeWithFont:font constrainedToSize:_m_TextLabel.frame.size
 lineBreakMode:NSLineBreakByCharWrapping];
 
 CGRect frame=_m_TextLabel.frame;
 frame.size.height=_m_TextLabel.contentSize.height;
 // _m_TextLabel.font=font;
 NSLog(@"TextView height%f",size.height);
 NSLog(@"image View height%f",_GifImagePreview.frame.size.height);
 if(frame.size.height>_GifImagePreview.frame.size.height+20)
 {
 NSLog(@"1");
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please decrease the font size or delete some text" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
 _m_TextLabel.frame=CGRectMake(_m_TextLabel.frame.origin.x,_GifImagePreview.frame.origin.y, _m_TextLabel.frame.size.width,_GifImagePreview.frame.size.height);
 isTure=TRUE;
 [alert show];
 [alert release];
 }
 else
 {
 CGSize size123 = [_m_TextLabel.text sizeWithFont:font constrainedToSize:_m_TextLabel.frame.size
 lineBreakMode:NSLineBreakByCharWrapping]; // default mode
 int numberOfLines = size123.height / font.lineHeight;
 
 NSLog(@"Number of lines %d",numberOfLines);
 
 if(numberOfLines>1)
 {
 NSLog(@"2");
 _m_TextLabel.frame=CGRectMake(_m_TextLabel.frame.origin.x,frame.origin.y, frame.size.width,frame.size.height);
 }
 else
 {
 CGFloat width =  [textView.text sizeWithFont:textView.font].width;
 
 UILabel *locationLabel=[[UILabel alloc]init];
 locationLabel.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y,width+20, textView.frame.size.height);
 int a=_m_TextLabel.frame.origin.x-_GifImagePreview.frame.origin.x;
 
 int b=locationLabel.frame.size.width+a;
 
 
 NSLog(@"wsdasadasd%d",b);
 // _GifImagePreview.frame.size.width);
 if(b>_GifImagePreview.frame.size.width)
 {
 NSLog(@"3");
 
 locationLabel.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y,_GifImagePreview.frame.size.width-20, textView.frame.size.height);
 
 textView.frame = locationLabel.frame;
 //[locationLabel release];
 
 textView.frame = locationLabel.frame;
 // [locationLabel release];
 }
 else
 {
 
 locationLabel.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y,width+25,40);
 NSLog(@"4");
 textView.frame = locationLabel.frame;
 // [locationLabel release];
 }
 }
 }
 if(frame.size.width>_GifImagePreview.frame.size.width)
 {
 NSLog(@"5");
 CGFloat widthCalData=_GifImagePreview.frame.size.width-_m_TextLabel.frame.origin.x;
 CGFloat textViewwidth=_m_TextLabel.frame.size.width-widthCalData;
 
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please decrease the font size or delete some text" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
 _m_TextLabel.frame=CGRectMake(_m_TextLabel.frame.origin.x+textViewwidth,_GifImagePreview.frame.origin.y, _m_TextLabel.frame.size.width,_GifImagePreview.frame.size.height);
 isTure=TRUE;
 [alert show];
 [alert release];
 }
 
 ///////////For Width////////////
 CGFloat widthData=_GifImagePreview.frame.size.width-_m_TextLabel.frame.origin.x;
 CGFloat setWidth=_m_TextLabel.frame.size.width-widthData;
 NSLog(@"Width123 %f",widthData);
 NSLog(@"Width321 %f",widthData);
 CGFloat width =  [textView.text sizeWithFont:textView.font].width;
 UILabel *locationLabel=[[UILabel alloc]init];
 locationLabel.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y,width+20, textView.frame.size.height-1);
 int a=_m_TextLabel.frame.origin.x-_GifImagePreview.frame.origin.x;
 int b=locationLabel.frame.size.width+a;
 
 if(b>_GifImagePreview.frame.size.width)
 {
 locationLabel.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y,_GifImagePreview.frame.size.width-a-5, textView.contentSize.height-5);
 NSLog(@"6");
 textView.frame = locationLabel.frame;
 
 }
 
 //////////For Height////////////
 CGFloat heightData=_GifImagePreview.frame.size.height-_m_TextLabel.frame.origin.y;
 CGFloat setHeight=_m_TextLabel.frame.size.height-heightData;
 
 if(_m_TextLabel.frame.size.height  > heightData)
 {
 NSLog(@"7");
 [_m_TextLabel setFrame:CGRectMake(_m_TextLabel.frame.origin.x, _m_TextLabel.frame.origin.y-setHeight, _m_TextLabel.frame.size.width, _m_TextLabel.frame.size.height)];
 }
 /////////For Y_axis of TextView
 
 if(_m_TextLabel.frame.origin.y<=_GifImagePreview.frame.origin.y && _m_TextLabel.frame.size.height<=_GifImagePreview.frame.size.height)
 {
 
 [_m_TextLabel setFrame:CGRectMake(_m_TextLabel.frame.origin.x, _GifImagePreview.frame.origin.y, _m_TextLabel.frame.size.width, _m_TextLabel.frame.size.height)];
 }
 
 if(_m_TextLabel.frame.origin.y<=_GifImagePreview.frame.origin.y && _m_TextLabel.frame.size.height>_GifImagePreview.frame.size.height)
 {
 [_m_TextLabel setFrame:CGRectMake(_m_TextLabel.frame.origin.x, _GifImagePreview.frame.origin.y, _m_TextLabel.frame.size.width, _GifImagePreview.frame.size.height)];
 
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please decrease the font size or delete some text " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
 [alert show];
 [alert release];
 
 }
 _m_Crossbtn.frame=CGRectMake(_m_TextLabel.frame.origin.x-6,_m_TextLabel.frame.origin.y-28, _m_Crossbtn.frame.size.width,_m_Crossbtn.frame.size.height);
 
 
 }

 
 */


/*
 
 
 actionSheet = [[[UIActionSheet alloc]initWithTitle:@"Select State" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
 
 [actionSheet showInView:self.view];
 [actionSheet setBounds:CGRectMake(0, 0, 320, 470.0)];
 
 m_picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 44.0, 320.0, 250.0)];
 m_picker.delegate = self;
 m_picker.dataSource = self;
 m_picker.showsSelectionIndicator = YES;
 
 UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
 pickerToolbar.barStyle = UIBarStyleBlack;
 [pickerToolbar sizeToFit];
 
 NSMutableArray *barItems = [[NSMutableArray alloc] init];
 
 UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
 [barItems addObject:flexSpace];
 
 UIBarButtonItem *btnBarCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnBarCancelClicked)];
 [barItems addObject:btnBarCancel];
 
 [pickerToolbar setItems:barItems animated:YES];
 
 [actionSheet addSubview:pickerToolbar];
 [actionSheet addSubview:m_picker];

 
 */


@end
