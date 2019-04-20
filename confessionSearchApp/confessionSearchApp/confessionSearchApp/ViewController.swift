//
//  ViewController.swift
//  confessionSearchApp
//
//  Created by  on 4/2/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit
//Testing for CocoaPods Support for MAC Lab
import SQLite
import SQLite3




class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBAction func helpButtonPress(_ sender: UIButton) {
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView2(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchType.count
    }
    func pickerView3(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     return documentNameData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView3(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return documentNameData[row]
    }
    func pickerView2(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchType[row]
    }
    
    class DocumentTitle{
        var documentID : Int
        var title : String
        var searchTypePicker:[String] = [String]()
        var documentTypeID : Int
        init(documentID: Int, title: String, documentTypeID: Int)
        {
            self.documentID = documentID
            self.title = title
            self.documentTypeID = documentTypeID
        }}
        class Document
        {
            var docDetailID:Int
            var documentText:String
            var documentID:Int
            var chProofs:String
            var chMatches:Int
            var chName:String
            var chTags:String
            init(docDetailID:Int,documentText:String,chName:String,documentID:Int,chMatches:Int,chProofs:String,chTags:String)
            {
                self.documentID = documentID
                self.docDetailID=docDetailID
                self.chName=chName
                self.documentText=documentText
                self.chProofs=chProofs
                self.chTags=chTags
                self.chMatches=chMatches
            }
        }
    
    class DocumentType{
        var documentTypeID:Int
        var documentTypeName:String
        init(documentTypeID:Int,documentTypeName:String)
        {
            self.documentTypeID=documentTypeID
            self.documentTypeName=documentTypeName
            
        }
    }
    
   
    
    @IBOutlet weak var documentTypePicker: UIPickerView!
    @IBOutlet weak var documentTitlePicker: UIPickerView!
    
   

    var documentList: [Document] = [Document]() //Document List
    
    var db: OpaquePointer? //DB Pointer
    //Document Type Spinner List/Array Adapter 
    var pickerData: [String] = [String]()
    //Document Title Spinner List Adapter
    var documentNameData: [String] = [String]()
    //Test code
    var documentTypeList : [DocumentType] = [DocumentType]()
    var documentTitleList : [DocumentTitle] = [DocumentTitle]()
    
    var topic: String = ""
    var chNumber:Int = 0
    var searchType: [String] = [String]()
    
    //Cocoa Pods Test code
    let path = Bundle.main.pathForResource("confessionSearchDB.db", ofType: "sqlite3")!
    let cocoDB= try Connection(path, readonly: true)
   //Document Type Table
    let docTypes = Table("DocumentType")
    let documentTypetypeid = Expression<Int64>("DocumentTypeID")
    let documentTypeName = Expression<String?>("DocumentTypeName")
   //Document Type Array storage
    let docTypeArray = Array(try cocoDB.prepare(docTypes))
     // docTypes.column(documentTypetypeID, primaryKey: true)
   // docTypes.column(documentTypeName, unique: true)
   //Document Name Table
    let documentNameTable = Table("DocumentTitle")
    let documentTitleTypeID = Expression<Int>("DocumentTypeID")
    let documentNameID = Expression<Int64>("DocumentID")
    let documentName = Expression<String?>("DocumentName")
    //Document Name Array Storage
      let docNameArray = Array(try cocoDB.prepare(documentNameTable))
   //Document Table 
    let documentTable = Table("Document")
    let DocumentID = Expression<Int64>("DocumentID")
    let DocumentDetailID = Expression<Int64>("DocDetailID")
    let ChapterNum = Expression<Int64>("DocIndexNum")
    let ChapterName = Expression<String?>("ChName")
    let ChapterText = Expression<String?>("ChText")
    let ChapterProofs = Expression<String?>("ChProofs")
    let ChapterTags = Expression<String?>("ChTags")    
    //let ChMatches = Expression<Int64>("ChMatches")
     
    override func viewDidLoad() {
        super.viewDidLoad()

        searchType = ["Topic","Question","View Document"]
        //Borrowed from simplifiedIOS Swift SQLite Tutorial with modifications on which files are used.
        //Load the DB pointer
        //DB Pointer For retrieving data from Database
       // let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("confessionSearchDB.db")
      //  if sqlite3_open(fileURL.path,&db) != SQLITE_OK{print("Error Opening DB")}
      // readDocumentTypes()
        testLoadDocTypes()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var searchTypeCollectionView: UIPickerView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func searchButton(_ sender: UIButton) {
     
        
        
    }
    @IBOutlet weak var searchTypePicker: UIPickerView!

    func testLoadDocTypes()
    {
         pickerData.append("All")
       
       //Getting the text needed for the Spinner object
        
       for docType in try cocoDB.prepare(docTypes.select(documentTypeName))
        {
            pickerData.append(documentTypeName)
        } 
        
       for docName in try cocoDB.prepare(documentNameTable.select(documentName)
{
    documentNameData.append(docName)
}
        
        
    }
    func typeSelected(varName : String) 
    {
        

    }
    func readDocumentTypes()
    {
        /*
        documentList.removeAll()
        let queryString = "SELECT * from DocumentType"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print ("error preparing insert: \(errmsg)")
            return
        }
        pickerData.append("All")
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            let documentTypeId = sqlite3_column_int(stmt, 0)
            let documentTypeName = String(cString: sqlite3_column_text(stmt,1))
        pickerData.append(documentTypeName)
            
        }
        var titlePtr : OpaquePointer?
        let query2String = "SELECT * from DocumentTitle"
        while(sqlite3_step(titlePtr)==SQLITE_ROW)
        {
            let documentID = sqlite3_column_int(titlePtr,0)
            let documentTitle = String(cString: sqlite3_column_text(titlePtr,1))
            //let documentID=
            let documentTypeId = sqlite3_column_int(titlePtr,2)
            documentNameData.append(documentTitle)
        }
        
        */
}
    
}



