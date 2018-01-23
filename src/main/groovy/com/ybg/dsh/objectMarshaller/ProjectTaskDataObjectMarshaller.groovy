package com.ybg.dsh.objectMarshaller

import com.ybg.dsh.pm.ProjectTaskData
import grails.converters.JSON
import org.grails.web.converters.exceptions.ConverterException
import org.grails.web.converters.marshaller.ObjectMarshaller
import org.grails.web.json.JSONWriter

import java.text.SimpleDateFormat

class ProjectTaskDataObjectMarshaller implements ObjectMarshaller<JSON> {

    def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

    @Override
    boolean supports(Object object) {
        return object instanceof ProjectTaskData
    }

    @Override
    void marshalObject(Object object, JSON converter) throws ConverterException {
        JSONWriter writer = converter.getWriter()
        writer.object()
        writer.key('id').value(object.id)
                .key('label').value(object.label)
                .key('name').value(object.name)
                .key("type").value(object.type)
                .key("value").value(object.value)
                .key("fileSize").value(object.fileSize)
                .key("fileName").value(object.fileName)
                .key("fileType").value(object.fileType)
                .key("project").value(object.projectTask.projectFlow.project.name)
                .key('task').value(object.projectTask.taskName)
                .key('flow').value(object.projectTask.projectFlow.flowName)
        writer.endObject()
    }

}
