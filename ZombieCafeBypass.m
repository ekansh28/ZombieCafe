#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

void noop_setObjectForKey(id self, SEL _cmd, id obj, id key) {
    NSLog(@"[ZombieCafeBypass] Prevented call to setObject:forKey: on class: %@ with key: %@ and value: %@", NSStringFromClass([self class]), key, obj);
}

__attribute__((constructor))
static void patch_setObjectForKey() {
    const char *targetClassName = "NSObject"; // Change if you learn the real crashing class
    Class targetClass = objc_getClass(targetClassName);

    if (targetClass) {
        SEL selector = sel_registerName("setObject:forKey:");
        BOOL success = class_addMethod(targetClass, selector, (IMP)noop_setObjectForKey, "v@:@@");
        if (success) {
            NSLog(@"[ZombieCafeBypass] Hooked setObject:forKey: on class %s", targetClassName);
        } else {
            NSLog(@"[ZombieCafeBypass] Failed to hook setObject:forKey:");
        }
    }
}
