import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

// config
const String libraryName = 'IAU Shiraz Library--->';
const String baseURL = 'http://localhost:5000/api/';

String memberId = '';
String memberPassword = '';
List<String> search = ['', '', '', '', '', '', '', ''];
String savedISBN = '';

void main() {
  runApp(const MyApp());
}

//go to home functionality for home key
void gotoHome(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const MyHomePage(),
    ),
  );
}

void gotoUserHome(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const UserHome(),
    ),
  );
}

void gotoOperatorHome(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const OperatorHome(),
    ),
  );
}

void gotoAdminHome(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const AdminHome(),
    ),
  );
}

void gotoAddBook(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const OperatorAddBook(),
    ),
  );
}

//a message dialog to show anywhere needed.
messageDialog(String message, context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//an error dialog to show anywhere needed.
errorDialog(int code, String status, context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('error code: ' + code.toString()),
              Text('status: ' + status),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

passwordChangeLogout(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Password changed.'),
              Text('Please Login again: '),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Ok'),
              onPressed: () {
                gotoHome(context);
              }),
        ],
      );
    },
  );
}

Future<http.Response> testRoute() {
  return http.get(
    Uri.parse(baseURL + 'test'),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
  );
}

//add book routes
Future<http.Response> addBook(
    isbn, name, publishYear, edition, publisherName, quantity) {
  return http.post(Uri.parse(baseURL + 'operator/add_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'isbn': isbn,
        'name': name,
        'publish_year': publishYear,
        'edition': edition,
        'publisher_name': publisherName,
        'quantity': quantity
      }));
}

Future<http.Response> viewBook(isbn) {
  return http.post(Uri.parse(baseURL + 'user/view_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'isbn': isbn,
      }));
}

Future<http.Response> authorBook(author, isbn, number) {
  return http.post(Uri.parse(baseURL + 'operator/author_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'author_name': author,
        'isbn': isbn,
        'num': number
      }));
}

Future<http.Response> translatorBook(translator, isbn, number) {
  return http.post(Uri.parse(baseURL + 'operator/translator_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'translator_name': translator,
        'isbn': isbn,
        'num': number
      }));
}

Future<http.Response> categoryBook(category, isbn, number) {
  return http.post(Uri.parse(baseURL + 'operator/category_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'category_name': category,
        'isbn': isbn,
        'num': number
      }));
}

//everyone routes functions
Future<http.Response> userLogin() {
  return http.post(Uri.parse(baseURL + 'login'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'authorization': 'Basic ' +
        //     base64Encode(
        //         utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_id': memberId,
        'member_password': memberPassword
      }));
}

Future<http.Response> operatorLogin() {
  return http.post(Uri.parse(baseURL + 'login_operator'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'authorization': 'Basic ' +
        //     base64Encode(
        //         utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_id': memberId,
        'member_password': memberPassword
      }));
}

Future<http.Response> adminLogin() {
  return http.post(Uri.parse(baseURL + 'login_admin'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'authorization': 'Basic ' +
        //     base64Encode(
        //         utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_id': memberId,
        'member_password': memberPassword
      }));
}

//user routes functions
Future<http.Response> userSearchBooks() {
  return http.post(Uri.parse(baseURL + 'user/search_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'isbn': search[0],
        'name': search[1],
        'publish_year': search[2],
        'edition': search[3],
        'publisher_name': search[4],
        'author': search[5],
        'translator': search[6],
        'category': search[7],
      }));
}

Future<http.Response> userBorrowed() {
  return http.get(Uri.parse(baseURL + 'user/borrowed_books'), headers: {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'authorization': 'Basic ' +
        base64Encode(utf8.encode(memberId.toString() + ':' + memberPassword))
  });
}

Future<http.Response> userChangePhone(phone) {
  return http.post(Uri.parse(baseURL + 'user/change_phone'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_phone': phone,
      }));
}

Future<http.Response> userChangePassword(pass) {
  return http.post(Uri.parse(baseURL + 'user/change_password'),
      headers: {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_password': pass,
      }));
}

//operator routes functions
Future<http.Response> operatorSignup(
    member_name, member_phone, member_password) {
  return http.post(Uri.parse(baseURL + 'operator/signup'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_name': member_name,
        'member_phone': member_phone,
        'member_password': member_password,
      }));
}

Future<http.Response> operatorRenewal(member_id) {
  return http.post(Uri.parse(baseURL + 'operator/member_renewal'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_id': member_id,
      }));
}

