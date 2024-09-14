package cook;

import java.sql.*;

public class DBConn {
	public static final String URL = "jdbc:mysql://localhost:3306/cook";
	public static final String USER = "root";
	public static final String PASSWORD = "1234";
	
	public static Connection conn() throws Exception {
		Class.forName("com.mysql.cj.jdbc.Driver");
		return DriverManager.getConnection(URL, USER, PASSWORD);	
	}
	
	public static void close(ResultSet rs,PreparedStatement psmt,Connection conn) throws Exception {
		if(rs != null) rs.close();
		if(psmt != null) psmt.close();
		if(conn != null) conn.close();
	}
	
	public static void close(PreparedStatement psmt,Connection conn) throws Exception {
		if(psmt != null) psmt.close();
		if(conn != null) conn.close();
	}
}