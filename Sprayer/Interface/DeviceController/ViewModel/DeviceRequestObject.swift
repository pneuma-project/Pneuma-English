//
//  DeviceRequestObject.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/17.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import SwiftyJSON

class DeviceRequestObject: NSObject {
    
    @objc class var shared: DeviceRequestObject {
        struct instance {
            static let _instance:DeviceRequestObject = DeviceRequestObject()
        }
        return instance._instance
    }
    
    //绑定蓝牙mac地址
    @objc func requestEditMacAddress(macAddress:String,sucBlock:((_ status:Int)->())?) {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(Url_EditMacAddress, param: ["loginKey":loginKey,"macAddress":macAddress], checkSum: [loginKey,macAddress], suc: { (data) in
                Dprint("EditMacAddress_Url:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if code == "200" {
                    let result = dataJson["result"].intValue
                    if let block = sucBlock {
                        block(result)
                    }
                }
            }) { (error) in
                Dprint("EditMacAddress_UrlError:\(error)")
            }
        }
    }
    
    //蓝牙设备绑定状态
    @objc func requestGetMacAddressBindState(macAddress:String,sucBlock:((_ status:Int)->())?) {
        SURLRequest.sharedInstance.requestPostWithHeader(URL_GetMacAddressBindState, param: ["macAddress":macAddress], checkSum: [macAddress], suc: { (data) in
            Dprint("URL_GetMacAddressBindState:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            if code == "200" {
                let result = dataJson["result"].intValue
                if let block = sucBlock {
                    block(result)
                }
            }
        }) { (error) in
            Dprint("URL_GetMacAddressBindStateError:\(error)")
        }
    }
    
    //添加训练数据
    @objc func requestSaveTrainData(medicineId:String,trainData:String,dataSum:Double,addDate:String,sucBlock:((_ code:String)->())?) {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(URL_SaveTrainData, param: ["loginKey":loginKey,"medicineId":medicineId,"trainData":trainData,"dataSum":dataSum,"addDate":addDate], checkSum: [loginKey,medicineId,trainData,"\(dataSum)",addDate], suc: { (data) in
                Dprint("URL_SaveTrainData:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if let block = sucBlock {
                    block(code)
                }
            }) { (error) in
                Dprint("URL_SaveTrainDataError:\(error)")
            }
        }
    }
    
    //获取最新一条训练数据
    @objc var requestGetNewTrainDataSuc:((_ model:SprayerDataModel)->())?
    @objc func requestGetNewTrainData() {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(URL_GetNewTrainData, param: ["loginKey":loginKey], checkSum: [loginKey], suc: { (data) in
                Dprint("URL_GetNewTrainData:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if code == "200" {
                    let result = dataJson["result"]
                    let model = SprayerDataModel.getFromModel(json: result)
                    if let block = DeviceRequestObject.shared.requestGetNewTrainDataSuc {
                        block(model)
                    }
                }
            }) { (error) in
                Dprint("URL_GetNewTrainDataError:\(error)")
            }
        }
    }
    
    //添加吸雾数据
    @objc func requestSaveSuckFogData(medicineId:String,suckFogData:String,dataSum:Float,addDate:String,sucBlock:((_ code:String)->())?) {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(URL_SaveSuckFogData, param: ["loginKey":loginKey,"medicineId":medicineId,"suckFogData":suckFogData,"dataSum":dataSum,"addDate":addDate], checkSum: [loginKey,medicineId,suckFogData,"\(dataSum)",addDate], suc: { (data) in
                Dprint("URL_SaveSuckFogData:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if let block = sucBlock {
                    block(code)
                }
            }) { (error) in
                Dprint("URL_SaveSuckFogDataError:\(error)")
            }
        }
    }
    
    ///获取当天吸雾数据
    @objc var requestGetNowDataSuckFogDataSuc:((_ dataList:[SprayerDataModel])->())?
    @objc func requestGetNowDataSuckFogData(addDate:String,endDate:String) {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(URL_GetNowDateSuckFogData, param: ["loginKey":loginKey,"addDate":addDate,"endDate":endDate], checkSum: [loginKey,addDate,endDate], suc: { (data) in
                Dprint("URL_GetNowDateSuckFogData:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if code == "200" {
                    var dataArr:[SprayerDataModel] = []
                    let resultJsonArr = dataJson["result"].arrayValue
                    for resultJson:JSON in resultJsonArr {
                        let model = SprayerDataModel.getFromModel(json: resultJson)
                        dataArr.append(model)
                    }
                    if let block = DeviceRequestObject.shared.requestGetNowDataSuckFogDataSuc {
                        block(dataArr)
                    }
                }
            }) { (error) in
                Dprint("URL_GetNowDateSuckFogDataError:\(error)")
            }
        }
    }
    
    //获取历史喷雾数据
    @objc var requestGetHistorySuckFogDataSuc:((_ dataList:[SprayerDataModel])->())?
    @objc func requestGetHistorySuckFogData() {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(URL_GetHistorySuckFogData, param: ["loginKey":loginKey], checkSum: [loginKey], suc: { (data) in
                Dprint("URL_GetHistorySuckFogData:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if code == "200" {
                    var dataArr:[SprayerDataModel] = []
                    let resultJsonArr = dataJson["result"].arrayValue
                    for resultJson:JSON in resultJsonArr {
                        let model = SprayerDataModel.getFromModel(json: resultJson)
                        dataArr.append(model)
                    }
                    if let block = DeviceRequestObject.shared.requestGetHistorySuckFogDataSuc {
                        block(dataArr)
                    }
                }
            }) { (error) in
                Dprint("URL_GetHistorySuckFogDataError:\(error)")
            }
        }
    }
}
