//
//  ViewController.swift
//  TouchIDAndFaceIDDemo-Swift
//
//  Created by 贺文杰 on 2019/7/15.
//  Copyright © 2019 贺文杰. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        verifyIsTouchIDOrFaceID()
    }
    
    func verifyIsTouchIDOrFaceID(){
        if #available(iOS 8.0, *){
            
            let context = LAContext.init()
            var error : NSError?
            
            if context.canEvaluatePolicy(getAuthentication(), error: &error){
                if context.biometryType == LABiometryType.none{
                    print("调用不起")
                    return
                }
                if #available(iOS 11.0, *){ //Face ID
                    getTouchIDOrFaceIDStatus(context: context, isTouchID: false)
                }else{ //Touch ID
                    getTouchIDOrFaceIDStatus(context: context, isTouchID: true)
                }
            }else{
                print("\(String(describing: error))")
            }
        }
    }
    
    func getAuthentication() -> LAPolicy{
        var policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        if #available(iOS 9.0, *){
            policy = LAPolicy.deviceOwnerAuthentication
        }
        return policy
    }
    
    func getTouchIDOrFaceIDStatus(context : LAContext , isTouchID : ObjCBool)
    {
        context.localizedFallbackTitle = "另一种方式验证"
        /*
         LAPolicyDeviceOwnerAuthenticationWithBiometrics 生物识别
         LAPolicyDeviceOwnerAuthentication 生物识别+密码认证
         */
        ///如果超出尝试次数，这里的block不会执行
        context.evaluatePolicy(getAuthentication(), localizedReason: NSLocalizedString("通过验证指纹解锁", comment: "")) { (success, error) in
            if success{
                print("验证成功")
            }else{
                print("\(String(describing: error?.localizedDescription))")
            }
        }
    }

}

