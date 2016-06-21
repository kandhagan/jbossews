package com.kangan.servlet;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;

import com.kangan.utils.TorrConstants;

import static com.kangan.utils.TorrConstants.*;

public class AcceptFileServlet extends HttpServlet {

	private static final String TORR_JSP ="starttorrfile.jsp";
	
	
	/**
     * The doPost method that gets called with every request.
     *
     * @param req The HTTP servlet request
     * @param res The HTTP servlet response
     * @exception ServletException Servlet activities while throwing JSP threw exception.
     * @exception IOException IO activities while throwing JSP threw exception.
     */
   	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
   		boolean isXML = true;
   		try{
   			// Create a new file upload handler
	   		ServletFileUpload upload = new ServletFileUpload();
			// Parse the request
	   		FileItemIterator iter = upload.getItemIterator(req);
	   		InputStream torrIS = null;
	   		byte [] torrBA = null;
	   		while (iter.hasNext()) {
	   		    FileItemStream item = iter.next();
	   		    String name = item.getFieldName();
	   		    InputStream stream = item.openStream();
				/*if (item.isFormField()) {
					if("cmd".equals(name))
						sKey = new String(SSOUtils.getBytesFromHex(Streams.asString(stream)));
				}
	   		   	else*/ 
	   		    torrBA = getOutput(stream);
	   		   		
			}
	   		FileOutputStream fos = new FileOutputStream(TORR_FILE_NAME);
	   		fos.write(torrBA);
	   		fos.close();
			
	   		//	Fwd to jsp again
	   		req.setAttribute(TORR_CMD, true);
	   		req.getRequestDispatcher(TORR_JSP).forward(req, res);
	   		
	    }
   		catch(Exception e){
   			OutputStream out = res.getOutputStream();
	        res.setContentType("text/plain");
	        String sOut = TorrConstants.printStackTrace(e);
	        out.write(sOut.getBytes());
	        out.close();
   		}
    }
   	
   	/**
   	 * returns byte array from stream
   	 */
   	private byte [] getOutput(InputStream stream) throws Exception{
   		ByteArrayOutputStream buffer = new ByteArrayOutputStream();

   		int nRead;
   		byte[] data = new byte[16384];
   		while ((nRead = stream.read(data, 0, data.length)) != -1) {
   		  buffer.write(data, 0, nRead);
   		}
   		buffer.flush();
   		return buffer.toByteArray();
   	}

   	
}