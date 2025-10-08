part of 'about_bloc.dart';

sealed class AboutState extends Equatable {
  const AboutState();
  
  @override
  List<Object> get props => [];
}

final class AboutInitial extends AboutState {}
