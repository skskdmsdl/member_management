package common;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.oreilly.servlet.multipart.FileRenamePolicy;

public class MvcFileRenamePolicy implements FileRenamePolicy {

	/**
	 * 새파일명
	 * 20200626_103210111_123.jpg
	 * 
	 */
	@Override
	public File rename(File oldFile) {
		File newFile = null;
		
		do {
			SimpleDateFormat sdf 
				= new SimpleDateFormat("yyyyMMdd_HHmmssSSS_");
			int rndNum = (int)(Math.random()*1000);
			//확장자
			String oldName = oldFile.getName();
			String ext = "";
			int dotIndex = oldName.lastIndexOf(".");
			if(dotIndex > -1)
				ext = oldName.substring(dotIndex); //.jpg
			
			String newName = sdf.format(new Date()) + rndNum + ext;
			newFile = new File(oldFile.getParent(), newName);
			
		} while(!createNewFile(newFile));
		
		System.out.println("newFile@mvcRenamePolicy = " + newFile);
		
		return newFile;
	}

	/**
	 * 파일이 존재하지 않으면, 파일을 생성하고, true 리턴
	 * 파일이 존재하면, 파일을 생성하지 않고, false 리턴
	 * 
	 * @param f
	 * @return
	 */
	private boolean createNewFile(File f) {
	    try {
	      return f.createNewFile();
	    }
	    catch (IOException ignored) {
	      return false;
	    }
	  }
}
