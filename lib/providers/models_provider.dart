import 'package:chat_gpt_fltr/models/model.dart';
import 'package:chat_gpt_fltr/services/api_service.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo-0301";
  // Getters
  String get getCurrentModel => currentModel;

  // Setters
  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];
  List<ModelsModel> get getModelsList => modelsList;

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
