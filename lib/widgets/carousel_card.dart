import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realtime_demo/widgets/carousel_cubit.dart';

class CarouselCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const CarouselCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = context.select(
          (CarouselCubit c) => c.state.selectedCardIndex == index,
    );

    return Container(
      height: 170,
      width: 100,
      decoration: ShapeDecoration(
        color: Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            // we're changing border color based on if the card is selected
            color: Color(0xFFD9D9D9),
            width: 1,
          ),
        ),
        // shadows: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: -2,
        //     // you can animate the radius to make the feeling of cards
        //     // 'coming closer to you' stronger
        //     blurRadius: 16,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Image.asset('assets/images/contest_icon.png',
                                height: 54.0,
                                width: 54.0,
                                fit: BoxFit.cover,
                              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Contest Name',
                       style: GoogleFonts.inter(
                     fontSize: 16,
                         fontWeight: FontWeight.bold,
                         color: Colors.black
                   ),
                     ),
                     Text('Contest Name',
                       style: GoogleFonts.inter(
                     fontSize: 14,
                         fontWeight: FontWeight.w400,
                         color: Colors.black
                   ),
                     ),
                   ],
                 ),
               )
              ],
            ),
          ),
          Icon(icon, color: Colors.white, size: 20),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}