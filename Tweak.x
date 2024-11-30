#import <UIKit/UIKit.h>

// 为 iOS 15+ 的方法手动声明
@interface UITraitCollection (iOS15Support)
- (UITraitCollection *)traitCollectionByMergingTraitsFromCollection:(UITraitCollection *)trait;
@end

// Hook UIApplication 的 main 方法入口，确保在应用启动时立即生效
%hook UIApplication

+ (void)load {
    %orig;

    // 强制使用浅色模式
    if (@available(iOS 13.0, *)) {
        // 设置 UIWindow 的全局样式
        [[NSNotificationCenter defaultCenter] addObserverForName:UIWindowDidBecomeVisibleNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            UIWindow *window = note.object;
            window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }];

        // 设置 UIView 的全局样式
        [UIView appearance].overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

%end

%hook UITraitCollection

- (UIUserInterfaceStyle)userInterfaceStyle {
    if (@available(iOS 13.0, *)) {
        return UIUserInterfaceStyleLight; // 始终返回浅色模式
    }
    return %orig;
}

%end

// Hook UIViewController 的生命周期方法
%hook UIViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;

    if (@available(iOS 13.0, *)) {
        // 在 view 即将显示时强制设置浅色模式
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

%end
