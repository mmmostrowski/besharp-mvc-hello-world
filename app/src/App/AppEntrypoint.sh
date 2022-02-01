#!/usr/bin/env bash

@class AppEntrypoint @implements Entrypoint

    @var @inject AppControllerFactory appFactory

    function AppEntrypoint.main()
    {
        @let appFactory = $this.appFactory

        @let app = $appFactory.create

        $app.initialize

        $app.run
    }

@classdone