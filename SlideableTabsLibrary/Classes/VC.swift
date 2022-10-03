//
//  ViewController.swift
//  SlideableTabs
//
//  Created by HudaMac-Asad on 17/08/2022.
//

import UIKit

public class SlideableTab{
    static public func setSlideableTabs(tabControllers:[TabController], mainView:UIView)->VC{
        let vc = UIStoryboard.init(name: "Page", bundle: Bundle(for: VC.classForCoder())).instantiateViewController(withIdentifier: "VC") as! VC
        vc.tempPageTabs = tabControllers
        mainView.parentViewController?.embed(vc, inView: mainView)
        return vc
    }
}

public class TabController{
    var title:String? = ""
    var vc:UIViewController = UIViewController()
    
    
    public init(title:String,vc:UIViewController) {
        self.vc = vc
        self.title = title
    }
}

public class VC: UIViewController {
    
    
    @IBOutlet weak var pageTab: Slideheader!
    @IBOutlet weak var pagesView: UIView!
    var pageVC:UIPageViewController!
    
    var tempPageTabs:[TabController] = []
    open var currentIndex: Int {
        set{
            tabBarDidSelectItemAt(tab: pageTab, index: newValue)
        }
        get{
            return pageTab.currentIndex
        }
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        pageTab.viewControllers = tempPageTabs
        pageTab.isSizeToFitCellsNeed = true
        pageTab.delegate = self
        presentPageOnVcView()
        pageVC.delegate = self
        pageVC.dataSource = self
        
        //for init display
        pageTab.collView.scrollToItem(at: IndexPath(item: pageTab.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageVC.setViewControllers([pageTab.viewControllers!.first!.vc], direction: .forward, animated: true)
        
        
        
        // Do any additional setup after loading the view.
    }
    

    func presentPageOnVcView(){
        pageVC = storyboard?.instantiateViewController(withIdentifier: "PageVC") as! PageVC
        embed(pageVC, inView: pagesView)
    }

}







extension VC:TabsDelegate{
    func tabBarDidSelectItemAt(tab: Slideheader, index: Int) {
        if index != pageTab.currentIndex{
            if index > pageTab.currentIndex{
                pageVC.setViewControllers([pageTab.viewControllers![index].vc], direction: .forward, animated: true)
            }else{
                pageVC.setViewControllers([pageTab.viewControllers![index].vc], direction: .reverse, animated: true)
            }
            pageTab.currentIndex = index
            pageTab.collView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//            pageTab.collView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}



extension VC:UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = pageTab.viewControllers?.firstIndex(where: { $0.vc == viewController}) else {
            return nil
        }
        pageTab.currentIndex = vcIndex
        pageTab.collView.selectItem(at: IndexPath(item: vcIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)

        let pIndex = vcIndex - 1
        let count = pageTab.viewControllers?.count ?? 0

        guard pIndex >= 0 else {
            return nil
        }
        
        guard count > pIndex else {
            return nil
        }
        return pageTab.viewControllers?[pIndex].vc
    }
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vcIndex = pageTab.viewControllers?.firstIndex(where: { $0.vc == pendingViewControllers.first}) else {
            return
        }
        pageTab.currentIndex = vcIndex
        pageTab.collView.selectItem(at: IndexPath(item: vcIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vcIndex = pageTab.viewControllers?.firstIndex(where: { $0.vc == previousViewControllers.first}) else {
            return
        }
        pageTab.currentIndex = vcIndex
        pageTab.collView.selectItem(at: IndexPath(item: vcIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let vcIndex = pageTab.viewControllers?.firstIndex(where: { $0.vc == viewController}) else {
            return nil
        }
        pageTab.currentIndex = vcIndex
        pageTab.collView.selectItem(at: IndexPath(item: vcIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)

        let nIndex = vcIndex + 1
        guard nIndex >= 0 else {
            return nil
        }
        
        guard nIndex < (pageTab.viewControllers?.count ) ?? 0 else {
            return nil
        }
        return pageTab.viewControllers?[nIndex].vc
    }
    
}



extension UIViewController{
   func embed(_ viewController:UIViewController, inView view:UIView){
        view.removeSubviews()
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
extension UIView{
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
    func removeSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
