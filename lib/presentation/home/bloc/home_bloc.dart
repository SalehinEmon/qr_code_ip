import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  String ipAddress = '';
  String portAddress = "5125";
  List<DropdownMenuItem> networkList = [];
  HomeBloc() : super(HomeInitial()) {
    on<DataLoadEvent>(onDataLoadEvent);
    on<SetIpAddressEvent>(onSetIpAddressEvent);
  }
  onSetIpAddressEvent(SetIpAddressEvent event, emit) {
    ipAddress = event.ipAddress;
    portAddress = event.portAddress;
    emit(DataChangedState());
  }

  onDataLoadEvent(DataLoadEvent event, emit) async {
    emit(DataLoadingState());
    await loadIpData();
    emit(DataLoadFinishState());
  }

  Future<void> loadIpData() async {
    var interfaceList = await NetworkInterface.list();
    for (var item in interfaceList) {
      DropdownMenuItem tempItem = DropdownMenuItem(
        value: item.addresses.first.address,
        child: Text("${item.name} (${item.addresses.first.address})"),
      );
      networkList.add(tempItem);
    }
    if (interfaceList.isNotEmpty) {
      ipAddress = interfaceList.first.addresses.first.address;
    }
  }

  Future<String> getIpAddress() async {
    var interfaceList = await NetworkInterface.list();
    if (interfaceList.isNotEmpty) {
      for (var item in interfaceList) {
        DropdownMenuItem tempItem = DropdownMenuItem(
          value: item.addresses.first.address,
          child: Text(item.name),
        );
        networkList.add(tempItem);
      }
      NetworkInterface firstOne = interfaceList.first;
      ipAddress = firstOne.addresses.first.address;
    }
    // for (var interface in await NetworkInterface.list()) {
    //   print('== Interface: ${interface.name} ==');
    //   for (var addr in interface.addresses) {
    //     print(
    //         '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
    //   }
    // }
    return ipAddress;
  }
}
