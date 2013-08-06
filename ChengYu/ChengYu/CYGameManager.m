//
//  CYGameManager.m
//  ChengYu
//
//  Created by ZYVincent on 13-6-17.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CYGameManager.h"

@implementation CYGameManager
@synthesize delegate;

- (id)init
{
    if (self = [super init]) {
        
        words = [[NSMutableArray alloc]init];
        correctList = [[NSMutableArray alloc]init];
        playerSelectedWord = [[NSMutableArray alloc]init];
        
        NSArray *randomArr = [[CYSqliteManager shareManager]getPagesWordListByRandom];
//        NSLog(@"randomArr --->%@",randomArr);
        
        NSMutableArray *resultArray = [NSMutableArray array];
        
        int resultCount = 9;
        for (int i=0; i<resultCount; i++) {
            
            int randIndex = arc4random()%randomArr.count;
            
            if ([resultArray containsObject:[randomArr objectAtIndex:randIndex]]) {
                i--;
                continue;
            }else{
                [resultArray addObject:[randomArr objectAtIndex:randIndex]];
            }
        }
        
        //取出所有字符
        for (int i=0; i<resultArray.count; i++) {
            
            NSArray *eachList = [[resultArray objectAtIndex:i]componentsSeparatedByString:@","];

            for (int j=0; j<eachList.count;j++) {
                
                NSString *eId = [eachList objectAtIndex:j];
                
                NSDictionary *wordText = [[CYSqliteManager shareManager]wordById:[NSNumber numberWithInt:[eId intValue]]];
                
                CYWord *newWord = [[CYWord alloc]initWithDict:wordText];
                [words addObject:newWord];
                [newWord release];
            }
        }
        
//        NSLog(@"allWords from sql --->%@",words);
        
        //取得正确字符数组
        for (int i=0; i<resultArray.count; i++) {
            
            NSArray *eachList = [[resultArray objectAtIndex:i]componentsSeparatedByString:@","];
            
            [correctList addObject:eachList];
        }
        
//        [self addWord:@"望子成龙"];
//        [self addWord:@"不三不四"];
//        [self addWord:@"不伦不类"];
//        [self addWord:@"坐井观天"];
//        [self addWord:@"厚积薄发"];
//        [self addWord:@"不舞之鹤"];
//        [self addWord:@"坐怀不乱"];
//        [self addWord:@"作茧自缚"];
//        [self addWord:@"否极泰来"];
//        [self addWord:@"叶公好龙"];
//        [self addWord:@"醉生梦死"];
//        [self addWord:@"长绳系日"];
//        [self addWord:@"投鼠忌器"];
//        [self addWord:@"并日而食"];
//        [self addWord:@"作壁上观"];
//        [self addWord:@"左右逢源"];
//        [self addWord:@"左顾右盼"];
//        [self addWord:@"沐猴而冠"];
//        [self addWord:@"趋之若鹜"];
//        [self addWord:@"左思右想"];
//        [self addWord:@"尊师重道"];
//        [self addWord:@"作奸犯科"];
//        [self addWord:@"做贼心虚"];
//        [self addWord:@"安之若素"];
//        [self addWord:@"春风化雨"];
//        [self addWord:@"蝇营狗苟"];
//        [self addWord:@"缘木求鱼"];
//        [self addWord:@"暗送秋波"];
//        [self addWord:@"明察秋毫"];
//        [self addWord:@"一叶知秋"];
//        [self addWord:@"春色满园"];
//        [self addWord:@"寻花问柳"];
//        [self addWord:@"雪兆丰年"];
//        [self addWord:@"斗转星移"];
//        [self addWord:@"大喜过望"];
//        [self addWord:@"得意忘形"];
//        [self addWord:@"欢呼雀跃"];
//        [self addWord:@"欢天喜地"];
//        [self addWord:@"乐极生悲"];
//        [self addWord:@"谈笑风生"];
//        [self addWord:@"手舞足蹈"];
//        [self addWord:@"心悦诚服"];
//        [self addWord:@"幸灾乐祸"];
//        [self addWord:@"心花怒放"];
//        [self addWord:@"忘乎所以"];
//        [self addWord:@"眉飞色舞"];
//        [self addWord:@"如释重负"];
//        [self addWord:@"赏心悦目"];
//        [self addWord:@"心旷神怡"];
//        [self addWord:@"走马观花"];
//        [self addWord:@"对牛弹琴"];
//        [self addWord:@"哭笑不得"];
//        [self addWord:@"冷嘲热讽"];
//        [self addWord:@"前仰后合"];
//        [self addWord:@"忍俊不禁"];
//        [self addWord:@"笑里藏刀"];
//        [self addWord:@"啼笑皆非"];
//        [self addWord:@"一笑百媚"];
//        [self addWord:@"长歌当哭"];
//        [self addWord:@"破涕为笑"];
//        [self addWord:@"横眉怒目"];
//        [self addWord:@"火冒三丈"];
//        [self addWord:@"火上浇油"];
//        [self addWord:@"怒火中烧"];
//        [self addWord:@"同仇敌忾"];
//        [self addWord:@"千夫所指"];
//        [self addWord:@"七情六欲"];
//        [self addWord:@"悲欢离合"];
//        [self addWord:@"老泪纵横"];
//        [self addWord:@"悲痛欲绝"];
//        [self addWord:@"肝肠寸断"];
//        [self addWord:@"痛哭流涕"];
//        [self addWord:@"别开生面"];
//        [self addWord:@"神采焕发"];
//        [self addWord:@"抓耳搔腮"];
//        [self addWord:@"催人泪下"];
//        [self addWord:@"声泪俱下"];
//        [self addWord:@"夺眶而出"];
//        [self addWord:@"归心似箭"];
//        [self addWord:@"闷闷不乐"];
//        [self addWord:@"平心而论"];
//        [self addWord:@"肃然起敬"];
//        [self addWord:@"心广体胖"];
//        [self addWord:@"心平气和"];
//        [self addWord:@"坐立不安"];
//        [self addWord:@"神清气爽"];
//        [self addWord:@"唇亡齿寒"];
//        [self addWord:@"风雨凄凄"];
//        [self addWord:@"嘘寒问暖"];
//        [self addWord:@"天寒地冻"];
//        [self addWord:@"冰清玉洁"];
//        [self addWord:@"如履薄冰"];
//        [self addWord:@"垂涎三尺"];
//        [self addWord:@"隔岸观火"];
//        [self addWord:@"赴汤蹈火"];
//        [self addWord:@"耳提面命"];
//        [self addWord:@"逢场作戏"];
//        [self addWord:@"水深火热"];
//        [self addWord:@"乌烟瘴气"];
//        [self addWord:@"乘热打铁"];
//        [self addWord:@"跃马扬鞭"];
//        [self addWord:@"暗箭难防"];
//        [self addWord:@"残羹冷炙"];
//        [self addWord:@"杯水车薪"];
//        [self addWord:@"趁火打劫"];
//        [self addWord:@"刀耕火种"];
//        [self addWord:@"玩火自焚"];
//        [self addWord:@"沉鱼落雁"];
//        [self addWord:@"固若金汤"];
//        [self addWord:@"海底捞月"];
//        [self addWord:@"含沙射影"];
//        [self addWord:@"海枯石烂"];
//        [self addWord:@"海纳百川"];
//        [self addWord:@"浑水摸鱼"];
//        [self addWord:@"竭泽而渔"];
//        [self addWord:@"泾渭分明"];
//        [self addWord:@"镜花水月"];
//        [self addWord:@"冷暖自知"];
//        [self addWord:@"开源节流"];
//        [self addWord:@"龙潭虎穴"];
//        [self addWord:@"萍水相逢"];
//        [self addWord:@"千山万水"];
//        [self addWord:@"如鱼得水"];
//        [self addWord:@"山清水秀"];
//        [self addWord:@"水滴石穿"];
//        [self addWord:@"水落石出"];
//        [self addWord:@"饮水知源"];
//        [self addWord:@"百花齐放"];
//        [self addWord:@"乘风破浪"];
//        [self addWord:@"打情骂俏"];
//        [self addWord:@"独断专行"];
//        [self addWord:@"发扬光大"];
//        [self addWord:@"叱咤风云"];
//        [self addWord:@"风尘仆仆"];
//        [self addWord:@"风吹雨打"];
//        [self addWord:@"风吹草动"];
//        [self addWord:@"风华正茂"];
//        [self addWord:@"风华绝代"];
//        [self addWord:@"风卷残云"];
//        [self addWord:@"风云变幻"];
//        [self addWord:@"风雨交加"];
//        [self addWord:@"高风亮节"];
//        [self addWord:@"好勇斗狠"];
//        [self addWord:@"好大喜功"];
//        [self addWord:@"见风使舵"];
//        [self addWord:@"两袖清风"];
//        [self addWord:@"狂风骤雨"];
//        [self addWord:@"雷厉风行"];
//        [self addWord:@"气宇轩昂"];
//        [self addWord:@"伤风败俗"];
//        [self addWord:@"拾金不昧"];
//        [self addWord:@"如雷灌耳"];
//        [self addWord:@"不动声色"];
//        [self addWord:@"大摇大摆"];
//        [self addWord:@"大义凛然"];
//        [self addWord:@"老气横秋"];
//        [self addWord:@"道貌岸然"];
//        [self addWord:@"神清气爽"];
//        [self addWord:@"插科打诨"];
//        [self addWord:@"左右开弓"];
//        [self addWord:@"绵里藏针"];
//        [self addWord:@"一表人才"];
//        [self addWord:@"德才兼备"];
//        [self addWord:@"守株待兔"];
//        [self addWord:@"捕风捉影"];
//        [self addWord:@"低声下气"];
//        [self addWord:@"隔墙有耳"];
//        [self addWord:@"拐弯抹角"];
//        [self addWord:@"井井有条"];
//        [self addWord:@"简明扼要"];
//        [self addWord:@"口齿伶俐"];
//        [self addWord:@"理直气壮"];
//        [self addWord:@"面面相觑"];
//        [self addWord:@"名正言顺"];
//        [self addWord:@"伶牙俐齿"];
//        [self addWord:@"慢条斯理"];
//        [self addWord:@"漏洞百出"];
//        [self addWord:@"潜移默化"];
//        [self addWord:@"破绽百出"];
//        [self addWord:@"旁敲侧击"];
//        [self addWord:@"三缄其口"];
//        [self addWord:@"闪烁其辞"];
//        [self addWord:@"守口如瓶"];
//        [self addWord:@"说一不二"];
//        [self addWord:@"无可厚非"];
//        [self addWord:@"一言九鼎"];
//        [self addWord:@"一诺千金"];
//        [self addWord:@"一针见血"];
//        [self addWord:@"自相矛盾"];
//        [self addWord:@"闲言碎语"];
//        [self addWord:@"支支吾吾"];
//        [self addWord:@"指手划脚"];
//        [self addWord:@"浮生若梦"];
//        [self addWord:@"九天揽月"];
//        [self addWord:@"刻骨铭心"];
//        [self addWord:@"扬眉吐气"];
//        [self addWord:@"寸步难行"];
//        [self addWord:@"横扫千军"];
//        [self addWord:@"名垂青史"];
//        [self addWord:@"秋高气爽"];
//        [self addWord:@"英姿飒爽"];
//        [self addWord:@"十有八九"];
//        [self addWord:@"功成名就"];
//        [self addWord:@"齐心协力"];
//        [self addWord:@"变幻莫测"];
//        [self addWord:@"耳濡目染"];
//        [self addWord:@"颠倒是非"];
//        [self addWord:@"垂头丧气"];
//        [self addWord:@"举手之劳"];
//        [self addWord:@"精疲力尽"];
//        [self addWord:@"口若悬河"];
//        [self addWord:@"落井下石"];
//        [self addWord:@"千疮百孔"];
//        [self addWord:@"千钧一发"];
//        [self addWord:@"千载难逢"];
//        [self addWord:@"轻车熟路"];
//        [self addWord:@"形单影只"];
//        [self addWord:@"一举成名"];
//        [self addWord:@"异曲同工"];
//        [self addWord:@"九牛一毛"];
//        [self addWord:@"奋不顾身"];
//        [self addWord:@"画地为牢"];
//        [self addWord:@"素昧平生"];
//        [self addWord:@"锦瑟年华"];
//        [self addWord:@"初出茅庐"];
//        [self addWord:@"反败为胜"];
//        [self addWord:@"缓兵之计"];
//        [self addWord:@"锦囊妙计"];
//        [self addWord:@"诡计多端"];
//        [self addWord:@"强词夺理"];
//        [self addWord:@"身不由己"];
//        [self addWord:@"手无寸铁"];
//        [self addWord:@"先礼后兵"];
//        [self addWord:@"徒有虚名"];
//        [self addWord:@"势不可当"];
//        [self addWord:@"洪福齐天"];
//        [self addWord:@"花容月貌"];
//        [self addWord:@"头破血流"];
//        [self addWord:@"提心吊胆"];
//        [self addWord:@"无拘无束"];
//        [self addWord:@"虚情假意"];
//        [self addWord:@"斩尽杀绝"];
//        [self addWord:@"作恶多端"];
//        [self addWord:@"心神不宁"];
//        [self addWord:@"龇牙咧嘴"];
//        [self addWord:@"别出心裁"];
//        [self addWord:@"大刀阔斧"];
//        [self addWord:@"逢凶化吉"];
//        [self addWord:@"飞檐走壁"];
//        [self addWord:@"七上八下"];
//        [self addWord:@"偷鸡摸狗"];
//        [self addWord:@"徇私舞弊"];
//        [self addWord:@"遮天蔽日"];
//        [self addWord:@"百里挑一"];
//        [self addWord:@"丢三落四"];
//        [self addWord:@"花枝招展"];
//        [self addWord:@"偷梁换柱"];
//        [self addWord:@"无精打采"];
//        [self addWord:@"铁面无私"];
//        [self addWord:@"小题大作"];
//        [self addWord:@"安分守已"];
//        [self addWord:@"赞不绝口"];
//        [self addWord:@"东拼西凑"];
//        [self addWord:@"哀鸿遍野"];
//        [self addWord:@"参差不齐"];
//        [self addWord:@"充耳不闻"];
//        [self addWord:@"出口成章"];
//        [self addWord:@"耿耿于怀"];
//        [self addWord:@"进退维谷"];
//        [self addWord:@"兢兢业业"];
//        [self addWord:@"鸠占鹊巢"];
//        [self addWord:@"空谷足音"];
//        [self addWord:@"人言可畏"];
//        [self addWord:@"逃之夭夭"];
//        [self addWord:@"天高地厚"];
//        [self addWord:@"投桃报李"];
//        [self addWord:@"小心翼翼"];
//        [self addWord:@"忧心忡忡"];
//        [self addWord:@"战战兢兢"];
//        [self addWord:@"辗转反侧"];
//        [self addWord:@"楚楚动人"];
//        [self addWord:@"潸然泪下"];
//        [self addWord:@"哀兵必胜"];
//        [self addWord:@"安居乐业"];
//        [self addWord:@"出生入死"];
//        [self addWord:@"根深蒂固"];
//        [self addWord:@"祸福相依"];
//        [self addWord:@"大器晚成"];
//        [self addWord:@"功成身退"];
//        [self addWord:@"天长地久"];
//        [self addWord:@"知足常乐"];
//        [self addWord:@"大相径庭"];
//        [self addWord:@"呆若木鸡"];
//        [self addWord:@"东施效颦"];
//        [self addWord:@"鬼斧神工"];
//        [self addWord:@"害群之马"];
//        [self addWord:@"跳梁小丑"];
//        [self addWord:@"学富五车"];
//        [self addWord:@"越俎代庖"];
//        [self addWord:@"朝三暮四"];
//        [self addWord:@"庄周梦蝶"];
//        [self addWord:@"舍近求远"];
//        [self addWord:@"舍生取义"];
//        [self addWord:@"守身如玉"];
//        [self addWord:@"天下无敌"];
//        [self addWord:@"为富不仁"];
//        [self addWord:@"揠苗助长"];
//        [self addWord:@"易如反掌"];
//        [self addWord:@"斩钉截铁"];
//        [self addWord:@"自怨自艾"];
//        [self addWord:@"专心致志"];
//        [self addWord:@"一暴十寒"];
//        [self addWord:@"出言不逊"];
//        [self addWord:@"顾名思义"];
//        [self addWord:@"孑然一身"];
//        [self addWord:@"开诚布公"];
//        [self addWord:@"乐不思蜀"];
//        [self addWord:@"倾家荡产"];
//        [self addWord:@"忍辱负重"];
//        [self addWord:@"如鱼得水"];
//        [self addWord:@"死不瞑目"];
//        [self addWord:@"体无完肤"];
//        [self addWord:@"危在旦夕"];
//        [self addWord:@"言过其实"];
//        [self addWord:@"自给自足"];
//        [self addWord:@"不谋而同"];
//        [self addWord:@"不自量力"];
//        [self addWord:@"从善如流"];
//        [self addWord:@"刚愎自用"];
//        [self addWord:@"甘败下风"];
//        [self addWord:@"华而不实"];
//        [self addWord:@"吉人天相"];
//        [self addWord:@"居安思危"];
//        [self addWord:@"厉兵秣马"];
//        [self addWord:@"其貌不扬"];
//        [self addWord:@"叹为观止"];
//        [self addWord:@"相敬如宾"];
//        [self addWord:@"一见如故"];
//        [self addWord:@"斩草除根"];
//        [self addWord:@"量力而为"];
//        [self addWord:@"宁缺勿滥"];
//        [self addWord:@"六神无主"];
//        [self addWord:@"神魂颠倒"];
//        [self addWord:@"依依不舍"];
//        [self addWord:@"哑口无言"];
//        [self addWord:@"争风吃醋"];
//        [self addWord:@"义不容辞"];
//        [self addWord:@"毛骨耸然"];
//        [self addWord:@"百步穿杨"];
//        [self addWord:@"背水一战"];
//        [self addWord:@"不寒而栗"];
//        [self addWord:@"卧薪尝胆"];
//        [self addWord:@"后来居上"];
//        [self addWord:@"两败俱伤"];
//        [self addWord:@"碌碌无为"];
//        [self addWord:@"门可罗雀"];
//        [self addWord:@"怒发冲冠"];
//        [self addWord:@"平步青云"];
//        [self addWord:@"平易近人"];
//        [self addWord:@"破釜沉舟"];
//        [self addWord:@"歃血为盟"];
//        [self addWord:@"善始善终"];
//        [self addWord:@"深思熟虑"];
//        [self addWord:@"四面楚歌"];
//        [self addWord:@"相见恨晚"];
//        [self addWord:@"一意孤行"];
//        [self addWord:@"沾沾自喜"];
//        [self addWord:@"招摇过市"];
//        [self addWord:@"助纣为虐"];
//        [self addWord:@"作壁上观"];
//        [self addWord:@"我爱钟悦"];
       

        
    }
    return self;
}
- (void)dealloc
{
    [words release];
    [correctList release];
    [playerSelectedWord release];
    [super dealloc];
}

