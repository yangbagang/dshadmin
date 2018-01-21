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
    Date createTime = new Date()
    Short flag = 1 as Short

}
