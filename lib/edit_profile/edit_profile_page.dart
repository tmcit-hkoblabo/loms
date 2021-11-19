import 'package:loms2/edit_profile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  //EditProfilePage(this.name, this.description);
  EditProfilePage(
      this.description, this.furigana, this.position, this.number, this.belong);
  //final String name;
  final String description;
  final String furigana;
  final String position;
  final String number;
  final String belong;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileModel>(
      create: (_) => EditProfileModel(
        //name,
        description,
        furigana,
        position,
        number,
        belong,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('プロフィール編集'),
        ),
        body: Center(
          child: Consumer<EditProfileModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  /*
                  TextField(
                    controller: model.nameController,
                    decoration: InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setName(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  */
                  TextField(
                    controller: model.descriptionController,
                    decoration: InputDecoration(
                      //hintText: '${model.description}',
                      hintText: '自己紹介',
                    ),
                    onChanged: (text) {
                      model.setDescription(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.furiganaController,
                    decoration: InputDecoration(
                      hintText: 'ふりがな',
                    ),
                    onChanged: (text) {
                      model.setFurigana(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.positionController,
                    decoration: InputDecoration(
                      hintText: '教員or学生',
                    ),
                    onChanged: (text) {
                      model.setPosition(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (model.position == '学生')
                    TextField(
                      controller: model.numberController,
                      decoration: InputDecoration(
                        hintText: '学生番号',
                      ),
                      onChanged: (text) {
                        model.setNumber(text);
                      },
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  if (model.position == '教員')
                    TextField(
                      controller: model.belongController,
                      decoration: InputDecoration(
                        hintText: '所属学科',
                      ),
                      onChanged: (text) {
                        model.setBelong(text);
                      },
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            // 追加の処理
                            try {
                              await model.update();
                              Navigator.of(context).pop();
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
