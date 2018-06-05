//
//  AdminListDetailViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 6. 1..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class AdminListDetailViewController: UIViewController {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var lenderNameLabel: UILabel!
    @IBOutlet var rentDateLabel: UILabel!
    
    var selectedData: RentalInfoData?
    var fetchedArray: [UserInfoData] = Array()
//    var name: String?
    var rentDate: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let selectedData = selectedData else {return}
        typeLabel.text = selectedData.type
        numberLabel.text = selectedData.number
        
        //대여자 이름, 대여날짜, 대여자 폰번호 서버에서 select해서 받아오기
        //lenderNameLabel.text = name
        self.rentDateLabel.text = self.rentDate
        //self.rentDateLabel.text = "2018-06-05"
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }

    func downloadDataFromServer() -> Void {
        //let urlString: String = "http://localhost:8888/rental/Admin/AdminMypageListDetail.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/admin/AdminMypageListDetail.php"

        guard let requestURL = URL(string: urlString) else { return }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        var restString: String = "uid=" + appDelegate.ID!
        restString += "&type=" + (selectedData?.type)!
        restString += "&number=" + (selectedData?.number)!

        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return }
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    
                    return }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return }
                
                guard let success = jsonData["success"] as! String! else { print("Error: PHP failure(success)")
                    return }

                if success == "YES" {
                    
                    if let rentDate = jsonData["rentDate"] as! String! {
                        DispatchQueue.main.async {
                            //self.lenderNameLabel.text = name
                            self.rentDate = rentDate
                            print(rentDate)
                        }
                    }
//                    if let name = jsonData["name"] as! String! {
//                        DispatchQueue.main.async {
//                            self.lenderNameLabel.text = name
//                            print(name)
//                        }
//                    }
                } else {
                    if let errMessage = jsonData["error"] as! String! { DispatchQueue.main.async {
                        print(errMessage)
                        print(self.rentDate)

                        }
                    }
                }
            } catch {
                print("Error:  (error)")
            }
        }
        task.resume()

//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
//            guard let receivedData = responseData else {
//                print("Error: not receiving Data"); return; }
//            let response = response as! HTTPURLResponse
//
//            if !(200...299 ~= response.statusCode) { print("HTTP response Error!");
//                return }
//            do {
//                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:.allowFragments) as? [[String: Any]] {
//
//                    for i in 0...jsonData.count-1 {
//                        let newData: UserInfoData = UserInfoData()
//                        var jsonElement = jsonData[i]
//                        newData.name = jsonElement["name"] as! String
//                        newData.phoneNo = jsonElement["phoneNo"] as! String
//
//                        self.name = newData.name
//                        self.phoneNo = newData.phoneNo
//
//                        self.fetchedArray.append(newData)
//                    }
////                    //DispatchQueue.main.async { self.tableView.reloadData()
////                    self.lenderNameLabel.text =
////                    //}
//
//
//                }
//            } catch { print("Error:") }
//        }
//        task.resume()

    }

  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