Future<http.Response> operatorAddQuantity(isbn, quantity) {
  return http.post(Uri.parse(baseURL + 'operator/add_quantity'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(
          <String, String>{'isbn': isbn, 'added_quantity': quantity}));
}

Future<http.Response> operatorBorrowBook(isbn, member_id) {
  return http.post(Uri.parse(baseURL + 'operator/borrow_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{'isbn': isbn, 'member_id': member_id}));
}

Future<http.Response> operatorReturnBook(borrow_id) {
  return http.post(Uri.parse(baseURL + 'operator/return_book'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{'borrow_id': borrow_id}));
}

Future<http.Response> operatorPrintCard(id) {
  return http.post(Uri.parse(baseURL + 'operator/cardpdf'),
      headers: {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_id': id,
      }));
}

//admin routes funtions
Future<http.Response> adminReport() {
  return http.get(Uri.parse(baseURL + 'admin/report'), headers: {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'authorization': 'Basic ' +
        base64Encode(utf8.encode(memberId.toString() + ':' + memberPassword))
  });
}

Future<http.Response> adminBorrowed() {
  return http.get(Uri.parse(baseURL + 'admin/view_borrowed_books'), headers: {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'authorization': 'Basic ' +
        base64Encode(utf8.encode(memberId.toString() + ':' + memberPassword))
  });
}

Future<http.Response> adminSignup(
    member_name, member_phone, member_password, member_type) {
  return http.post(Uri.parse(baseURL + 'admin/signup_admin'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_name': member_name,
        'member_phone': member_phone,
        'member_password': member_password,
        'member_type': member_type,
      }));
}

Future<http.Response> adminOperatorRenewal(id) {
  return http.post(Uri.parse(baseURL + 'admin/operator_renewal'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_id': id,
      }));
}

Future<http.Response> adminPrintCard(id) {
  return http.post(Uri.parse(baseURL + 'admin/cardpdfadmin'),
      headers: {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'authorization': 'Basic ' +
            base64Encode(
                utf8.encode(memberId.toString() + ':' + memberPassword))
      },
      body: jsonEncode(<String, String>{
        'member_id': id,
      }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: libraryName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _gotoUserLogin() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginUser(),
      ),
    );
  }

  void _gotoOperatorLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginOperator(),
      ),
    );
  }

  void _gotoAdminLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginAdmin(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _testconnection() async {
      final res = await testRoute();
      var resfinal = jsonDecode(res.body);
      return resfinal;
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(children: <Widget>[
            Text(libraryName),
            Text("Home Page"),
          ]),
          leading: IconButton(
              onPressed: () => gotoHome(context), icon: const Icon(Icons.home)),
        ),
        body: FutureBuilder(
          future: _testconnection(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: _gotoUserLogin,
                        child: const Text('Login User')),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: _gotoOperatorLogin,
                        child: const Text('Login Operator')),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: _gotoAdminLogin,
                        child: const Text('Login Admin')),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(child: Text(error.toString()));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Waiting for Connection"),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
        ));
  }
}

//user pages
class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);
  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController memberidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _login() async {
    memberId =
        (memberidController.text == '') ? memberId : memberidController.text;
    memberPassword = (passwordController.text == '')
        ? memberPassword
        : sha256.convert(ascii.encode(passwordController.text)).toString();
    var res = await userLogin();
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const UserHome(),
        ),
      );
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  void _logout() {
    memberId = '';
    memberPassword = '';
    messageDialog('Logged out', context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("User Login"),
        ]),
        leading: IconButton(
            onPressed: () => gotoHome(context), icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberidController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: (memberId == '') ? 'Member ID:' : 'ID saved',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      (memberPassword == '') ? 'Password:' : 'Password Saved',
                  hintText: 'Enter Password'),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _logout, child: const Text('Logout')),
            ]),
          ],
        ),
      ),
    );
  }
}

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  void _gotoBorrowedBooks() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const UserBorrowedBooks(),
      ),
    );
  }

  void _gotoSearchBooks() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const UserSearchBook(),
      ),
    );
  }

  void _gotoChangePhone() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const UserChangePhone(),
      ),
    );
  }

  void _gotoChangePassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const UserChangePassword(),
      ),
    );
  }

  void _gotoViewBook() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const UserViewBook(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("User Home"),
        ]),
        leading: IconButton(
            onPressed: () => gotoHome(context), icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: _gotoBorrowedBooks,
                child: const Text('View Borrowed Books')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoSearchBooks, child: const Text('Search Books')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoChangePhone,
                child: const Text('Change Phone Number')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoChangePassword,
                child: const Text('Change Password')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoViewBook,
                child: const Text('View Book Details')),
          ],
        ),
      ),
    );
  }
}

