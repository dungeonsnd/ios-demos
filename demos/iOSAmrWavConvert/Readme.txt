制作iOS Framework

下面用 VoiceConv 这个示例来说明Framework的制作过程。

1 建立项目
新建一个Cocoa Touch Framework.
把armv7s添加到Build Settings人Architectures和Valid Architectures中（如果默认配置没有的话）.


2 编译生成
通过Product->Build来编译，成功后可以在 Xcode->Window->Projects对话框中，点击对话框右侧的 Derived Data 一行的 最后的右箭头来打开Findler，自动定位到项目文件夹。打开Build->Products->Release-iphonesimulator，打开编译生成的VoiceConv.framework，复制给使用者。
注意，编译时最好接上真机，在Xcode的设置中选择好真机，这样才能编译出真机的Framework。并且，在Schema->Run->Build Configuration中选择Release来生成发布版的Framework.
由于 录音需要真机，所以笔者在VoiceConv.framework编译和使用过程中都使用真机调度，没有测试模拟器模式下的framework生成和使用，所以本文档只考虑真机模式。

3 framework的使用
新建一个工程，将上述framework添加到工程。添加时可以直接插入项目中，也可以Add files xxx的方式，选择Copy Items xxx.
添加完后在 TARGETS->Build Phases-> Link Binary With Libaries中查看是否已经有你刚才加的Framework了。如果没有的话点击“+”按钮，在弹出的窗口中点击“Add Other”按钮，选择framework添加到工程中。

在需要使用的地方添加如#import "YourFramework/PublicFile.h"，这样就可以使用了。


另外，由于 VoiceConv 这个项目包含了c++的库（我理解是包含了.mm文件），所以我们需要在使用者项目配置中引入c++的库。在 Build Phases->Link Binary With Libraries一栏中点加号来添加 libc++.tbd. 笔者认为，VoiceConv使用了静态库，而c++库libc++.tbd是动态库(现在苹果公司把dylib改成了tbd，据查 the .tbd files are new "text-based stub libraries", that provide a much more compact version of the stub libraries for use in the SDK, and help to significantly reduce its download size. 笔者从使用角度来看，可以理解成动态库。)。
姑且不管苹果自创的tbd格式具体背后的原理，参考其它平台动态库和静态库理论，如Unix，常理来说静态库中不能包含动态为，只能包含其它静态库。

关于这一点，可以参阅百度地图的SDK配置说明文档，如下，
 '''静态库中采用Objective-C++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)，或者在工程属性中指定编译方式，即将Xcode的Project -> Edit Active Target -> Build -> GCC4.2 - Language -> Compile Sources As设置为"Objective-C++" '''


4 小结
iOS平台已经不支持amr格式了，而android平台原生支持。目前amr是主流的即时通信录音格式，其体积极小，据说非常适合质量要求不高、数据体积敏感的场合。 故通常选择在iOS平台做适配，这点要么是在端上做格式转换，要么是在服务器端。
音频文件格式通常包含封装格式和数据格式，笔者通俗的理解就是，数据格式是音频文件的编码、压缩格式，而封装格式是一个元数据组成的更上层的格式。
通常苹果的设备可以录制caf(pcm)格式，或wav格式。pcm音频质量高，体积非常大。那么只要把这两种格式转换为amr就可以实现跨平台能用。

数据格式转换使用较广的是opencore-amr这一老外的开源库。然后，我们还需要做封装格式转换，把wav和amr互转，幸好有人写好了，即本示例中的 amrwapper/amrFileCodec.mm。可以看到文件头显示信息 "Created by Tang Xiaoping on 9/27/11." 。
其实，这个文件中函数是读取wav和amr的格式，并做转换。没有技术难度，但非常复杂，如果自己来写，应该可以找到这样的格式规范文档来编码。


5 其它
制作和使用framework的过程中难免会出现各种问题(笔者认为这点苹果对开发者不太友好)，笔者也花费了好几个小时才做出了VoiceConv.framework并测试成功。
遇到问题时很可能是架构不对，请注意查看自己的.a或者framework支持哪些平台。

判断一个Framework支持哪些架构
lipo -info ./MyFramework.framework/MyFramework

目前iOS平台常见的cpu架构
armv7 iPhone4, iPhone4S
armv7s iPhone5, iPhone5C
arm64 iPhone5S
i386 x86_64 pc机上运行的模拟器


6 参考资料
http://blog.csdn.net/jiuqiaozi/article/details/40303019
http://blog.csdn.net/sky_2016/article/details/41592619
http://icocoa.tk/xcode6zhi-zuo-ios-framework.html

