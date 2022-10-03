//
//  Sildeheader.swift
//  SlideableTabs
//
//  Created by HudaMac-Asad on 17/08/2022.
//

import UIKit


protocol TabsDelegate{
    func tabBarDidSelectItemAt(tab:Slideheader, index:Int)
}

public class Slideheader: UIView {
    
    
    
    private let id = "TabCell"
    var delegate:TabsDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        customInit()
    }
    
    public lazy var viewControllers:[TabController]? = []{
        didSet{
            collView.reloadData()
        }
    }
    private func customInit(){
        addSubview(collView)
        collView.register( UINib(nibName: id, bundle: Bundle(for: Slideheader.classForCoder())), forCellWithReuseIdentifier: id)
        collView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        backgroundColor = .white
        superview?.layoutSubviews()
    }
    
    //Main
    lazy var collView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .null, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    //
    var isSizeToFitCellsNeed:Bool = false{
        didSet{
            collView.reloadData()
        }
    }
//    var dataArray:[String] = []{
//        didSet{
//            collView.reloadData()
//        }
//    }
    public var currentIndex = 0{
        didSet{
            collView.reloadData()
        }
    }
    var cellWidth:CGFloat = 60 {
        didSet{
            collView.reloadData()
        }
    }
    
    
}
extension Slideheader:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! TabCell
        cell.lblTitel.text = viewControllers?[indexPath.row].title
        cell.selectView.isHidden = currentIndex != indexPath.row
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isSizeToFitCellsNeed{
            let size = CGSize.init(width: 500, height: self.frame.height)
            let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let str = viewControllers?[indexPath.row].title ?? ""
            let estimatedRect = NSString(string: str).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)], context: nil)

            return CGSize.init(width: estimatedRect.size.width, height: self.frame.height)
        }
        return CGSize.init(width: cellWidth, height: self.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        delegate?.tabBarDidSelectItemAt(tab: self, index: index)
    }
    
    
}

