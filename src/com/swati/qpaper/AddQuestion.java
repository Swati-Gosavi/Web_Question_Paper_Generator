package com.swati.qpaper;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.swati.dbcon.ConnectDB;
import java.sql.*;


/**
 * Servlet implementation class AddQuestion
 */
public class AddQuestion extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddQuestion() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		
	
		String Que = request.getParameter("Que");
		String sub = request.getParameter("sub");
		String unit = request.getParameter("unit");

		try {
		    Connection con = ConnectDB.connect();

		    //  'keywords_tbl' contains columns keywords and kmarks
		    // We use a LIKE clause to match the keywords in the question
		    String selectKeywordsQuery = "SELECT keywords, kmarks FROM keywords_tbl WHERE ? LIKE CONCAT('%', keywords, '%')";

		    PreparedStatement ps1 = con.prepareStatement(selectKeywordsQuery);
		    ps1.setString(1, Que);

		    ResultSet rs = ps1.executeQuery();

		    int marks = 0;

		    // Loop through the result set to calculate the marks based on keywords found in the question
		    while (rs.next()) {
		        int kmarks = rs.getInt("kmarks");
		        marks += kmarks;
		    }

		    // Now we have the marks, we can use it in insert query
		    PreparedStatement ps2 = con.prepareStatement("INSERT INTO questions_tbl VALUES (?,?,?,?,?)");
		    ps2.setInt(1, 0);
		    ps2.setString(2, Que);
		    ps2.setInt(3,marks); // Use the marks calculated based on keywords
		    ps2.setInt(4, Integer.parseInt(unit));
		    ps2.setString(5, sub);

		    int i = ps2.executeUpdate();
		    if (i == 1) {
		        System.out.println("Questions Added Successfully...");
		        response.sendRedirect("addQue.html");
		    } else {
		        System.err.println("Failed..!!");
		        response.sendRedirect("addQue.html");
		    }
		} catch (Exception e) {
		    e.printStackTrace();
		}
		
	}
}
