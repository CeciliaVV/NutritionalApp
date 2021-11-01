import 'package:flutter/material.dart';
import 'package:nutritionalapp/bloc/food_cubit.dart';
import 'package:nutritionalapp/models/foodlist.dart';
import 'package:nutritionalapp/repository/api.dart';
import 'package:nutritionalapp/ui.dart/detail_food_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutritionalapp/ui.dart/food_search.dart';

class ListFoodScreen extends StatelessWidget {
  final List<Food> foods;

  const ListFoodScreen(this.foods, {Key? key}) : super(key: key);

  getListFoodScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            alignment: AlignmentDirectional.bottomEnd,
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: SizedBox(
            height: 120,
            width: 120,
            child: Image.network(
                "https://spoonacular.com/cdn/ingredients_250x250/${foods[index].image}"),
          ),
          title: Text(
            "${index + 1}. ${foods[index].name}",
            style: const TextStyle(color: Colors.green),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailFoodScreen(foods[index]),
              ),
            );
          },
        ),
        separatorBuilder: (context, index) => Divider(
          color: Colors.green[900],
        ),
        itemCount: foods.length,
      ),
    );
  }

  getLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  getErrorWidget(message) {
    return Center(
        child: Text(
      message,
      style: const TextStyle(color: Colors.green, fontSize: 20),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<FoodCubit>();

    return BlocBuilder<FoodCubit, FoodState>(builder: (context, state) {
      return BlocListener(
        listener: (context, state) {
          if (state is FoodSearchedState && state.foods.isNotEmpty) {
            getListFoodScreen(context);
          }
        },
        bloc: cubit,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: cubit.state is FoodSearchingState
                ? getLoadingWidget()
                : cubit.state is ErrorState
                    ? getErrorWidget("No results found. Try agin.")
                    : cubit.state is NoFoodSearchedState
                        ? Container()
                        : Container()),
      );
    });
  }
}
