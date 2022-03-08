//
//  AppDelegate.swift
//  SFSampleAppSwift
//
//  Created by Daichi Mizoguchi on 2014/12/08.
//  Copyright (c) 2014年 Daichi Mizoguchi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let RemoteAccessConsumerKey: String = "3MVG9Iu66FKeHhINkB1l7xt7kR8czFcCTUhgoA8Ol2Ltf1eYHOU4SqQRSEitYFDUpqRWcoQ2.dBv_a1Dyu5xa"
    let OAuthRedirectURI: String = "testsfdc:///mobilesdk/detect/oauth/done"
    
    
    override init() {
        super.init()
        SFLogger.setLogLevel(SFLogLevelDebug)
        SalesforceSDKManager.shared().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.shared().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.shared().authScopes = ["web", "api"]
        weak var weakSelf: AppDelegate! = self
        SalesforceSDKManager.shared().postLaunchAction = {(launchActionList :SFSDKLaunchAction) -> () in
            let acListString:String = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            weakSelf?.log(SFLogLevelInfo, msg:"Post-launch: launch actions taken:" + acListString)
            self.setupRootViewController()
        }
        
        SalesforceSDKManager.shared().launchErrorAction = {(error :NSError!, launchActionList :SFSDKLaunchAction) -> () in
            let errorString:String = error.localizedDescription
            weakSelf?.log(SFLogLevelError, msg:"Error during SDK launch:" + errorString)
            self.initializeAppViewState()
            SalesforceSDKManager.shared().launch()
            } as! SFSDKLaunchErrorCallbackBlock
        
        SalesforceSDKManager.shared().postLogoutAction = ({
            weakSelf?.handleSdkManagerLogout()
            return
        })
        
        SalesforceSDKManager.shared().switchUserAction = {(fromUser: SFUserAccount!, toUser: SFUserAccount!) -> () in
            weakSelf?.handleUserSwitch(fromUser: fromUser, toUser: toUser)
            return
        }
        
        return
    }

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.initializeAppViewState()
        SalesforceSDKManager.shared().launch()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {}

    func applicationWillTerminate(application: UIApplication) {}
    
    
    // MARK: Private methods
    
    func initializeAppViewState() {
        self.window?.rootViewController = InitialViewController(nibName: Util.className(ac: InitialViewController), bundle: nil)
        self.window?.makeKeyAndVisible()
    }
    
    
    func setupRootViewController() {
        let rootVC: RootViewController = RootViewController(nibName: Util.className(ac: RootViewController), bundle: nil)
        let navVC: UINavigationController = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = navVC
    }
    
    
    func resetViewState(postResetBlock: @escaping ()->Void) {
        if ((self.window?.rootViewController?.presentedViewController) != nil) {
            self.window?.rootViewController?.dismiss(animated: false, completion: postResetBlock)
        } else {
            postResetBlock()
        }
    }
    
    
    func handleSdkManagerLogout() {
        self.log(SFLogLevelDebug, msg:"SFAuthenticationManager logged out.  Resetting app.")
        self.resetViewState(postResetBlock: {
            self.initializeAppViewState()
            let allAccounts: Array? = SFUserAccountManager.sharedInstance().allUserAccounts
            
            if ((allAccounts?.count)! > 1) {
                let userSwitchVc: SFDefaultUserManagementViewController
                = SFDefaultUserManagementViewController(completionBlock: {(action: SFUserManagementAction) -> () in
                    self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                    return
                })
                self.window?.rootViewController?.present(userSwitchVc, animated: true, completion: nil)
            } else {
                if (allAccounts?.count == 1) {
                    SFUserAccountManager.sharedInstance().currentUser = SFUserAccountManager.sharedInstance().allUserAccounts[0] as! SFUserAccount
                }
                SalesforceSDKManager.shared().launch()
            }
        })
    }
    
    
    func handleUserSwitch(fromUser: SFUserAccount, toUser: SFUserAccount) {
        let switchMsg: String = "SFUserAccountManager changed from user " + fromUser.userName + "to " +  toUser.userName + " Resetting app."
        self.log(SFLogLevelDebug, msg:switchMsg)
        self.resetViewState(postResetBlock: {
            self.initializeAppViewState()
            SalesforceSDKManager.shared().launch()
        })
    }
}

