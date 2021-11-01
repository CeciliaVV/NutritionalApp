import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutritionalapp/repository/api.dart';

class ListFoodCubit extends Cubit<ListFoodState> {
  final Api api;

  ListFoodCubit(this.api) : super(InitialState());

  Future getutrientsFood(int id) async {
    emit(LoadingDetailFoodState());

    try {
      final nutrients = await api.getMacroNutrients(id);
      print(nutrients.toString());
      if (nutrients.isEmpty) {
        emit(ErrorState("No results found. Try agin."));
        //emit(NoFoodSearchedState());
      } else {
        emit(DetailFoodChargedState(nutrients));
      }
    } on Exception catch (e) {
      print(e);
      emit(ErrorState(e.toString()));
    }
  }
}

abstract class ListFoodState {}

class InitialState extends ListFoodState {}

class LoadingDetailFoodState extends ListFoodState {}

class DetailFoodChargedState extends ListFoodState {
  final Map<String, dynamic> nutrients;

  DetailFoodChargedState(this.nutrients);
}

class ErrorState extends ListFoodState {
  final String message;
  ErrorState(this.message);
}
