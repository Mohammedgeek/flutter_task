import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var database;
  var count = 0;
  List<Map> list;

  @override
  void initState() {
    super.initState();
    createDatabase().then((value) {
      if (value != null) {
        database = value;
      }
      getFavorites(database: database).then((value) {
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
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.indigo,
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
                          deleteFromFavorites(id: item['id']).then((value) {
                            getFavorites(database: database).then((value) {
                              this.list = value;
                              dataCount(database: database).then((value) {
                                count = value;
                                setState(() {});
                              });
                              setState(() {});
                            });
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
      onOpen: (db) {
        print('db opened ');
      },
    );
  }

  Future<List<Map>> getFavorites({Database database}) async {
    return await database
        .rawQuery('select * from deals where favorite = 1')
        .then((value) {
      print(value);
    });
  }

  Future<void> deleteFromFavorites({int id}) async {
    await database
        .rawUpdate('UPDATE deals SET favorite = ? WHERE id = ?', ['0', "$id"]);
  }

  Future<int> dataCount({Database database}) async {
    return Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM deals where favorite = 1'));
  }
}
