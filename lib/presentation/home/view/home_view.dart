import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_ip/presentation/home/bloc/home_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController portAddressCtlr = TextEditingController(text: "5125");
  String ipAddress = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(DataLoadEvent()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          ipAddress = context.read<HomeBloc>().ipAddress;
        },
        builder: (context, state) {
          return Scaffold(
            body: state is DataLoadingState
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Theme.of(context).primaryColor, size: 30),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                          items: context.watch<HomeBloc>().networkList,
                          onChanged: (value) {
                            ipAddress = value;
                            context.read<HomeBloc>().add(
                                  SetIpAddressEvent(
                                      value, portAddressCtlr.text),
                                );
                          },
                          value: context.read<HomeBloc>().ipAddress,
                        ),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: portAddressCtlr,
                          ),
                        ),
                        QrImageView(
                          data: genUrl(context.watch<HomeBloc>().ipAddress,
                              context.watch<HomeBloc>().portAddress),
                          version: QrVersions.auto,
                          size: 150,
                          gapless: false,
                        ),
                        Text(
                          genUrl(context.watch<HomeBloc>().ipAddress,
                              context.watch<HomeBloc>().portAddress),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(SetIpAddressEvent(
                                ipAddress, portAddressCtlr.text));
                          },
                          child: const Text("Generate"),
                        )
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  String genUrl(String ipAddress, String portAddress) {
    if (portAddress.isEmpty) {
      return 'http://$ipAddress/';
    }
    return 'http://$ipAddress:$portAddress/';
  }
}
