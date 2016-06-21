<%@ page language="java" contentType="text/html; charset=ISO-8859-1" import="java.io.*,java.util.*,java.net.*,com.turn.ttorrent.client.*,com.kangan.utils.*"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Test App</title>
</head>
<body>
<form action="process" method="POST" enctype='multipart/form-data' >
<pre>
	<label for="cmd">Select the Torr file: </label>
	<input type="file" name="cmd" id="cmd" size="35" placeholder="Enter torr url Here"/>
	<br/>
	<input type="submit" value="Process"/>
</pre>
<pre>
	<%
	  Object process =  request.getAttribute(TorrConstants.TORR_CMD);
	  if(null != process){//Forwarded after torr file written 
	
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
			    new File(TorrConstants.TORR_FILE_NAME),
			    new File(TorrConstants.TORR_OUT_DIR)));

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
			    finalSess.setAttribute(TorrConstants.PROGRESS_STATUS, "Completed piece: " + progress);
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
			sExcep = TorrConstants.printStackTrace(e);
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