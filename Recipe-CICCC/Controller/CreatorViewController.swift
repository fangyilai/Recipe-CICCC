//
//  CreatorViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-12.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

struct RecipeData{
    
    static var mainphoto = [UIImage]()
    static var title = [String]()
    static var cookingtime = [String]()
    static var servings = [String]()
    static var ingredients = [[String]]()
    static var amounts = [[String]]()
    static var stepPhotos = [[UIImage]]()
    static var stepTexts = [[String]]()
}


class CreatorViewController: UIViewController {
    

    var move = false
    var imagePicker = UIImagePickerController()
    var mainPhoto = UIImage()
    var photoList = [UIImage]()
    var preparationText = [String]()
    var recipeTitle = String()
    var recipeTime = String()
    var recipeServings = String()
    var ingredientList = [String]()
    var amountList = [String]()
    var position = CGPoint()
    var tableviewHeight = CGFloat()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewHeight = MainTableView.frame.origin.y
        imagePicker.delegate = self
        amountList.append("")
        ingredientList.append("")
        preparationText.append("")
        photoList.append(#imageLiteral(resourceName: "77d08f50-3ccc-4432-a86d-4dcfdd3d7cd4"))
        MainTableView.isEditing = false
        self.MainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    @IBOutlet weak var MainTableView: UITableView!
    @IBAction func UploadPhotoAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func StepTextViewPosition(_ sender: UIButton) {
        position = (sender as AnyObject).convert(CGPoint.zero, to: self.MainTableView)
        sender.isHidden = true
        print(sender.isHidden)
    }
    
    @IBAction func AddIngredients(_ sender: Any) {
        ingredientList.append("")
        amountList.append("")
        MainTableView.insertRows(at: [IndexPath(row: ingredientList.count-1, section: 4)], with: .top)
    }
    @IBAction func SaveData(_ sender: Any) {
        MainTableView.reloadData()
        RecipeData.mainphoto.append(mainPhoto)
        RecipeData.title.append(recipeTitle)
        RecipeData.cookingtime.append(recipeTime)
        RecipeData.servings.append(recipeServings)
        RecipeData.ingredients.append(ingredientList)
        RecipeData.amounts.append(amountList)
        RecipeData.stepPhotos.append(photoList)
        RecipeData.stepTexts.append(preparationText)
        
        print(RecipeData.title,RecipeData.cookingtime,RecipeData.servings, RecipeData.ingredients, RecipeData.amounts,RecipeData.stepTexts)
        //print(preparationText)
    }
    
    @IBAction func EditMode(_ sender: UIButton) {
        
        MainTableView.isEditing = !MainTableView.isEditing
        if MainTableView.isEditing{
            sender.setTitle("Done", for: .normal)
        }else{
            
            sender.setTitle("Edit", for: .normal)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        UITextView.animate(withDuration: 0.2, animations:{
            var frame = self.MainTableView.frame
            frame.origin.y = -243 // keyboardSize.size.height
            self.MainTableView.frame = frame
        })
    }
    
    @objc func dismissKeyBoard() {
        
//        UITextView.animate(withDuration: 0.3, animations:{
//            var frame = self.MainTableView.frame
//            frame.origin.y = 0 // self.tableviewHeight
//            self.MainTableView.frame = frame})
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//image picker
extension CreatorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let indexPath = self.MainTableView.indexPathForRow(at: position) {
            let section = indexPath.section
            if section == 0 {
                if let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    mainPhoto = photo
                }else if let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    mainPhoto = originalPhoto
                }
                
            }else if section == 6 {
                if let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    photoList[indexPath.row] = photo
                }else if let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    photoList[indexPath.row] = originalPhoto
                }
                print(photoList)
            }
        }

        dismiss(animated: true, completion: nil)
        MainTableView?.reloadData()
    }
    
    
}

