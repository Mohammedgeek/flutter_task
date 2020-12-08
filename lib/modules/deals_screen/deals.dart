import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_project/modules/favorites_screen/favorites_screen.dart';

import 'package:toast/toast.dart';

class DealsScreen extends StatefulWidget {
  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  var database;
  var count = 0;
  bool fav_falg = false;
  var nameController = TextEditingController();
  var imgController = TextEditingController();
  var offerController = TextEditingController();
  var priceBController = TextEditingController();
  var priceAController = TextEditingController();
  List<Map> list;

  @override
  void initState() {
    super.initState();
    createDatabase().then((value) {
      if (value != null) {
        database = value;
      }
      getUsers(database: database).then((value) {
        this.list = value;
        setState(() {});
      });
      dataCount(database: database).then((value) {
        count = value;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (b) => AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: 'Enter Name....',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: TextFormField(
                              controller: imgController,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                hintText: 'Enter img Url....',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: TextFormField(
                              controller: offerController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter Offer Number...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: TextFormField(
                              controller: priceBController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter Price...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: TextFormField(
                              controller: priceAController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter Price...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              width: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.indigo,
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  String name = nameController.text;
                                  String img = imgController.text;
                                  String offer = offerController.text;
                                  String priceB = priceBController.text;
                                  String priceA = priceAController.text;
                                  if (name.isEmpty ||
                                      img.isEmpty ||
                                      offer.isEmpty ||
                                      priceB.isEmpty ||
                                      priceA.isEmpty) {
                                    Toast.show(
                                        "Pleas fill a valid data...", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                    return;
                                  }
                                  insertUser(
                                    database: database,
                                    name: name,
                                    img: img,
                                    offer: offer,
                                    priceAfter: priceA,
                                    priceBefore: priceB,
                                  ).then((value) {
                                    Navigator.pop(context);
                                    getUsers(database: database).then((value) {
                                      this.list = value;
                                      dataCount(database: database)
                                          .then((value) {
                                        this.count = value;
                                        setState(() {});
                                      });
                                      nameController.text = '';
                                      imgController.text = '';
                                      offerController.text = '';
                                      priceBController.text = '';
                                      priceAController.text = '';
                                      setState(() {});
                                    });
                                  });
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              width: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.indigo,
                              ),
                              child: FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ));
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.indigo,
      ),
      appBar: AppBar(
        title: Text('Deals'),
        backgroundColor: Colors.indigo,
        actions: [
          InkWell(onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return FavoritesScreen();
            }));
          },child: Icon(Icons.favorite)),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  '${count} items',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 5.0,
            color: Colors.grey[300],
          ),
          (this.list == null)
              ? Center(child: Text('No Data'))
              : Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildItem(list[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        Container(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                    shrinkWrap: true,
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildItem(Map item) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage("assets/slider/${item['img']}.png"),
                fit: BoxFit.fill,
                height: 130.0,
                width: 150.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: 65.0,
                    height: 25.0,
                    color: Colors.redAccent,
                    child: Center(
                        child: Text(
                      '${item['offer']}% OFF',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${item['name']}',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    height: 25.0,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'EGP ${item['priceAfter']}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'EGP ${item['priceBefore']}',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 80.0,
                      ),
                      InkWell(
                        onTap: () {
                          if (fav_falg == false)
                            fav_falg = true;
                          else
                            fav_falg = false;
                          setState(() {});
                          insertToFavorites(database: database, id: item['id']).then((value) {
                            setState(() {});
                          });

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey[200],
                            ),
                            child: Icon(
                              (fav_falg)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  (fav_falg) ? Colors.indigo : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteUser(id: item['id']);
                          getUsers(database: database).then((value) {
                            this.list = value;
                            dataCount(database: database).then((value) {
                              count = value;
                              setState(() {});
                            });
                            setState(() {});
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey[200],
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  Future<Database> createDatabase() async {
    return await openDatabase(
      'dealsDb',
      version: 2,
      onCreate: (Database db, version) async {
        print('dp created');
        await db
            .execute(
                'create table deals (id integer primary key , name text , img text , offer int , priceBefore int , priceAfter int , favorite int)')
            .then((value) {
          print(' deals table created');
        });
        // await db
        //     .execute(
        //         'create table favorites (id integer primary key , name text , img text , offer int , priceBefore int , priceAfter int)')
        //     .then((value) {
        //   print('favorites table created');
        // });
      },
      onOpen: (db) {
        print('db opened ');
      },
    );
  }

  Future<void> insertUser(
      {Database database,
      String name,
      String img,
      String offer,
      String priceBefore,
      String priceAfter,
      int favorite = 0}) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO deals (name, img, offer , priceBefore , priceAfter , favorite) VALUES("$name", "$img", "$offer" , "$priceBefore" , "$priceAfter" , "$favorite")');
    });
  }

  Future<void> insertToFavorites({Database database, int id}) async {
    await database.rawUpdate(
        'UPDATE deals SET favorite = ? WHERE id = ?',
        ["1", "$id"]);
  }



  Future<List<Map>> getUsers({Database database}) async {
    return await database.rawQuery('SELECT * FROM deals');
  }

  Future<void> deleteUser({int id}) async {
    await database.rawDelete('DELETE FROM deals WHERE id = ?', ['$id']);
  }

  Future<int> dataCount({Database database}) async {
    return Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM deals'));
  }
}
