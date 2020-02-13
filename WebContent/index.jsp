<!--
by robert.szeiman
17.04.12
-->

<!-- JSP init -->
<%@ page import="java.util.*"
	language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%> 
<%
    String [] errorList = (String[])request.getAttribute("errors");
	String [] paramList = (String[])request.getAttribute("params");
	//debug
	//System.out.println(Arrays.toString(errorList));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<!-- CSS -->
        <link rel="stylesheet" href="design.css" type="text/css"/>
        <title>会員登録画面</title>
        <!-- JS -->
        <script type="text/javascript">
        function initTest() {
        	//starting values for testing only
        	/*
        	document.getElementById("surname").value = "Ｓｚｅｉｍａｎ";
        	document.getElementById("name").value = "Ｒｏｂｅｒｔ";
        	document.getElementById("surnamekana").value = "ｾｲﾏﾝ";
        	document.getElementById("namekana").value = "ﾛﾍﾞﾙﾄ";
        	document.getElementById("age").value = "32";
        	document.getElementById("login").value = "mr2dax";
        	document.getElementById("password").value = "Mr2dax";
        	document.getElementById("password2").value = "Mr2dax";
        	document.getElementById("edu4").checked = true;
        }
        */
        /*
        //validate form entries on frontend
        function valForm() {
        	//grab data from form
        	var lnamer = document.forms["form"]["surname"].value;
        	var fnamer = document.forms["form"]["name"].value;
        	var lnamef = document.forms["form"]["surname_kana"].value;
        	var fnamef = document.forms["form"]["name_kana"].value;
        	var age = document.forms["form"]["age"].value;
        	var edu = document.forms["form"]["student_class"].value;
        	var login = document.forms["form"]["login_name"].value;
        	var pw = document.getElementById("password").value;
        	var pwc = document.getElementById("password2").value;
			//error messages for error message areas on form
        	var ME001="必ず入力してください。";																																												
        	var ME002="全角文字のみ入力可能です。";																																												
        	var ME003="半角カタカナのみ入力可能です。";																																												
        	var ME004="半角数値のみ入力可能です。";																																												
        	var ME005="半角英数字のみ入力可能です。";																																												
        	var ME006="入力可能文字数は%1～%2です。";																																												
        	var ME007="%1～%2の範囲内で入力してください。";																																												
        	var ME008="%1の年齢は%2～%3の範囲で入力してください。";																																												
        	//var ME009="入力されたIDは既に使用されています。";	//comes from servlet as a request forward																																											
        	var ME010="パスワードが希望ログイン名と同じです。";																																												
        	var ME011="パスワードと確認用パスワードが相違しています。";
        	var ME012="%1～%2文字で小文字・大文字・数値をそれぞれ1つ以上使用して半角英数字のみ入力してください。";
  			//aux err vars
        	var mincnt = 1;
        	var maxcnt = 25;
        	var minval = 6;
        	var maxval = 120;
        	var edu1 = 12;	//小中限界
        	var edu2 = 15;	//中高限界
        	var edu3 = 18;	//高大限界
        	var errmessage = "";	//to collect error message from form validation
        	//init error message areas on form
        	document.getElementById("err1").innerHTML = "";
        	document.getElementById("err2").innerHTML = "";
        	document.getElementById("err3").innerHTML = "";
        	document.getElementById("err4").innerHTML = "";
        	document.getElementById("err5").innerHTML = "";
        	document.getElementById("err6").innerHTML = "";
        	document.getElementById("err7").innerHTML = "";
			
        	//functions
        	//check if text is 全角 (full-length character)
        	function isZen(text){
                for(var i=0; i<text.length; i++){
                    //1文字ずつ文字コードをエスケープし、その長さが4文字以上なら全角
                    //check each character's length
                    var len=escape(text.charAt(i)).length;
                    //if character's length is longer or equal to 4 bytes, then it is 全角
                    if( len>=4 ){
                        return true;
                    }
                }
                return false;
            }
        	//check if text has any 半角カタカナ (half-length katakana character)
        	function hasHanKata(text) {
        		var han="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｯｬｭｮﾞﾟ";
                var mes="";
                for (var i=0; i<text.length; i++) {
                    //文字列を１文字ずつ調べる
                    //loop through text
                    var tmp1=text.substr(i,1);
                    for (var j=0; j<han.length; j++) {
                    	//check if each character is 半角カタカナ
                        var tmp2=han.substr(j,1);
                        //含まれていた半角カナを格納
                        //if yes then store it in a variable string
                        if (tmp1==tmp2) {
                            mes+="「"+tmp1+"」";
                        }
                    }
                }
                if(mes!="") {
                	//半角カタカナが含まれている場合
                	//if there were any 半角カタカナ in text, then return true
                    return true;
                } else {
                	//半角カタカナが含まれていない場合
                	//if not, then return false
                    return false;
                }
            }
        	//check if text is all 半角カタカナ
        	function isHanKata(text) {
        		var han="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｯｬｭｮﾞﾟ";
                var mes="";
                for (var i=0; i<text.length; i++) {
                    // 文字列を１文字ずつ調べる
                    //loop through text
                    var tmp1=text.substr(i,1);
                    for (var j=0; j<han.length; j++) {
                        var tmp2=han.substr(j,1);
                        // 含まれていた半角カナを格納
                        //if yes then store it in a variable string
                        if (tmp1==tmp2) {
                            mes+=tmp1;
                        }
                    }
                }
                if(mes.length==text.length) {
                	//if text is all 半角カタカナ then lenghts match
                    return true;
                } else {
                	//if not then not all characters are 半角カタカナ
                    return false;
                }
            }
        	
        	//roumaji name checks
        	//only 全角文字 accepted, no 半角, 数字, special characters, 全角数字
        	if ( !(isZen(lnamer)) || !(isZen(fnamer)) || (hasHanKata(lnamer)) || (hasHanKata(fnamer)) || (lnamer.match(/[０-９]/) ) || (fnamer.match(/[０-９]/) ) || (lnamer.match(/[0-9]/) ) || (fnamer.match(/[0-9]/) ) ) {
            	//if error, then set error area text on form to show designated error message
        		errmessage = ME002;
            	document.getElementById("err1").innerHTML = errmessage;
            }
			//cannot be blank
        	if ( lnamer.length == 0 || fnamer.length == 0 ) {
        		errmessage = ME001;
        		document.getElementById("err1").innerHTML = errmessage;
        	}
        	//max 25 characters
        	if ( lnamer.length > 25 || fnamer.length > 25 ) {
        		//replace limit numbers in error message
        		mincnt = 1;
        		maxcnt = 25;
        		errmessage = ME006.replace("%1", mincnt);
        		errmessage = errmessage.replace("%2", maxcnt);
        		document.getElementById("err1").innerHTML = errmessage;
        	}
        	
        	//furigana name checks
        	//only 半角カタカナ accepted
        	if ( !(isHanKata(lnamef)) || !(isHanKata(fnamef)) ) {
            	errmessage = ME003;
            	document.getElementById("err2").innerHTML = errmessage;
        	}
        	//cannot be blank
        	if ( fnamef.length == 0 || lnamef.length == 0 ) {
        		errmessage = ME001;
        		document.getElementById("err2").innerHTML = errmessage;
        	}
        	//max 25 characters
        	if ( lnamef.length > 25 || fnamef.length > 25 ) {
        		mincnt = 1;
        		maxcnt = 25;
        		errmessage = ME006.replace("%1", mincnt);
        		errmessage = errmessage.replace("%2", maxcnt);
        		document.getElementById("err2").innerHTML = errmessage;
        	}

        	//age checks
        	if ( age.length > 3 ) {
        		mincnt = 1;
        		maxcnt = 3;
        		errmessage = ME006.replace("%1", mincnt);
        		errmessage = errmessage.replace("%2", maxcnt);
        		document.getElementById("err3").innerHTML = errmessage;
        	}
        	//cannot be blank
        	if ( age.length == 0 ) {
        		errmessage = ME001;
        		document.getElementById("err3").innerHTML = errmessage;
        	}
        	//only 半角数字 accepted
        	if ( !(age.match(/^[0-9]+$/)) && (age !="") ) {
        		errmessage = ME004;
        		document.getElementById("err3").innerHTML = errmessage;
        	}
        	//age must be between 6-120 years
        	if ( ( parseInt(age) < 6) || (parseInt(age) > 120) ) {
        		minval = 6;
        		maxval = 120;
        		errmessage = ME007.replace("%1", minval);
        		errmessage = errmessage.replace("%2", maxval);
        		document.getElementById("err3").innerHTML = errmessage;
        	}
        	
        	//edu checks
        	//each educational level has a set age limit (min age - max age)
    		switch (edu) {
    		//cannot be blank
    		case "": 
   				errmessage = ME001;
           		document.getElementById("err4").innerHTML = errmessage;
    			break;
    		case "小学生": 
    			if ( parseInt(age) > edu1 ) {
    				minval = 6;
    				maxval = edu1;
    				errmessage = ME008.replace("%1", edu);
             		errmessage = errmessage.replace("%2", minval);
             		errmessage = errmessage.replace("%3", maxval);
             		document.getElementById("err4").innerHTML = errmessage;
    			}
    			break;
    		case "中学生": 
    			if ( (parseInt(age) < edu1 ) || (parseInt(age) > edu2 ) ) {
    				minval = edu1;
    				maxval = edu2;
    				errmessage = ME008.replace("%1", edu);
             		errmessage = errmessage.replace("%2", minval);
             		errmessage = errmessage.replace("%3", maxval);
             		document.getElementById("err4").innerHTML = errmessage;
    			}
    			break;
    		case "高校生": 
    			if ( (parseInt(age) < edu2 ) || (parseInt(age) > edu3 ) ) {
    				minval = edu2;
    				maxval = edu3;
    				errmessage = ME008.replace("%1", edu);
             		errmessage = errmessage.replace("%2", minval);
             		errmessage = errmessage.replace("%3", maxval);
             		document.getElementById("err4").innerHTML = errmessage;
    			}
    			break;
    		case "大学生": 
    			if ( (parseInt(age) < edu3 ) ) {
    				minval = edu3;
    				maxval = 120;
    				errmessage = ME008.replace("%1", edu);
             		errmessage = errmessage.replace("%2", minval);
             		errmessage = errmessage.replace("%3", maxval);
             		document.getElementById("err4").innerHTML = errmessage;
    			}
    		}

        	//login checks
        	//cannot be blank
        	if ( login.length == 0 ) {
        		errmessage = ME001;
        		document.getElementById("err5").innerHTML = errmessage;
        	}
        	//only 半角英数字 accepted
        	if ( !(login.match(/^[a-zA-Z0-9]+$/)) && login.length != 0  ) {
        		errmessage = ME005;
        		document.getElementById("err5").innerHTML = errmessage;
        	}
        	//has to be between 4-8 characters
        	if ( (login.length > 8 || login.length < 4 ) && login.length != 0  ) {
        		mincnt = 4;
        		maxcnt = 8;
        		errmessage = ME006.replace("%1", mincnt);
        		errmessage = errmessage.replace("%2", maxcnt);
        		document.getElementById("err5").innerHTML = errmessage;
        	}

        	//password checks
        	//cannot be blank
        	if ( pw.length == 0 ) {
        		errmessage = ME001;
        		document.getElementById("err6").innerHTML = errmessage;
        	}
        	//has to be between 4-10 characters
        	if ( (pw.length > 10 || pw.length < 4) && pw.length != 0  ) {
        		mincnt = 4;
        		maxcnt = 10;
        		errmessage = ME006.replace("%1", mincnt);
        		errmessage = errmessage.replace("%2", maxcnt);
        		document.getElementById("err6").innerHTML = errmessage;
        	}
        	//only 半角英数字 accepted, must contain 1 number, 1 lowercase character and 1 uppercase character
        	if ( !(pw.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]+$/)) && pw.length != 0 && !(pw.length > 10) && !(pw.length < 4)  ) {
        		mincnt = 4;
        		maxcnt = 10;
        		errmessage = ME012.replace("%1", mincnt);
        		errmessage = errmessage.replace("%2", maxcnt);
        		document.getElementById("err6").innerHTML = errmessage;
        	}
        	//has to match password with confirmation field
        	if ( (pw != pwc) && (pw != "")) {
        		errmessage = ME011;
        		document.getElementById("err7").innerHTML = errmessage;
        	}
        	//cannot be same as login ID
        	if ( (pw == login) && (pw != "")) {
        		errmessage = ME010;
        		document.getElementById("err6").innerHTML = errmessage;
        	}
        	//if there was no error, then submit the form, pop-up message to notify
        	if (errmessage == "") {
        		document.getElementById('form').submit();
        		alert("登録の手続きが誠に完了しました！");
        		//must return true to input form for submission to work
        		return true;
        	//if there were errors, then clear errmessage variable (otherwise double submission imminent)
        	//return false to hinder form submission
        	} else {
        		errmessage = "";
        		return false;
        	}
        }
        */
        </script>
    </head>
    <!-- for testing only -->
    <body onload="initTest()">
		<div class="center">
    	<h1>会員情報入力</h1>
    	<!-- form validation with JS onsubmit="return valForm()" -->
    	<form id="form"name="form" method="POST" action="./ServletForm">
			<table>
				<tr>
					<th>氏名</th>
					<td>
						<div class="description">全角英文字で入力してください。</div>
						<div class="error" id="err1">
						<% 
						if (errorList != null) {
							out.print(errorList[0]);
						}
						%>
						</div>
						（姓）<input type="text" name="surname" id="surname" value="<% 
						if (paramList != null) {
							out.print(paramList[0]);
						}
						%>">（名）<input type="text" name="name" id="name" value="<% 
						if (paramList != null) {
							out.print(paramList[1]);
						}
						%>">
					</td>
				</tr>
				<tr>
					<th>氏名（フリガナ）</th>
					<td>
						<div class="description">半角カタカナで入力してください。</div>
						<div class="error" id="err2">
						<% 
						if (errorList != null) {
							out.print(errorList[1]);
						}
						%>
						</div>
						（姓）<input type="text" name="surname_kana" id="surnamekana" value="<% 
						if (paramList != null) {
							out.print(paramList[2]);
						}
						%>">（名）<input type="text" name="name_kana" id="namekana" value="<% 
						if (paramList != null) {
							out.print(paramList[3]);
						}
						%>">
					</td>
				</tr>
				<tr>
					<th>年齢</th>
					<td>
						<div class="description">半角数値で入力してください。</div>
						<div class="error" id="err3">
						<% 
						if (errorList != null) {
							out.print(errorList[2]);
						}
						%>
						</div>
						<input type="text" name="age" size="3" id="age" value="<% 
						if (paramList != null) {
							out.print(paramList[4]);
						}
						%>">
					</td>
				</tr>
				<tr>
					<th>区分</th>
					<td>
						<div class="error" id="err4">
						<% 
						if (errorList != null) {
							out.print(errorList[3]);
						}
						%>
						</div>
						<input type="radio" name="student_class" value="小学生" id="edu1"<%
								if (paramList != null) {
									if (paramList[5].equals("小学生")) {
										out.print(" checked=\"checked\"");
									}
								}
						%>>小学生&nbsp;&nbsp;
						<input type="radio" name="student_class" value="中学生" id="edu2"<%
								if (paramList != null) {
									if (paramList[5].equals("中学生")) {
										out.print(" checked=\"checked\"");	
									}
								}
						%>>中学生<br>
						<input type="radio" name="student_class" value="高校生" id="edu3"<%
								if (paramList != null) {
									if (paramList[5].equals("高校生")) {
										out.print(" checked=\"checked\"");
									}
								}
						%>>高校生&nbsp;&nbsp;
						<input type="radio" name="student_class" value="大学生" id="edu4"<%
								if (paramList != null) {
									if (paramList[5].equals("大学生")) {
										out.print(" checked=\"checked\"");
									}
								}
						%>>大学生<br>
					</td>
				</tr>
				<tr>
					<th>希望ログイン名</th>
					<td>
						<div class="description">&lt;4～8文字・半角英数字&gt;<br>
						他のユーザーと同じIDは使用できません。</div>
						<div class="error" id="err5">
						<% 
						if (errorList != null) {
							out.print(errorList[4]);
						}
						%>
						</div>
						<input type="text" name="login_name" id="login" value="<% 
						if (paramList != null) {
							out.print(paramList[6]);
						}
						%>">
					</td>
				</tr>
				<tr>
					<th>パスワード</th>
					<td>
							<div class="description">&lt;4～10文字・半角英数字&gt;<br>
						小文字・大文字・数値をそれぞれ1つ以上使用してください。<br>
						「ログインID」と同じものは使用できません。</div>
						<div class="error" id="err6">
						<% 
						if (errorList != null) {
							out.print(errorList[5]);
						}
						%>
						</div>
						<input type="password" name="password" id="password">
					</td>
				</tr>
				<tr>
					<th>確認用パスワード</th>
					<td>
						<div class="description">確認の為もう一度パスワードを入力してください。</div>
						<div class="error" id="err7">
						<% 
						if (errorList != null) {
							out.print(errorList[6]);
						}
						%>
						</div>
						<input type="password" name="password2" id="password2">
					</td>
				</tr>
			</table><br>
			<button type="submit" id="register">登録</button></form>
		</div>
	</body>
</html>