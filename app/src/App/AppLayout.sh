#!/usr/bin/env bash

@class AppLayout @extends BaseLayout

    @var initialFocusIndex = 100

    @var LayersWidget layers
    @var Widget settingsInitialWidget
    @var Widget areYouSureQuitInitialWidget
    @var Widget helpDialogInitialWidget

    @var TwoRowsWidget ballsContainerWidget
    @var Widget ballsHandlerWidget

    function AppLayout.prepareRootWidget()
    {
        @let fps = $this.fpsWidget
        @let mainFrame = $this.mainFrame
        @let appSettings = $this.appSettingsDialog
        @let areYouSureQuit = $this.areYouSureQuitDialog
        @let helpDialog = $this.helpDialog

        @let layers = $this.createWidget \
            id: 'main_layers' \
            construct: LayersWidget \
                'main' $mainFrame \
                'are_you_sure_quit' $areYouSureQuit \
                'settings' $appSettings \
                'help' $helpDialog \
                'fps' $fps \
            placement: 0 0 0 0  \
        ;

        @let areYouSureQuitInitialWidget = $this.areYouSureQuitInitialWidget
        $layers.setupInitialFocusWidget 'are_you_sure_quit' $areYouSureQuitInitialWidget

        @let helpDialogInitialWidget = $this.helpDialogInitialWidget
        $layers.setupInitialFocusWidget 'help' $helpDialogInitialWidget

        @let settingsInitialWidget = $this.settingsInitialWidget
        $layers.setupInitialFocusWidget 'settings' $settingsInitialWidget

        $layers.turnOnLayer 'main'
        $layers.turnOnLayer 'fps'
        $layers.turnOffLayer 'are_you_sure_quit'
        $layers.turnOffLayer 'settings'

        $this.layers = $layers

        @returning $layers
    }

    function AppLayout.fpsWidget()
    {
        @returning @of $this.createWidget \
            id: 'fps' \
            construct: FpsWidget \
            placement: 0 0 0 0  \
        ;
    }

    function AppLayout.mainFrame()
    {
        @let tabs = $this.mainTabs

        @let settingsButton = $this.openSettingsButton

        @let frame = $this.createWidget \
            id: 'main_frame' \
            construct: FrameWidget \
                $tabs \
            placement: 1 1 1 1  \
        ;

        @let helpMark = $this.helpMark

        @returning @of $this.createWidget \
            id: 'main_composition' \
            construct: CompositionWidget \
                $frame $settingsButton $helpMark \
            placement: 0 0 0 0 \
        ;
    }

    function AppLayout.mainTabs()
    {
        @let helloWorld = $this.helloWorldTab
        @let realHelloWorld = $this.realHelloWorldTab
        @let balls = $this.ballsTab
        @let fastBalls = $this.fastBallsTab

        @let color = @pixel_modes.lRed
        @let idleWidget = $this.createWidget \
            id: "idle_tab_red" \
            construct: FlatWidget \
                "${color}" \
        ;

        @returning @of $this.createWidget \
            id: 'main_tabs' \
            construct: TabsWidget \
                'MVC Hello World' $helloWorld \
                'Hello World' $realHelloWorld \
                'Performance test' $fastBalls \
                'GUI test' $balls \
                'Idle' $idleWidget \
            placement: 0 0 0 0  \
            focusIndex: 10 \
        ;
    }

    # Real Hello World Tab
    function AppLayout.realHelloWorldTab()
    {
        @returning @of $this.createWidget \
            id: 'real_hello_world' \
            construct: RealHelloWorldWidget \
            placement: auto auto auto auto \
        ;
    }


    # Hello World Tab

    function AppLayout.helloWorldTab()
    {
        @returning @of $this.helloWorldMainRows
    }

    function AppLayout.helloWorldMainRows()
    {
        @let upRow = $this.helloWorldHeader
        @let downRow = $this.helloWorldMainCols

        @returning @of $this.createWidget \
            id: 'hello_world_tab_main_rows' \
            construct: TwoRowsWidget \
                $upRow 9 \
                $downRow auto \
            placement: 0 0 0 0 \
        ;
    }

    function AppLayout.helloWorldMainCols()
    {
        @let leftCol = $this.helloWorldLeftColumn
        @let rightCol = $this.helloWorldWidget

        @returning @of $this.createWidget \
            id: 'hello_world_tab_main_cols' \
            construct: TwoColumnsWidget \
                $leftCol 26 \
                $rightCol auto \
            placement: 0 0 0 0 \
        ;
    }

    function AppLayout.helloWorldLeftColumn()
    {
        @let appState = $this.appState

        @let aboutUs = $this.aboutUsWidget

        @let subjectsList = $this.createWidget \
            id: 'hello_world_tab_subjects' \
            construct: VerticalListWidget \
            bindAppState: \
                list:$appState.subjectsList \
                current:$appState.currentSubjectIdx \
                on_next:$appState.selectNextSubject \
                on_prev:$appState.selectPrevSubject \
            placement: 0 0 0 0 \
            focusIndex: 110 \
        ;

        @let subjectsListGroup = $this.createWidget \
            id: 'hello_world_tab_subjects_group' \
            construct: GroupWidget \
                $subjectsList \
            bindAppState: \
                title:$appState.subjectsListGroupTitle \
            placement: 1 0 1 0 \
        ;

        @returning @of $this.createWidget \
            id: 'hello_world_tab_left_col' \
            construct: TwoRowsWidget \
                $subjectsListGroup auto \
                $aboutUs 8 \
            placement: 0 0 0 0 \
        ;
    }

    function AppLayout.aboutUsWidget()
    {
        @returning @of $this.createWidget \
            id: 'about_us_widget' \
            construct: AboutUsWidget \
            placement: 0 0 0 0 \
        ;
    }

    function AppLayout.helloWorldHeader()
    {
        @let appState = $this.appState

        @let leftCol = $this.greetingsList
        @let rightCol = $this.helloWorldSettings

        @let leftColGroup = $this.createWidget \
            id: 'hello_world_tab_header_left_group' \
            construct: GroupWidget \
                $leftCol \
            bindAppState: \
                title:$appState.greetingsListGroupTitle \
            placement: 1 1 1 1 \
        ;

        @let rightColGroup = $this.createWidget \
            id: 'hello_world_tab_header_right_group' \
            construct: GroupWidget \
                $rightCol \
            bindAppState: \
                title:$appState.helloWorldSettingsTitle \
            placement: 0 1 1 1 \
        ;

        @returning @of $this.createWidget \
            id: 'hello_world_tab_header' \
            construct: TwoColumnsWidget \
                $leftColGroup auto \
                $rightColGroup 28 \
            placement: 0 0 0 0 \
        ;
    }

    function AppLayout.helloWorldSettings()
    {
        @let appState = $this.appState

        @let bold = $this.helloWorldBoldCheckbox
        @let colors = $this.helloWorldColorCheckbox

        @returning @of $this.createWidget \
            id: 'hello_world_settings' \
            construct: CompositionWidget \
                $bold $colors \
            placement: 0 0 0 0 \
        ;
    }

    function AppLayout.helloWorldBoldCheckbox()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'hello_world_settings_bold_checkbox' \
            construct: CheckboxWidget \
            bindAppState: \
                checked:$appState.isHelloWorldBoldEnabled \
                text:$appState.isHelloWorldBoldText \
            placement: 0 0 auto 0  \
            focusIndex: 120 \
        ;
    }

    function AppLayout.helloWorldColorCheckbox()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'hello_world_settings_color_checkbox' \
            construct: CheckboxWidget \
            bindAppState: \
                checked:$appState.isHelloWorldColorsEnabled \
                text:$appState.isHelloWorldColorsText \
            placement: 0 2 auto 0  \
            focusIndex: 130 \
        ;
    }

    function AppLayout.greetingsList()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'hello_world_greetings_list' \
            construct: HorizontalListWidget \
            bindAppState: \
                list:$appState.greetingsList \
                current:$appState.currentGreetingIdx \
                on_next:$appState.selectNextGreeting \
                on_prev:$appState.selectPrevGreeting \
            placement: 0 0 0 0 \
            focusIndex: 100 \
        ;
    }

    function AppLayout.helloWorldWidget()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'hello_world_widget' \
            construct: HelloWorldWidget \
            bindAppState: \
                greeting:$appState.currentGreetingText \
                suffix:$appState.currentGreetingSuffix \
                subject:$appState.currentSubjectText \
                boldEnabled:$appState.isHelloWorldBoldEnabled \
                colorsEnabled:$appState.isHelloWorldColorsEnabled \
            placement: auto auto auto auto \
        ;
    }

    # Fast Balls Tab
    function AppLayout.fastBallsTab()
    {
        @returning @of $this.createWidget \
            id: 'fast_balls_tab_balls' \
            construct: BallsWidget 15 \
            placement: 0 0 0 0 \
        ;
    }

    # Balls Tab
    function AppLayout.ballsTab()
    {
        @let appState = $this.appState
        @let appController = $this.appController

        @let balls = $this.createWidget \
            id: 'balls_tab_balls' \
            construct: BallsWidget 1 \
            placement: 0 0 0 0 \
        ;

        $this.ballsHandlerWidget = $balls

        @let sectionsGroup = $this.ballsTabSectionsGroup
        @let ballsGroup = $this.ballsTabBallsGroup

        @let controlPanel = $this.createWidget \
            id: 'balls_tab_control_panel' \
            construct: CompositionWidget \
                $sectionsGroup \
                $ballsGroup \
            placement: 0 0 0 0 \
        ;

        @let $this.ballsContainerWidget = $this.createWidget \
           id: 'balls_tab_main_frame' \
           construct: TwoRowsWidget \
              $controlPanel 10 \
              $balls auto \
           placement: 0 0 0 0 \
       ;

        @returning @of $this.ballsContainerWidget
    }

    function AppLayout.makeNewHorizontalBallsSection()
    {
        @returning @of $this.makeNewBallsSection TwoRowsWidget
    }

    function AppLayout.makeNewVerticalBallsSection()
    {
        @returning @of $this.makeNewBallsSection TwoColumnsWidget
    }

    function AppLayout.makeNewBallsSection()
    {
        local wrapperWidgetClass="${1}"

        @let currentBalls = $this.ballsHandlerWidget
        @let container = $this.ballsContainerWidget

        @let newBalls = $this.createWidget \
            id: "balls_tab_balls_$(date +%s)_${RANDOM}" \
            construct: BallsWidget 1 \
            placement: 0 0 0 0 \
        ;

        @let wrapper = $this.createWidget \
            id: "balls_tab_balls_wrapper_$(date +%s)_${RANDOM}" \
           construct: ${wrapperWidgetClass} \
              $currentBalls 50% \
              $newBalls auto \
           placement: 0 0 0 0 \
       ;

       $this.ballsHandlerWidget = $wrapper
       $container.replaceDownWidget $wrapper

       @returning $newBalls
    }

    function AppLayout.replaceTopBallsSection()
    {
        local newWrapper="${1}"

        @let container = $this.ballsContainerWidget
        $container.replaceDownWidget $newWrapper

        $this.ballsHandlerWidget = $newWrapper
    }

    function AppLayout.ballsTabBallsGroup()
    {
        @let addOneButton = $this.createWidget \
            id: 'balls_tab_add_one_balls_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.addBallButtonTitle \
                clicked:$appController.addOneBall \
            placement: 0 0 0 0 \
            focusIndex: 230 \
        ;

        @let removeOneButton = $this.createWidget \
            id: 'balls_tab_remove_one_balls_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.removeBallButtonTitle \
                clicked:$appController.removeOneBall \
            placement: 0 2 0 0 \
            focusIndex: 240 \
        ;

        @let removeAllButton = $this.createWidget \
            id: 'balls_tab_remove_all_balls_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.removeAllBallsButtonTitle \
                clicked:$appController.removeAllBalls \
            placement: 0 4 0 0 \
            focusIndex: 250 \
        ;

        @let ballsComposition = $this.createWidget \
            id: 'balls_tab_control_panel_balls_composition' \
            construct: CompositionWidget \
                $addOneButton \
                $removeOneButton \
                $removeAllButton \
            placement: 0 0 0 0 \
        ;

        @returning @of $this.createWidget \
            id: 'balls_tab_control_panel_balls' \
            construct: GroupWidget \
                $ballsComposition \
            bindAppState: \
                title:$appState.ballsGroupTitle \
            placement: 50 1 auto auto \
            placementSize: 10 8 \
        ;
    }

    function AppLayout.ballsTabSectionsGroup()
    {
        @let addHorizontalButton = $this.createWidget \
            id: 'balls_tab_add_horizontal_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.addHorizSectionButtonTitle \
                clicked:$appController.addHorizontalBallsSection \
            placement: 0 0 0 0 \
            focusIndex: 200 \
        ;

        @let addVerticalButton = $this.createWidget \
            id: 'balls_tab_add_vertical_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.addVertSectionButtonTitle \
                clicked:$appController.addVerticalBallsSection \
            placement: 0 2 0 0 \
            focusIndex: 210 \
        ;

        @let removeSectionButton = $this.createWidget \
            id: 'balls_tab_remove_section_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.removeSectionButtonTitle \
                clicked:$appController.removeBallsSection \
            placement: 0 4 0 0 \
            focusIndex: 220 \
        ;

        @let sectionsComposition = $this.createWidget \
            id: 'balls_tab_control_panel_sections_composition' \
            construct: CompositionWidget \
                $addHorizontalButton \
                $addVerticalButton \
                $removeSectionButton \
            placement: 0 0 0 0 \
        ;

        @returning @of $this.createWidget \
            id: 'balls_tab_control_panel_sections' \
            construct: GroupWidget \
                $sectionsComposition \
            bindAppState: \
                title:$appState.sectionsGroupTitle \
            placement: 1 1 auto auto \
            placementSize: 45 8 \
        ;
    }

    # Help
    function AppLayout.helpMark()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'help_dialog_mark' \
            bindAppState: \
                text:$appState.helpMarkText \
                color:$appState.helpMarkTextColor \
            construct: TextWidget \
            placement: 10 0 0 0 \
        ;
    }

    function AppLayout.helpDialog()
    {
        @let closeButton = $this.helpDialogCloseButton
        @let helpText = $this.helpTextWidget

        @let appState = $this.appState
        @let appController = $this.appController

        $this.helpDialogInitialWidget = $closeButton

        @returning @of $this.createWidget \
            id: 'help_dialog' \
            bindAppState: \
                on_escape:$appController.closeHelp \
                title:$appState.helpDialogPopupTitle \
                shadowsEnabled:$appState.isPopupShadowsEnabled \
            construct: PopupFrameWidget \
                $helpText \
                $closeButton \
            placement: auto auto auto auto \
            placementSize: 50 20 \
        ;
    }

    function AppLayout.helpTextWidget()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'help_dialog_text' \
            construct: TextWidget \
            bindAppState: \
                text:$appState.helpDialogText \
                color:$appState.helpDialogColor \
            placement: 2 1 2 1 \
        ;
    }

    function AppLayout.helpDialogCloseButton()
    {
        @let appState = $this.appState
        @let appController = $this.appController

        @returning @of $this.createWidget \
            id: 'help_dialog_close_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.helpDialogCloseButtonTitle \
                clicked:$appController.closeHelp \
            placement: auto auto 2 1  \
            focusIndex: 2001 \
        ;
    }

    # Are You Sure Want Quit ?

    function AppLayout.areYouSureQuitDialog()
    {
        @let yesButton = $this.areYouSureQuitYesButton
        @let noButton = $this.areYouSureQuitNoButton
        @let confirmationText = $this.confirmationTextWidget
        @let appState = $this.appState
        @let appController = $this.appController

        $this.areYouSureQuitInitialWidget = $noButton

        @returning @of $this.createWidget \
            id: 'popup_are_you_sure_quit' \
            bindAppState: \
                on_escape:$appController.closeAreYouSureQuit \
                title:$appState.areYouSureQuitPopupTitle \
                shadowsEnabled:$appState.isPopupShadowsEnabled \
            construct: PopupFrameWidget \
                $confirmationText \
                $yesButton \
                $noButton \
            placement: auto auto auto auto \
            placementSize: 40 9 \
        ;
    }

    function AppLayout.confirmationTextWidget()
    {
        @let appState = $this.appState
        @let appController = $this.appController

        @returning @of $this.createWidget \
            id: 'popup_are_you_sure_quit_confirm_text' \
            construct: TextWidget \
            bindAppState: \
                text:$appState.areYouSureQuitConfirmationText \
                color:$appState.areYouSureQuitConfirmationColor \
            placement: 4 2 4 2  \
        ;
    }

    function AppLayout.areYouSureQuitYesButton()
    {
        @let appState = $this.appState
        @let appController = $this.appController

        @returning @of $this.createWidget \
            id: 'popup_are_you_sure_quit_yes_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.areYouSureQuitYesButtonTitle \
                clicked:$appController.quitApp \
            placement: auto auto 12 1  \
            focusIndex: 1001 \
        ;
    }

    function AppLayout.areYouSureQuitNoButton()
    {
        @let appState = $this.appState
        @let appController = $this.appController

        @returning @of $this.createWidget \
            id: 'popup_are_you_sure_quit_no_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.areYouSureQuitNoButtonTitle \
                clicked:$appController.closeAreYouSureQuit \
            placement: auto auto 1 1  \
            focusIndex: 1002 \
        ;
    }

    # App Settings

    function AppLayout.appSettingsDialog()
    {
        @let closeButton = $this.closeSettingsButton
        @let isAnimationCheckbox = $this.isAnimationCheckbox
        @let isPopupShadowsCheckbox = $this.isPopupShadowsCheckbox
        @let themeNameInput = $this.themeNameInput
        @let appState = $this.appState
        @let appController = $this.appController

        $this.settingsInitialWidget = $isAnimationCheckbox

        @returning @of $this.createWidget \
            id: 'popup_frame_widget' \
            bindAppState: \
                on_escape:$appController.closeAppSettings \
                title:$appState.appSettingPopupTitle \
                shadowsEnabled:$appState.isPopupShadowsEnabled \
            construct: PopupFrameWidget \
                $isAnimationCheckbox \
                $isPopupShadowsCheckbox \
                $themeNameInput \
                $closeButton \
            placement: auto auto auto auto \
            placementSize: 50 13 \
        ;
    }


    function AppLayout.openSettingsButton()
    {
        @let appState = $this.appState
        @let appController = $this.appController

        @returning @of $this.createWidget \
            id: 'main_settings_open_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.openSettingsButtonText \
                clicked:$appController.openAppSettings \
            placement: auto 0 0 auto  \
            focusIndex: 0 \
        ;
    }

    function AppLayout.closeSettingsButton()
    {
        @let appState = $this.appState
        @let appController = $this.appController

        @returning @of $this.createWidget \
            id: 'main_settings_popup_close_button' \
            construct: ButtonWidget \
            bindAppState: \
                text:$appState.closeSettingsButtonText \
                clicked:$appController.closeAppSettings \
            placement: auto auto 1 1  \
            focusIndex: 1 \
        ;
    }

    function AppLayout.themeNameInput()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'main_settings_popup_theme_name_input' \
            construct: InputWidget 20 \
            bindAppState: \
                label:$appState.themeNameLabel \
                text:$appState.themeName \
            placement: 0 5 0 0 \
            focusIndex: 140 \
        ;
    }

    function AppLayout.isAnimationCheckbox()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'main_settings_popup_animation_checkbox' \
            construct: CheckboxWidget \
            bindAppState: \
                checked:$appState.isAnimationEnabled \
                text:$appState.isAnimationText \
            placement: 1 1 auto 1  \
            focusIndex: 40 \
        ;
    }

    function AppLayout.isPopupShadowsCheckbox()
    {
        @let appState = $this.appState

        @returning @of $this.createWidget \
            id: 'main_settings_popup_shadows_checkbox' \
            construct: CheckboxWidget \
            bindAppState: \
                checked:$appState.isPopupShadowsEnabled \
                text:$appState.isPopupShadowsText \
            placement: 1 3 auto 1  \
            focusIndex: 50 \
        ;
    }

@classdone