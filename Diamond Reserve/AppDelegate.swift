//
//  AppDelegate.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 26.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import AWSAuthCore
import UserNotifications
import AWSSNS
import AWSDynamoDB
import SwiftyJSON
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
     var isInitialized = false
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let didFinishLaunching = AWSSignInManager.sharedInstance().interceptApplication(
            application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        
        registerForPushNotifications()
        
        if (!isInitialized) {
            AWSSignInManager.sharedInstance().resumeSession(completionHandler: {
                (result: Any?, error: Error?) in
                print("Result: \(String(describing: result)) \n Error:\(String(describing: error))")
            })
            isInitialized = true
        }
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:ce0590c6-05bb-470f-be56-b9a76692de91")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        getAdminARN()
        
        UNUserNotificationCenter.current().delegate = self
        
        if  let user = Auth.auth().currentUser {
            UserManager.sharedInstance.loadCurrentUser()
            DiamondManager.sharedInstance.loadMarkupValues()
            UserManager.sharedInstance.login(id: user.email!, completion: { (_ success: Bool, _ userJson: JSON?) in
                if (success) {
                    print(userJson!)
                    UserManager.sharedInstance.user = User(userJson!)
                    UserManager.sharedInstance.saveCurrentUser(userJson: userJson!)
                }
            })
            moveToMainScreen()
        } else {
            moveToLogin()
        }
        
        return didFinishLaunching
    }
 
 

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = "\(deviceToken)"
//            .trimmingCharacters(in: CharacterSet(charactersIn:"<>"))
//            .replacingOccurrences(of:" ", with:"")
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let deviceTokenString = tokenParts.joined()
        print("Device Token: \(deviceTokenString)")
        
        print("deviceTokenString: \(deviceTokenString)")
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
       
        
        let sns = AWSSNS.default()
        let request = AWSSNSCreatePlatformEndpointInput()
        request?.token = deviceTokenString
        request?.platformApplicationArn = SNSPlatformApplicationArn
        sns.createPlatformEndpoint(request!).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print("Error: \(String(describing: task.error))")
            } else {
                let createEndpointResponse = task.result as! AWSSNSCreateEndpointResponse
                print("endpointArn: \(String(describing: createEndpointResponse.endpointArn))")
                UserDefaults.standard.set(createEndpointResponse.endpointArn, forKey: "endpointArn")
            }
            return nil
        })
  
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    
    func getAdminARN() {
        
        UserManager.sharedInstance.getAdminARNs { (_ success: Bool, _ adminARNs: [String]?) in
            if success {
                UserManager.sharedInstance.adminARNS = adminARNs
                UserDefaults.standard.set(adminARNs, forKey: "adminEndpointArn")
            }
        }

    }
    
    func moveToMainScreen() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabbarVC: TabbarViewController? = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as? TabbarViewController
        mainTabbarVC?.selectedIndex = 0
        
        let mainViewController: MainSideMenuController = (storyboard.instantiateViewController(withIdentifier: "MainSideMenuVC") as? MainSideMenuController)!
        mainViewController.rootViewController = mainTabbarVC
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        window?.rootViewController = mainViewController

    }
    
    
    func moveToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splashVC: SplashViewController = (storyboard.instantiateViewController(withIdentifier: "splashVC") as? SplashViewController)!
        let startNC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "startNC") as! UINavigationController
        startNC.viewControllers = [splashVC]
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        window?.rootViewController = startNC
    }
    


    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        let action = data["action"] as! String
        if  action == "reserve_request" {
            let diamondID = data["diamond_id"] as! String
            
            let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
            
            dynamoDbObjectMapper.load(Diamond.self, hashKey: diamondID, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                if let error = task.error as NSError? {
                    print("Getting Diamond failed")
                } else if (task.result as? Diamond) != nil {
                    let diamond: Diamond = task.result as! Diamond
                    let userInfo = ["diamond": diamond, "action":"reserve_request"] as [String : Any]
                    NotificationCenter.default.post(name: NSNotification.Name("diamond_notification"), object: userInfo)
                }
                else if (task.result as? Diamond) == nil {
                    print("There is no diamond for this id")
                }
                return nil
            })
        }
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 1
        let userInfo = response.notification.request.content.userInfo
        
        let action = userInfo["action"] as! String
        //if  action == "reserve_request" {
            let diamondID = userInfo["diamond_id"] as! String
            let userId = userInfo["user_id"] as! String
            
            DiamondManager.sharedInstance.getReservation(user_id: userId, diamond_id: diamondID, completion: { (_ success: Bool, _ diamond: Diamonds?) in
                if success {
                    let userInfo = ["object": diamond, "action": action] as [String : Any]
                    NotificationCenter.default.post(name: NSNotification.Name("diamond_notification"), object: userInfo)
                }
            })

        //}
        completionHandler()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.sound, .alert])
    }

}

