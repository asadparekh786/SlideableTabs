//
//  PageVC.swift
//  SlideableTabs
//
//  Created by HudaMac-Asad on 18/08/2022.
//

import UIKit

public class PageVC: UIPageViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

public class ContentVC:UIViewController{
    
    
    @IBOutlet weak var lblTitlte: UILabel!
    public var strTitle = ""
    public var pageIndex = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        lblTitlte.text = strTitle
    }
}
