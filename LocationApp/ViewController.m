//
//  ViewController.m
//  LocationApp
//
//  Created by 张柯 on 2018/2/6.
//  Copyright © 2018年 张柯. All rights reserved.
//

#import "ViewController.h"
#import "ChangeLocation.h"
#import "GDataXMLNode.h"


@interface ViewController ()<NSXMLParserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    116.403414,39.924091 //故宫
//    116.307672,39.819901 //房天下大厦
    
    //1.查找要定位的位置坐标
    CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake(39.819901,116.307672);
    //2.再进行坐标转换（对应百度和高德转苹果）
    CLLocationCoordinate2D WGSlocation2D = [ChangeLocation bd09ToWgs84:location2D];
    NSLog(@"纬度：%f,经度：%f",WGSlocation2D.latitude , WGSlocation2D.longitude);
    
    
    
    
    return;
    //获取工程目录的xml文件
    NSString *gpxPath = [[NSBundle mainBundle]pathForResource:@"Location" ofType:@"gpx"];
    NSData *xmlData = [[NSData alloc]initWithContentsOfFile:gpxPath];
    
    //DOM解析
    NSError *error = nil;

    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    if (error) {
        NSLog(@"error : %@", error);
        return;
    }
    
    GDataXMLElement *rootElement = xmlDocument.rootElement;
//    GDataXMLElement *gpx = [rootElement elementsForName:@"gpx"].firstObject;
    GDataXMLElement *wpt = [rootElement elementsForName:@"wpt"].firstObject;
    
    GDataXMLNode *lat = [wpt attributeForName:@"lat"];
    [lat setStringValue:[NSString stringWithFormat:@"%f",WGSlocation2D.latitude]];
    GDataXMLNode *lon = [wpt attributeForName:@"lat"];
    [lon setStringValue:[NSString stringWithFormat:@"%f",WGSlocation2D.longitude]];

    
    
    //SAX解析
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.delegate = self;
    [parser parse];
    
}


#pragma mark -- NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"DidStartDocument");
}
//解析完毕XML文档
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"DidEndDocument");
}

/**
 只要开始解析一个元素就会调用

 @param parser <#parser description#>
 @param elementName 元素名称
 @param namespaceURI <#namespaceURI description#>
 @param qName <#qName description#>
 @param attributeDict 元素中的属性
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
     NSLog(@"%@", elementName);
     NSLog(@"%@", attributeDict);
}

// 只要解析完一个元素就会调用
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
     NSLog(@"%@", elementName);
}

// 解析出现错误时调用
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    NSLog(@"error");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
