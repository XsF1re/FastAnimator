#import <Foundation/Foundation.h>
#import <substrate.h>

static double speed;

%group FastAnimator
%hook CASpringAnimation

//효과: 설정앱에서 다른 메뉴로 전환할 때, 기본값: 1, 숫자가 0에 가까울수록 빨라짐
- (void)setMass:(double)arg1 {
  if(speed == 0)
    speed = 0.00001;
  arg1 = arg1 * speed;
  %orig;
}
%end

//효과: 스프링보드에서 앱 실행시, 가장빠름:0, 기본값: 50 근사치, 숫자가 적을수록 더 빠룸
%hook SBFFluidBehaviorSettings
-(void)setResponse:(double)arg1 {
  if(speed == 0)
    speed = 0.00001;
  arg1 = arg1 * speed;
  %orig;
}
%end

//효과: 스프링보드 -> 폴더 전환 속도
%hook SBFAnimationSettings
- (void)setMass:(double)arg1 {
  if(speed == 0)
    speed = 0.00001;
  arg1 = arg1 * speed;
  %orig;
}
%end
%end

%group NoFlyIn
//잠금화면 -> 홈화면 앱 날라오는 애니메이션 제거
%hook CSCoverSheetTransitionSettings
-(void)setIconsFlyIn:(BOOL)arg1 {
  %orig(NO);
}
%end
%end

%ctor {
  @autoreleasepool {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/kr.xsf1re.fastanimator.plist"];
    BOOL enabled = [prefs[@"enabled"] boolValue];
    BOOL disableFlyIn = [prefs[@"disableFlyIn"] boolValue];
    double mySpeed = [prefs[@"speed"] doubleValue];

    if(!enabled)
      return;

    if(prefs[@"speed"])
      speed = mySpeed;
    else
      speed = 1;

    %init(FastAnimator);

    if(disableFlyIn)
      %init(NoFlyIn);

  }
}
