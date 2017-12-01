package com.ybg.dsh.file

class FileInfo {

    static constraints = {
    }

    String title
    String memo
    String type
    String fileName
    String fileId
    Long fileSize
    Short flag = 1 as Short

}
