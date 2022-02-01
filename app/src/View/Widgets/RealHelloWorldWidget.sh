#!/usr/bin/env bash

@class RealHelloWorldWidget @implements Widget WidgetWithSize

    @var @inject CanvasPrinter canvasPrinter

    @var boldFormat = ''

    @var format = ''

    function RealHelloWorldWidget.initialize()
    {
        @let $this.boldFormat = @pixel_modes.bold
    }

    function RealHelloWorldWidget.calculateMinSize()
    {
        local calculator="${1}"

        $calculator.setupSize 46 14
    }

    function RealHelloWorldWidget.widgetWidth()
    {
        @returning 46
    }

    function RealHelloWorldWidget.widgetHeight()
    {
        @returning 14
    }

    function RealHelloWorldWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let canvasPrinter = $this.canvasPrinter
        @let x = $context.x1
        @let y = $context.y1

        @let comment = @pixel_modes.dGray
        @let normal = @pixel_modes.yellow
        @let string = @pixel_modes.green
        @let keyword1 = @pixel_modes.lYellow
        @let keyword2 = @pixel_modes.bold
        local keyword="${keyword1}${keyword2}"

        $canvasPrinter.printFrame $canvas $(( x )) $(( y )) 46 14

        (( x+=3 ))
        (( y+=2 ))

        $canvasPrinter.printText $canvas $(( x )) $(( y )) "#!/usr/bin/env bash" "${comment}"

        $canvasPrinter.printText $canvas $(( x )) $(( y + 2 )) "@class" "${keyword}"
        $canvasPrinter.printText $canvas $(( x + 7 )) $(( y + 2 )) "HelloWorld" "${normal}"
        $canvasPrinter.printText $canvas $(( x + 18 )) $(( y + 2 )) "@implements" "${keyword}"
        $canvasPrinter.printText $canvas $(( x + 30 )) $(( y + 2 )) "Entrypoint" "${normal}"

        $canvasPrinter.printText $canvas $(( x + 4 )) $(( y + 4 )) "function" "${keyword}"
        $canvasPrinter.printText $canvas $(( x + 13 )) $(( y + 4 )) "HelloWorld.main()" "${normal}"

        $canvasPrinter.printText $canvas $(( x + 4 )) $(( y + 5 )) "{" "${normal}"

        $canvasPrinter.printText $canvas $(( x + 8 )) $(( y + 6 )) "echo" "${keyword}"
        $canvasPrinter.printText $canvas $(( x + 13 )) $(( y + 6 )) "\"Hello World!\"" "${string}"

        $canvasPrinter.printText $canvas $(( x + 4 )) $(( y + 7 )) "}" "${normal}"

        $canvasPrinter.printText $canvas $(( x )) $(( y + 9 )) "@classdone" "${keyword}"


    }

@classdone



