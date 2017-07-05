//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerDemoAppDelegate.h"
#import "ELCImagePickerDemoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
@import Firebase;
@import FirebaseStorage;
@import FirebaseDatabase;


@interface ELCImagePickerDemoViewController ()

@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

@end

@implementation ELCImagePickerDemoViewController
NSString *imageID;
FIRDatabaseReference *ref;


//Using generated synthesizers
- (IBAction)launchController:(id)sender {
    
    
    //Show picker
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (IBAction)launchSpecialController
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.specialLibrary = library;
    NSMutableArray *groups = [NSMutableArray array];
    [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {
            // this is the end
            [self displayPickerForGroup:[groups objectAtIndex:0]];
        }
    } failureBlock:^(NSError *error) {
        self.chosenImages = nil;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"A problem occured %@", [error description]);
        // an error here means that the asset groups were inaccessable.
        // Maybe the user or system preferences refused access.
    }];
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = _scrollView.frame;
    workingFrame.origin.x = 0;
    
   
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                
                [_scrollView addSubview:imageview];
                
     
//              
//                //Create a new folder
//                NSString *directoryName = @"Marriage";
//                
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,   NSUserDomainMask, YES);
//                NSLog(@"Current directory path: %@", paths);
//                NSString *applicationDirectory = [paths objectAtIndex:0];
//                NSString *filePathAndDirectory = [applicationDirectory stringByAppendingPathComponent:directoryName];
//                NSLog(@"Current new directory: %@", filePathAndDirectory);
//                
//                NSError *error;
//                
//                if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
//                                               withIntermediateDirectories:YES
//                                                                attributes:nil
//                                                                     error:&error])
//                {
//                    NSLog(@"Create directory error: %@", error);
//                }
//                NSString *filenameimage = imageID;
//           
//                NSLog(@"Created file: %@", [filenameimage stringByAppendingString:@".jpg"]);
//                
//                NSLog(@"filename = %@", filenameimage);
//                NSString *filePath = [filePathAndDirectory stringByAppendingPathComponent:[filenameimage stringByAppendingString:@".png"]];
//                NSFileManager *manager = [NSFileManager defaultManager];
//                // 1st, This funcion could allow you to create a file with initial contents.
//                // 2nd, You could specify the attributes of values for the owner, group, and permissions.
//                // Here we use nil, which means we use default values for these attibutes.
//                // 3rd, it will return YES if NSFileManager create it successfully or it exists already.
//                if ([manager createFileAtPath:filePath contents:nil attributes:nil]) {
//                    NSLog(@"Created the File Successfully.");
//                } else {
//                    NSLog(@"Failed to Create the File");
//                }
                
                //Store images to  server
                
                ref = [[FIRDatabase database] reference];
                 NSLog(@"ref value %@", ref);
                FIRUser *currentUser = [FIRAuth auth].currentUser;
                FIRStorageReference *storageRef = [[FIRStorage storage] reference];
                NSLog(@"refe value %@", storageRef);
                imageID = [[NSUUID UUID] UUIDString];
//                NSString *imageName = [NSString stringWithFormat:@"Birthday/%@.jpg",imageID];
                
                NSString *imageName = [NSString stringWithFormat:@"Files/UserId/%@.jpg",imageID];

                
                FIRStorageReference *profilePicRef = [storageRef child:imageName];
                FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
                metadata.contentType = @"image/jpeg";
                NSData *imageData = UIImageJPEGRepresentation(imageview.image, 0.8);
                [profilePicRef putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
                 {
                     if (!error)
                     {
                         NSString *profileImageURL = metadata.downloadURL.absoluteString;
                         NSLog(@"profileImageURL %@", profileImageURL);
                         //[self saveValuesForUser: currentUser];
                          [[[[ref child:@"Files"] child:@"UserId"] child:@"imagename"] setValue:profileImageURL];
                         
                                               }
                     else if (error)
                     {
                         NSLog(@"Failed to Register User with profile image");
                     }
                 }];
//                
//                //Retrieve images                
//                NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePathAndDirectory
//                                                                                    error:NULL];
//                NSMutableArray *mp3Files = [[NSMutableArray alloc] init];
//                [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    NSString *filename = (NSString *)obj;
//                    NSString *extension = [[filename pathExtension] lowercaseString];
//                    if ([extension isEqualToString:@"png"]) {
//                        [mp3Files addObject:[filePathAndDirectory stringByAppendingPathComponent:filename]];
//                        
//                        for (id obj in mp3Files)
//                            NSLog(@"IMAGENAME: %@", obj);
//                        
//                    }
//                }];

                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                [_scrollView addSubview:imageview];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    self.chosenImages = images;
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSLog(@" directory images: %@", imageURL);
    
    
        [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
