//
//  WriteDiaryViewController.swift
//  DiaryApp
//
//  Created by EthanLin on 2018/1/19.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import CoreData

class WriteDiaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    //UIImagePickerControllerDelegate => 實作選取圖片完後觸發的事件
    //UINavigationControllerDelegate => 開啟相機或存取照片時畫面跳轉所用
    
    // diaryTextView相關
    var photoImage: UIImage?
    
    let textViewFont = UIFont.systemFont(ofSize: 22)
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    
    //在鍵盤上加入toolBar
    @IBOutlet var toolBar: UIView!
    
    //toolBar的動作
    // 開啟相機
    @IBAction func openCamera(_ sender: UIButton) {
        cameraUseWay(1)
    }
    
    //定位
    @IBAction func findLocation(_ sender: UIButton) {
    }
    
    
    @IBAction func saveDiaryAndGotoView3(_ sender: UIBarButtonItem) {
        //可以存Diary的功能
        saveDiary()
        
        let diaryCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DiaryCategoryTableViewController") as! DiaryCategoryTableViewController
        //找到要去的ViewController，要到最後一個畫面是 0 1 2 的 2
        self.navigationController?.tabBarController?.selectedIndex = 2
        
        //鍵盤跳出
        diaryTextView.resignFirstResponder()
        
        //textView清除
        diaryTextView.text = ""
        
    }
    
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        self.cameraUseWay(2)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //在虛擬鍵盤上加上按鈕
        diaryTextView.inputAccessoryView = toolBar
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //寫入一個方法來判斷到底要開相機還是選相簿
     func cameraUseWay(_ kind:Int){
        let picker = UIImagePickerController()
        switch kind {
        case 1:
            //開啟相機
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.allowsEditing = true // 可對照片做編輯
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("No camera")
            }
        default:
            //開啟相簿
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                picker.allowsEditing = true //可對照片做編輯
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    //相簿照片被點按後的事件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let photo = info[UIImagePickerControllerOriginalImage] as! UIImage?
        self.photoImage = photo
        //呼叫插入圖片的方法
        if let okPhoto = photoImage{
             insertPicture(okPhoto, mode: .fitTextLine)
        }
//        insertPicture(photo!, mode: .fitTextView)
        dismiss(animated: true, completion: nil)
    }
 
    //在textView中插入圖片的方法
    //插入圖片
    func insertPicture(_ image:UIImage, mode:ImageAttachmentMode = .default){
        //獲取textView的所有文本，轉成可變的文本
        let mutableStr = NSMutableAttributedString(attributedString: diaryTextView.attributedText)
        
        //创建图片附件
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        imgAttachment.image = image
        
        //设置图片显示方式
        if mode == .fitTextLine {
            //与文字一样大小
            imgAttachment.bounds = CGRect(x: 0, y: -4, width: diaryTextView.font!.lineHeight,
                                          height: diaryTextView.font!.lineHeight)
        } else if mode == .fitTextView {
            //撑满一行
            let imageWidth = diaryTextView.frame.width - 10
            let imageHeight = image.size.height/image.size.width*imageWidth
            imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        }
        
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        
        //获得目前光标的位置
        let selectedRange = diaryTextView.selectedRange
        //插入文字
        mutableStr.insert(imgAttachmentString, at: selectedRange.location)
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedStringKey.font, value: textViewFont,
                                range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        
        //重新给文本赋值
        diaryTextView.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        diaryTextView.selectedRange = newSelectedRange
        //移动滚动条（确保光标在可视区域内）
        self.diaryTextView.scrollRangeToVisible(newSelectedRange)
    }
    
    
    enum ImageAttachmentMode {
        case `default`  //默认（不改变大小）
        case fitTextLine  //使尺寸适应行高
        case fitTextView  //使尺寸适应textView
    }
    
    
    //可以存日記的函數
    func saveDiary(){
        if diaryTextView.text.characters.count > 0{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //此行程式碼讓我們連結到CoreData的model
            let diary = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: context) as! Diary
            
            //把資料存進coreData
            diary.diaryContent = diaryTextView.text
            
            if let selectedPhoto = self.photoImage{
                diary.diaryImage = UIImageJPEGRepresentation(selectedPhoto, 0.75) as NSData?
            }
            
            //存檔
            appDelegate.saveContext()
            
                    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    print(path)
        }
    }
    
}