class UserBorrowedBooks extends StatefulWidget {
  const UserBorrowedBooks({Key? key}) : super(key: key);
  @override
  State<UserBorrowedBooks> createState() => _UserBorrowedBooksState();
}

class _UserBorrowedBooksState extends State<UserBorrowedBooks> {
  late List<dynamic> data;
  _borrowed() async {
    final res = await userBorrowed();
    var resfinal = jsonDecode(res.body);
    return resfinal;
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('borrow_id', 100),
      _getTitleItemWidget('isbn', 150),
      _getTitleItemWidget('borrow_date', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(data[index]['borrow_id'].toString()),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[Text(data[index]['isbn'].toString())],
          ),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(data[index]['borrow_date'].toString()),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: <Widget>[
            Text(libraryName),
            Text("User Borrowed Books"),
          ]),
          leading: IconButton(
              onPressed: () => gotoUserHome(context),
              icon: const Icon(Icons.home)),
        ),
        body: FutureBuilder(
          future: _borrowed(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = (snapshot.data as List<dynamic>);
              return HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 600,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: data.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(child: Text(error.toString()));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Waiting for Connection"),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class UserSearchBook extends StatefulWidget {
  const UserSearchBook({Key? key}) : super(key: key);
  @override
  State<UserSearchBook> createState() => _UserSearchBookState();
}

class _UserSearchBookState extends State<UserSearchBook> {
  TextEditingController isbnController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController publishYearController = TextEditingController();
  TextEditingController editionController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController translatorController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  _submit() async {
    search = [
      isbnController.text,
      nameController.text,
      publishYearController.text,
      editionController.text,
      publisherController.text,
      authorController.text,
      translatorController.text,
      categoryController.text
    ];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const UserSearchBookResult(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("User Search Book"),
        ]),
        leading: IconButton(
            onPressed: () => gotoUserHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: isbnController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'ISBN:',
                  hintText: 'Enter ISBN'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name:',
                  hintText: 'Enter Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: publishYearController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Publish Year:',
                  hintText: 'Enter Publish Year'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: editionController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Edition:',
                  hintText: 'Enter Edition'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: publisherController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Publisher:',
                  hintText: 'Enter Publisher Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Author:',
                  hintText: 'Enter Author Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: translatorController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Translator:',
                  hintText: 'Enter Translator Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Category:',
                  hintText: 'Enter Category'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _submit, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}

class UserSearchBookResult extends StatefulWidget {
  const UserSearchBookResult({Key? key}) : super(key: key);
  @override
  State<UserSearchBookResult> createState() => _UserSearchBookResultState();
}

class _UserSearchBookResultState extends State<UserSearchBookResult> {
  late List<dynamic> data;
  _search() async {
    final res = await userSearchBooks();
    var resfinal = jsonDecode(res.body);
    return resfinal;
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Name', 100),
      _getTitleItemWidget('ISBN', 125),
      _getTitleItemWidget('Publish Year', 100),
      _getTitleItemWidget('Edition', 75),
      _getTitleItemWidget('Publisher Name', 75),
      _getTitleItemWidget('Quantity', 75),
      _getTitleItemWidget('Remaining', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(data[index]['name'].toString()),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[Text(data[index]['isbn'].toString())],
          ),
          width: 125,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(data[index]['publish_year'].toString()),
          width: 75,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(data[index]['edition'].toString()),
          width: 75,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(data[index]['publisher_name'].toString()),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(data[index]['quantity'].toString()),
          width: 75,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(data[index]['remaining'].toString()),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: <Widget>[
            Text(libraryName),
            Text("User Search Book"),
          ]),
          leading: IconButton(
              onPressed: () => gotoUserHome(context),
              icon: const Icon(Icons.home)),
        ),
        body: FutureBuilder(
          future: _search(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = (snapshot.data as List<dynamic>);
              return HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 600,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: data.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(child: Text(error.toString()));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Waiting for Connection"),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class UserChangePhone extends StatefulWidget {
  const UserChangePhone({Key? key}) : super(key: key);
  @override
  State<UserChangePhone> createState() => _UserChangePhoneState();
}

class _UserChangePhoneState extends State<UserChangePhone> {
  TextEditingController memberPhoneController = TextEditingController();

  _changePhone() async {
    var res = await userChangePhone(memberPhoneController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Phone number Changed', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("User Change Phone"),
        ]),
        leading: IconButton(
            onPressed: () => gotoUserHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberPhoneController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'New Phone:',
                  hintText: 'Enter New Phone Number'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _changePhone, child: const Text('Change Phone')),
          ],
        ),
      ),
    );
  }
}

