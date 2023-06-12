import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_demo/widgets/carousel_card.dart';

import 'carousel_cubit.dart';

class CarouselTest extends StatelessWidget {
  const CarouselTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (_) => CarouselCubit(),
      child: const CarouselCards(),
    );
  }
}

class CarouselCards extends StatefulWidget {
  const CarouselCards({Key? key}) : super(key: key);

  @override
  State<CarouselCards> createState() => _CarouselCardsState();
}

class _CarouselCardsState extends State<CarouselCards> {
  final _carouselController = PageController(viewportFraction: 0.6);

  @override
  void initState() {
    super.initState();
    final carouselCubit = context.read<CarouselCubit>();
    _carouselController.addListener(() {
      final page = _carouselController.page?.round();
      if (page == null) return;
      if (carouselCubit.state.selectedCardIndex != page) {
        carouselCubit.selectCard(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                ExpandablePageView.builder(
                  controller: _carouselController,
                  // allows our shadow to be displayed outside of widget bounds
                  clipBehavior: Clip.none,
                  itemCount: 3,
                  itemBuilder: (_, index) {
                    if (!_carouselController.position.haveDimensions) {
                      return const SizedBox();
                    }

                    return AnimatedBuilder(
                      animation: _carouselController,
                      builder: (_, __) => Transform.scale(
                        scale: min(
                          1,
                          (3 - (_carouselController.page! - index).abs() / 2),
                        ),
                        child: CarouselCard(
                          icon: Icons.bolt_outlined,
                          label: '$index',
                          index: index,
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      );
  }
}