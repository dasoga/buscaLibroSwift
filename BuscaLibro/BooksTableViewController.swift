//
//  BooksTableViewController.swift
//  BuscaLibro
//
//  Created by Dante Solorio on 2/24/16.
//  Copyright © 2016 Dante Solorio. All rights reserved.
//

import UIKit
import CoreData

class BooksTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var booksListTableView: UITableView!
    
    var books = [Book]()
    
    let moc = DataController().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchBooks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: General functions
    
    func fetchBooks(){
        books.removeAll(keepCapacity: false)
        let bookFetch = NSFetchRequest(entityName: "Book")
        
        do{
            let fetchedBook = try moc.executeFetchRequest(bookFetch) as! [Book]
            if fetchedBook.count > 0 {
                for book in fetchedBook{
                    if book.isbn != nil{
                        self.books.append(book)
                    }
                }
            }
        }catch{
            fatalError("bad things happened \(error)")
        }
        booksListTableView.reloadData()
    }
    
    //MARK: Table view delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailSegue"{
            let bookGet = books[booksListTableView.indexPathForSelectedRow!.row] as Book
            let detail = segue.destinationViewController as! DetailBookViewController
            detail.bookTitle = bookGet.title!
            detail.bookAuthors = bookGet.authors!
            if bookGet.image != nil{
                detail.bookImage = bookGet.image!
            }
        }
    }
    

}
