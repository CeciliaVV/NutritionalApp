import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutritionalapp/bloc/food_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutritionalapp/repository/api.dart';
import 'package:nutritionalapp/ui.dart/list_food_screen.dart';

class FoodSearch extends StatelessWidget {
  const FoodSearch({Key? key}) : super(key: key);

  getFoodFormWidget(BuildContext context) {
    final cubit = context.watch<FoodCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /*const SizedBox(
                height: 20,
              ),*/
              const Text(
                "Nutritional App",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              /*const Text(
            "Search any word you want quickly",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),*/
              /*const SizedBox(
                height: 32,
              ),*/
              TextField(
                controller: cubit.queryController,
                decoration: InputDecoration(
                  hintText: "Search your food",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  hintStyle: const TextStyle(color: Colors.black54),
                ),
              ),
              /*const SizedBox(
                height: 50,
              ),*/
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    cubit.getFoodSearched();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent[400],
                      padding: const EdgeInsets.all(16)),
                  child: const Text("SEARCH",
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
            ]),
      )),
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

    return BlocListener(
      listener: (context, state) {
        if (state is FoodSearchedState && state.foods.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListFoodScreen(state.foods),
            ),
          );
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
                      ? getFoodFormWidget(context)
                      : Container()),
    );
  }
}