- (void)addWord:(NSString*)word
{

//    //插入
//    for (int i = 0; i<word.length; i++) {
//        
//        NSString *subString = [word substringWithRange: NSMakeRange(i,1)];
//        
//        [[CYSqliteManager shareManager]insertNewWords:subString];
//
//    }
    
//    //返回正确得字符列表
//    NSMutableString *listString = [NSMutableString string];
//    for (int i=0; i<word.length; i++) {
//        
//        NSString *subString = [word substringWithRange: NSMakeRange(i,1)];
//
//        int wId = [[CYSqliteManager shareManager]wordIdByVaule:subString];
//        
//        if (i!=word.length-1) {
//            [listString appendFormat:@"%d,",wId];
//        }else{
//            [listString appendFormat:@"%d",wId];
//        }
//    }
//    
//    [[CYSqliteManager shareManager]insertNewWordList:listString];
    
    
}

-(void)addNewWord:(NSString *)word needLock:(BOOL)state
{
    NSArray *tempWords = [word componentsSeparatedByString:@","];

    NSMutableArray *correctArr = [NSMutableArray array];
    for (int i=0; i<tempWords.count; i++) {
        
        CYWord *nWord = [[CYWord alloc]init];
        
        nWord.w_value = [tempWords objectAtIndex:i];
        nWord.w_id = [NSString stringWithFormat:@"%d",words.count];        
        nWord.isLocked = state;
        
        [correctArr addObject:nWord.w_id];
        [words addObject:nWord];
        [nWord release];

    }
    [correctList addObject:correctArr];
    
    
}


