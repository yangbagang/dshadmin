package com.ybg.dsh.objectMarshaller

import com.ybg.dsh.pm.ProjectTask
import grails.converters.JSON
import org.grails.web.converters.exceptions.ConverterException
import org.grails.web.converters.marshaller.ObjectMarshaller
import org.grails.web.json.JSONWriter

import java.text.SimpleDateFormat

class ProjectTaskObjectMarshaller implements ObjectMarshaller<JSON> {

    def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

    @Override
    boolean supports(Object object) {
        return object instanceof ProjectTask
    }

    @Override
    void marshalObject(Object object, JSON converter) throws ConverterException {
        JSONWriter writer = converter.getWriter()
        writer.object()
        writer.key('id').value(object.id)
                .key('taskId').value(object.taskId)
                .key('taskName').value(object.taskName)
                .key("taskVersion").value(object.taskVersion)
                .key("createTime").value(sdf?.format(object.createTime))
                .key("updateTime").value(sdf?.format(object.updateTime))
                .key("status").value(object.status)
                .key("createUser").value(object.createUser.realName)
                .key("updateUser").value(object.updateUser.realName)
                .key('project').value(object.projectFlow.project.name)
                .key('flow').value(object.projectFlow.flowName)
        writer.endObject()
    }
}
