import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/db_helper.dart';
import 'package:todo_list/duty_type.dart';
import '../duty.dart';

class HomeController extends GetxController {
  final dutyTypeList = RxList<DutyType>([]);
  final dutyList = RxList<Duty>([]);
  final completedList = RxList<Duty>([]);
  final _currentTodoText = RxnString();
  final _completedTodosCount = RxInt(0);

  //final dutyList = RxList<Duty>([]);

  final _currentDutyType = Rxn<DutyType>(null);

  final formKey = GlobalKey<FormState>();
  late TextEditingController dutyTextController;
  late TextEditingController dutyTypeTextController;
  late String? currentDutyTypeName;

  DutyType? get currentDutyType => _currentDutyType.value;

  set currentDutyType(DutyType? value) => _currentDutyType.value = value;

  String? get currentTodoText => _currentTodoText.value;

  set currentTodoText(String? value) => _currentTodoText.value = value;

  int get completedTodosCount => _completedTodosCount.value;

  set completedTodosCount(int value) => _completedTodosCount.value = value;

  @override
  Future<void> onInit() async {
    super.onInit();

    initTextControllers();
    await loadDutyTypeList();
    await loadDutyList();
    checkCompletedDuties();
  }

  @override
  void onClose() {
    dutyTypeTextController.dispose();
    dutyTextController.dispose();

    super.onClose();
  }

  void initTextControllers() {
    dutyTextController = TextEditingController();
    dutyTypeTextController = TextEditingController();
  }

  Future<void> loadDutyTypeList() async {
    List<Map<String, dynamic>> response = await DatabaseHelper.queryAllDutyTypes();

    final typeList = <DutyType>[];
    for (Map<String, dynamic> item in response) {
      final type = DutyType.fromJson(item);
      typeList.add(type);
    }

    dutyTypeList.clear();
    dutyTypeList.addAll(typeList);
    dutyTypeList.refresh();
  }

  Future<void> addDutyType() async {
    final dutyType = DutyType(null, name: currentDutyTypeName);
    await DatabaseHelper.insertDutyType(dutyType);

    Get.back();
    dutyTypeTextController.clear();

    currentDutyType = null;
    await loadDutyTypeList();

  }

  Future<void> deleteDutyType(int? id) async {
    final activeDuties = dutyList.where((x) => x.typeId == id);

    if(activeDuties.isEmpty){
      await DatabaseHelper.deleteDutyType(id);
      await loadDutyTypeList();
      currentDutyType = null;
      Get.back();
    }else{
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds : 2),
        backgroundColor: Colors.red,
        title : 'Silme Hatası',
        message: 'Seçtiğiniz görev tipine ait ${activeDuties.length} görev bulunmaktadır')
    );
    };
  }



  void typeOnChanged(DutyType? value) {
    currentDutyType = value;
  }

  void typeTextOnChanged(String? value) {
    currentDutyTypeName = value;
  }

  Future<void> loadDutyList() async {
    List<Map<String, dynamic>> response = await DatabaseHelper.queryAllDuties();
    final List<Duty> duties = [];

    for (Map<String, dynamic> item in response) {
      final duty = Duty.fromJson(item);
      duties.add(duty);
    }

    dutyList.clear();
    dutyList.addAll(duties);
    dutyList.refresh();
  }

  Future<void> addDuty() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Duty newDuty = Duty(name: currentTodoText!, isCompleted: false, typeId: currentDutyType?.id);
      await DatabaseHelper.insertDuty(newDuty);

      await loadDutyList();
      FocusScope.of(Get.context!).unfocus();
      dutyTextController.clear();
    }
  }

  Future<int> deleteDuty(int id) async{
    final result = await DatabaseHelper.deleteDuty(id);
    await loadDutyList();
    checkCompletedDuties();

    return result;
  }


  String? todoValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Görev adı boş bırakılamaz!';
    }
    if (value != null && value.length <= 2) {
      return 'Görev adı 3 karakterden az olamaz!';
    }
    if (currentDutyType == null) {
      return 'Lütfen görev türü seçin!';
    }

    return null;
  }

  void todoOnSaved(String? value) {
    if(value != null){
      currentTodoText = value;
    }
  }

  Future<void> checkCompleted(bool? value, Duty duty) async {
    await DatabaseHelper.updateDutyState(value, duty);
    await loadDutyList();
    checkCompletedDuties();
  }

  void checkCompletedDuties() {
    completedTodosCount = 0;

    for (Duty duty in dutyList) {
      if (duty.isCompleted) {
        completedTodosCount++;
      }
    }
  }

  void showCompleted() async {
    final List<Duty> list = [];
    await loadDutyList();

    for (Duty duty in dutyList) {
      if (duty.isCompleted) {
        list.add(duty);
      }
    }

    dutyList.clear();
    dutyList.addAll(list);
    dutyList.refresh();
  }

  void showUnCompleted() async {
    final List<Duty> list = [];
    await loadDutyList();

    for (Duty duty in dutyList) {
      if (!duty.isCompleted) {
        list.add(duty);
      }
    }

    dutyList.clear();
    dutyList.addAll(list);
    dutyList.refresh();
  }
}
