package com.ybg.dsh.objectMarshaller

import com.ybg.dsh.wf.FlowDefinition
import grails.converters.JSON
import org.grails.web.converters.exceptions.ConverterException
import org.grails.web.converters.marshaller.ObjectMarshaller
import org.grails.web.json.JSONWriter

import java.text.SimpleDateFormat

class FlowDefinitionObjectMarshaller implements ObjectMarshaller<JSON> {

    def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

    @Override
    boolean supports(Object object) {
        return object instanceof FlowDefinition
    }

    @Override
    void marshalObject(Object object, JSON converter) throws ConverterException {
        JSONWriter writer = converter.getWriter()
        writer.object()
        writer.key('id').value(object.id)
                .key("workFlow").value(object.workFlow.name)
                .key('name').value(object.name)
                .key('memo').value(object.memo)
                .key('createTime').value(sdf?.format(object.createTime))
                .key('prevName').value(object.prevName)
                .key('prevId').value(object.prevId)
                .key('workFlowId').value(object.workFlow.id)
        writer.endObject()
    }

}
