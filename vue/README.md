# vue
实现双向绑定的本质就是把模板变量{{text}}转换成一个渲染函数(node.contentText = text), 然后在每次给变量text赋值的时候调用这个函数.

参考文章:  
https://segmentfault.com/a/1190000006599500