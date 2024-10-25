# ISéneca: Interfaz de usuario que se complementa con el proyecto de TimeTable o Horarios

# Descripción del proyecto

ISéneca es la interfaz de usuario para gestionar las incidencias que cometen los alumnos fácilmente con una interfaz sencilla y amigable, funciona con el proyecto TimeTable que le manda los datos de alumnos, profesores y horarios que la interfaz recoge y muestra para que los profesores puedan gestionar las incidencias fácilmente, está hecho en el framework de flutter y se conecta con firebase para un loggin sencillo para que los profesores accedan fácilmente.

# Instalación de flutter

Instalar y configurar flutter es complicado ya que se necesitan muchos componentes para que el proyecto funcione, lo primero es descargar el [sdk de flutter](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.13.5-stable.zip) (actualmente es la versión 3.19.3). Una vez que se haya descargado creamos una carpeta <b>src</b> a la altura de C:\ o si es un ordenador compartido a la altura del usuario <b>NUNCA</b> a la altura de los archivos del programa ya que es posible que aparezcan errores de compilación a la hora de ejecutar un proyecto de flutter, cuando hayamos creado la carpeta descomprimimos el zip de flutter dentro de src.

Una vez que se haya descomprimido la carpeta en su sitio correspondiente tenemos que acceder a las variables de entorno colocando en el buscador de windows <b>Editar las variables de entorno de esta cuenta</b> buscamos la variable Path y seleccionamos editar, y añadimos esta expresion.

<h3>Si la carpeta está colocada en C:\</h3>

```
C:\src\flutter\bin
```

<h3>Si la carpeta está colocada a la altura del usuario</h3>

```
%USERPROFILE%\src\flutter\bin
```

Para comprobar que flutter se ha instalado aplicamos ```Windows``` + ```R``` y escribimos cmd, cuando se abra el símbolo del sistema escribimos:

```
flutter --version
```

