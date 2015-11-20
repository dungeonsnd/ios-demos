
已经移植完成。集成到IOS项目中并编译通过了，在真机iTouch5_ios7.1.4上向macbook中的一个python tcp server发起连接，成功连接上。

TODO: 
1) 必须提供多线程支持。测试方便，目前是在UI线程中完成的网络处理。同时发现，在UI线程中libevent的事件循环dispatch会返回，猜测被主线程中断了。
2) 启用 BITCODE. 需要简单修改编译脚本再测。 暂时没时间去完成。


参考资源:
https://github.com/OnionBrowser/iOS-OnionBrowser/blob/master/build-libevent.sh
http://blog.csdn.net/sozell/article/details/8926090
