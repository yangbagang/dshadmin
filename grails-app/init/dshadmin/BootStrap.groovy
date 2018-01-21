package dshadmin

import com.ybg.dsh.objectMarshaller.FlowDefinitionObjectMarshaller
import com.ybg.dsh.objectMarshaller.SystemUserRoleObjectMarshaller
import grails.converters.JSON

class BootStrap {

    def systemUserService

    def init = { servletContext ->
        JSON.registerObjectMarshaller(Date) {
            return it?.format("yyyy-MM-dd HH:mm:ss")
        }
        JSON.registerObjectMarshaller(new SystemUserRoleObjectMarshaller(), 9999)
        systemUserService.initSystemUser()
        JSON.registerObjectMarshaller(new FlowDefinitionObjectMarshaller(), 9999)
    }

    def destroy = {
    }
}