class UserChangePassword extends StatefulWidget {
  const UserChangePassword({Key? key}) : super(key: key);
  @override
  State<UserChangePassword> createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  TextEditingController memberPasswordController = TextEditingController();
  TextEditingController memberPasswordRepeatController =
      TextEditingController();
  TextEditingController memberPasswordOldController = TextEditingController();
  _changePassword() async {
    var res = await userChangePassword(memberPasswordController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      memberPassword = '';
      passwordChangeLogout(context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  _checkPassword() async {
    //memberPasswordController.text
    //sha256.convert(ascii.encode(passwordController.text)).toString();
    if (memberPasswordController.text == memberPasswordRepeatController.text) {
      if (sha256
              .convert(ascii.encode(memberPasswordOldController.text))
              .toString() ==
          memberPassword) {
        _changePassword();
      } else {
        messageDialog("Old password is not correct", context);
      }
    } else {
      messageDialog("New passwords don't match", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("User Password Change"),
        ]),
        leading: IconButton(
            onPressed: () => gotoUserHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              obscureText: true,
              controller: memberPasswordOldController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Old Password:',
                  hintText: 'Enter Old Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: memberPasswordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'New Password:',
                  hintText: 'Enter New Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: memberPasswordRepeatController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'New Password Repeat:',
                  hintText: 'Enter New Password Again'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _checkPassword,
                child: const Text('Change Password')),
          ],
        ),
      ),
    );
  }
}

class UserViewBook extends StatefulWidget {
  const UserViewBook({Key? key}) : super(key: key);
  @override
  State<UserViewBook> createState() => _UserViewBookState();
}

class _UserViewBookState extends State<UserViewBook> {
  TextEditingController isbnController = TextEditingController();

  void _viewBook() async {
    var res = await viewBook(isbnController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (res.statusCode == 200 && resmap['status'] == 'not available') {
      messageDialog('Book not available', context);
    } else if (res.statusCode == 200 && resmap['status'] == 'available') {
      messageDialog(resmap['book'], context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("User View Book Details"),
        ]),
        leading: IconButton(
            onPressed: () => gotoUserHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: isbnController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'ISBN:',
                  hintText: 'Enter ISBN'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _viewBook, child: const Text('View Book')),
          ],
        ),
      ),
    );
  }
}

class LoginOperator extends StatefulWidget {
  const LoginOperator({Key? key}) : super(key: key);
  @override
  State<LoginOperator> createState() => _LoginOperatorState();
}

class _LoginOperatorState extends State<LoginOperator> {
  TextEditingController memberidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _login() async {
    memberId =
        (memberidController.text == '') ? memberId : memberidController.text;
    memberPassword = (passwordController.text == '')
        ? memberPassword
        : sha256.convert(ascii.encode(passwordController.text)).toString();
    var res = await operatorLogin();
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const OperatorHome(),
        ),
      );
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  void _logout() {
    memberId = '';
    memberPassword = '';
    messageDialog('Logged out', context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Login"),
        ]),
        leading: IconButton(
            onPressed: () => gotoHome(context), icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberidController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: (memberId == '') ? 'Member ID:' : 'ID saved',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      (memberPassword == '') ? 'Password:' : 'Password Saved',
                  hintText: 'Enter Password'),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _logout, child: const Text('Logout')),
            ]),
          ],
        ),
      ),
    );
  }
}

//operator pages
class OperatorHome extends StatefulWidget {
  const OperatorHome({Key? key}) : super(key: key);
  @override
  State<OperatorHome> createState() => _OperatorHomeState();
}

class _OperatorHomeState extends State<OperatorHome> {
  void _gotoSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const OperatorSignUp(),
      ),
    );
  }

  void _gotoRenewal() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const OperatorRenewal(),
      ),
    );
  }

  void _gotoAddBook() {
    gotoAddBook(context);
  }

  void _gotoAddQuantity() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const OperatorAddQuantity(),
      ),
    );
  }

  void _gotoBorrow() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const OperatorBorrowBook(),
      ),
    );
  }

  void _gotoReturnBook() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const OperatorReturnBook(),
      ),
    );
  }

  void _gotoPrintCard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const OperatorPrintCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Home"),
        ]),
        leading: IconButton(
            onPressed: () => gotoHome(context), icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: _gotoSignup, child: const Text('Signup')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoRenewal, child: const Text('Renewal')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoAddBook, child: const Text('Add Book')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoAddQuantity, child: const Text('Add Quantity')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoBorrow, child: const Text('Borrow Book')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoReturnBook, child: const Text('Return Book')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoPrintCard, child: const Text('Print Card')),
          ],
        ),
      ),
    );
  }
}

