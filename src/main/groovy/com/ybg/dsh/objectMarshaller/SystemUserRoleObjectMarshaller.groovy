package com.ybg.dsh.objectMarshaller

import com.ybg.dsh.sys.SystemUserRole
import grails.converters.JSON
import org.grails.web.converters.exceptions.ConverterException
import org.grails.web.converters.marshaller.ObjectMarshaller
import org.grails.web.json.JSONWriter

/**
 * Created by yangbagang on 16/7/5.
 */
class SystemUserRoleObjectMarshaller implements ObjectMarshaller<JSON> {

    @Override
    boolean supports(Object object) {
        return object instanceof SystemUserRole
    }

    @Override
    void marshalObject(Object object, JSON converter) throws ConverterException {
        JSONWriter writer = converter.getWriter()
        writer.object()
        writer.key('realName').value(object.user.realName)
              .key("roleName").value(object.role.roleName)
              .key('adminId').value(object.user.id)
              .key('roleId').value(object.role.id)
        writer.endObject()
    }
}
