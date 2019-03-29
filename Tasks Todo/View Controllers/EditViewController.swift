//
//  EditViewController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/29/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import ChameleonFramework

class EditViewController: UIViewController {
    @IBOutlet weak var textField: UITextView!
    
    var todoController: ToDoController?
    
    var todo: Todo? {
        didSet {
            updateViews()
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let colorHex = todo?.color else {fatalError()}
       // title = todo?.title
        updateNavBar(withHexCode: colorHex)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            // navigationController?.navigationBar.barTintColor = .red
            updateNavBar(withHexCode: "C6C2FF")
        }
        super.willMove(toParent: parent)
    }
    
    //MARK: - NavBar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist!")
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()}
        navBar.barTintColor =  navBarColor
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)]
        
        
    }
    
    
    private func updateViews() {
        guard isViewLoaded else {return}
        guard let todo = todo else {return}
        textField.text = todo.title
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let titleText = textField.text, !titleText.isEmpty, let todo = todo else {return}
        
        todoController?.updateTodoTitle(todo: todo, title: titleText)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
