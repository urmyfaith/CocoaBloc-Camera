//
//  SCReviewControllers.m
//  StitchCam
//
//  Created by David Warner on 9/18/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import "SBReviewController.h"
#import <PureLayout/PureLayout.h>
#import "SBAssetsManager.h"
#import "SBCaptureManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "SBAsset.h"

#import "SBPhotoReviewView.h"
#import "SBVideoReviewView.h"

#import "SBCaptionButton.h"

#import "UIDevice+Orientation.h"

@interface SBReviewController ()

@property (nonatomic) SBReviewView *reviewView;

@end

@implementation SBReviewController

- (BOOL) isOfficialEnabled {
    return self.reviewView.officialButton.isOn;
}

- (BOOL) isExclusiveEnabled {
    return self.reviewView.exclusiveButton.isOn;
}

#pragma mark - Init methods

- (instancetype) initWithAsset:(SBAsset *)asset {
    if (self = [super init]) {
        self.reviewOptions = SBReviewViewOptionsDoNotShow;
        _asset = asset;
    }
    return self;
}

#pragma mark - View State
-(void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.view.backgroundColor = [UIColor blackColor];
    
    switch (self.asset.type) {
        case SBAssetTypeImage: {
            self.reviewView = [[SBPhotoReviewView alloc] initWithFrame:self.view.bounds];
            @weakify(self);
            [[self.asset fetchImage] subscribeNext:^(UIImage *image) {
                @strongify(self);
                [(SBPhotoReviewView*)self.reviewView setImage:image];
            }];
            break;
        }
        case SBAssetTypeVideo:
            self.reviewView = [[SBVideoReviewView alloc] initWithFrame:self.view.bounds videoURL:self.asset.fileURL];
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.reviewView];
    [self.reviewView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.reviewView.rejectButton addTarget:self action:@selector(rejectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviewView.acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviewView.undoButton addTarget:self action:@selector(undoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviewView.drawButton addTarget:self action:@selector(drawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.reviewView.drawButton.hidden = YES;
    self.reviewView.undoButton.hidden = YES;
    
    RAC(self.reviewView, options) = RACObserve(self, reviewOptions);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIViewController attemptRotationToDeviceOrientation];
}

#pragma mark Actions

- (void) undoButtonPressed:(UIButton*)button {
    
}

- (void) drawButtonPressed:(UIButton*)button {
    
}

-(void)rejectButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reviewController:rejectedAsset:)]) {
        [self.delegate reviewController:self rejectedAsset:self.asset];
    }
}

-(void)acceptButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reviewController:acceptedAsset:)]) {
        NSString *title = self.reviewView.titleField.text;
        NSString *caption = self.reviewView.descriptionField.text;
        if (title.length > 0) {
            self.asset.title = title;
            if (caption.length > 0)
                self.asset.caption = caption;
        }

        [self.delegate reviewController:self acceptedAsset:self.asset];
    }
}

#pragma mark - Status bar states
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
