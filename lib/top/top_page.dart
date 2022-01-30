//NEW

//import 'package:book_list_sample/add_book/add_book_page.dart';
//import 'package:loms2/authentication/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loms2/mypage/my_page.dart';
import 'package:loms2/top/top_model.dart';
import 'package:loms2/domain/book.dart';
//import 'package:loms2/edit_book/edit_book_page.dart';
import 'package:loms2/login/login_page.dart';
//import 'package:book_list_sample/mypage/my_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:loms2/top_page.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopModel>(
      create: (_) => TopModel()..fetchBookList(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Top'), //もともとは本一覧
            actions: [
              IconButton(
                onPressed: () async {
                  // 画面遷移
                  if (FirebaseAuth.instance.currentUser != null) {
                    print('ログインしている');
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPage(),
                        fullscreenDialog: true,
                      ),
                    );
                  } else {
                    print('ログインしてない');
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInOnGoogle(),
                        fullscreenDialog: true,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.person),
              ),
            ],
          ),
          /*
        body: Center(
          child: Consumer<TopModel>(builder: (context, model, child) {
            final List<Ble>? books = model.books;

            if (books == null) {
              return CircularProgressIndicator();
            }
            final List<Widget> widgets = books
                .map(
                  (book) => ListTile(
                    title: Text(book.name.toString()),
                    subtitle: Text(book.location.toString()),
                  ),
                )
                .toList();

            return ListView(
              children: widgets,
            );
          }),
        ),
        */

          body: Center(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              // 指定したstreamにデータが流れてくると再描画される
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Consumer<TopModel>(builder: (context, model, child) {
                    final List<Ble>? books = model.books;

                    if (books == null) {
                      return CircularProgressIndicator();
                    }

                    final List<Widget> widgets = books
                        .map(
                          (book) => ListTile(
                            title: Text(book.name.toString()),
                            subtitle: Text(book.location.toString()),
                          ),
                        )
                        .toList();

                    return ListView(
                      children: widgets,
                    );
                  });
                } else if (snapshot.hasError) {
                  return Text('エラーだよ');
                }
                return Consumer<TopModel>(builder: (context, model, child) {
                  final List<Ble>? books = model.books;

                  if (books == null) {
                    return CircularProgressIndicator();
                  }

                  final List<Widget> widgets = books
                      .map(
                        (book) => ListTile(
                          title: Text(book.name.toString()),
                          subtitle: Text(book.location.toString()),
                        ),
                      )
                      .toList();

                  return ListView(
                    children: widgets,
                  );
                });
              },
            ),
          )

          /*
          child: Consumer<TopModel>(builder: (context, model, child) {
            //final List<Book>? books = model.books;
            final List<Ble>? books = model.books;

            if (books == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map(
                  (book) => ListTile(
                    title: Text(book.name.toString()),
                    subtitle: Text(book.location.toString()),
                  ),
                )
                .toList();

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                builder: (context, snapshot) {
              return ListView(
                children: widgets,
              );
            });
            /*
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: widgets,
                );
              } else if (snapshot.hasError) {
                return Text('エラーだよ');
              }
              return ListView(
                children: widgets,
              );
            });
            */
          }),
        ),
        */

          /*
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              // 画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('本を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }),
        */

          //元データ
          /*
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map(
                  (book) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    child: ListTile(
                      leading: book.imgURL != null
                          ? Image.network(book.imgURL!)
                          : null,
                      title: Text(book.title),
                      subtitle: Text(book.author),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: '編集',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () async {
                          // 編集画面に遷移

                          // 画面遷移
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book),
                            ),
                          );

                          if (title != null) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('$titleを編集しました'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          model.fetchBookList();
                        },
                      ),
                      IconSlideAction(
                        caption: '削除',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          // 削除しますか？って聞いて、はいだったら削除
                          await showConfirmDialog(context, book, model);
                        },
                      ),
                    ],
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              // 画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('本を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }),
        */
          ),
    );
  }

  /*
  Future showConfirmDialog(
    BuildContext context,
    Book book,
    BookListModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("『${book.title}』を削除しますか？"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                // modelで削除
                await model.delete(book);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${book.title}を削除しました'),
                );
                model.fetchBookList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }*/
}
