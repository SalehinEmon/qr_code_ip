part of 'home_bloc.dart';

abstract class HomeEvent {}

class DataLoadEvent extends HomeEvent {}

class SetIpAddressEvent extends HomeEvent {
  String ipAddress;
  String portAddress;
  SetIpAddressEvent(this.ipAddress,this.portAddress);
}
