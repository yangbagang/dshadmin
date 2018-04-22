package com.ybg.dsh.sys

import grails.test.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class BackupRecorderServiceSpec extends Specification {

    BackupRecorderService backupRecorderService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new BackupRecorder(...).save(flush: true, failOnError: true)
        //new BackupRecorder(...).save(flush: true, failOnError: true)
        //BackupRecorder backupRecorder = new BackupRecorder(...).save(flush: true, failOnError: true)
        //new BackupRecorder(...).save(flush: true, failOnError: true)
        //new BackupRecorder(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //backupRecorder.id
    }

    void "test get"() {
        setupData()

        expect:
        backupRecorderService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<BackupRecorder> backupRecorderList = backupRecorderService.list(max: 2, offset: 2)

        then:
        backupRecorderList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        backupRecorderService.count() == 5
    }

    void "test delete"() {
        Long backupRecorderId = setupData()

        expect:
        backupRecorderService.count() == 5

        when:
        backupRecorderService.delete(backupRecorderId)
        sessionFactory.currentSession.flush()

        then:
        backupRecorderService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        BackupRecorder backupRecorder = new BackupRecorder()
        backupRecorderService.save(backupRecorder)

        then:
        backupRecorder.id != null
    }
}
