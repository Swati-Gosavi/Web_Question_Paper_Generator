<%@ page import="com.swati.dbcon.*" %>
<%@ page import="java.sql.*" %>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">



<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link href="bootstrap.min.css" rel="stylesheet">
    <!-- Template Stylesheet -->
    <link href="style.css" rel="stylesheet">
    
    
    <style>
    
    

    
    
    .btncentre{
    text-align:center;
    }
    
    
        .ram {
            padding-top: 160px;
        }

        .question-paper {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border: 2px solid black;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            font-family: Arial, sans-serif;
        }

        .question-paper h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 24px;
            color: black;
        }

        .question-paper h3 {
            margin-bottom: 5px;
            font-size: 18px;
            color: black;
        }

        .question-paper h3:last-child {
            text-align: right;
            font-size: 18px;
        }

        .question-paper p {
            margin-bottom: 10px;
        }

        .question-paper .paper-details {
            display: flex; /* Use flexbox to arrange paper details */
            justify-content: space-between; /* Push subject to the left and marks to the right */
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3a3a3a; /* Add a dark line */
        }

        .question-paper .question-container {
            max-height: none; /* Remove max-height */
            padding-top: 20px;
        }

        .question-paper .question-container b {
            display: inline-block;
            width: 20px;
            font-size: 20px;
            font-weight: bold;
            color: #0080ff;
        }

        .question-paper .question-container p {
            margin-left: 30px;
            font-size: 18px;
            color: #3a3a3a;
            flex: 1; 
        }

        .question-paper .question-container .marks {
            font-size: 18px;
            font-weight: bold;
            color: black;
            float: right; /* Move marks to the right */
        }

        .question-paper .question-container .question {
            display: flex; /* Use flexbox to align question items horizontally */
            align-items: center; /* Center items vertically */
        }

        .question-paper .question-container hr {
            margin-top: 15px;
            margin-bottom: 10px;
            border: none;
            height: 1px;
            background-color: #3a3a3a;
        }

        .question-paper .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 18px;
            color: #3a3a3a;
        }
        
         img{
        height:25%;
        width:25%;
        margin-left:40%;
        }
        
        
        
        
     
    /* Existing CSS styles */

    /* Style for the buttons */
    .btn {
    margin: 15px;
        font-size: 16px;
        padding: 10px 20px;
        align:centre;
    }

    /* Style for the download button */
    .btn-medium {
        background-color: #0080ff;
        border-color: #0080ff;
    }

    /* Style for the download button on hover */
    .btn-medium:hover {
        background-color: #0070cc;
        border-color: #0070cc;
    }

    /* Style for the print button */
    .print-button {
        background-color: #0080ff;
        border-color: #0080ff;
    }

    /* Style for the print button on hover */
    .print-button:hover {
        background-color: #0070cc;
        border-color: #0070cc;
    }

    /* Hide the print button when printing */
    @media print {
        .print-button {
            display: none;
        }
    }
</style>
    <title>Exam Question Paper</title>
</head>
<body>

    <%
    String branch = request.getParameter("branch");
    String year = request.getParameter("year");
    String sub = request.getParameter("sub");
    String subcode = request.getParameter("subcode");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    if(sub!=null && date!=null)
    {
    %>
    <div class="question-paper">
    <img src="rcp_logo.jpg" >
    	<h1 align="center" style="color:darkblue;">R.C. PATEL INSTITUTE OF TECHNOLOGY</h1>
        <h2 align="center" style="color:#26D701;">END SEM EXAMINATION</h2>
        <h3 align="center">MAX MARKS:75</h3>
        
         <div class="paper-details">
			<div>
				<h3>Branch: <%=branch%></h3>
				<h3>Time: <%=time%></h3>
				<h3 style="text-align: left;">Date: <%=date%></h3>
			</div>
			<div>
				<h3>Year: <%=year %></h3>
				<h3>Subject: <%=sub%></h3>
				<h3>Subject Code: <%=subcode%></h3>
			</div>
		</div>

        <div class="question-container">
            <%
            Connection con = ConnectDB.connect();
            int total = 75;
            int numUnits = 5;
            int marksPerUnit = (total / numUnits);

            try {
                PreparedStatement ps1 = con.prepareStatement("SELECT Que,marks,unit FROM questions_tbl WHERE sub=? AND unit IN (1,2,3,4,5) ORDER BY unit, marks DESC, RAND()");
                ps1.setString(1,sub);
                ResultSet rs = ps1.executeQuery();
                int Qid = 1;
                int[] marksFromUnit = new int[numUnits + 1];
                int[] marksAddedCount = new int[numUnits + 1];
                int[] marksToAdd = {10,5};
                

                while (Qid<=total && rs.next()) {
                    String Que = rs.getString("Que");
                    int marks = rs.getInt("marks");
                    int unit = rs.getInt("unit");

                    if (marksFromUnit[unit]+ marks <= marksPerUnit && marks == marksToAdd[marksAddedCount[unit]])
                    {
                        marksFromUnit[unit]+= marks;
                        marksAddedCount[unit]=(marksAddedCount[unit] + 1)% 2;
         
            %>
            <div class="question">
          
                <b><%= Qid %></b>
                <p><%= Que %></p>
                <div class="marks"><%= marks %> marks</div>
            </div>
            <hr>
            <%
                	    Qid++;
                    }
                }
                
                rs.beforeFirst();  //Reset the ResultSet pointer
                
                while(rs.next() && Qid <=total)
                {
                	String Que = rs.getString("Que");
                    int marks = rs.getInt("marks");
                    int unit = rs.getInt("unit");
                    
                    //Check if we can add a 5-mark question
                    if(marks==5 && marksFromUnit[unit] + marks<=marksPerUnit)
                    {
                    	marksFromUnit[unit]+= marks;
                    %>
              
				            <div class="question">
				                <b><%= Qid %></b>
				                <p><%= Que %></p>
				                <div class="marks"><%= marks %> marks</div>
				            </div>
				            <hr>
				     <%
                	    Qid++;
                     }
                }
                
            } catch (Exception e)
            {
                e.printStackTrace();
            }
        %>
        </div>

        <div class="footer">
           
         <small><i><p>All the Best!</p></i> </small>  
        </div>
    </div>

    <% } %>
   
<!-- Add the print button -->
<center>
<button class="btn btn-primary btn-medium print-button" onclick="window.print()">Print</button>
<button class="btn btn-primary btn-medium print-button"><a href="login.html">Logout</a></button>
<button class="btn btn-primary btn-medium print-button"><a href="index.html">Home</a></button>
</center>
   </div>
   
</body>
</html>




