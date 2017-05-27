# iBeacon
 iBeacon的設計僅能作為定位用。
iBeacon也被應用於室內定位以及室內導覽之類的應用,但由於BLE無線訊號的干因素頗多,單靠RSSI的資訊為基礎, iBeacon做為室內精準定位的表現只能說是差強人意,但做為基本與概略的定位而言,仍是可以滿足的。  

Apple於CoreLocation Framework中,提供了:Beacon的相關功能,若要用到 Beacon ,有幾個名詞我們需要先進一步的理解: 
ProximityUUID:這是一個128bits長,以UUID為格式的一個唯一的識別碼,通 常會供我們用來判斷是否這是我們在尋找的iBeacon 。 

*  Major:這是一個16bits長的unsigned int數字,算是該ProximityUUID底下的 一個附屬資訊,用來識別目前User是否正在特定的場域之用  
*  Minor:這也是一個16bits長的unsigned int數字,常用來識別某一場域中的不同 顆iBeacon。   

iBeacon於CoreLocation中的支援方式十分的簡單,典型的用法中,我們當然需要加人CoreLocation Framework,以及CLLocationManagerDelegate的Protocol 
指定目標Beacon的UUID值,多組也可以: NSUU ID 
*  requestAlwaysAuthorization可以於背景執行：info.plist加入使用敘述Privacy-Location Always Usage Description
