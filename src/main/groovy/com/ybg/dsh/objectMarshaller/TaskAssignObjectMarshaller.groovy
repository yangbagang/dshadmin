package com.ybg.dsh.objectMarshaller

import com.ybg.dsh.wf.TaskAssign
import grails.converters.JSON
import org.grails.web.converters.exceptions.ConverterException
import org.grails.web.converters.marshaller.ObjectMarshaller
import org.grails.web.json.JSONWriter

import java.text.SimpleDateFormat

class TaskAssignObjectMarshaller implements ObjectMarshaller<JSON> {

    def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

    @Override
    boolean supports(Object object) {
        return object instanceof TaskAssign
    }

    @Override
    void marshalObject(Object object, JSON converter) throws ConverterException {
        JSONWriter writer = converter.getWriter()
        writer.object()
        writer.key('id').value(object.id)
                .key("taskId").value(object.workTask.id)
                .key('taskName').value(object.workTask.name)
                .key("userId").value(object.systemUser.id)
                .key('userName').value(object.systemUser.realName)
                .key('flag').value(object.flag)
                .key('createTime').value(sdf?.format(object.createTime))
        writer.endObject()
    }

}
