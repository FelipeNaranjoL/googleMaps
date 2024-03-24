# found_me

1- instalaccion

    1.1 configuracion y soporte para android: Es importante modificar el valor de aplicationId a este valor "com.example.found_me",  esto con el fin de que la key de google maps no de problemas ya que esa key solo funcionara con este aplicationId, la ubicacion del archivo a modificar esta en
    android>app>build.grandle
    tambien, dentro de este archivo, debes modificar el minSdkVersion y el targetSdkVersion con los valores de 21 y 31 respectivamente, dejando en claro desde que version de android puede soportar nuestra app, en este caso, la 5.0 o superior

    1.2 permiso de internet: agregar esta linea 
    <uses-permission android:name="android.permission.INTERNET"/>
    a android>app>src>main>AndroidManifest.xml
    con el fin de otorgar permisos de internet automaticamente al producto final

    1.3 dependencias: instala las siguientes dependencias para el correcto funcionamiento de la app
    cupertino_icons: ^1.0.6
    google_maps_flutter: ^2.0.6
    permission_handler: ^8.1.1
    geolocator: ^7.1.1
    provider: ^5.0.0
    esto lo ubicas dentro del archivo pubspec.yaml, debajo de dependencies

    1.4 imagenes: esta app usa de una imagen como marcador del usuario, para el correcto funcionamiento de la app, debes ir a pubspec.yaml y descomentar el codigo de assets y agregar la ubicacion de la imagen a ocupar o una nueva en caso de ser necesario o solicitado por el cliente, usa la misma nomenclatura con la imagen ya añadida para no perderte.

    1.5 version de lengiajes entre otros

2-api key

    2.1 api key de google maps
        2.1.1 generacion de proyecto y habilitar mapa para dispositivos: debes ingresar con una cuenta a google cloud platform, creas un nuevo proyecto,en este caso, el proyecto lo denomine "TestMaps", una vez creado el proyecto, te diriges a "apis y servicios", luego a "bibleoteca de apis" y habilitas maps sdk para android y ios, con el fin de que la clave pueda trabajar con estos dispositivos sin ningun problema

        2.1.2 credenciales: una vez habilitadas ambas bivleotecas, te diriges a "credenciales" de la misma pestaña de apis y servicios. una vez dentro, generas 2 apis key, una para android y otra para ios
        ojo, esta api key por si sola no funciona, es importante haber realizado el paso 1.1, relacionado a aplicationid, ya que la api key tendra la restriccion de solo funcionar bajo este proyecto android, no para otros. esto se realiza marcando la casilla de apps para android y luego agregando restricciones de android, en el nombre del paquete agregas
        com.example.found_me
        y en huella digital, ejecutas este comando en cmd o en una terminal como administrador 
        keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
        y copias el "sha1"completo y lo pegas, asi te aseguras de que la api funcionara correctamente durante el desarrollo

        2.1.3 insertar api key dentro de la app: te diriges a android>app>src>main>AndroidManifest.xml y pegas esta linea de codigo debajo de la etiqueta application
        <meta-data android:name="com.google.android.geo.API_KEY" android:value="Your key here"/>
        y en "your key here" ingresas la credencial de android que generaste.
        en ios aun no se genero esta key, eso dependera del cliente.
    2.2 api key de apihere 
    PENDIENTE LA DOCUMENTACION


3- estructura

    3.1 contenedores: dentro de lib>app>iu se ubicara pages y routes
    la primera se encarga de crear tanto la vista de la app dentro de carpetas y la otra tiene como fin redirigirlas en caso de que se genere algun cambio o el usuario desee ver las secciones de "favoritos" y "configuraciones"

    3.2 pages:  son los componentes visuales, que estan divididas en carpetas para evitar confusion para futuros programadores, las mas relevantes son home y mapa
    home siendo el controlador para poder navegar a las otras secciones de la app y mapa siendo el corazon de la aplicacion, la cual permite ver la ubicacion del usuario y dejarlo interactuar.

    3.3 routes: esta carpeta contiene el nombre de las rutas, con el fin de redirigir de manera mas rapida al usuario

3.4 PENDIENTE LA DOCUMENTACION


4- diseño (modificar)
RequestPermission para solicitud de "permitir utilizar GPS"
main para la barra superior y cambiar colores de la app a una verde y agregar una imagen
RequestPermission mejorar el apartado visual de la ultimas lineas y tambien la peticion de dar permisos de ubicacion, ubicadas en initState
google_map mejorar el diseño de peticion de encendido de gps
<!-- mapa para mejorar el mensaje de solicitud de GPS -->




5- enlaces para documentacion y otras peticiones de api
PENDIENTE
autosuggest: https://www.here.com/docs/bundle/geocoding-and-search-api-v7-api-reference/page/index.html#/paths/~1autosuggest/get

OJO, PARA LOS CAMBIOS PARA IOS, DEBES VER
*CLASE 1
*CLASE 10

POR SI EL CLIENTE QUIERE CAMBIAR EL ESTILO DEL MAPA
CLASE 4

*linea 21 de home_page.dart, el appbar esta comentado, en un futuro usalo por si quieres
agregar diseño
* en circle_marker.dart y custom_marker puedes modificar la ubicacion y el tamaño de los circulos y rectangulos que se ven en el mapa una
vez seleccionas la ubicacion origin y destination