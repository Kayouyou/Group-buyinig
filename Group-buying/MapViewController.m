//
//  MapViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/23.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "DianpingApi.h"
#import "BusinessInfo.h"
#import "MapAnnotation.h"
#import "WebViewController.h"
#import "MapCallOutAnnotation.h"
#import "MapCallOutAnnotationView.h"

#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]
@import CoreLocation;//定位框架

//设置mapview的 代理
@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

//必须import mapkit  这个框架
@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@property (nonatomic,strong) NSMutableDictionary *params;

@property (nonatomic,strong) MapCallOutAnnotation *callOutAnnotation;

@property (nonatomic,strong) NSArray *business;

@property (nonatomic,strong) NSString *cityName;
//
//@property (nonatomic,strong) NSString *cityName1;
@end

@implementation MapViewController{
    
    CLLocationManager *_locationManager;//定位管理
    
    CLGeocoder *_geocoder;//地理编码
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册广播
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedBusiness:) name:@"pushWebViewNotification" object:nil];
    
    
    
    
    
    
    self.params = [NSMutableDictionary new];
    
    
    //创建gecoder  对像
    _geocoder = [[CLGeocoder alloc]init];
    
    self.MapView.showsUserLocation = YES;
    
    //请求定位服务
    _locationManager = [[CLLocationManager alloc]init];
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _MapView.delegate = self;
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _MapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //定位的精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    //定个位的频率
    _locationManager.distanceFilter = 10.0;//10米定位一次
    
    
    
    //设置地图类型
    _MapView.mapType = MKMapTypeStandard;
    
   

    [DianpingApi requestBusinessWithParams:_params AndCallback:^(id obj) {
        
        NSLog(@"_params:%@",obj);
        
        [self addAnnotatonByArray:obj];
    }];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    
    [self initUI];
    
    //调用gecode 的方法  获取当前的城市地理位置信息  并显示在地图上
    
    [self gecode:_cityName];
    

}
//
//
-(void)gecode:(NSString *)str{

    
    
    //对地址进行编码
    [_geocoder geocodeAddressString:_cityName completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            
            return;
            
        }else{
            for (CLPlacemark *placemark in placemarks) {
                NSLog(@"%@,%@,%@,%@", placemark.name, placemark.locality, placemark.country, placemark.postalCode);
            }
        }
        CLPlacemark *placemark = [placemarks firstObject];
        
        CLLocationCoordinate2D coord;
        
        coord.longitude = placemark.location.coordinate.longitude;
        coord.latitude = placemark.location.coordinate.latitude;

        [self.params setObject:@(coord.longitude) forKey:@"longitude"];
            [self.params setObject:@(coord.latitude) forKey:@"latitude"];
           [self.params setObject:@"5000" forKey:@"radius"];
        
        
            //设置地图的当期坐标区域  和 缩小比例
           [self.MapView  setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.2, 0.2)) animated:YES];
        
        
       
        }];
    
}
//


//为了显示地图时定位到您的当前位置
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{


    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    
  MKCoordinateRegion region =  MKCoordinateRegionMake(userLocation.location.coordinate,span);
    
    
    [self.params setObject:@(userLocation.location.coordinate.longitude) forKey:@"longitude"];
    
    [self.params setObject:@(userLocation.location.coordinate.latitude) forKey:@"latitude"];
    [self.params setObject:@"1000" forKey:@"radius"];
    
    
    //设置地图的当期坐标区域  和 缩小比例
    [self.MapView  setRegion:MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.5, 0.5)) animated:YES];
 
    

    [_MapView setRegion:region animated:YES];

}


-(void)addAnnotatonByArray:(NSArray *)arr{

    
//    [_MapView addAnnotation:annotation];
    

    
    //通过for循环  得到 每一个annotation
    for (BusinessInfo *info in arr) {
        
        MapAnnotation *annotation = [MapAnnotation new];
        
                
        
        CLLocationCoordinate2D coord;
        
        coord.latitude = info.latitude;
        coord.longitude = info.longitude;
        
        annotation.coordinate = coord;
        
//        annotation.title = info.name;
        
        annotation.business = info;
        annotation.urlString = info.business_url;
        
        NSLog(@" annotation.urlString:%@",annotation.urlString);
        
//        WebViewController *webVC = [[WebViewController alloc]init];
//        
//        
//        //webvc  根据传来的商户信息的URL   来显示响应的信息
//        webVC.urlString = annotation.urlString;
        
      
        
        
        //添加注释
        
        [self.MapView addAnnotation:annotation];
       
        //这句话会让所有的显示的大头针不用点击就显示标注
       //[_MapView selectAnnotation:annotation animated:YES];

    }
    

}

//当地图显示大头针时  调用此方法  返回自定义的大头针的样子
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    static NSString *AnnotationIdentifier = @"AnnotationIdentifier";
    
//    MKPinAnnotationView *customPinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        
        MKAnnotationView *customPinView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        
    
    //初始化大头针对象
    
    if (!customPinView)
        
    {
        
        customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    }
        //自定义图片  跟 animatesDrop 这个动画效果有冲突  会覆盖自定义图片  会显示系统默认的图片
        customPinView.image = [UIImage imageNamed:@"icon_pin_floating"];
 
