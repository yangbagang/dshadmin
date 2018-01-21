package dshadmin

import com.ybg.dsh.objectMarshaller.FlowDefinitionObjectMarshaller
import com.ybg.dsh.objectMarshaller.SystemUserRoleObjectMarshaller
import com.ybg.dsh.objectMarshaller.TaskAssignObjectMarshaller
import com.ybg.dsh.objectMarshaller.WorkTaskObjectMarshaller
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
        JSON.registerObjectMarshaller(new WorkTaskObjectMarshaller(), 9999)
        JSON.registerObjectMarshaller(new TaskAssignObjectMarshaller(), 9999)
    }

    def destroy = {
    }
}
