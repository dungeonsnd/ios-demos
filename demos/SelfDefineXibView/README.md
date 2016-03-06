以下拷贝自我的evernote

ios-study-code

7  iOS中一些初始化问题
代码见 github/ios-demo/SelfDefineXibView

1) TableView使用默认cell时可以这样初始化cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cellId";

    UITableViewCell *cell =[self.tblAccount dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {

        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];

    }



......

}


2)  用xib(自定义的类继承自UITableViewCell)方式自定义的cell初始化方式
 

 

- (void)viewDidLoad {

.........

    self.cellId =@"cellId";

    [self.tableView registerNib:[UINib nibWithNibName:@"SDXVCustomCell" bundle: nil] forCellReuseIdentifier:self.cellId];

}

 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SDXVCustomCell *cell =[self.tableView dequeueReusableCellWithIdentifier:self.cellId];

  .....  

}

3) 自定义View情况
结论，

```
等同关系的情况：xib有outlet及action对应的View时，只能设置xib视图选中时的Identity inspector->Custom class->Class为自己编写的View子类的类名，File's Owner中Class不设置。
引用关系的情况：i) xib的outlet及action对应ViewController时，即创建VC时同时勾选创建xib，设置File's Owner中的Class，视图中的Class保持默认的UIView。 ii) 自定义View中加载xib，并连接outlet及action时，设置方式同VC的情况。
```

代码见 https://github.com/dungeonsnd/ios-demos/tree/master/demos/SelfDefineXibView

a) 自定义View，并且这个View中不需要使用xib
新建一个类继承自View,不同时创建xib. 这时可以在引用的地方可以用 
initWithFrame 方式来创建。在代码中创建自定义View时仅会调用SDXVCustomView的 initWithFrame, 不会调用 awakeFromNib。



或者，在引用的地方拖一个View到xib中，然后设置类为自己定义View的类名称。

在 xib 中放置，不在代码中创建时仅会依次调用SDXVCustomView的 initWithCoder、awakeFromNib。




b) 自定义View，并且这个View中需要使用xib (注意，先有View再有xib，也就是View中加载这个xib)

在自定义View类中使用下面的方式（xxx表示xib名称，不带扩展名）来获取xib对应的UIView对象，

[[NSBundle mainBundle]loadNibNamed:@"xxx" owner:self options:nil][0];


如果自定义View中需要连接xib的outlet或action时，xib中的File's Owner的Identity inspector中的Custom class->Class 要设置为需要连接到的类名，而First Responder下面的一栏的Identity inspector中的Custom class->Class默认即可。



c) 使用xib自定义View,并且不需要单独的View类来关联这个xib

这个简单，用loadNibNamed来加载这个xib, 在xib中设置File's Owner为需要outlet和action的那个ViewController。 


d) 使用xib自定义View,并且用一个View类来对xib进行控制 (注意，view和xib是关联关系，不需要在View中加载这个xib)

这个情况依然在引用的地方使用 loadNibNamed来加载，区别于上面的是，File's Owner中Class不设置，而下面的Class要设置成需要关联的类名称。  使用类名来创建没有显示出来，可能无法用关联的类来加载。

这种情况下尝试用File's Owner的Class设置成我的View类名，而下面的Class不设置(即设置方式同b, 自定义View并在View中加载xib的情况)。 这时运行后程序崩溃，所以不能这么设置。 进一步测试发现，只要设置了File's Owner的并且有Outlet时必崩溃。

