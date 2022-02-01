#!/usr/bin/env bash

@class GreetingsList

    @var Vector greetings
    @var Vector suffixes
    @var Vector greetingsWithSuffixes

    function GreetingsList()
    {
        @let $this.greetings = @vectors.make "${@}"
        @let $this.suffixes = @vectors.make "${@}"
        @let $this.greetingsWithSuffixes = @vectors.make "${@}"
    }

    function GreetingsList.addGreetings()
    {
        local even=true
        local item
        local greeting
        for item in "${@}"; do
            if $even; then
                even=false
                greeting="${item}"
            else
                even=true
                $this.addGreeting "${greeting}" "${item}"
            fi
        done
    }

    function GreetingsList.addGreeting()
    {
        local greeting="${1}"
        local suffix="${2}"

        @let greetings = $this.greetings
        $greetings.add "${greeting}"

        @let suffixes = $this.suffixes
        $suffixes.add "${suffix}"

        @let greetingsWithSuffixes = $this.greetingsWithSuffixes
        $greetingsWithSuffixes.add "${greeting}${suffix}"
    }

    function GreetingsList.size()
    {
        @let greetings = $this.greetings

        @returning @of $greetings.size
    }

    function GreetingsList.greeting()
    {
        local idx="${1}"

        @let greetings = $this.greetings
        @returning @of $greetings.get "${idx}"
    }

    function GreetingsList.suffix()
    {
        local idx="${1}"

        @let suffixes = $this.suffixes
        @returning @of $suffixes.get "${idx}"
    }

    function GreetingsList.greetingWithSuffix()
    {
        local idx="${1}"

        @let greetingsWithSuffixes = $this.greetingsWithSuffixes
        @returning @of $greetingsWithSuffixes.get "${idx}"
    }

@classdone