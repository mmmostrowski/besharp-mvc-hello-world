#!/usr/bin/env bash

@class AppState

    function AppState()
    {
        @let greetings = $this.greetings
        $greetings.addGreetings\
            "Hello" "!" \
            "Hey" "!" \
            "Hi" "!" \
            "Aloha" "!" \
            "Hola" "!" \
            "Howdy" ":)" \
            "What's up" "?" \
            "Have a good day" "!" \
            "Supp" "?" \
            "How are you doing" "?" \
            "Greetings" "!" \
            "Long time no see" "!" \
            "Morning" "!" \
            "Nice to see you" "!" \
        ;

        @let subjects = $this.subjects
        $subjects.addSubjects \
            "World" \
            "Universe" \
            "Y'all" \
            "Everybody" \
            "Programmers" \
            "People" \
            "Boy" \
            "Girl" \
            "Kid" \
        ;
    }

    # Greetings

    @var @inject GreetingsList greetings
    @var currentGreetingIdx = 0
    @var greetingsListGroupTitle = 'Greetings'
    @var helloWorldSettingsTitle = 'Display settings'

    function AppState.currentGreetingText()
    {
        @let greetings = $this.greetings
        @let currentGreetingIdx = $this.currentGreetingIdx

        @returning @of $greetings.greeting "${currentGreetingIdx}"
    }

    function AppState.greetingsList()
    {
        @let greetings = $this.greetings

        @returning @of $greetings.greetingsWithSuffixes
    }

    function AppState.currentGreetingSuffix()
    {
        @let greetings = $this.greetings
        @let currentGreetingIdx = $this.currentGreetingIdx

        @returning @of $greetings.suffix "${currentGreetingIdx}"
    }

    function AppState.selectNextGreeting()
    {
        @let greetings = $this.greetings
        @let greetingNum = $greetings.size
        @let idx = $this.currentGreetingIdx

        if (( ++idx >= greetingNum )); then
            idx=$(( greetingNum - 1 ))
        fi

        $this.currentGreetingIdx = "${idx}"
    }

    function AppState.selectPrevGreeting()
    {
        @let idx = $this.currentGreetingIdx

        if (( --idx < 0 )); then
            idx=0
        fi

        $this.currentGreetingIdx = "${idx}"
    }

    # Subjects

    @var @inject SubjectsList subjects
    @var currentSubjectIdx = 0
    @var subjectsListGroupTitle = 'Subjects'

    function AppState.currentSubjectText()
    {
        @let subjects = $this.subjects
        @let currentSubjectIdx = $this.currentSubjectIdx

        @returning @of $subjects.subject "${currentSubjectIdx}"
    }

    function AppState.subjectsList()
    {
        @let subjects = $this.subjects

        @returning @of $subjects.subjects
    }

    function AppState.selectNextSubject()
    {
        @let subjects = $this.subjects
        @let subjectNum = $subjects.size
        @let idx = $this.currentSubjectIdx

        if (( ++idx >= subjectNum )); then
            idx="$(( subjectNum - 1 ))"
        fi

        $this.currentSubjectIdx = "${idx}"
    }

    function AppState.selectPrevSubject()
    {
        @let idx = $this.currentSubjectIdx

        if (( --idx < 0 )); then
            idx=0
        fi

        $this.currentSubjectIdx = "${idx}"
    }

    # Balls
    @var sectionsGroupTitle = "Sections"
    @var ballsGroupTitle = "Balls"
    @var addHorizSectionButtonTitle = "add horizontal"
    @var addVertSectionButtonTitle = "add vertical"
    @var removeSectionButtonTitle = "remove top"
    @var addBallButtonTitle = 'add one'
    @var removeBallButtonTitle = 'remove one'
    @var removeAllBallsButtonTitle = 'remove all'

    # Help Dialog
    @var helpMarkText = '~ press F1 for help ~'
    @var helpMarkTextColor = dim
    @var helpDialogPopupTitle = 'Help'
    @var helpDialogCloseButtonTitle = 'close'
    @var helpDialogText = "$(
        echo 'Keyboard control:'
        echo ''
        echo '   - TAB            - next widget'
        echo ''
        echo '   - SHIFT+TAB      - previous widget'
        echo ''
        echo '   - ARROWS         - scroll'
        echo ''
        echo '   - SPACE, ENTER   - action'
        echo ''
        echo '   - ESC            - escape'
        echo ''
        echo '   - F1             - this help'
    )"

    # Are You Sure Quit ?
    @var areYouSureQuitPopupTitle = 'Are you sure?'
    @var areYouSureQuitConfirmationText = 'Are you sure you want to quit?'
    @var areYouSureQuitYesButtonTitle = 'yes'
    @var areYouSureQuitNoButtonTitle = 'no'

    # App Settings
    @var openSettingsButtonText = "Settings"
    @var closeSettingsButtonText = "close"

    @var appSettingPopupTitle = 'App settings'

    @var isAnimationEnabled = true
    @var isAnimationText = 'animation enabled'

    @var isPopupShadowsEnabled = true
    @var isPopupShadowsText = 'popup shadows enabled'

    @var themeNameLabel = 'Theme name'
    @var themeName = 'Purple Rain'

    # Hello World Settings
    @var isHelloWorldBoldEnabled = true
    @var isHelloWorldBoldText = 'bold'

    @var isHelloWorldColorsEnabled = false
    @var isHelloWorldColorsText = 'colored'

@classdone