class OperatorAddBook extends StatefulWidget {
  const OperatorAddBook({Key? key}) : super(key: key);
  @override
  State<OperatorAddBook> createState() => _OperatorAddBookState();
}

class _OperatorAddBookState extends State<OperatorAddBook> {
  TextEditingController isbnController = TextEditingController();

  _checkISBN(String isbn) async {
    final res = await viewBook(savedISBN);
    var resfinal = jsonDecode(res.body);
    return resfinal;
  }

  void _saveISBN() {
    savedISBN = isbnController.text;
    setState(() {});
  }

  void _gotoAddBook() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AddBookBook(),
      ),
    );
  }

  void _gotoAddAuthor() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AddBookAuthor(),
      ),
    );
  }

  void _gotoAddTranslator() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AddBookTranslator(),
      ),
    );
  }

  void _gotoAddCategory() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AddBookCategory(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: <Widget>[
            Text(libraryName),
            Text("Operator Add Book Home"),
          ]),
          leading: IconButton(
              onPressed: () => gotoOperatorHome(context),
              icon: const Icon(Icons.home)),
        ),
        body: FutureBuilder(
          future: _checkISBN(savedISBN),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              var data = (snapshot.data as Map<String, dynamic>);
              if (data['status'] == 'not available') {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text((savedISBN == '') ? '' : 'saved isbn: ' + savedISBN),
                      const SizedBox(height: 20),
                      TextField(
                        controller: isbnController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                (savedISBN == '') ? 'ISBN:' : 'ISBN Saved',
                            hintText: 'Enter ISBN'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _saveISBN, child: const Text('Save ISBN')),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: _gotoAddBook,
                          child: const Text('Add Book')),
                    ],
                  ),
                );
              } else if (data['status'] == 'available') {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(data['book']),
                      const SizedBox(height: 20),
                      TextField(
                        controller: isbnController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                (savedISBN == '') ? 'ISBN:' : 'ISBN Saved',
                            hintText: 'Enter ISBN'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _saveISBN, child: const Text('Save ISBN')),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: _gotoAddBook,
                          child: const Text('Add Book')),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _gotoAddAuthor,
                          child: const Text('Add Author')),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _gotoAddTranslator,
                          child: const Text('Add Translator')),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _gotoAddCategory,
                          child: const Text('Add Category')),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text((savedISBN == '') ? '' : 'saved isbn: ' + savedISBN),
                      const SizedBox(height: 10),
                      Text(data['status']),
                      const SizedBox(height: 20),
                      TextField(
                        controller: isbnController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                (savedISBN == '') ? 'ISBN:' : 'ISBN Saved',
                            hintText: 'Enter ISBN'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _saveISBN, child: const Text('Save ISBN')),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(child: Text(error.toString()));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Waiting for Connection"),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class AddBookBook extends StatefulWidget {
  const AddBookBook({Key? key}) : super(key: key);
  @override
  State<AddBookBook> createState() => _AddBookBookState();
}

class _AddBookBookState extends State<AddBookBook> {
  TextEditingController nameController = TextEditingController();
  TextEditingController publishYearController = TextEditingController();
  TextEditingController editionController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  _addBook() async {
    var res = await addBook(
        savedISBN,
        nameController.text,
        publishYearController.text,
        editionController.text,
        publisherController.text,
        quantityController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Book Added.', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Add Book"),
        ]),
        leading: IconButton(
            onPressed: () => gotoAddBook(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name:',
                  hintText: 'Enter Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: publishYearController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Publish Year:',
                  hintText: 'Enter Publish Year'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: editionController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Edition:',
                  hintText: 'Enter Edition'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: publisherController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Publisher:',
                  hintText: 'Enter Publisher Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Quantity:',
                  hintText: 'Enter Quantity'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addBook,
              child: const Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddBookAuthor extends StatefulWidget {
  const AddBookAuthor({Key? key}) : super(key: key);
  @override
  State<AddBookAuthor> createState() => _AddBookAuthorState();
}

class _AddBookAuthorState extends State<AddBookAuthor> {
  TextEditingController authorNameController = TextEditingController();
  TextEditingController authorNumberController = TextEditingController();

  _addAuthor() async {
    var res = await authorBook(
        authorNameController.text, savedISBN, authorNumberController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Author Added.', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Add Author"),
        ]),
        leading: IconButton(
            onPressed: () => gotoAddBook(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: authorNameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Author:',
                  hintText: 'Enter Author Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: authorNumberController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Number:',
                  hintText: 'Enter Author Number'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _addAuthor, child: const Text('Add Author')),
          ],
        ),
      ),
    );
  }
}

