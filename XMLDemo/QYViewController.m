//
//  QYViewController.m
//  XMLDemo
//
//  Created by qingyun on 14-11-27.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYViewController.h"
#import "QYBook.h"
#import "GDataXMLNode.h"

#define kBookStore  @"bookstore"
#define kBook       @"book"
#define kCategory   @"category"
#define kTitle      @"title"
#define kLanguage   @"lang"
#define kAuthor     @"author"
#define kYear       @"year"
#define kPrice      @"price"

//#define BUILD_XML_SAX


@interface QYViewController () <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *bookstore;
@property (nonatomic, strong) QYBook *currentBook;
@property (nonatomic, strong) NSString *currentContent;
@end

@implementation QYViewController

#ifdef BUILD_XML_SAX
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. 创建url
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    
    // 2. 创建xml解析器对象
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];

    // 3. 设置解析器的代理
    parser.delegate = self;
    
    // 4. 开始解析
    BOOL result = [parser parse];
    
    if (!result) {
        NSLog(@"bookstore.xml parse error!");
        return;
    }
}

#pragma mark - xml parser delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    // 创建模型对象数组
    _bookstore = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // 遇到element开始标签了，在这里创建模型对象，或者解析模型对象的属性，并保存到模型对象中
    if ([elementName isEqualToString:kBook]) {
        _currentBook = [[QYBook alloc] init];
        _currentBook.category = attributeDict[kCategory];
    }
    
    if ([elementName isEqualToString:kTitle]) {
        _currentBook.lang = attributeDict[kLanguage];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    _currentContent = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kBook]) {
        [_bookstore addObject:_currentBook];
    } else if ([elementName isEqualToString:kBookStore]) {
        NSLog(@"bookstore.xml will finish parsing.");
    } else {
        [_currentBook setValue:_currentContent forKey:elementName];
    }

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"parseError:%@", parseError);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"bookstore:%@", _bookstore);
}

#else

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"GDataXMLNode");
    
    _bookstore = [NSMutableArray array];
    
    // 1. 从bookstore.xml生成NSData对象
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 2. 根据NSData对象，创建GDataXMLDocument对象
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    
    // 3. 从DOM模型对象中，取出根元素rootElement
    GDataXMLElement *rootElement = [doc rootElement];
    NSArray *elements = [rootElement elementsForName:kBook];
    
//    NSLog(@"%@", elements);
    
    // 4. 遍历取得其他的子元素
    for (GDataXMLElement *element in elements) {
        // 创建模型对象
        QYBook *book = [[QYBook alloc] init];
        
        // 根据属性名字，解析book的属性
        book.category = [[element attributeForName:kCategory] stringValue];
        
        // 解析book的子元素的内容，及子元素的属性
        GDataXMLElement *titleElement = [element elementsForName:kTitle][0];
        book.title = [titleElement stringValue];
        book.lang = [[titleElement attributeForName:kLanguage] stringValue];
        
        GDataXMLElement *authorElement = [element elementsForName:kAuthor][0];
        book.author = [authorElement stringValue];
        
        GDataXMLElement *yearElement = [element elementsForName:kYear][0];
        book.year = [yearElement stringValue];
        
        GDataXMLElement *priceElement = [element elementsForName:kPrice][0];
        book.price = [priceElement stringValue];

        [_bookstore addObject:book];
    }
    
    NSLog(@"Bookstore:%@", _bookstore);
    
}

#endif

@end
