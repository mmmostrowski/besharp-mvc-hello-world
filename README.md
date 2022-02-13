# BeSharp MVC Hello World 

## Demo Showcase App for BeSharp Framework 

---
Intention of this project is a feedback about [BeSharp Framework](https://github.com/mmmostrowski/besharp). 

---

### Reasoning
This Hello World App itself isn't particularly useful.

Its purpose is to show BeSharp Framework OOP code layout in action, and to test various OOP patterns, like composition, decoration, events, factories, etc.

Even if MVC pattern is not very natural for Bash, it's giving a good visual feedback about OOP itself.
Rendering GUI is also a CPU resource demanding task, therefore it is a good field for performance research & optimizations.

In a typical Bash-like applications we would rather expect to have classes like `Credentials` or `DockerParamsGenerator`, instead of `WidgetsTree`.      

---

### Quick start

If you have Docker available on your workstation, please run demo showcase app:
```shell
docker run -it --rm --pull always mmmostrowski/besharp-mvc-hello-world
```

The source code for this app can be found in `/app/src/` [folder](https://github.com/mmmostrowski/besharp-mvc-hello-world/tree/main/app/src). 

---
### Develop locally

**Warning: Make sure you have a Docker Engine available on your machine!**

_Note: If you have no Docker installed on your machine, please follow installation instructions from [BeSharp Framework](https://github.com/mmmostrowski/besharp) project page._    


1. Clone project to a local folder. Open it in your favorite IDE.
2. Open BeSharp terminal:
   - **on Linux / MacOs** - please run `./besharp` from the project folder,
   - **on Windows** - please run `besharp.bat` from the project folder.
3. Please run `run` command from the BeSharp terminal. You should have the app working.
4. Please quit the app (e.x. hit `CTRL + C`).
5. In your IDE, please open `AppState.sh` file. Please change line:
```shell
@var isHelloWorldColorsEnabled = false
```
to
```shell
@var isHelloWorldColorsEnabled = true
```
6. In BeSharp terminal, please run `run` again. <br> 
   You should now see a colored _"Hello world !"_ text, by default. <br>
   Please notice how widget data binding mechanism has changed upper right corner checkbox state accordingly.   
7. Please quit app again (e.x. hit `CTRL + C`). Please go back to your IDE, open `HelloWorldWidget.sh` file, and change line:
```shell
@let color = @pixel_modes.randomColor
```
to
```shell
@let color = @pixel_modes.magento
```
8. Please `run` again. You should get an error message, something similar to:
```shell
./app: line 30597: @pixel_modes.magento: command not found
```
It would be hard to debug such an error message. The file `app/dist/single-script/app` is huge!<br>
   
10. Let's now run `develop` command instead of `run` command in the BeSharp terminal.<br>
Now, we can easily read from the given stacktrace, where the error exactly comes from: 
```shell
...
     at: HelloWorldWidget.draw()   /besharp/app/src/View/Widgets/HelloWorldWidget.sh:91 
...
```
11. Ok. Let's fix the bug. Please search for "`@static { @pixel_modes }`" phrase in your IDE.<br>
    `PixelModes.sh` file is where a solution for our bug can be found:
```shell
    @var magenta = "\e[95m"
```
12. Now replace `magento` to `magenta` in the `HelloWorldWidget.sh` file and run `run` again.


<br>
Voilà. You've just made your first development session in BeSharp Framework!

---

BeSharp by Maciej Ostrowski (c) 2022
