# Linkedin
REST API Sign In with LinkedIn

*  ####  [基本字段查詢][api]  
##### 基本字段開發者權限：r_basicprofile
##### 串接郵件需要權限：r_emailaddress
[api]:https://developer.linkedin.com/docs/fields/basic-profile
***
####  NSURLSession使用Apple於iOS7的時候,推出了NSURLConnection的後繼者一NSURLSession 
* 可以進行更詳細的設定。 
* 可以對於每一個工作進行取消、暫停、繼續等動作。 
* 當App暫停在背景時,仍可以進行上傳與下載的作業。
* 可以支援Delegate或者Block方式的運作。 
#### 透過指定NSURLSessionConfiguration的參數,可以指定為三大類使用情境 
* defaultSessionConfig uration:預設的設定,類似於NSURLConnection的 運作模式,傳輸的資料量大時,將於內部儲存空間做暫存 
* ephemeralSessionConfiguration:專供臨時傳輸所需的設定,所有的東西都 儲存於記憶體中,當App結束該Session時,所有的資訊都會消失
* backgroundSessionConfiguration:專供背景傳輸所需的設定,類似於 defaultSessionConfiguration ,但將於背景開啟一個新的Process來處理所有的工作 我們也可以指定三種不同的NSURLSessionTask:
* ##### NSURLSessionDataTask:一般的NSData下載,但不支援背景下載。 
* ##### NSURLSessionUploadTask :上傳內容用,有支援背景下載 
* ##### NSURLSessionDownloadTask:下載內容用,有支援背景下載  = 
***
### http協定-維基百科: http:// hwikipedia.org/zh-twiHttp) 
####  HTTP協定(1.1)提供了八種方法(or 動作)來表明Request-URI指定的資源的不同操作方式: 
* OPTIONS 返回伺服器針對特定資源所支援的HTTP請求方法。也可以利用向Web伺服器發送'*'的請求來測試伺服器的功能性。
* HEAD 向伺服器索要與GET請求相一致的響應,只不過響應體將不會被返回。這一方法可以在不必傳輸整個響應內容的情況下,就可以獲取包含在響應訊息頭中的資訊。 * * GET 向特定的資源發出請求。注意:GET方法不應當被用於產生「副作用」的操作中,例如在WebApplication中。其中一個原因是GET可能會被網路蜘蛛等隨意。 
* POST 向指定資源送出資料進行處理請求(例如送出表單或者上傳檔案)。資料被包含在請求體中. POST請求可能會導致新的資源的建立和/或已有資源的修改。
* PUT 向指定資源位置上傳其最新內容。 
* DELETE 請求伺服器刪除Request-URI所標識的資源 
* TRACE 回顯伺服器收到的請求,主要用於測試或診斷 
* CONNECT HTP/1.1協定中預留給能夠將連線改為管道方式的代理伺服器。 
####  以一般的應用來說, GET與POST是兩種我們最常用的方法, GET可以讓我們 從Server取得一些資訊,同時間也可以用帶入參數的方式執行這個GET動作: http://maps.google.com.tw/?ll=23.123456,123.654321&z=13 以上例而言問號(?)後面的內容就是HTTP Get所帶入的參數,若有多個參數時,用 &符號來區隔,上面這個參數代表的是要求Google Maps顯示這個經緯度的內容,並且將地圖的放大等級設定為13。 

* 一般性簡單的參數的話, GET就可以勝任愉快了,但是若要傳輸大量的資料時 (eg.上傳檔案) , GET就無法應付這樣的需求了,此時我們常用的協定方式是 POST-POST可以讓我們將資料內容當作參數POST到Server上去,雖然不具有FTP/SSH協定之類的續傳/內容檢查等專門的用作大量資料傳輸的能力,但就一般 性的上傳檔案或者資料而言, POST仍足以提供一個簡便的方法把大量資料送至 Server ,在大部分的情況下仍可以運作良好 
* 傳輸保密安全: HTTP被廣泛的使用,但在某些內容敏感性的通訊時,就需要 在傳輸的過程中做必要的保護(eg.線上付費、登入帳號密碼等), HTTPS就是一個 相對應的技術,可以提供HTTP協定SSL/TLS的加密保護。
