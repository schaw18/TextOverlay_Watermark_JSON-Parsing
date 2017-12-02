//
//  ViewController.m
//  TextOverlay_Watermark
//
//  Created by Brandon Gutierrez on 11/30/17.
//  Copyright © 2017 Brandon Gutierrez. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"start");
}

-(IBAction)insertImageButtonClicked:(id)sender{
    [self insertSampleImage];
}

-(void)insertSampleImage{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_imageView.bounds.size.width, _imageView.bounds.size.height), NO, 0.0);
    
    //UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    //NSLog(@"%@", blank);
    UIGraphicsEndImageContext();

    //[_theImage setAlpha:0.0f];


    UIImage *sampleImage = [UIImage imageNamed:@"sample.jpg"];
    _imageView.image = sampleImage;

}

- (IBAction)addTextOverlayButtonClicked:(id)sender{
    [self addTextOverlay];
}

-(void)addTextOverlay{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 250, 40)];
    label.text = @"Test";
    label.textColor = [UIColor blueColor];
    label.font=[UIFont fontWithName:@"Marker Felt" size:35];
    [_imageView addSubview:label];
    [_imageView setUserInteractionEnabled:YES];
    [label setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];

    [label addGestureRecognizer:panGesture];
    panGesture = nil;
}

-(void)handlePanGesture:(id)sender
{
    //NSLog(@"handle pan gesture");
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
}

-(void)handleMovementView:(UIPanGestureRecognizer *)recognizer
{
    
    //NSLog(@"handle movement view");
    CGPoint movement;
    
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect rec = recognizer.view.frame;
        CGRect imgvw = _imageView.frame;
        if((rec.origin.x >= imgvw.origin.x && (rec.origin.x + rec.size.width <= imgvw.origin.x + imgvw.size.width)))
        {
            CGPoint translation = [recognizer translationInView:recognizer.view.superview];
            movement = translation;
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            rec = recognizer.view.frame;
            
            if( rec.origin.x < imgvw.origin.x )
                rec.origin.x = imgvw.origin.x;
            
            if( rec.origin.x + rec.size.width > imgvw.origin.x + imgvw.size.width )
                rec.origin.x = imgvw.origin.x + imgvw.size.width - rec.size.width;
            
            recognizer.view.frame = rec;
            
            [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
            //[self handleMovementForHandlers:movement];
        }
    }
}

-(IBAction)addWatermarkButtonClicked:(id)sender{
    _imageView.image = [self addWatermark];
}

-(UIImage*)addWatermark{
    
    UIImage *backgroundImage = _imageView.image;
    UIImage *watermarkedImage = [UIImage imageNamed:@"watermark.png"];
    
    
    //Now re-drawing your  Image using drawInRect method
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    // set watermark position/frame a s(xposition,yposition,width,height)
    //[watermarkedImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkedImage.size.width, backgroundImage.size.height - watermarkedImage.size.height, watermarkedImage.size.width, watermarkedImage.size.height)];
    [watermarkedImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    //[watermarkedImage drawInRect:CGRectMake(100, 300, 400, 50)];
    //[watermarkedImage drawInRect:CGRectMake(100, 300, 400, 50)];
    
    
    // now merging two images into one
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (IBAction)saveImageButtonClicked:(id)sender
{
    [self saveImage:_imageView];
}

-(UIImage *)saveImage:(UIImageView *)imgView
{
    UIGraphicsBeginImageContextWithOptions(_imageView.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_imageView.layer renderInContext:context];
    UIImage *images = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(images, nil, nil, nil);
    return images;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
