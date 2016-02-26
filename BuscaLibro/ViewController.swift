//
//  ViewController.swift
//  BuscaLibro
//
//  Created by Dante Solorio on 2/9/16.
//  Copyright © 2016 Dante Solorio. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var isbTextField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageBook: UIImageView!
    @IBOutlet var doneButton: UIButton!
    
    var bookIsbn:String = ""
    var bookTitle:String = ""
    var bookAuthors:String = ""
    var bookImage:NSData!
    
    let moc = DataController().managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: General Functions

    
    func getBookDataFunction(isbn: String){
        let urlBase = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let url = NSURL(string: urlBase + isbn)
        //print("peticion \(url!)")
        let session = NSURLSession.sharedSession()
        if url != nil{
            let dt = session.dataTaskWithURL(url!) { (datos, response, error) -> Void in
                //let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                
                dispatch_sync(dispatch_get_main_queue()){
                    self.showData(datos!)
                }
                
            }
            dt.resume()
        }else{
            let alert = UIAlertController(title: "Error", message: "Error, por favor intenta nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
        
    }
    
    func showData(response:NSData){
        //print("response \(response)")
        self.authorLabel.text = ""
        if response != ""{
            //responseTextView.text = "\(response)"
            //print("respose \(response)")
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.MutableLeaves)
                let objectDic = json as! NSDictionary
                let level = "ISBN:\(isbTextField.text!)"
                //let dic2 = objectDic[level] as! NSDictionary
                
                if let exist = objectDic[level]{
                    // Check Title
                    bookIsbn = level
                    if let title = exist["title"] as? String{
                        //print("Title \(title)")
                        bookTitle = title
                        self.titleLabel.text = title
                    }
                    // Check Author
                    if let authors = exist["authors"] as? NSArray{
                        for author in authors{
                            let name  = author["name"] as? String
                            self.authorLabel.text = self.authorLabel.text! + "\(name!)\n"
                            bookAuthors = self.authorLabel.text! + "\(name!)\n"
                        }
                    }
                    
                    
                    if let cover = exist["cover"] as? NSDictionary{
                        getBookCoverFromURL(cover["large"] as! String)
                        
                    }else{
                        self.imageBook.image = nil
                    }
                    doneButton.hidden = false
                }else{
                    
                    showAlertErrorMessage()
                }
            }catch{
                
            }
            
        }else{
            showAlertErrorMessage()
        }
    }
    
    func getBookCoverFromURL(urlString: String){
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        if url != nil{
            let dt = session.dataTaskWithURL(url!) { (datos, response, error) -> Void in
                //let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                dispatch_sync(dispatch_get_main_queue()){
                    self.imageBook.image = UIImage(data: datos!)
                    self.bookImage = datos!
                }
                
            }
            dt.resume()
        }else{
            print("no image")
        }
    }
    
    func showAlertErrorMessage(){
        doneButton.hidden = true
        let alert = UIAlertController(title: "No encontrado", message: "Error, no se encontro libro, por favor intenta nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func saveBook(isbn:String)->Bool{
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: moc) as! Book
        
        if isExistBook(isbn){
            print("not save it because is duplicate")
            let alert = UIAlertController(title: "¡Alerta!", message: "Al parecer ya haz agregado este libro anteriormente.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }else{
            entity.setValue(bookIsbn, forKey: "isbn")
            entity.setValue(bookTitle, forKey: "title")
            entity.setValue(bookAuthors, forKey: "authors")
            entity.setValue(bookImage, forKey: "image")
            do{
                try moc.save()
            }catch{
                fatalError("failure to save context: \(error)")
            }
            return true
        }
    }
    
    func isExistBook(isbn:String)->Bool{
        let bookFetch = NSFetchRequest(entityName: "Book")
        var isExist = false
        do{
            let fetchedBook = try moc.executeFetchRequest(bookFetch) as! [Book]
            if fetchedBook.count > 0 {
                for book in fetchedBook{
                    if book.isbn != nil{
                        if book.isbn == isbn{
                            isExist = true
                        }
                    }
                }
            }
        }catch{
            fatalError("bad things happened \(error)")
        }
        return isExist
    }
    
    //MARK: Actions
    
    @IBAction func hideKeyboard(sender:AnyObject){
        isbTextField.resignFirstResponder()
    }
    
    @IBAction func closeAction(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAction(sender:AnyObject){
        if self.saveBook(bookIsbn){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text! != ""{
            getBookDataFunction(textField.text!)
        }else{
            let alert = UIAlertController(title: "Error", message: "Por favor ingresa un ISBN para busqueda.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        textField.resignFirstResponder()
        return true
    }

    

    
    

}

