<%@ page language="java" contentType="text/html; charset=ISO-8859-1" import="java.io.*,java.util.*,java.net.*,com.turn.ttorrent.client.*"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
	static final String CMD_PARAM = "cmd";
	static final String TORR_FILE = "some.torrent";
	static final String TORR_OUT_DIR = ".";
	static final String WGET_EXCPN = "WGET_EXCPN";
	static final String WGET_ERR = "WGET_ERR";
	static final String WGET_OUT = "WGET_OUT";
	static final String WGET_RET = "WGET_RET";
	static final String PROGRESS_STATUS = "PROGRESS_STATUS";
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
	static int downloadTorrFile(String torrUrl, HttpSession sess){
		int retStat = -9999;
		StringBuilder sbErr = new StringBuilder();
		StringBuilder sbOut = new StringBuilder();
		StringBuilder sbExcep = new StringBuilder();
		try{
			Process process = java.lang.Runtime.getRuntime().exec("wget --no-check-certificate -O " + TORR_FILE + " '" + torrUrl + "'");
			retStat = process.waitFor();
			//System.out.printf("Return status: " + retStat);
			 InputStream is = process.getInputStream();
		     InputStreamReader isr = new InputStreamReader(is);
		     BufferedReader br = new BufferedReader(isr);
		     
		     String line;
			// System.out.printf("Output of running [%s] is:\n\n", sCmd);
			 sbOut.append("Output of fetching [").append(torrUrl).append("] is:\n\n");
			 while ((line = br.readLine()) != null) {
		       //System.out.println(line);
		       sbOut.append(line).append('\n');
		     }
			 
			 InputStream es = process.getErrorStream();
		     InputStreamReader esr = new InputStreamReader(es);
		     br = new BufferedReader(esr);
		     
		    // System.out.printf("Error of running [%s] is:\n\n", sCmd);
			 sbErr.append("Error of fetching [").append(torrUrl).append("] is:\n\n");
			 while ((line = br.readLine()) != null) {
		       //System.out.println(line);
		       sbErr.append(line).append('\n');
		     }

		}
		catch(Exception e){
			//e.printStackTrace();
			sbExcep.append(printStackTrace(e));
		}
		finally{
			sess.setAttribute(WGET_ERR, sbErr.toString());
			sess.setAttribute(WGET_OUT, sbOut.toString());
			sess.setAttribute(WGET_EXCPN, sbErr.toString());
			
		}
		return retStat;
	}
%>
<%
	String sCmd =  request.getParameter(CMD_PARAM);
	sCmd = (sCmd == null || sCmd.trim().isEmpty()) ? "" : sCmd.trim();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Test App</title>
</head>
<body>
<form action="starttorr.jsp" method="post">
<pre>
	<label for="cmd">Torr Url: </label>
	<input type="text" name="cmd" id="cmd" size="35" placeholder="Enter torr url Here"/>
	<br/>
	<input type="submit" value="Execute"/>
</pre>
<pre>
	<%if(!sCmd.isEmpty()){ %>
	The URL sent was : <%=sCmd%>
	<%int retStat = downloadTorrFile(sCmd, session);%>
	<br/>WGET Return status : <%=retStat%>
	<br/>WGET Command output : <br/><%=session.getAttribute(WGET_OUT)%>
	<br/>WGET Command error : <br/><%=session.getAttribute(WGET_ERR)%>
	<br/>WGET Command Excpn : <br/><%=session.getAttribute(WGET_EXCPN)%>
	<br/>
	<%
		String sExcep = null;
		try{
			// First, instantiate the Client object.
			Client client = new Client(
			  // This is the interface the client will listen on (you might need something
			  // else than localhost here).
			  InetAddress.getLocalHost(),

			  // Load the torrent from the torrent file and use the given
			  // output directory. Partials downloads are automatically recovered.
			  SharedTorrent.fromFile(
			    new File(TORR_FILE),
			    new File(TORR_OUT_DIR)));

			// You can optionally set download/upload rate limits
			// in kB/second. Setting a limit to 0.0 disables rate
			// limits.
			//client.setMaxDownloadRate(50.0);
			client.setMaxUploadRate(10.0);
			final HttpSession finalSess = session;
			//Set Observer
			client.addObserver(new Observer(){
			  @Override
			  public void update(Observable observable, Object data) {
			    Client client = (Client) observable;
			    float progress = client.getTorrent().getCompletion();
			    // Do something with progress.
			    finalSess.setAttribute(PROGRESS_STATUS, "Completed piece: " + progress);
			  }
			});

			// At this point, can you either call download() to download the torrent and
			// stop immediately after...
			client.download();

			// Or call client.share(...) with a seed time in seconds:
			// client.share(3600);
			// Which would seed the torrent for an hour after the download is complete.

			// Downloading and seeding is done in background threads.
			// To wait for this process to finish, call:
			//client.waitForCompletion();

			// At any time you can call client.stop() to interrupt the download.

		}
		catch(Exception e){
			//e.printStackTrace();
			sExcep = printStackTrace(e);
		}
		if(null != sExcep){
	%>
		Exception occured: <br/><%=sExcep%>	
		<br/>
	<%} else{ %>
			<div style="border-style: double;">
				<iframe src="torrstatus.jsp"></iframe>
			</div>
			
	 <%} %>
  <%} else{ %>
<h1> Test Page</h1>
<%} %>
</pre>
</form>
</body>
</html>