class AddBookTranslator extends StatefulWidget {
  const AddBookTranslator({Key? key}) : super(key: key);
  @override
  State<AddBookTranslator> createState() => _AddBookTranslatorState();
}

class _AddBookTranslatorState extends State<AddBookTranslator> {
  TextEditingController translatorNameController = TextEditingController();
  TextEditingController translatorNumberController = TextEditingController();

  _addTranslator() async {
    var res = await translatorBook(translatorNameController.text, savedISBN,
        translatorNumberController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Translator Added.', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Add Translator"),
        ]),
        leading: IconButton(
            onPressed: () => gotoAddBook(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: translatorNameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Translator:',
                  hintText: 'Enter Translator Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: translatorNumberController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Number:',
                  hintText: 'Enter Translator Number'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _addTranslator, child: const Text('Add Translator')),
          ],
        ),
      ),
    );
  }
}

class AddBookCategory extends StatefulWidget {
  const AddBookCategory({Key? key}) : super(key: key);
  @override
  State<AddBookCategory> createState() => _AddBookCategoryState();
}

class _AddBookCategoryState extends State<AddBookCategory> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryNumberController = TextEditingController();

  _addCategory() async {
    var res = await categoryBook(
        categoryController.text, savedISBN, categoryNumberController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Category Added.', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Add Category"),
        ]),
        leading: IconButton(
            onPressed: () => gotoAddBook(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Category:',
                  hintText: 'Enter Category Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryNumberController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Number:',
                  hintText: 'Enter Category Number'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _addCategory, child: const Text('Add Category')),
          ],
        ),
      ),
    );
  }
}

class OperatorSignUp extends StatefulWidget {
  const OperatorSignUp({Key? key}) : super(key: key);
  @override
  State<OperatorSignUp> createState() => _OperatorSignUpState();
}

class _OperatorSignUpState extends State<OperatorSignUp> {
  TextEditingController memberNameController = TextEditingController();
  TextEditingController memberPhoneController = TextEditingController();
  TextEditingController memberPasswordController = TextEditingController();

  _signup() async {
    var res = await operatorSignup(memberNameController.text,
        memberPhoneController.text, memberPasswordController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Member Added. ID: ' + resmap['msg'], context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Signup"),
        ]),
        leading: IconButton(
            onPressed: () => gotoOperatorHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberNameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member Name:',
                  hintText: 'Enter Member Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: memberPasswordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member Password:',
                  hintText: 'Enter Member Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: memberPhoneController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member Phone:',
                  hintText: 'Enter Member Phone'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _signup, child: const Text('Signup')),
          ],
        ),
      ),
    );
  }
}

class OperatorRenewal extends StatefulWidget {
  const OperatorRenewal({Key? key}) : super(key: key);
  @override
  State<OperatorRenewal> createState() => _OperatorRenewalState();
}

class _OperatorRenewalState extends State<OperatorRenewal> {
  TextEditingController memberIDController = TextEditingController();

  _renew() async {
    var res = await operatorRenewal(memberIDController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Member Renewed', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Renewal"),
        ]),
        leading: IconButton(
            onPressed: () => gotoOperatorHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberIDController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member ID:',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _renew, child: const Text('Renew')),
          ],
        ),
      ),
    );
  }
}

class OperatorAddQuantity extends StatefulWidget {
  const OperatorAddQuantity({Key? key}) : super(key: key);
  @override
  State<OperatorAddQuantity> createState() => _OperatorAddQuantityState();
}

class _OperatorAddQuantityState extends State<OperatorAddQuantity> {
  TextEditingController isbnController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  _addQuantity() async {
    var res =
        await operatorAddQuantity(isbnController.text, quantityController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Quantity Added', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Add Quantity"),
        ]),
        leading: IconButton(
            onPressed: () => gotoOperatorHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: isbnController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'ISBN:',
                  hintText: 'Enter ISBN'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Added Books:',
                  hintText: 'Enter Number Of Added Books'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _addQuantity, child: const Text('Add Quantity')),
          ],
        ),
      ),
    );
  }
}