//tableview
extension CreatorViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0, 1, 2, 3, 5:
                return 1
            case 4:
                return ingredientList.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 350
        case 1,2,3,4,5:
            return 40
        case 6:
            return 100
        default:
            return UITableView.automaticDimension

        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.section{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainPhotoCell") as! CreatorPhotoCell
                cell.Mainphoto.image = mainPhoto
                return cell
            case 1:
                let cell : TitleCell = tableView.dequeueReusableCell(withIdentifier: "title") as! TitleCell
                recipeTitle =  cell.TitleTextField.text ?? ""
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "timeNserving") as! TimeNSearvingCell
                recipeTime = cell.TimeTextFieldCell.text ?? ""
                recipeServings = cell.ServingsTextFieldCell.text ?? ""
                return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editingredients") as! EditIngredientsCell
            
            if tableView.isEditing == true {
                if move == true {
                    cell.ingredientTextField.text = ingredientList[indexPath.row]
                    cell.AmountTextField.text = amountList[indexPath.row]
                    
                }else{
                    ingredientList[indexPath.row] = cell.ingredientTextField.text ?? ""
                    amountList[indexPath.row] = cell.AmountTextField.text ?? ""
                }
            }
            else{
                ingredientList[indexPath.row] = cell.ingredientTextField.text ?? ""
                amountList[indexPath.row] = cell.AmountTextField.text ?? ""
            }
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier:"instructions") as! InstructionTitleCell
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "preparation") as! PreparationCell
            cell.stepNumber.text = String(indexPath.row + 1) + " :"
            cell.stepsImageView.image = photoList[indexPath.row]
            
            if tableView.isEditing == true {
                cell.textView.text = preparationText[indexPath.row]
                print(preparationText)
            }
            if cell.StepButton.isHidden {
                cell.StepButton.isHidden = false
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients") as! IngredientsCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt : IndexPath) {
        tableView.cellForRow(at: didSelectRowAt)?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section != sourceIndexPath.section{
            return sourceIndexPath
        }else{
            return proposedDestinationIndexPath
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let edit: Bool = indexPath.section == 6 || indexPath.section == 4 ? true : false
        return edit
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        move = true
        if sourceIndexPath.section == 4{
            let tempIngredient = ingredientList[sourceIndexPath.item]
            ingredientList.remove(at: sourceIndexPath.item)
            ingredientList.insert(tempIngredient, at: destinationIndexPath.item)
            
            let tempAmount = amountList[sourceIndexPath.item]
            amountList.remove(at: sourceIndexPath.item)
            amountList.insert(tempAmount, at: destinationIndexPath.item)
        }
        
        
        if sourceIndexPath.section == 6{
            let tempPreparation = preparationText[sourceIndexPath.item]
            preparationText.remove(at: sourceIndexPath.item)
            preparationText.insert(tempPreparation, at: destinationIndexPath.item)
            print(preparationText)
            let tempPhoto = photoList[sourceIndexPath.item]
            photoList.remove(at: sourceIndexPath.item)
            photoList.insert(tempPhoto, at: destinationIndexPath.item)
        }
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if indexPath.section == 4{
                ingredientList.remove(at: indexPath.item)
                amountList.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //  tableView.reloadData()
            }
            else if indexPath.section == 6{
                preparationText.remove(at: indexPath.item)
                photoList.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //  tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


// TextField
extension CreatorViewController: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UITextView.animate(withDuration: 0.3, animations:{
            var frame = self.MainTableView.frame
            frame.origin.y = 0 // self.tableviewHeight
            self.MainTableView.frame = frame})
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        move = false
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        MainTableView.reloadData()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let indexPath = self.MainTableView.indexPathForRow(at: position) {
            if indexPath.section == 6 {
                preparationText[indexPath.row] = textView.text
                print(indexPath)
                print(preparationText)
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        MainTableView.reloadData()
    }
}



//TableViewCell
class CreatorPhotoCell: UITableViewCell{
    @IBOutlet weak var Mainphoto: UIImageView!
}


class TitleCell: UITableViewCell{
    @IBOutlet weak var TitleTextField: UITextField!
}


class TimeNSearvingCell: UITableViewCell {
    @IBOutlet weak  var TimeTextFieldCell: UITextField!
    @IBOutlet weak  var ServingsTextFieldCell: UITextField!

}

class IngredientsCell: UITableViewCell{
}

class EditIngredientsCell: UITableViewCell{
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var AmountTextField: UITextField!
}

class InstructionTitleCell: UITableViewCell{
    
}
class PreparationCell: UITableViewCell{
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stepsImageView: UIImageView!
    @IBOutlet weak var StepButton: UIButton!
    var imagePicker = UIImagePickerController()
}