- (CYWord*)wordById:(NSString *)wId
{
    CYWord *rWord = nil;
    for (CYWord *word in words) {
       
        if ([word.w_id isEqualToString:wId]) {
            rWord = word;
            break;
        }
    }
    
    return rWord;
}

- (NSArray*)gameRoundWordsList
{
    return correctList;
}

- (NSArray*)allWords
{
    return words;
}

- (BOOL)isArrFirst:(NSArray*)aArr isEuqalToAnOhter:(NSArray*)bArr
{
//    NSLog(@"arr-->%@",aArr);
//    NSLog(@"brr-->%@",bArr);
    
    if (aArr.count!=bArr.count) {
        return NO;
    }
    BOOL result = YES;
    for (int i=0;i<aArr.count;i++) {
        
        if (![[aArr objectAtIndex:i] isEqualToString:[bArr objectAtIndex:i]]) {
            
            result = NO;
            break;
        }
    }
//    NSLog(@"resullt ---->%d",result);
    
    return result;
}

- (void)addInputWord:(CYWordSprite *)aSprite
{
    [playerSelectedWord addObject:aSprite];
    
    if (playerSelectedWord.count>=4) {
        
        
        BOOL resultSuccess = NO;

        NSMutableArray *inputWords = [NSMutableArray array];
        for (int i=0; i<playerSelectedWord.count; i++) {
            
            CYWordSprite *iSprite = [playerSelectedWord objectAtIndex:i];
            
            [inputWords addObject:iSprite.word.w_id];
            
        }
        
        for (int i=0; i<correctList.count; i++) {
            
            NSArray *anyItem = [correctList objectAtIndex:i];
            
            if ([self isArrFirst:inputWords isEuqalToAnOhter:anyItem]) {
                
                resultSuccess = YES;
                break;
            
            }
            
        }
        
        if (resultSuccess) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(gameManagerCheckNeedClearWords:)]) {
                [self.delegate gameManagerCheckNeedClearWords:playerSelectedWord];
            }
            [self clearResult];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(gameManagerNeedResrvePreWordsState:)]) {
                [self.delegate gameManagerNeedResrvePreWordsState:playerSelectedWord];
            }
            [self clearResult];
        }
        
    }
    
    
    
}
- (void)clearResult
{
    [playerSelectedWord removeAllObjects];
}

