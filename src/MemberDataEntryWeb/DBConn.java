/*
* by robert.szeiman
* 17.04.12
*/

package MemberDataEntryWeb;

//import for DB connection
import java.sql.*;

public class DBConn {
	//set up connection
	public Connection getConnection() {
		Connection con = null;
		String driver = "org.postgresql.Driver";					//JDBC driver
		String server = "localhost";								//PostgreSQL server name (ip/hostname)
		String dbname = "member_reg_scn";							//database name
		String url = "jdbc:postgresql://" + server + "/" + dbname;	//connection url construction
		String user = "postgres";									//db user name
		String pw = "Muthafuc85$";									//db user pw
		
		try {
			Class.forName(driver);
			con = DriverManager.getConnection(url, user, pw);			//connect to the database
			con.setAutoCommit(false);									//have to explicitly call commit after transactions 
		} catch(Exception ex) {
			//System.out.println("Connection error");
			ex.printStackTrace();
		}
		return con;
	}
	//close connection, empty statement and result set for select
	public void clearConnection(Connection con, PreparedStatement prst, ResultSet rs) {
		try {
			if (con != null) {
				con.close();
			}
			if (prst != null) {
				prst.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	//close connection and empty statement for insert/update/delete/create etc. (no result set)
		public void clearConnection(Connection con, PreparedStatement prst) {
			try {
				if (con != null) {
					con.close();
				}
				if (prst != null) {
					prst.close();
				}
			}
			catch (Exception ex) {
				ex.printStackTrace();
			}
		}
}