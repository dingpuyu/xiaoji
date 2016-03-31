//
//  XTNoteFlowLayout.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/12.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//


class XTNoteFlowLayout: UICollectionViewFlowLayout {
//    文／疯狂的剁椒鱼头（简书作者）
//    原文链接：http://www.jianshu.com/p/f99d59837921
//    著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
    
    var itemW: CGFloat = kMainScreenWidth/2.0 - 0.5
    var itemH: CGFloat = 100
    
    override init() {
        super.init()
        
        //设置每一个元素的大小
        self.itemSize = CGSizeMake(itemW, itemH)
        //设置滚动方向
        self.scrollDirection = .Vertical
        //设置垂直间距
        self.minimumLineSpacing = 1.0
        //设置水平间距
        self.minimumInteritemSpacing = 0.5
        
    }

    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //苹果推荐，对一些布局的准备操作放在这里
    override func prepareLayout() {
        super.prepareLayout()
        //设置边距(让第一张图片与最后一张图片出现在最中央)ps:这里可以进行优化
//        let inset = (self.collectionView?.bounds.width ?? 0)  * 0.5 - self.itemSize.width * 0.5
//        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, inset)
    }
    
}
