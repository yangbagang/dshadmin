package com.ybg.dsh.objectMarshaller

import com.ybg.dsh.pm.Project
import grails.converters.JSON
import org.grails.web.converters.exceptions.ConverterException
import org.grails.web.converters.marshaller.ObjectMarshaller
import org.grails.web.json.JSONWriter

import java.text.SimpleDateFormat

class ProjectObjectMarshaller implements ObjectMarshaller<JSON> {

    def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

    @Override
    boolean supports(Object object) {
        return object instanceof Project
    }

    @Override
    void marshalObject(Object object, JSON converter) throws ConverterException {
        JSONWriter writer = converter.getWriter()
        writer.object()
        writer.key('id').value(object.id)
                .key('name').value(object.name)
                .key('memo').value(object.memo)
                .key("workFlowId").value(object.workFlowId)
                .key("flowId").value(object.flowId)
                .key("flowName").value(object.flowName)
                .key("flowVersion").value(object.flowVersion)
                .key("taskName").value(object.taskName)
                .key("status").value(object.status)
                .key('createTime').value(sdf?.format(object.createTime))
                .key('updateTime').value(sdf?.format(object.updateTime))
                .key('createUser').value(object.createUser?.realName)
                .key('updateUser').value(object.updateUser?.realName)
        writer.endObject()
    }
}
