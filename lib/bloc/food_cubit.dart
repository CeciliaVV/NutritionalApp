import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutritionalapp/models/foodlist.dart';
import 'package:nutritionalapp/repository/api.dart';

class FoodCubit extends Cubit<FoodState> {
  final Api api;

  FoodCubit(this.api) : super(NoFoodSearchedState());

  final queryController = TextEditingController();

  Future getFoodSearched() async {
    emit(FoodSearchingState());

    try {
      final foods = await api.getFood(queryController.text);
      print(foods.toString());
      if (foods.isEmpty) {
        emit(ErrorState("No results found. Try agin."));
        //emit(NoFoodSearchedState());
      } else {
        emit(FoodSearchedState(foods));
      }
    } on Exception catch (e) {
      print(e);
      emit(ErrorState(e.toString()));
    }
  }
}

abstract class FoodState {}

class NoFoodSearchedState extends FoodState {}

class FoodSearchingState extends FoodState {}

class FoodSearchedState extends FoodState {
  final List<Food> foods;

  FoodSearchedState(this.foods);
}

class ErrorState extends FoodState {
  final String message;
  ErrorState(this.message);
}
