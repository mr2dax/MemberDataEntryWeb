/*
* by robert.szeiman
* 17.04.12
*/

package MemberDataEntryWeb;

//import for DB connection
import java.sql.*;
import java.util.ArrayList;

public class Process {
	private static final String INSERT = "INSERT INTO member_info_reg VALUES (?,?,?,?,?,?,?,?);";	//insert SQL
	private static final String SELECT = "SELECT id FROM member_info_reg WHERE username = ? LIMIT 1;";	//select SQL
	
	//processing insert statement
	public static void insertProc (String lnamer, String fnamer, String lnamef, String fnamef, String age, String edu, String login, String pw) {
		//connect to DB
		DBConn dbconn = new DBConn();
		Connection c = null;
		PreparedStatement prst = null;
		
		try {
			c = dbconn.getConnection();
			//prepare the insert query
			prst = c.prepareStatement(INSERT);
			prst.setString(1, lnamer);
			prst.setString(2, fnamer);
			prst.setString(3, lnamef);
			prst.setString(4, fnamef);
			prst.setInt(5, Integer.parseInt(age));
			prst.setString(6, edu);
			prst.setString(7, login);
			prst.setString(8, pw);
			//go, commit
			prst.executeUpdate();
			c.commit();
		} catch (Exception ex) {
			ex.printStackTrace();
			//rollback the transaction if there was an error for ACID
			try {
				c.rollback();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} finally {
			//disconnect
			dbconn.clearConnection(c, prst);
		}
	}
	
	//processing select statement
	public static boolean selectProc (String login) throws Exception {
		//connection with result expected
		DBConn dbconn = new DBConn();
		Connection c = null;
		PreparedStatement prst = null;
		ResultSet rs = null;
		boolean login_exists = false;
		
		try {
			//connect and prepare select query
			c = dbconn.getConnection();
			prst = c.prepareStatement(SELECT);
			prst.setString(1, login);
			prst.executeQuery();
			rs = prst.getResultSet();
			//get first result only (will be only on anyways because of the LIMIT 1)
			login_exists = rs.next();
			//debug
			//System.out.println("Login: "+ login);
			//System.out.println("Exists: "+ login_exists);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception("PostgreSQL Server Connection Error -> check database server availability...");
		} finally {
			//disconnect
			dbconn.clearConnection(c, prst, rs);
		}
		//return true/false depending on if the login exists or not
		return login_exists;
	}
	
	//functions for validation
	//check if text is completely �S�p (full-length character)
	public static boolean isZen(String text){
		//matches full-length katakana, roman letters, hiragana, common and uncommon kanji
		if ( text.matches("[�@-���`-���@-��]*|[\\u3040-\\u309F]*|[\\u4E00-\\u9FAF]*") ) {
			return true;
		} else {
			return false;
		}
    }
	//check if text is all ���p�J�^�J�i (half-length katakana character)
	public static boolean isHanKata(String text) {
		//matches half-width katakana only
		if (text.matches("[�-���]*")) {
			return true;
		} else {
			return false;	
		}
    }

	//validate form entries from frontend
	public static String[] valForm(ArrayList<String> arr) throws Exception {
    	//grab data from form
    	String lnamer = arr.get(0);
    	String fnamer = arr.get(1);
    	String lnamef = arr.get(2);
    	String fnamef = arr.get(3);
    	String age = arr.get(4);
    	String edu = arr.get(5);
    	String login = arr.get(6);
    	String pw = arr.get(7);
    	String pwc = arr.get(8);
		//error messages for error message areas on form
    	String ME001="�K�����͂��Ă��������B";																																												
    	String ME002="�S�p�����̂ݓ��͉\�ł��B";																																												
    	String ME003="���p�J�^�J�i�̂ݓ��͉\�ł��B";																																												
    	String ME004="���p���l�̂ݓ��͉\�ł��B";																																												
    	String ME005="���p�p�����̂ݓ��͉\�ł��B";																																												
    	String ME006="���͉\��������%1�`%2�ł��B";																																												
    	String ME007="%1�`%2�͈͓̔��œ��͂��Ă��������B";																																												
    	String ME008="%1�̔N���%2�`%3�͈̔͂œ��͂��Ă��������B";
    	String ME009="���͂��ꂽID�͊��Ɏg�p����Ă��܂��B";
    	String ME010="�p�X���[�h����]���O�C�����Ɠ����ł��B";																																												
    	String ME011="�p�X���[�h�Ɗm�F�p�p�X���[�h�����Ⴕ�Ă��܂��B";
    	String ME012="%1�`%2�����ŏ������E�啶���E���l�����ꂼ��1�ȏ�g�p���Ĕ��p�p�����̂ݓ��͂��Ă��������B";
		//aux err/val vars
    	Integer mincnt = 1;
    	Integer maxcnt = 25;
    	Integer minval = 6;
    	Integer maxval = 120;
    	Integer edu1 = 12;	//�������E
    	Integer edu2 = 15;	//�������E
    	Integer edu3 = 18;	//������E
    	//to collect error messages from form validation (7 error area on form, string array from 0 to 6)
    	String[] errmessage = new String [] {"N/E","N/E","N/E","N/E","N/E","N/E","N/E"};
    	Integer sect;
    	//init error message areas on form//!!!
    	/*
    	document.getElementById("err1").innerHTML = "";
    	document.getElementById("err2").innerHTML = "";
    	document.getElementById("err3").innerHTML = "";
    	document.getElementById("err4").innerHTML = "";
    	document.getElementById("err5").innerHTML = "";
    	document.getElementById("err6").innerHTML = "";
    	document.getElementById("err7").innerHTML = "";
		*/

    	//roumaji name checks
    	sect = 0;
    	//only �S�p���� accepted, no ���p, ����, special characters, �S�p����
    	if ( !(isZen(lnamer)) || !(isZen(fnamer)) ) {
        	//if error, then add the error message to error array
    		errmessage[sect] = ME002;
        }
		//cannot be blank
    	if ( lnamer.length() == 0 || fnamer.length() == 0 ) {
    		errmessage[sect] = ME001;
    	}
    	//max 25 characters
    	if ( lnamer.length() > 25 || fnamer.length() > 25 ) {
    		//replace limit numbers in error message
    		mincnt = 1;
    		maxcnt = 25;
    		errmessage[sect] = ME006.replace("%1", mincnt.toString()).replace("%2", maxcnt.toString());
    	}
    	
    	//furigana name checks
    	sect = 1;
    	//only ���p�J�^�J�i accepted
    	if ( !(isHanKata(lnamef)) || !(isHanKata(fnamef)) ) {
    		errmessage[sect] = ME003;
    	}
    	//cannot be blank
    	if ( fnamef.length() == 0 || lnamef.length() == 0 ) {
    		errmessage[sect] = ME001;
    	}
    	//max 25 characters
    	if ( lnamef.length() > 25 || fnamef.length() > 25 ) {
    		mincnt = 1;
    		maxcnt = 25;
    		errmessage[sect] = ME006.replace("%1", mincnt.toString()).replace("%2", maxcnt.toString());
    	}

    	//age checks
    	sect = 2;
    	//debug
    	//System.out.println(age);
    	//cannot be blank
    	if ( age.replaceAll("\\s","") == "" ) {
    		errmessage[sect] = ME001;
    	} else {
    		//only ���p���� accepted
    		if ( !(age.matches("^[0-9]+$") ) ) {
    			errmessage[sect] = ME004;
    		} else {
    			//can only be max 3 digits long
    			if ( age.length() > 3 ) {
    				mincnt = 1;
    	    		maxcnt = 3;
    	    		errmessage[sect] = ME006.replace("%1", mincnt.toString()).replace("%2", maxcnt.toString());
    			} else {
    				//age must be between 6-120 years
    				minval = 6;
    				maxval = 120;
    				if ( ( Integer.parseInt(age) < minval) || (Integer.parseInt(age) > maxval) ) {
    			    	errmessage[sect] = ME007.replace("%1", minval.toString()).replace("%2", maxval.toString());
    			    }
    			}
    		}
    	}
    	
    	//edu checks
    	sect = 3;
    	//debug
    	//System.out.println(edu);
    	//each educational level has a set age limit (min age - max age)
		if ( edu == null ) {
			edu = "";
		}
		if ( !(errmessage[2].equals("N/E")) ) {
			age = "0";
		}
		
		switch (edu) {
		//cannot be blank
		case "": 
				errmessage[sect] = ME001;
			break;
		case "���w��": 
			if ( Integer.parseInt(age) > edu1 ) {
				minval = 6;
				maxval = edu1;
				errmessage[sect] = ME008.replace("%1", edu).replace("%2", minval.toString()).replace("%3", maxval.toString());
			}
			break;
		case "���w��": 
			if ( (Integer.parseInt(age) < edu1 ) || (Integer.parseInt(age) > edu2 ) ) {
				minval = edu1;
				maxval = edu2;
				errmessage[sect] = ME008.replace("%1", edu).replace("%2", minval.toString()).replace("%3", maxval.toString());
			}
			break;
		case "���Z��": 
			if ( (Integer.parseInt(age) < edu2 ) || (Integer.parseInt(age) > edu3 ) ) {
				minval = edu2;
				maxval = edu3;
				errmessage[sect] = ME008.replace("%1", edu).replace("%2", minval.toString()).replace("%3", maxval.toString());
			}
			break;
		case "��w��": 
			if ( (Integer.parseInt(age) < edu3 ) ) {
				minval = edu3;
				maxval = 120;
				errmessage[sect] = ME008.replace("%1", edu).replace("%2", minval.toString()).replace("%3", maxval.toString());
			}
		}

    	//login checks
		sect = 4;
		//cannot be blank
    	if ( login.length() == 0 ) {
    		errmessage[sect] = ME001;
    	} else {
    		//only ���p�p���� accepted
        	if ( !(login.matches("^[a-zA-Z0-9]+$")) ) {
        		errmessage[sect] = ME005;
        	} else {
        		//has to be between 4-8 characters
            	if ( login.length() > 8 || login.length() < 4  ) {
            		mincnt = 4;
            		maxcnt = 8;
            		errmessage[sect] = ME006.replace("%1", mincnt.toString()).replace("%2", maxcnt.toString());
            	} else {
            		//check if login name already exists
            		if ( Process.selectProc(login) ) {
            			errmessage[sect] = ME009;
            		} else {
            			//cannot be same as password
            	    	if ( pw.equals(login) ) {
            	    		errmessage[5] = ME010;
            	    	}
            		}
            	}
        	}
    	}

    	//password checks
    	sect = 5;
    	//cannot be blank
    	if ( pw.length() == 0 ) {
    		errmessage[sect] = ME001;
    	}
    	//has to be between 4-10 characters
    	if ( (pw.length() > 10 || pw.length() < 4) && pw.length() != 0  ) {
    		mincnt = 4;
    		maxcnt = 10;
    		errmessage[sect] = ME006.replace("%1", mincnt.toString()).replace("%2", maxcnt.toString());
    	}
    	//only ���p�p���� accepted, must contain 1 number, 1 lowercase character and 1 uppercase character
    	if ( !(pw.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]+$")) && pw.length() != 0 && !(pw.length() > 10) && !(pw.length() < 4)  ) {
    		mincnt = 4;
    		maxcnt = 10;
    		errmessage[sect] = ME012.replace("%1", mincnt.toString()).replace("%2", maxcnt.toString());
    	}
    	
    	//password confirmation check
    	//has to match password with confirmation field
    	sect = 6;
    	if ( !(pw.equals(pwc)) && (pw != "") ) {
    		errmessage[sect] = ME011;
    	}
    	
		return errmessage;
    }
}
