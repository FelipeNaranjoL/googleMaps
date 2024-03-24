import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_me/app/data/providers/local/geolocator_wrapper.dart';
import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/helpers/current_position.dart';
import 'package:found_me/app/ui/pages/home/controller/home_state.dart';
import 'package:found_me/app/ui/pages/home/widgets/custom_markers.dart';
import 'package:found_me/app/utils/fit_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class HomeController extends ChangeNotifier {
  //exportacion del home_state.dart para poder trabajar con las variables creadas dentro del archivo
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

//variable de escuchar eventos dentro de la app, en este caso son las de escuchar las llamadas del gps
//y el otro de escuchar la posicion del usuario
  StreamSubscription? _gpsSubscription, _positionSubscription;
// varibale encargada de controlar los cambios del mapa
  GoogleMapController? _mapController;
  //hace referencia al doc GeolocatorWrapper.dart para usar sus metodos
  final GeolocatorWrapper _geolocator;

//funcion encargada de ejecutar _init y _geolocator
  HomeController(this._geolocator) {
    _init();
  }

  Future<void> _init() async {
    //se revisa si el gps esta habilitado o no gracias al metodo de isLocationServiceEnabled de _geolocator
    final gpsEnabled = await _geolocator.isLocationServiceEnabled;
    // en state, se pasa el valor actual de gpsEnabled, modificando gpsEnabled del home_state
    _state = state.copyWith(gpsEnabled: gpsEnabled);
    //el metodo onServiceEnabled escucha si el usuario activa el servicio de GPS
    _gpsSubscription = _geolocator.onServiceEnabled.listen(
      (enabled) {
        //en caso de que gpsEnabled sea true, se modificara este valor con el de home_state, quedando como
        //true y se manda a notificar
        _state = state.copyWith(gpsEnabled: enabled);
        notifyListeners();
      },
    );
    _initLocationUpdates();
  }

  //funcion encargada de dar las actualizaciones de la posicion inicial del usuario en caso de que prenda o apague el gps
  Future<void> _initLocationUpdates() async {
    //variable que deja en claro si se tiene la ubicacion actual o no
    bool initialized = false;
    //el metodo onLocationUpdates se encarga de actualizar y escuchar los cambios de
    //posicion del gps
    _positionSubscription = _geolocator.onLocationUpdates.listen(
      (position) {
        //en caso de que sea falsa, se mandara el parametro de position para establecer una posicion
        //inicial en la funcion _setInitialPosition, el initialized ya que se obtuvo la ubicacion y se manda
        //a notificar a la app
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
        //enlacamos el archivo de current.position, ya que es un singleton y ocupamos su metodo setValue para almacenar los datos
        // lat y lng de mi posicion actual
        CurrentPosition.i.setValue(
          LatLng(position.latitude, position.longitude),
        );
      },
    );
  }

//funcion encargada de dar la posicion actual del usuario
  void _setInitialPosition(Position position) {
    // si el gps esta habilitado y la _initialPosition es nula, se le asignara una posicion gracias
    //a que se guardo una variable para almacenar la ubicacion del usuario
    if (state.gpsEnabled && state.initialPosition == null) {
      _state = state.copyWith(
        initialPosition: LatLng(position.latitude, position.longitude),
        loading: false,
      );
      // print('posicion inicial $initialPosition');
    }
  }

//funcion de generar un mapa
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

//esta funcion define el origen y destino que haya seleccionado el usuario
  void setOriginAndDestination(Place origin, Place destination) async {
    //esto es esto
    //final copy = Map<MarkerId, Marker>.from(_state.markers);
    //pero mas resumido
    final copy = {..._state.markers};
    //se generan los id de los marcadores de manera personalizada
    const originId = MarkerId('origin');
    const destinationId = MarkerId('destination');
    //variables que mostrara el icono dependiendo si es origin o destination
    //si es origen, mostrara el icono de gps, si es destino, mostrara el tiempo de llegada estimada
    final originIcon = await _placeToMarker(origin, null);
    final destinationIcon = await _placeToMarker(destination, 30);

    //dentro de los marcadores, se asignara el id, su posicion y su nombre flotante
    //segun la informacion de su origen/destino
    final originMarker = Marker(
      markerId: originId,
      position: origin.position,
      icon: originIcon,
    );
    final destinationMarker = Marker(
      markerId: destinationId,
      position: destination.position,
      icon: destinationIcon,
    );
    //se asigna el id dentro de la lista de originMarker/destinationMarker
    copy[originId] = originMarker;
    copy[destinationId] = destinationMarker;
    //se envia los datos asignados en el buscador al metodo copyWith
    //reemplazando los valores de ese metodo con los asignados en este archivo
    _state = _state.copyWith(
      origin: origin,
      destination: destination,
      markers: copy,
    );
    //se le indica a _mapController que anime la camara para visualizar el origen y destino
    //que el usuario haya designado y se notifica a la app
    await _mapController?.animateCamera(
      fitMap(
        origin.position,
        destination.position,
        padding: 120,
      ),
    );
    notifyListeners();
  }

//funcion encargada de redirigir al usuario a las configuraciones de gps para habilitarlo
  Future<void> turnOnGps() => _geolocator.openAppSettings();

// metodo que hace zoom al mapa
  Future<void> zoomIn() => _zoom(true);

  //metodo que quita zoom al mapa
  Future<void> zoomOut() => _zoom(false);

//funcionamiento del zoom
//mientras _mapController sea distinto de nulo, se creara una variable zoom que controlara el nivel de
//del mapa, si zoomIn es falso, se reducira el valor de zoom, llegando como limite a 0,
// caso contrario, aumentara en 1
  Future<void> _zoom(bool zoomIn) async {
    if (_mapController != null) {
      double zoom = await _mapController!.getZoomLevel();
      if (!zoomIn) {
        if (zoom - 1 <= 0) {
          return;
        }
      }
      zoom = zoomIn ? zoom + 1 : zoom - 1;
      //luego se obtiene la parte visible del mapa para calcular el centro entre la esquina superior derecha
      //y la esquina inferior izquierda
      final bounds = await _mapController!.getVisibleRegion();
      final northeast = bounds.northeast;
      final southwest = bounds.southwest;
      final center = LatLng((northeast.latitude + southwest.latitude) / 2,
          (northeast.longitude + southwest.longitude) / 2);
      //se obtiene ese dato y se actualiza la camara para realizar la peticion de zoom que el usuario requiera
      final cameraUpdate = CameraUpdate.newLatLngZoom(center, zoom);
      await _mapController!.animateCamera(cameraUpdate);
    }
  }

//funcion que mostrara la duracion en tiempo entre 2 puntos
  Future<BitmapDescriptor> _placeToMarker(Place place, int? duration) async {
    //se crean las variables que almacenaran el tamaño, texto, e imagen?
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    const size = ui.Size(350, 120);
    final customMarker = MyCustomMarker(
      label: place.title,
      duration: duration,
    );
    //llamamos al metodo paint para subir mi canvas y el tamaño del mismo
    customMarker.paint(canvas, size);
    //variable que almacenara el canvas ya dibujado
    final picture = recorder.endRecording();
    //y definimos sus dimensiones en esta variable
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    //convertira el canvas a formato png
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    //almacenamos por ultima vez en este formato para que BitmapDescriptor lo pueda leer
    final bytes = byteData!.buffer.asUint8List();
    //y lo retornamos para poder verlo en la vista
    return BitmapDescriptor.fromBytes(bytes);
  }

//esta funcion, libera las acciones realizadas por el usuario una vez cierre la app
  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    super.dispose();
  }
}
