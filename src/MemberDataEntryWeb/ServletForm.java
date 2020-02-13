/*
* by robert.szeiman
* 17.04.12
*/

package MemberDataEntryWeb;

import java.io.IOException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class ServletForm extends HttpServlet {
	//constructor
	public ServletForm() {
        super();
	}
	//if form is posted in GET method, then "re-post" it as POST
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
	}
	//POST method received
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
			try {
				//debug
				System.out.println("Data received!");
				//making sure that character encoding is UTF-8
				request.setCharacterEncoding("UTF-8");
				//fetch data from from request 
				ArrayList<String> paramArr = new ArrayList<String>();
				String lnamer = request.getParameter("surname");
				String fnamer = request.getParameter("name");
				String lnamef = request.getParameter("surname_kana");
				String fnamef = request.getParameter("name_kana");
				String age = request.getParameter("age");
				String edu = request.getParameter("student_class");
				String login = request.getParameter("login_name");
				String pw = request.getParameter("password");
				String pwc = request.getParameter("password2");
				paramArr.add(lnamer);
				paramArr.add(fnamer);
				paramArr.add(lnamef);
				paramArr.add(fnamef);
				paramArr.add(age);
				paramArr.add(edu);
				paramArr.add(login);
				paramArr.add(pw);
				paramArr.add(pwc);
				//treating edu is null case (bug workaround)
				if (edu == null) {
					edu = "";
				}
				//string array to pass back to jsp frontend (request.getAttribute doesn't like ArrayList...) (bug workaround)
				String[] params = new String [] {lnamer,fnamer,lnamef,fnamef,age,edu,login,pw,pwc};
				//validate entries
				//debug
				//System.out.println(paramArr);
				String errArr[] = Process.valForm(paramArr);
				//debug
				//System.out.println(Arrays.toString(errArr));
				//System.out.println(Arrays.toString(params));
				//check if there were any errors
				boolean err = false;
				for( int i=0 ; i<errArr.length ; i++) {
					if( errArr[i] == "N/E" ) {
						err = false;
					} else {
						err = true;
						break;
					}
				}
				//debug
				//System.out.println(err);
				if ( err ) {
					//debug
					System.out.println("Input error(s)!");
					//don't insert data
					//change "N/E"s to empty string
					for( int i=0 ; i<errArr.length ; i++) {
						if ( errArr[i] == "N/E" ){
							errArr[i] = "";
						}
					}
				} else {
					//if no errors, then send data to DB insert procedure
					Process.insertProc(lnamer, fnamer, lnamef, fnamef, age, edu, login, pw);
					//debug
					System.out.println("Data sent for DB insertion!");
					//clean errors array
					for( int i=0 ; i<errArr.length ; i++) {
						errArr[i] = "";
					}
				}
				//return to the requester site with errors (if any) and entries from form submission
				request.setAttribute("errors", errArr);
				request.setAttribute("params", params);
				if (err) {
					request.getRequestDispatcher("index.jsp").forward(request, response);
				} else {
					request.getRequestDispatcher("success.jsp").forward(request, response);
				}
			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("ex", e.getMessage());
				request.getRequestDispatcher("error.jsp").forward(request, response);
			}
	}
	//short description of this servlet
	public String getServletInfo() {
        return "ServletForm";
    }
}
