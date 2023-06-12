import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CarouselCubit extends Cubit<CarouselState> {
  CarouselCubit()
      : super(
    const CarouselState(selectedCardIndex: 0),
  );

  void selectCard(int cardIndex) {
    emit(CarouselState(selectedCardIndex: cardIndex));
  }
}

@immutable
class CarouselState {
  final int selectedCardIndex;

  const CarouselState({required this.selectedCardIndex});
}