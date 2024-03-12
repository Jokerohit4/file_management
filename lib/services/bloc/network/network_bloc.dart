import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_management/services/bloc/network/network_event.dart';
import 'package:file_management/services/bloc/network/network_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  NetworkBloc(this._connectivity) : super(NetworkInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (ConnectivityResult result) {
        add(NetworkStatusChanged(result));
      },
    );

    on<NetworkStatusChanged>(_onNetworkStatusChanged);
  }

  Future<void> _onNetworkStatusChanged(
      NetworkStatusChanged event,
      Emitter<NetworkState> emit,
      ) async {
    if (event.connectivityResult == ConnectivityResult.none) {
      emit(NetworkOffline());
    } else {
      emit(NetworkOnline());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
