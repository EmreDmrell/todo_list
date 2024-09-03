import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/home_controller.dart';
import 'duty.dart';
import 'duty_type.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'ToDoS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: controller.formKey,
              child: TextFormField(
                controller: controller.dutyTextController,
                autofocus: false,
                validator: controller.todoValidator,
                onSaved: controller.todoOnSaved,
                onEditingComplete: () async => await controller.addDuty(),
                decoration: InputDecoration(
                  hintText: 'Bugün neler yapacaksın?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.dutyTextController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            height: size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13),
                    child: Container(
                        width: size.width * 0.4,
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(() => DropdownButton<DutyType>(
                                elevation: 8,
                                menuMaxHeight: 200,
                                padding: const EdgeInsets.all(5),
                                style: const TextStyle(color: Colors.black),
                                value: controller.currentDutyType,
                                hint: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Görev Türü',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                items: getDropdownMenuItems(),
                                onChanged: controller.typeOnChanged,
                              )),
                        )),
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    height: size.height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                          padding: const EdgeInsets.all(15)),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Görev Türü Ekle'),
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              controller: controller.dutyTypeTextController,
                              onChanged: controller.typeTextOnChanged,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.dutyTypeTextController.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 30),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.2,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.dutyTypeTextController.clear();
                                      },
                                      child: const Text('Vazgeç'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.2,
                                    child: ElevatedButton(
                                      onPressed: controller.addDutyType,
                                      child: const Text('Oluştur'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Görev Türü Ekle'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Tooltip(
                  message: 'Tamamlanmış Görevler',
                  child: Obx(() => showCompletedDuties()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Tooltip(
                      message: 'Bütün görevler',
                      child: TextButton(onPressed: controller.loadDutyList, child: const Text('All Todos')),
                    ),
                    Tooltip(
                      message: 'Aktif görevler',
                      child: TextButton(onPressed: controller.showUnCompleted, child: const Text('Active')),
                    ),
                    Tooltip(
                      message: 'Tamamlanmış görevler',
                      child: TextButton(onPressed: controller.showCompleted, child: const Text('Completed')),
                    )
                  ],
                ),
              )
            ],
          ),
          showDutylist(size, controller.dutyList)
        ],
      ),
    );
  }

  List<DropdownMenuItem<DutyType>> getDropdownMenuItems() {

    final menuList = <DropdownMenuItem<DutyType>>[];
    for (DutyType type in controller.dutyTypeList) {
      final menuItem = DropdownMenuItem<DutyType>(
        value: type,
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (DismissDirection direction) async => await controller.deleteDutyType(type.id),
          direction: DismissDirection.startToEnd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type.name!),
                const Icon(Icons.arrow_forward_ios, color: Colors.indigo,)
              ],
            ),
          ),
        ),
      );
      menuList.add(menuItem);
    }

    return menuList;
  }

  SizedBox showDutylist(Size size, List<Duty> list) {
    return SizedBox(
        width: size.width,
        height: size.height * 0.4,
        child:Obx(() => ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, int index) {
              return Dismissible(
                  key: ValueKey<Duty>(list[index]),
                  onDismissed: (direction) async => await controller.deleteDuty(list[index].id),
                  direction: DismissDirection.startToEnd,
                  child: buildDutyList(list[index]));
            })));
  }

  ListTile buildDutyList(Duty duty) {
    return ListTile(
      leading: Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: duty.isCompleted,
        onChanged: (bool? value) {
          controller.checkCompleted(value, duty);
        },
      ),
      title: Text(duty.name),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.indigo,),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }


  Widget showCompletedDuties() {
    if (controller.completedTodosCount == 0) {
      return const Text('Hiçbir görev tamamlanmadı');
    } else {
      return Text('${controller.completedTodosCount} görev tamamlandı');
    }
  }


}

