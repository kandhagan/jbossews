package jbossews;

import java.io.File;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.commons.io.FileUtils;

public class Main {
	
	static{
		// Create a trust manager that does not validate certificate chains
	    TrustManager[] trustAllCerts = new TrustManager[]{
	        new X509TrustManager() {
	            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
	                return null;
	            }
	            public void checkClientTrusted(
	                java.security.cert.X509Certificate[] certs, String authType) {
	            }
	            public void checkServerTrusted(
	                java.security.cert.X509Certificate[] certs, String authType) {
	            }
	        }
	    };

	    // Install the all-trusting trust manager
	    try {
	        SSLContext sc = SSLContext.getInstance("SSL");
	        sc.init(null, trustAllCerts, new java.security.SecureRandom());
	        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
	    } catch (Exception e) {
	    }
	}
public static void main(String[] args) {
	try {
		FileUtils.copyURLToFile(new URL("https://torcache.net/torrent/DCD34ABFF04562614C4B8D353BF60B296B15423F.torrent?title=[kat.cr]last.minute.survival.secrets.128.ingenious.tips.to.endure.the.coming.apocalypse.and.other.minor.inconveniences.2014.pdf.gooner"), new File("some.torr"));
	} catch (Exception e) {
		e.printStackTrace();
	}
}
}