class OperatorBorrowBook extends StatefulWidget {
  const OperatorBorrowBook({Key? key}) : super(key: key);
  @override
  State<OperatorBorrowBook> createState() => _OperatorBorrowBookState();
}

class _OperatorBorrowBookState extends State<OperatorBorrowBook> {
  TextEditingController isbnController = TextEditingController();
  TextEditingController memberIDController = TextEditingController();
  _addBorrow() async {
    var res =
        await operatorBorrowBook(isbnController.text, memberIDController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Book Borrowed', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Borrow Book"),
        ]),
        leading: IconButton(
            onPressed: () => gotoOperatorHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: isbnController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'ISBN:',
                  hintText: 'Enter ISBN'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: memberIDController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member ID:',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addBorrow, child: const Text('Borrow')),
          ],
        ),
      ),
    );
  }
}

class OperatorReturnBook extends StatefulWidget {
  const OperatorReturnBook({Key? key}) : super(key: key);
  @override
  State<OperatorReturnBook> createState() => _OperatorReturnBookState();
}

class _OperatorReturnBookState extends State<OperatorReturnBook> {
  TextEditingController borrowIDController = TextEditingController();
  _addReturn() async {
    var res = await operatorReturnBook(borrowIDController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Book Returned' + resmap['msg'], context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Return Book"),
        ]),
        leading: IconButton(
            onPressed: () => gotoOperatorHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: borrowIDController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Borrow ID:',
                  hintText: 'Enter BorrowID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addReturn, child: const Text('Return')),
          ],
        ),
      ),
    );
  }
}

class OperatorPrintCard extends StatefulWidget {
  const OperatorPrintCard({Key? key}) : super(key: key);
  @override
  State<OperatorPrintCard> createState() => _OperatorPrintCardState();
}

class _OperatorPrintCardState extends State<OperatorPrintCard> {
  TextEditingController printCardController = TextEditingController();

  _printCard() async {
    var res = await operatorPrintCard(printCardController.text);
    if (res.statusCode != 200) {
      Map<String, dynamic> resmap = jsonDecode(res.body);
      errorDialog(res.statusCode, resmap['status'], context);
    } else {
      messageDialog('Downloading...', context);
      final rawData = res.bodyBytes;
      final content = base64Encode(rawData);
      final anchor = html.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", "card.pdf")
        ..click();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Operator Print Card"),
        ]),
        leading: IconButton(
            onPressed: () => gotoOperatorHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: printCardController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member ID:',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _printCard, child: const Text('Print Card')),
          ],
        ),
      ),
    );
  }
}

//admin pages
class LoginAdmin extends StatefulWidget {
  const LoginAdmin({Key? key}) : super(key: key);
  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  TextEditingController memberidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _login() async {
    memberId =
        (memberidController.text == '') ? memberId : memberidController.text;
    memberPassword = (passwordController.text == '')
        ? memberPassword
        : sha256.convert(ascii.encode(passwordController.text)).toString();
    var res = await adminLogin();
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      gotoAdminHome(context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  void _logout() {
    memberId = '';
    memberPassword = '';
    messageDialog('Logged out', context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Admin Login"),
        ]),
        leading: IconButton(
            onPressed: () => gotoHome(context), icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberidController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: (memberId == '') ? 'Member ID:' : 'ID saved',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      (memberPassword == '') ? 'Password:' : 'Password Saved',
                  hintText: 'Enter Password'),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _logout, child: const Text('Logout')),
            ]),
          ],
        ),
      ),
    );
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  _gotoReport() async {
    var res = await adminReport();
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog(resmap['msg'], context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  void _gotoBorrowedBooks() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AdminBorrowedBooks(),
      ),
    );
  }

  void _gotoSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AdminSignUp(),
      ),
    );
  }

  void _gotoRenewal() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AdminOperatorRenewal(),
      ),
    );
  }

  void _gotoPrintCard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AdminPrintCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Admin Home"),
        ]),
        leading: IconButton(
            onPressed: () => gotoHome(context), icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: _gotoReport, child: const Text('Report')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoBorrowedBooks,
                child: const Text('Borrowed Books')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoSignup,
                child: const Text('Signup Admin/Operator')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoRenewal, child: const Text('Operator Renewal')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _gotoPrintCard, child: const Text('Print Card')),
          ],
        ),
      ),
    );
  }
}

