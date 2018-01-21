package com.ybg.dsh.objectMarshaller

import com.ybg.dsh.wf.WorkTask
import grails.converters.JSON
import org.grails.web.converters.exceptions.ConverterException
import org.grails.web.converters.marshaller.ObjectMarshaller
import org.grails.web.json.JSONWriter

import java.text.SimpleDateFormat

class WorkTaskObjectMarshaller implements ObjectMarshaller<JSON> {

    def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

    @Override
    boolean supports(Object object) {
        return object instanceof WorkTask
    }

    @Override
    void marshalObject(Object object, JSON converter) throws ConverterException {
        JSONWriter writer = converter.getWriter()
        writer.object()
        writer.key('id').value(object.id)
                .key("flowId").value(object.flowDefinition.id)
                .key('flowName').value(object.flowDefinition.name)
                .key('name').value(object.name)
                .key('createTime').value(sdf?.format(object.createTime))
                .key('taskId').value(object.taskId)
                .key('taskType').value(object.taskType)
                .key('marked').value(object.marked)
        writer.endObject()
    }

}
