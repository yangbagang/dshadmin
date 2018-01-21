package com.ybg.dsh.wf

import grails.gorm.transactions.Transactional
import groovy.sql.Sql

@Transactional
class WorkFlowService {

    def dataSource

    def updateFlag(Long id, Short flag) {
        def sql = new Sql(dataSource)
        def updateSql = "update work_flow set flag = ? where id = ?"
        sql.execute(updateSql, flag, id)
    }

    def create(String name, String memo, String flowVersion) {
        def sql = new Sql(dataSource)
        def insertSql = "insert into work_flow(version, is_deleted, create_time, name, flow_version, flag, memo)" +
                " values(0, 0, now(), ?, ?, 1, ?)"
        sql.execute(insertSql, name, flowVersion, memo)
    }

}
