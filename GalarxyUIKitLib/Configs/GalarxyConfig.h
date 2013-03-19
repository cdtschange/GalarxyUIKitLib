//
//  GalarxyConfig.h
//  GalarxyUIKitLib
//
//  Created by Wei Mao on 12/29/12.
//  Copyright (c) 2012 isoftstone. All rights reserved.
//

#ifndef GalarxyUIKitLib_GalarxyConfig_h
#define GalarxyUIKitLib_GalarxyConfig_h

#define RESOURCEBUNDLE [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"GalarxyUIKitLibResources" withExtension:@"bundle"]]
#define UIIMAGERESOURCEBUNDLE(name,type) [[UIImage alloc] initWithContentsOfFile:[RESOURCEBUNDLE pathForResource:name ofType:type]]


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#endif
