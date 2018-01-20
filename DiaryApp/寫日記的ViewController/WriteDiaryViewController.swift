//
//  WriteDiaryViewController.swift
//  DiaryApp
//
//  Created by EthanLin on 2018/1/19.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class WriteDiaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    //UIImagePickerControllerDelegate => 實作選取圖片完後觸發的事件
    //UINavigationControllerDelegate => 開啟相機或存取照片時畫面跳轉所用
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    
    //在鍵盤上加入toolBar
    @IBOutlet var toolBar: UIView!
    
    //toolBar的動作
    // 開啟相機
    @IBAction func openCamera(_ sender: UIButton) {
        cameraUseWay(2)
    }
    
    //定位
    @IBAction func findLocation(_ sender: UIButton) {
    }
    
    
    @IBAction func saveDiaryAndGotoView3(_ sender: UIBarButtonItem) {
        let diaryCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DiaryCategoryViewController") as! DiaryCategoryViewController
        //找到要去的ViewController，要到最後一個畫面是 0 1 2 的 2
        self.navigationController?.tabBarController?.selectedIndex = 2
        
        //鍵盤跳出
        diaryTextView.resignFirstResponder()
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
    
    
 
    
}
