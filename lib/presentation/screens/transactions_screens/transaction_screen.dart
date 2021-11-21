import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_add_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_delete_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_get_dto.dart';
import 'package:moordak/data/models/transaction_model.dart';
import 'package:moordak/logic/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/consts/strings.dart';
import 'package:moordak/presentation/screens/drawer.dart';
import 'package:moordak/presentation/screens/transactions_screens/details_transaction.dart';
import 'package:moordak/presentation/screens/transactions_screens/edit_transaction.dart';
import 'package:moordak/presentation/list_items/transaction_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class TransactionsScreen extends StatefulWidget {
  final String userId;
  TransactionsScreen({this.userId});
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with AutomaticKeepAliveClientMixin<TransactionsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TransactionBloc _transactionBloc;
  bool _isLoading = true;
  int _pageNumber = 0;

  Map<String, AppBar> _appBarList;
  String _currentAppBar = 'mainAppBar';
  AppBar _searchAppBar, _mainAppBar;
  ScrollController _listScrollController = new ScrollController();
  List<TransactionModel> _finalTransactions = [];
  SharedPreferences _preferences;

  _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _transactionBloc.add(
      GetAllTransactionsEvent(
        new TransactionGetDto(
          apiToken: _preferences.getString('apiToken'),
          pageNumber: _pageNumber,
          userId: widget.userId ?? null,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    _getPreferences();
    _listScrollController.addListener(() {
      double maxScroll = _listScrollController.position.maxScrollExtent;
      double currentScroll = _listScrollController.position.pixels;

      if (maxScroll - currentScroll <= 200) {
        if (!_isLoading) {
          _transactionBloc.add(
            GetAllTransactionsEvent(
              new TransactionGetDto(
                apiToken: _preferences.getString('apiToken'),
                pageNumber: _pageNumber++,
                userId: widget.userId ?? null,
              ),
            ),
          );
        }
      }
    });
    _searchAppBar = new AppBar(
      title: _buildSearch(),
      elevation: 5,
      backgroundColor: Colors.white,
      leading: new GestureDetector(
          child: new Padding(
            padding: const EdgeInsets.only(right: 12),
            child: new Icon(Icons.arrow_back, color: new Color(0xff075E54)),
          ),
          onTap: () {
            setState(() {
              _currentAppBar = 'mainAppBar';
              _transactionBloc.add(
                GetAllTransactionsEvent(
                  new TransactionGetDto(
                    apiToken: _preferences.getString('apiToken'),
                    pageNumber: _pageNumber++,
                    userId: widget.userId ?? null,
                  ),
                ),
              );
            });
          }),
    );
    _mainAppBar = new AppBar(
      title: Text(
        'تراکنش ها',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      elevation: 5,
      leading: widget.userId == null
          ? new IconButton(
              onPressed: () {
                DrawerScreenState.drawerKey.currentState.openDrawer();
              },
              icon: Icon(Icons.menu),
            )
          : new IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
      backgroundColor: maincolor,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            new IconButton(
              onPressed: () {
                setState(() {
                  _currentAppBar = 'searchAppBar';
                });
              },
              icon: new Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
    _appBarList = <String, AppBar>{
      'mainAppBar': _mainAppBar,
      'searchAppBar': _searchAppBar
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _transactionBloc,
        listener: (context, state) {
          if (state is TransactionExceptionState) {
            _exceptionState(state.text);
          } else if (state is DeleteTransactionState) {
            _isLoading = false;
            _transactionDelete(state.isSuccessed);
          }
        },
        builder: (context, state) {
          if (state is GetAllTransactionsState) {
            _getAllTransactions(state.transactions);
          } else if (state is TransactionLoadingState) {
            _isLoading = true;
          } else if (state is GetAllTransactionsBySearchState) {
            _isLoading = false;
            _getAllTransactions(state.transactions);
          }
          return Scaffold(
              appBar: _appBarList[_currentAppBar],
              floatingActionButton: _floatingActionButton(),
              key: _scaffoldKey,
              body: new RefreshIndicator(
                child: _isLoading == true && _finalTransactions.length == 0
                    ? Center(
                        child: new CircularProgressIndicator(
                          color: maincolor,
                        ),
                      )
                    : _finalTransactions.length > 0
                        ? Scrollbar(
                            child: ListView.builder(
                              controller: _listScrollController,
                              padding: EdgeInsets.only(bottom: 50),
                              itemCount: _finalTransactions.length,
                              itemBuilder: (context, index) {
                                return new TransactionViewModel(
                                    transactionModel: _finalTransactions[index],
                                    onItemClicked: () {
                                      _onItemClicked(
                                          context, _finalTransactions[index]);
                                    },
                                    onItemLongPressed: () {
                                      _onItemLongPressed(
                                          context,
                                          new TransactionAddDto(
                                              id: _finalTransactions[index].id,
                                              apiToken: apiToken,
                                              imageArray:
                                                  _finalTransactions[index]
                                                      .imgFileUrls,
                                              isCharity:
                                                  _finalTransactions[index]
                                                      .isCharity,
                                              payDate: _finalTransactions[index]
                                                  .payDate,
                                              payVal: _finalTransactions[index]
                                                  .payVal));
                                    });
                              },
                            ),
                          )
                        : _buildEmpty(),
                onRefresh: () async {
                  await _transactionBloc.add(
                    GetAllTransactionsEvent(
                      new TransactionGetDto(
                        apiToken: _preferences.getString('apiToken'),
                        pageNumber: _pageNumber = 0,
                      ),
                    ),
                  );
                  return null;
                },
              ));
        });
  }

  Widget _buildEmpty() {
    return new Center(
      child: new Text(
        'موردی برای نمایش وجود ندارد',
        style: new TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return new TextField(
      onChanged: (text) =>
          new Timer(new Duration(seconds: 1), _onSearchTextChanged(text)),
      decoration: new InputDecoration(
          border: InputBorder.none, hintText: "جستجو کنید..."),
    );
  }

  _onSearchTextChanged(String searchText) {
    _pageNumber = 0;
    _finalTransactions.clear();
    _transactionBloc.add(
      GetAllTransactionsBySearchEvent(
        new TransactionGetDto(
          apiToken: _preferences.getString('apiToken'),
          pageNumber: _pageNumber,
          search: searchText,
          userId: widget.userId ?? null,
        ),
      ),
    );
  }

  _exceptionState(String exception) async {
    _isLoading = false;
    if (exception == '401') {
      _preferences = await SharedPreferences.getInstance();
      _preferences.clear();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(exception),
        ),
      );
    }
  }

  _getAllTransactions(List<TransactionModel> transactions) {
    _isLoading = false;
    if (transactions.length > 0 && _pageNumber == 0) {
      _finalTransactions.clear();
      _finalTransactions.addAll(transactions);
    } else if (transactions.length > 0) {
      _finalTransactions.addAll(transactions);
    }
  }

  _transactionDelete(bool isSuccessed) {
    if (isSuccessed == true) {
      Toast.show('با موفقیت حذف شد', context);
      Navigator.pop(context);
      _transactionBloc.add(
        GetAllTransactionsEvent(
          TransactionGetDto(
            apiToken: _preferences.getString('apiToken'),
            pageNumber: _pageNumber = 0,
          ),
        ),
      );
    } else {
      Toast.show('عملیات با خطا مواجه شد', context);
      Navigator.pop(context);
    }
  }

  _onItemLongPressed(
      BuildContext context, TransactionAddDto transactionAddDto) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              new MaterialButton(
                onPressed: () async {
                  _preferences = await SharedPreferences.getInstance();
                  String _apiToken = _preferences.getString('apiToken');
                  _transactionBloc.add(
                    DeleteTransactionEvent(
                      TransactionDeleteDto(
                        apiToken: _apiToken,
                        id: transactionAddDto.id,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Icon(Icons.delete, color: Colors.red),
                    new Text(
                      'حذف تراکنش',
                      style: new TextStyle(
                        fontSize: 16,
                        color: maincolor,
                      ),
                    ),
                  ],
                ),
              ),
              new MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (BuildContext context) => TransactionBloc(),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: EditTransactionScreen(
                              transactionAddDto: transactionAddDto,
                            ),
                          ),
                        ),
                      )).then(
                    (value) => _transactionBloc.add(
                      GetAllTransactionsEvent(
                        new TransactionGetDto(
                          apiToken: _preferences.getString('apiToken'),
                          pageNumber: _pageNumber = 0,
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Icon(Icons.edit, color: Colors.green),
                    new Text(
                      'تغییر تراکنش',
                      style: new TextStyle(
                        fontSize: 16,
                        color: maincolor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _floatingActionButton() {
    return new FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/transaction_add_page').then(
          (value) => _transactionBloc.add(
            new GetAllTransactionsEvent(
              new TransactionGetDto(
                apiToken: _preferences.getString('apiToken'),
                pageNumber: _pageNumber = 0,
              ),
            ),
          ),
        );
      },
      backgroundColor: maincolor,
      child: new Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

_onItemClicked(context, TransactionModel _transactionItem) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: DetailsTransactionScreen(
          transactionModel: _transactionItem,
        ),
      ),
    ),
  );
}
