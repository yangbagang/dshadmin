package com.ybg.dsh.sys


class PagingAndSortInterceptor {

    PagingAndSortInterceptor() {
        match(action: ~/(list*|search*|find*)/)
    }

    boolean before() {
        if (params.length) {
            params.max = params.length
        }
        if (params.start) {
            params.offset = params.start
        }
        if (params."order[0][column]") {
            def sortColumnIndex = params."order[0][column]"
            def sortDir = params."order[0][dir]"

            def sortColumn = params."columns[${sortColumnIndex}][data]"
            params.sort = sortColumn
            params.order = sortDir
        }
        true
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
