import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/loan_dtos/add_loan_dto.dart';
import 'package:moordak/data/dtos/loan_dtos/delete_loan_dto.dart';
import 'package:moordak/data/dtos/loan_dtos/get_loan_dto.dart';
import 'package:moordak/data/models/loan_Installments_model.dart';
import 'package:moordak/data/models/loan_model.dart';
import 'package:moordak/logic/blocs/installment_bloc/installment_bloc.dart';
import 'package:moordak/logic/blocs/loan_bloc/loan_bloc.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/consts/strings.dart';
import 'package:moordak/presentation/screens/drawer.dart';
import 'package:moordak/presentation/screens/installment_screens/loan_installments_screen.dart';
import 'package:moordak/presentation/screens/loan_screen/edit_loan_screen.dart';
import 'package:moordak/presentation/screens/loan_screen/loan_details.dart';
import 'package:moordak/presentation/view_models/loan_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoanScreen extends StatefulWidget {
  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen>
    with AutomaticKeepAliveClientMixin<LoanScreen> {
  Map<String, AppBar> _appBarList;
  String _currentAppBar = 'mainAppBar';
  AppBar _searchAppBar, _mainAppBar;
  bool _isLoading = true;
  int _pageNumber = 0;
  LoanBloc _loanBloc;
  List<LoanModel> _finalLoans = [];
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController _listScrollController = new ScrollController();
  SharedPreferences _preferences;
  _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _loanBloc.add(
      GetAllLoansEvent(
        GetLoanDto(
          apiToken: _preferences.getString('apiToken'),
          pageNumber: _pageNumber,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loanBloc = BlocProvider.of<LoanBloc>(context);
    _getPreferences();
    _listScrollController.addListener(() {
      double maxScroll = _listScrollController.position.maxScrollExtent;
      double currentScroll = _listScrollController.position.pixels;

      if (maxScroll - currentScroll <= 200) {
        if (!_isLoading) {
          _loanBloc.add(
            GetAllLoansEvent(
              new GetLoanDto(
                apiToken: _preferences.getString('apiToken'),
                pageNumber: _pageNumber++,
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
            });
          }),
    );
    _mainAppBar = new AppBar(
      title: Text(
        'وام ها',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      elevation: 5,
      leading: new IconButton(
        onPressed: () {
          DrawerScreenState.drawerKey.currentState.openDrawer();
        },
        icon: Icon(Icons.menu),
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
        bloc: _loanBloc,
        listener: (context, state) {
          if (state is LoanExceptionState) {
            _exceptionState(state.message);
          } else if (state is DeleteLoanState) {
            _deleteLoan(state.isSuccessed);
          }
        },
        builder: (context, state) {
          if (state is GetAllLoansState) {
            _getAllLoans(state.loans);
          }
          if (state is GetAllLoansBySearchState) {
            _getAllLoans(state.loans);
          } else if (state is LoanLoadingState) {
            _isLoading = true;
          }
          return Scaffold(
            appBar: _appBarList[_currentAppBar],
            key: _scaffoldKey,
            floatingActionButton: _buildFloatingActionButton(),
            body: new RefreshIndicator(
                child: _isLoading == true && _finalLoans.length == 0
                    ? Center(
                        child: new CircularProgressIndicator(
                          color: maincolor,
                        ),
                      )
                    : _finalLoans.length > 0
                        ? Scrollbar(
                            child: ListView.builder(
                              controller: _listScrollController,
                              padding: EdgeInsets.only(bottom: 50),
                              itemCount: _finalLoans.length,
                              itemBuilder: (context, index) {
                                return new LoanViewModel(
                                    loanModel: _finalLoans[index],
                                    onItemClicked: () {
                                      _onItemClicked(
                                          context, _finalLoans[index]);
                                    },
                                    onItemLongPressed: () {
                                      _onItemLongPressed(
                                        new AddLoanDto(
                                          id: _finalLoans[index].id,
                                          getDate: _finalLoans[index].getDate,
                                          installmentCount: _finalLoans[index]
                                              .installmentCount,
                                          installmentMonthPeriod:
                                              _finalLoans[index]
                                                  .installmentMonthPeriod,
                                          installmentVal:
                                              _finalLoans[index].installmentVal,
                                          isFinished:
                                              _finalLoans[index].isFinished,
                                          apiToken: apiToken,
                                          applicationUserId: _finalLoans[index]
                                              .applicationUserId,
                                          loanVal: _finalLoans[index].loanVal,
                                          firstName:
                                              _finalLoans[index].firstName,
                                          lastName: _finalLoans[index].lastName,
                                        ),
                                        _finalLoans[index].id,
                                        _finalLoans[index].loanInstallments,
                                      );
                                    });
                              },
                            ),
                          )
                        : _buildEmpty(),
                onRefresh: () async {
                  await _loanBloc.add(
                    GetAllLoansEvent(
                      new GetLoanDto(
                        apiToken: _preferences.getString('apiToken'),
                        pageNumber: _pageNumber = 0,
                      ),
                    ),
                  );
                  return null;
                }),
          );
        });
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

  _deleteLoan(bool isSuccessed) {
    _isLoading = false;
    if (isSuccessed == true) {
      Navigator.pop(context);
      Toast.show('با موفقیت حذف شد', context);
      _loanBloc.add(
        new GetAllLoansEvent(
          new GetLoanDto(
            apiToken: _preferences.getString('apiToken'),
            pageNumber: _pageNumber = 0,
          ),
        ),
      );
    } else {
      Toast.show('عملیات ناموفق', context);
    }
  }

  _getAllLoans(List<LoanModel> list) {
    _isLoading = false;
    if (list.length > 0 && _pageNumber == 0) {
      _finalLoans.clear();
      _finalLoans = list;
    } else if (list.length > 0) {
      _finalLoans.addAll(list);
    }
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
    _finalLoans.clear();
    _loanBloc.add(
      GetAllLoansBySearchEvent(
        GetLoanDto(
          apiToken: _preferences.getString('apiToken'),
          search: searchText,
          pageNumber: _pageNumber = 0,
        ),
      ),
    );
  }

  _onItemClicked(context, LoanModel _loanItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider<InstallmentBloc>(
            create: (BuildContext context) => InstallmentBloc(),
            child: LoanDetailsScreen(
              loanModel: _loanItem,
            ),
          ),
        ),
      ),
    );
  }

  _onItemLongPressed(
      AddLoanDto addLoanDto, int id, List<LoanInstallmentsModel> list) {
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
                  _loanBloc.add(
                    DeleteLoanEvent(new DeleteLoanDto(
                      apiToken: _apiToken,
                      id: id,
                    )),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Icon(Icons.delete, color: Colors.red),
                    new Text(
                      'حذف وام',
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
                          create: (BuildContext context) => LoanBloc(),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: EditLoanScreen(
                              loanAddDto: addLoanDto,
                            ),
                          ),
                        ),
                      )).then(
                    (value) => _loanBloc.add(
                      GetAllLoansEvent(
                        new GetLoanDto(
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
                      'تغییر وام',
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
                          create: (BuildContext context) => InstallmentBloc(),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: new LoanInstallmentsScreen(
                              loanInstallments: list,
                              name:
                                  '${addLoanDto.firstName} ${addLoanDto.lastName != null ? addLoanDto.lastName : ''}',
                            ),
                          ),
                        ),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Icon(Icons.list, color: maincolor),
                    new Text(
                      'اقساط وام',
                      style: new TextStyle(
                        fontSize: 16,
                        color: maincolor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _buildFloatingActionButton() {
    return new FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/loan_add_page');
      },
      backgroundColor: maincolor,
      child: new Icon(Icons.add, color: Colors.white),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
