package com.kangan.utils;

import java.io.PrintWriter;
import java.io.StringWriter;

public class TorrConstants {
	public static final String TORR_FILE_NAME = "some.torrent";
	public static final String TORR_OUT_DIR = ".";
	public static final String TORR_CMD ="process";
	public static final String PROGRESS_STATUS = "PROGRESS_STATUS";
	/**
	 * Prints the stacktrace of the Exception
	 *
	 * @param Exception e, The Exception instance
	 * @return String, The stacktrace
	 */
	public static String printStackTrace(Throwable e)
	{
	    StringWriter sw = new StringWriter();
	    PrintWriter pw = new PrintWriter(sw);
	    e.printStackTrace(pw);
	    return sw.toString();
	}
}
