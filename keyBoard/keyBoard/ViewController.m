//
//  ViewController.m
//  自定义键盘
//
//  Created by 王洋 on 2018/10/19.
//  Copyright © 2018年 王洋. All rights reserved.
//

#import "ViewController.h"
#import "keyBoard.h"
//#import "KeyBoardView.h"
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property(nonatomic,strong)dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UITextField *textFiled2;
@property(weak,nonatomic)keyBoard *keyBoard1;
@property(weak,nonatomic)keyBoard *keyBoard2;

@end

@implementation ViewController
- (IBAction)click:(id)sender {
//    UIView *view = [UIApplication sharedApplication].keyWindow ;
    NSLog(@"self.view.subviews.count = %ld",self.view.subviews.count);

    [self actionForScreenShotWith:self.view savePhoto:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    keyBoard *keyBoardView = [[keyBoard alloc]init];
    keyBoardView.handleTextFiled = self.textFiled;
    [self.view addSubview:keyBoardView];
    
    self.keyBoard1 = keyBoardView;
    self.textFiled.inputView=[[UIView alloc] init];
    self.textFiled.inputView.hidden=YES;
    self.textFiled.delegate = self;
    self.textFiled.tag = 100001;
    keyBoardView.tag = 100001;

    keyBoard *keyBoardView2 = [[keyBoard alloc]init];
    keyBoardView2.handleTextFiled = self.textFiled2;
    [self.view addSubview:keyBoardView2];
    self.keyBoard2 = keyBoardView2;
    self.textFiled2.inputView=[[UIView alloc] init];
    self.textFiled2.inputView.hidden=YES;
    self.textFiled2.delegate = self;
    self.textFiled2.tag = 100002;
    keyBoardView2.tag = 100002;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"STARTEDITING" object:@"YES"];
    if (textField.tag == 100001) {
        self.keyBoard1.isAcceptNoti = YES;
        self.keyBoard2.isAcceptNoti = NO;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"STARTEDITING" object:@"NO"];
    if (textField.tag == 100001) {
        self.keyBoard1.isAcceptNoti = YES;
        self.keyBoard2.isAcceptNoti = NO;
    }
    return YES;
}
/// 截屏
- (void)actionForScreenShotWith:(UIView *)aimView savePhoto:(BOOL)savePhoto {

    if (!aimView) return;

    UIGraphicsBeginImageContextWithOptions(aimView.bounds.size, NO, 0.0f);
    [aimView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    if (savePhoto) {
        /// 保存到本地相册
        UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error) {
        NSLog(@"保存失败，请重试");
    } else {
        NSLog(@"保存成功");
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.textFiled endEditing:YES];
    [self.textFiled2 endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