El siguiente paso será instalar el Visual Studio Code instalado que es el editor para programar y arrancar flutter. Para instalarlo, accedemos al [enlace de descarga](https://code.visualstudio.com/download) y seleccionamos el sistema operativo en el que queremos que se instale. Una vez instalado, debemos abrirlo e instalar el plugin de Flutter "Flutter Dart Code". 

Si aparece que el comando no se encuentra hay un error en la configuración de las variables de entorno, si no mostrará un cuadro de texto y la extensión, si está instalado ejecutaremos el siguiente comando que nos ayudará a validar todos los componentes del entorno de desarrollo de Flutter para Windows:

```
flutter doctor
```

Al principio tardará bastante en ejecutarse pero nos mostrará los requisitos para ejecutarlo. Un ejemplo de ello es el siguiente:

```
Doctor summary (to see all details, run flutter doctor -v):
[√] Flutter (Channel stable, 3.19.3, on Microsoft Windows [Versi¢n 10.0.22631.3155], locale es-ES)
[√] Windows Version (Installed version of Windows is version 10 or higher)
[!] Visual Studio - develop Windows apps (Visual Studio Build Tools 2019 16.11.32)
    X The current Visual Studio installation is incomplete.
      Please use Visual Studio Installer to complete the installation or reinstall Visual Studio.
[!] Android Studio (not installed)
[X] Android toolchain - develop for Android devices
    X Unable to locate Android SDK.
      Install Android Studio from: https://developer.android.com/studio/index.html
      On first launch it will assist you in installing the Android SDK components.
      (or visit https://flutter.dev/docs/get-started/install/windows#android-setup for detailed instructions).
      If the Android SDK has been installed to a custom location, please use
      `flutter config --android-sdk` to update to that location.

[√] Chrome - develop for the web
[√] VS Code (version 1.86.2)
[√] Connected device (3 available)
[√] Network resources

! Doctor found issues in 3 categories.
```

El primer error que vemos nos indica que Visual Studio no está instalado correctamente. Ese error es porque nos falta instalar Visual Studio C++. Este es opcional y nos permite ejecutar la app como si fuera una app de escritorio.

El segundo error nos indica que debemos tener Android Studio instalado. Un requisito que necesita Flutter para funcionar es una SDK de Android Studio, lo primero es acceder al [enlace de descarga](https://developer.android.com/studio?hl=es-419) y descargar la última versión de Android Studio. Cuando se instale y accedamos al menú principal de la aplicación, seleccionamos more actions y elegiremos <b>SDK Manager</b>, nos aparecerá un menu con 3 opciones seleccionamos <b>SDK Tools</b> y tenemos que instalar:

<ul>
    <li>Android SDK Command-line Tools (latest)</li>
    <li>Android SDK Platform-Tools</li>
    <li>Google USB Driver</li>
    <li>Android Emulator</li>
    <li>Android Emulator hypervisor driver (installer)</li>
</ul>

Es posible que debido al avance de versiones del IDE algunos sdk vengan instalados por defecto, en ese caso los dejamos instalados.

Al realizar flutter doctor observamos este warning:

```
[!] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    ! Some Android licenses not accepted. To resolve this, run: flutter doctor --android-licenses
```

Para resolver ese warning debemos de ejecutar (aceptando licencias para resolver el warning):

```
flutter doctor --android-licenses
```

El siguiente paso es tener instalado Chrome para que flutter se ejecute en la web

El siguiente paso es acceder a Visual Studio Code e instalamos las siguientes extensiones

<ul>
<li>Flutter</li>
<li>Dart</li>
<li>Pubspec Assist</li>
</ul>

Ahora debemos de configurar Firebase en el proyecto, para ello primero debemos de instalar node, [enlace de descarga](https://nodejs.org/dist/v21.7.1/node-v21.7.1-x64.msi) tenemos que asegurarnos que node se instala en el path si no se instala accedemos a las variables de esta cuenta, seleccionamos Path, seleccionamos editar y añadimos esta sentencia

```
%USERPROFILE%\AppData\Roaming\npm
```

Una vez con node instalado accedemos al símbolo del sistema y ejecutamos el siguiente comando para instalar Firebase:

```
npm install -g firebase
```

Después ejecutamos la siguiente línea que servirá para las herramientas de Firebase:

```
npm install -g firebase-tools
```

Cuando se instale debemos seguir una serie de pasos:

<ol>
    <li>Sobre el proyecto, en el símbolo del sistema, ejecutamos firebase login</li>
    <li>Despues debemos de instalar el CLI con ```dart pub global activate flutterfire_cli``` que servirá para introducir la configuración de Firebase en el proyecto debemos de comprobar que en las variables de entorno esté esta ruta %USERPROFILE%\AppData\Local\Pub\Cache\bin en el path si no se encuentra debemos de añadirla</li>
    <li>Ejecutamos ```flutterfire configure``` y seleccionamos como proyecto principal el primero que nos ofrece y que el proyecto se ejecute en android y en web, moviéndonos con las flechas y seleccionando y deseleccionando con el espacio</li>
    <li>Después ejecutamos en símbolo del sistema ```flutter pub add firebase_core``` que sirve para incluir todas las herramientas de firebase en el proyecto</li>
    <li>Volvemos a realizar ```flutterfire configure``` con las mismas opciones</li>
</ol>

Una vez con todo instalado podemos arrancar el proyecto, siguiendo los siguientes pasos:

<ol>
    <li>Abrir el pubspec.yaml y seleccionar descargar que es un icono de descarga situado en la esquina superior derecha</li>
    <li>Ejecutar ```Ctrl``` + ```Shift``` + ```p``` y escribir Flutter: Select Device y seleccionar Chrome:Web</li>
    <li>Acceder al fichero main.dart situado dentro de la carpeta lib y ejecutarlo o con f5 o seleccionando run en la esquina superior derecha</li>
</ol>

# Créditos

Este proyecto ha sido diseñado por los alumnos de 2 DAM supervisado por el profesor Rafael Delgado Cubillas y Francisco Benitez Chico

- [Rafael Delgado Cubillas](https://www.linkedin.com/in/rafael-delgado-cubilla-7034a247/)

- [Francisco Benítez Chico](https://www.linkedin.com/in/franciscobenitezchico/)