- (void)removeInputWord:(CYWordSprite *)aSprite
{
    [playerSelectedWord removeObject:aSprite];
}

- (void)clearAndBuildNextRound
{
    [words removeAllObjects];
    [correctList removeAllObjects];
    [playerSelectedWord removeAllObjects];
    
    //build now
    NSArray *randomArr = [[CYSqliteManager shareManager]getPagesWordListByRandom];
//    NSLog(@"randomArr --->%@",randomArr);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    int resultCount = 9;
    for (int i=0; i<resultCount; i++) {
        
        int randIndex = arc4random()%randomArr.count;
        
        if ([resultArray containsObject:[randomArr objectAtIndex:randIndex]]) {
            i--;
            continue;
        }else{
            [resultArray addObject:[randomArr objectAtIndex:randIndex]];
        }
    }
    
    //取出所有字符
    for (int i=0; i<resultArray.count; i++) {
        
        NSArray *eachList = [[resultArray objectAtIndex:i]componentsSeparatedByString:@","];
        
        for (int j=0; j<eachList.count;j++) {
            
            NSString *eId = [eachList objectAtIndex:j];
            
            NSDictionary *wordText = [[CYSqliteManager shareManager]wordById:[NSNumber numberWithInt:[eId intValue]]];
            
            CYWord *newWord = [[CYWord alloc]initWithDict:wordText];
            [words addObject:newWord];
            [newWord release];
        }
    }
    
//    NSLog(@"allWords from sql --->%@",words);
    
    //取得正确字符数组
    for (int i=0; i<resultArray.count; i++) {
        
        NSArray *eachList = [[resultArray objectAtIndex:i]componentsSeparatedByString:@","];
        
        [correctList addObject:eachList];
    }
}

@end
