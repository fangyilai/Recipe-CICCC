//
//  MonthlyViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-05.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit
import Crashlytics

class MonthlyViewController: UIViewController {    
    
    var imageArray = [Image]()
    var arrayMenu = [String]()
    var searchIMageName = [Image]()
    var sideMenuOpen = false
    
    var recipeImages = [UIImage]()
    var recipeLabels = [String]()
    var mainViewController: MainPageViewController?
    var pageViewControllerDataSource: UIPageViewControllerDataSource?
    
    ///  スクロール開始地点
    var scrollBeginPoint: CGFloat = 0.0
    
    /// navigationBarが隠れているかどうか(詳細から戻った一覧に戻った際の再描画に使用)
    var lastNavigationBarIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryArray()

        navigationController?.setNavigationBarHidden(false, animated: false)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if lastNavigationBarIsHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        lastNavigationBarIsHidden = false
    }
    
    
    func CategoryArray() {
        let image1 = Image(title: "Valentine's Day", image: #imageLiteral(resourceName: "Easy-strawberry-desserts-–-Greek-Yogurt-recipes-–-Valentines-desserts"))
        let image2 = Image(title: "Cozy Spring", image: #imageLiteral(resourceName: "Valentines-Day-Cookie-Bars-1-3-680"))
        let image3 = Image(title: "Quick and Simple", image: #imageLiteral(resourceName: "190411-potato-salad-horizontal-1-1555688422"))
        let image4 = Image(title: "Healthy Diet", image: #imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"))
        
        let image5 = Image(title: "Home Cooking", image: #imageLiteral(resourceName: "merlin_141075420_edfc0f4f-ba70-4542-a881-085a9dc162b9-articleLarge"))
        
        imageArray.append(image1)
        imageArray.append(image2)
        imageArray.append(image3)
        imageArray.append(image4)
        imageArray.append(image5)
    }
    
    func updateNavigationBarHiding(scrollDiff: CGFloat) {
        let boundaryValue: CGFloat = 100.0
        
        /// navigationBar表示
        if scrollDiff > boundaryValue {
            navigationController?.setNavigationBarHidden(false, animated: true)
            lastNavigationBarIsHidden = false
            return
        }
            
            /// navigationBar非表示
        else if scrollDiff < -boundaryValue {
            navigationController?.setNavigationBarHidden(true, animated: true)
            lastNavigationBarIsHidden = true
            return
        } 
    }
    
    
}

extension MonthlyViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let image = imageArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImagesCell
        
        cell.setImage(UIimage: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewContoller = storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController
        let image = imageArray[indexPath.row]
        viewContoller?.T_image = image.image
        viewContoller?.T_Name = image.title

        switch indexPath.row{
               case 0: viewContoller?.recipeLabels = self.recipeLabels; break
               case 1: viewContoller?.recipeLabels = self.recipeLabels; break
               case 2:  viewContoller?.recipeLabels = self.recipeLabels; break
               case 3:  viewContoller?.recipeLabels = self.recipeLabels; break
               case 4:  viewContoller?.recipeLabels = self.recipeLabels; break
               case 5:  viewContoller?.recipeLabels = self.recipeLabels; break
               default: print("no category"); break
               }
         
//        guard self.navigationController?.topViewController == self else { return }
        self.navigationController?.pushViewController(viewContoller!, animated: true)
    }
    
    
    // they and self.ispaging = false in pageviewcontroller prevent from paging when collection view is scrollings
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          
        mainViewController = self.parent as? MainPageViewController
        
        if  mainViewController!.dataSource == nil {
            
            mainViewController!.dataSource = mainViewController
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainViewController = self.parent as? MainPageViewController
        pageViewControllerDataSource = mainViewController!.dataSource
                
        mainViewController!.dataSource = nil
        mainViewController?.isPaging = false
        
        let scrollDiff = scrollBeginPoint - scrollView.contentOffset.y
        updateNavigationBarHiding(scrollDiff: scrollDiff)

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginPoint = scrollView.contentOffset.y
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
           
           UIView.animate(withDuration: 0.3, animations: {
               self.navigationController?.setNavigationBarHidden(false, animated: false)
           })
           
       }
}

