#!/usr/bin/env bash

@class SubjectsList

    @var Vector list

    function SubjectsList()
    {
        @let $this.list = @vectors.make "${@}"
    }

    function SubjectsList.addSubjects()
    {
        @let list = $this.list
        $list.addMany "${@}"
    }

    function SubjectsList.addSubject()
    {
        local subject="${1}"

        @let list = $this.list
        $list.add "${subject}"
    }

    function SubjectsList.size()
    {
        @let list = $this.list

        @returning @of $list.size
    }

    function SubjectsList.subject()
    {
        local idx="${1}"

        @let list = $this.list
        @returning @of $list.get "${idx}"
    }

    function SubjectsList.subjects()
    {
        @returning @of $this.list
    }

@classdone