#warning 图片还可以优化！！！
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        
//        customPinView.frame = CGRectMake(0, 0, 30, 60);
//        
//        //根据分类来获取指定的商品图标
//        
//        NSString *imageName = [self getImageNameWithBusiness:]
        
        
//        customPinView.pinColor = MKPinAnnotationColorRed;//更改的时系统打头阵的颜色
        
        //customPinView.canShowCallout = YES;//自定义时必须要设置
        
        //设置大头针掉落的动画
       // customPinView.animatesDrop = YES;
        
        //customPinView.draggable = YES;//可以拖动
        
       // customPinView.selected = YES;//用户交互
        
        return customPinView;
        
    }
    
    else if ([annotation isKindOfClass:[MapCallOutAnnotation class]])
        
    {
        static NSString * callOutIdentifier = @"callOutAnnotation";
        
        MapCallOutAnnotationView * view = (MapCallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:callOutIdentifier];
        
        
        if (!view) {
            
            view = [[MapCallOutAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:callOutIdentifier];
            
            
            
            
        }
        
        MapCallOutAnnotation *ann = (MapCallOutAnnotation *)annotation;
        
        
        view.business = ann.business;
        
        
        
        
        return view;
        
    }
    
 
    //给按钮添加button 设置
//    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    
//   [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
//    
//    customPinView.rightCalloutAccessoryView = rightButton;
//    
//    _button = rightButton;
   
 return nil;
    
}

//自动显示气泡

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{


    MKAnnotationView *view = (MKAnnotationView *)[views objectAtIndex:0];


    [self.MapView selectAnnotation:view.annotation animated:YES];




}


//响应button    这里推出webView

//-(void)showDetails:(MyButton*)sender{
//    
//   
//    
//    //点击某行单元格  会推出一个WEBVC   显示相应的详细信息
//    //先创建一个WEBVC对象
//    WebViewController *webVC = [[WebViewController alloc]init];
//    
//    //webvc  根据传来的商户信息的URL   来显示响应的信息
//    webVC.urlString = sender.urlString;
//    
//    
//    NSLog(@"sender.urlString :%@",sender.urlString);
//    //推出的web 界面是  隐藏bottomBar
//    webVC.hidesBottomBarWhenPushed = YES;
//    
//    //调用推出下一个界面的方法  带动画
//    [self.navigationController pushViewController:webVC animated:YES];
//    
//
//
//}

//响应用户点击按钮事件

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{

    if ([view.annotation isKindOfClass:[MapAnnotation class]]) {
        
        [self.MapView removeAnnotation:self.callOutAnnotation];
        
        
        
        MapAnnotation *ann = (MapAnnotation *)view.annotation;
        
        MapCallOutAnnotation *callOutAnn = [MapCallOutAnnotation new];
        
        callOutAnn.coordinate = ann.coordinate;
        
        callOutAnn.business = ann.business;
        
        self.callOutAnnotation = callOutAnn;
        
        [self.MapView addAnnotation:callOutAnn];
        

        
    }
    
    
    

    
//    MapAnnotation *ann = (MapAnnotation *)view.annotation;
//    
//    
//    MapAnnotation *annotation  = [MapAnnotation new];
//
//    annotation.urlString = ann.urlString;
//    
//
//    
//    
//    NSLog(@"11annotation.urlString:%@",annotation.urlString);
//    
//    
//    
//    
//    WebViewController *webVC = [[WebViewController alloc]init];
//        
//    webVC.urlString = annotation.urlString;
//
//    //推出的web 界面是  隐藏bottomBar
//    webVC.hidesBottomBarWhenPushed = YES;
//    
//    //调用推出下一个界面的方法  带动画
//    [self.navigationController pushViewController:webVC animated:YES];

    

}

//点击cell 后推出webview这个界面；


- (void)didSelectedBusiness:(NSNotification *)notification {


    NSString *url = notification.userInfo[@"url"];
    
    WebViewController *webView = [WebViewController new];
    
    webView.urlString = url;
    
    
    [self.navigationController pushViewController:webView animated:YES];


}


-(void)dealloc {


    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pushWebViewNotification" object:nil];




}



-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{


    NSLog(@"位置发生了变化");
    
    [self.MapView removeAnnotations:self.MapView.annotations];
    
    
    CLLocationCoordinate2D coord = mapView.centerCoordinate;

    [self.params setObject:@(coord.longitude) forKey:@"longitude"];
    [self.params setObject:@(coord.latitude) forKey:@"latitude"];
    
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
    
        [self addAnnotatonByArray:obj];
    
    }];
   



}

#pragma mark - reloadUI
//更新UI
-(void)initUI{
    //设置状栏 的frame
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    //    // 添加
    [self.navigationController.navigationBar addSubview:statusBarView];
    //    //设置导航栏的背景色
    statusBarView.backgroundColor = TOPIC_COLOR_ORANGE;
    
    //设置导航栏字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置导航栏的的背景色
    self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
