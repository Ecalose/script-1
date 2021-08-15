// ==UserScript==
// @name         KuGouSignIn
// @namespace    http://tampermonkey.net/
// @version      0.9.9
// @description  kugou music sign in automatically
// @author       little star & zkysimon
// @source       https://zky.gs
// @match        https://*/*
// @icon         https://www.kugou.com/yy/static/images/play/logo.png
// @grant        GM_setValue
// @grant        GM_getValue
// @grant        GM_xmlhttpRequest
// @require      http://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.1.0.min.js
// @require      https://cdn.jsdelivr.net/gh/zkysimon/script@latest/kugou/md5.js
// ==/UserScript==

var textPosition = 0;
if (GM_getValue('CSDNsignInfo') != new Date().getDay())
    signInfo();

function signInfo() {
    var cookie = "kg_mid=fa9f78b2a73c8eed05a21197990dee87; kg_dfid=0R8VNQ2n5PGs2CzkEp0OvcuB; kg_dfid_collect=d41d8cd98f00b204e9800998ecf8427e; ACK_SERVER_10015=%7B%22list%22%3A%5B%5B%22gzlogin-user.kugou.com%22%5D%5D%7D; Hm_lvt_aedee6983d4cfc62f509129360d6bb3d=1628429701,1628907693,1628923423,1628990754; kg_mid_temp=fa9f78b2a73c8eed05a21197990dee87; ACK_SERVER_10016=%7B%22list%22%3A%5B%5B%22gzreg-user.kugou.com%22%5D%5D%7D; ACK_SERVER_10017=%7B%22list%22%3A%5B%5B%22gzverifycode.service.kugou.com%22%5D%5D%7D; CheckCode=czozMjoiZjk3YzY0YjQ3ODRiYjE5NWNlZTEzMDhjYjgyMWVmNWMiOw%3D%3D; KuGoo=KugooID=1596410269&KugooPwd=D00377A4B318EEC444B2272E5B7CBDFB&NickName=%u77e5%u547d&Pic=http://imge.kugou.com/kugouicon/165/20210802/20210802192355302570.jpg&RegState=1&RegFrom=&t=93a3a544923e7bb97ebea81b723079be253641de31a21aaf592e3b5b265c600d&a_id=1014&ct=1628995115&UserName=%u0031%u0035%u0039%u0036%u0034%u0031%u0030%u0032%u0036%u0039; KugooID=1596410269; t=93a3a544923e7bb97ebea81b723079be253641de31a21aaf592e3b5b265c600d; a_id=1014; UserName=%u0031%u0035%u0039%u0036%u0034%u0031%u0030%u0032%u0036%u0039; mid=fa9f78b2a73c8eed05a21197990dee87; dfid=0R8VNQ2n5PGs2CzkEp0OvcuB; Hm_lpvt_aedee6983d4cfc62f509129360d6bb3d=1628995118";
    var kugouid = cookie.match(/KugooID=(\S*)&Ku/)[1];
    var token = cookie.match(/&t=(\S*)&a/)[1];
    var time = new Date().valueOf();
    var arr = new Array(9);

    arr[0] = "appid=1014";
    arr[1] = "token=" + token;
    arr[2] = "kugouid=" + kugouid;
    arr[3] = "srcappid=2919";
    arr[4] = "clientver=20000";
    arr[5] = "clienttime=" + time;
    arr[6] = "mid=" + time;
    arr[7] = "uuid=" + time;
    arr[8] = "dfid=-";
    arr.sort();

    var str = "NVPh5oo715z5DIWAeQlhMDsWXXQV4hwt";
    for (var i = 0; i < arr.length; i++) {
        str = str + arr[i];
    }
    str = str + "NVPh5oo715z5DIWAeQlhMDsWXXQV4hwt";

    var signature = hex_md5(str).toUpperCase();

    var address = "https://h5activity.kugou.com/v1/musician/do_signed?appid=1014"
                + "&token=" + token
                + "&kugouid=" + kugouid
                + "&srcappid=2919&clientver=20000"
                + "&clienttime=" + time
                + "&mid=" + time
                + "&uuid=" + time
                + "&dfid=-"
                + "&signature=" + signature;

    GM_xmlhttpRequest({
        method: "post",
        url: address,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        onload: function (r) {
            var errcode = r.responseText.match(/"errcode":(\S*)}/)[1];
            if (errcode == 0) {
                var signedTimes = r.responseText.match(/"signed_times":(\S*),"notice"/)[1];
                if (signedTimes == 3) {
                    alert(new Date().toLocaleDateString() + "酷狗音乐人签到成功，恭喜您已经领取7天vip。");
                }
                else {
                    alert(new Date().toLocaleDateString() + "酷狗音乐人签到成功，您已连续签到" + signedTimes + "天。")
                }
            }
            else {
                var errmsg = r.responseText.match(/"errmsg":"(\S*)"}/)[1];
                alert(errmsg);
            }
        }
    });
}