class AdminBorrowedBooks extends StatefulWidget {
  const AdminBorrowedBooks({Key? key}) : super(key: key);
  @override
  State<AdminBorrowedBooks> createState() => _AdminBorrowedBooksState();
}

class _AdminBorrowedBooksState extends State<AdminBorrowedBooks> {
  late List<dynamic> data;
  _borrowed() async {
    final res = await adminBorrowed();
    var resfinal = jsonDecode(res.body);
    return resfinal;
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('borrow_id', 100),
      _getTitleItemWidget('isbn', 150),
      _getTitleItemWidget('member_id', 100),
      _getTitleItemWidget('borrow_date', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(data[index]['borrow_id'].toString()),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[Text(data[index]['isbn'].toString())],
          ),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(data[index]['member_id'].toString()),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(data[index]['borrow_date'].toString()),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: <Widget>[
            Text(libraryName),
            Text("Admin Borrowed Books"),
          ]),
          leading: IconButton(
              onPressed: () => gotoAdminHome(context),
              icon: const Icon(Icons.home)),
        ),
        body: FutureBuilder(
          future: _borrowed(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = (snapshot.data as List<dynamic>);
              return HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 600,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: data.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(child: Text(error.toString()));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Waiting for Connection"),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class AdminSignUp extends StatefulWidget {
  const AdminSignUp({Key? key}) : super(key: key);
  @override
  State<AdminSignUp> createState() => _AdminSignUpState();
}

class _AdminSignUpState extends State<AdminSignUp> {
  TextEditingController memberNameController = TextEditingController();
  TextEditingController memberPhoneController = TextEditingController();
  TextEditingController memberPasswordController = TextEditingController();
  TextEditingController memberTypeController = TextEditingController();

  _signup() async {
    var res = await adminSignup(
        memberNameController.text,
        memberPhoneController.text,
        memberPasswordController.text,
        memberTypeController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Member Added. ID: ' + resmap['msg'], context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Admin Signup"),
        ]),
        leading: IconButton(
            onPressed: () => gotoAdminHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberNameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member Name:',
                  hintText: 'Enter Member Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: memberPasswordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member Password:',
                  hintText: 'Enter Member Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: memberPhoneController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member Phone:',
                  hintText: 'Enter Member Phone'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: memberTypeController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member Type:',
                  hintText: 'Enter Member Type'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _signup, child: const Text('Signup')),
          ],
        ),
      ),
    );
  }
}

class AdminOperatorRenewal extends StatefulWidget {
  const AdminOperatorRenewal({Key? key}) : super(key: key);
  @override
  State<AdminOperatorRenewal> createState() => _AdminOperatorRenewalState();
}

class _AdminOperatorRenewalState extends State<AdminOperatorRenewal> {
  TextEditingController memberIDController = TextEditingController();

  _signup() async {
    var res = await adminOperatorRenewal(memberIDController.text);
    Map<String, dynamic> resmap = jsonDecode(res.body);
    if (resmap['status'] == 'ok') {
      messageDialog('Operator Renewed', context);
    } else {
      errorDialog(res.statusCode, resmap['status'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Admin Operator Renewal"),
        ]),
        leading: IconButton(
            onPressed: () => gotoAdminHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberIDController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member ID:',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _signup, child: const Text('Operator Renewal')),
          ],
        ),
      ),
    );
  }
}

class AdminPrintCard extends StatefulWidget {
  const AdminPrintCard({Key? key}) : super(key: key);
  @override
  State<AdminPrintCard> createState() => _AdminPrintCardState();
}

class _AdminPrintCardState extends State<AdminPrintCard> {
  TextEditingController printCardController = TextEditingController();

  _printCard() async {
    var res = await adminPrintCard(printCardController.text);
    if (res.statusCode != 200) {
      Map<String, dynamic> resmap = jsonDecode(res.body);
      errorDialog(res.statusCode, resmap['status'], context);
    } else {
      messageDialog('Downloading...', context);
      final rawData = res.bodyBytes;
      final content = base64Encode(rawData);
      final anchor = html.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", "card.pdf")
        ..click();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Text(libraryName),
          Text("Admin Print Card"),
        ]),
        leading: IconButton(
            onPressed: () => gotoAdminHome(context),
            icon: const Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: printCardController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Member ID:',
                  hintText: 'Enter Member ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _printCard, child: const Text('Print Card')),
          ],
        ),
      ),
    );
  }
}
