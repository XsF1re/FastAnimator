#import <spawn.h>
#include "FARootListController.h"

#define PREFERENCE_FA @"/var/mobile/Library/Preferences/kr.xsf1re.fastanimator.plist"

NSMutableDictionary *prefs_FA;

@implementation FARootListController


- (NSArray *)specifiers {
	if (!_specifiers) {
		[self getPreference];
		NSMutableArray *specifiers = [[NSMutableArray alloc] init];

		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"활성화" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
			specifier;
		})];

		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"사용" target:self set:@selector(setSwitch:forSpecifier:) get:@selector(getSwitch:) detail:nil cell:PSSwitchCell edit:nil];
			[specifier.properties setValue:@"enabled" forKey:@"displayIdentifier"];
			specifier;
		})];

		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"애니메이션 속도" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
			specifier;
		})];

    [specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"size" target:self set:@selector(setNumber:forSpecifier:) get:@selector(getNumber:) detail:Nil cell:PSSliderCell edit:Nil];
			[specifier setProperty:@"speed" forKey:@"displayIdentifier"];
			[specifier setProperty:@1 forKey:@"default"];
			[specifier setProperty:@0.0 forKey:@"min"];
			[specifier setProperty:@1.0 forKey:@"max"];
			[specifier setProperty:@YES forKey:@"isSegmented"];
			[specifier setProperty:@100 forKey:@"segmentCount"];
			[specifier setProperty:@YES forKey:@"showValue"];
			specifier;
		})];


		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"잠금해제 시 앱 날아오르기 비활성화" target:self set:@selector(setSwitch:forSpecifier:) get:@selector(getSwitch:) detail:nil cell:PSSwitchCell edit:nil];
			[specifier.properties setValue:@"disableFlyIn" forKey:@"displayIdentifier"];
			specifier;
		})];


		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"변경사항 적용" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
			specifier;
		})];


		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"리스프링" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
			specifier->action = @selector(respring:);
			specifier;
		})];




		_specifiers = [specifiers copy];
	}
	return _specifiers;
}

-(void)setNumber:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
	prefs_FA[[specifier propertyForKey:@"displayIdentifier"]] = value;
	[[prefs_FA copy] writeToFile:PREFERENCE_FA atomically:FALSE];
}
-(NSNumber *)getNumber:(PSSpecifier *)specifier {
	return prefs_FA[[specifier propertyForKey:@"displayIdentifier"]] ? prefs_FA[[specifier propertyForKey:@"displayIdentifier"]] : @1;
}


-(void)setSwitch:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
	prefs_FA [[specifier propertyForKey:@"displayIdentifier"]] = [NSNumber numberWithBool:[value boolValue]];
	[[prefs_FA copy] writeToFile:PREFERENCE_FA atomically:FALSE];
}
-(NSNumber *)getSwitch:(PSSpecifier *)specifier {
	return [prefs_FA [[specifier propertyForKey:@"displayIdentifier"]] isEqual:@1] ? @1 : @0;
}


- (void)respring:(id)sender {
	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

-(void)getPreference {
	if(![[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_FA]) prefs_FA = [[NSMutableDictionary alloc] init];
	else prefs_FA = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFERENCE_FA];
}

@end
