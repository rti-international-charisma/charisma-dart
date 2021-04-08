
import 'package:charisma/account/login_page_widget.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

void main() {

  ApiClient apiClient = MockApiClient();
  MockRouterDelegate routerDelegate = MockRouterDelegate();

  testWidgets('should render form fields', (WidgetTester tester) async {

    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterial());

    expect(find.byKey(ValueKey('LoginUNameKey')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginPWordKey')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginForgotPWordKey')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginLoginBtnKey')), findsOneWidget);
  });

  testWidgets('tapping on register now should take to Signup page', (WidgetTester tester) async {

    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterialMockRouter(routerDelegate));

    await tester.tap(find.byKey(ValueKey('LoginRegisterBtnKey')), warnIfMissed: false);
    await tester.pump();

    verify (routerDelegate.push(SignUpConfig));
  });

  testWidgets('tapping on forgot password should take to Reset Password page', (WidgetTester tester) async {

    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterialMockRouter(routerDelegate));

    await tester.tap(find.byKey(ValueKey('LoginForgotPWordKey')), warnIfMissed: false);
    await tester.pump();

    verify (routerDelegate.push(ForgotPasswordConfig));
  });

  testWidgets('should show error if username is empty', (WidgetTester tester) async {

    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('LoginPWordKey')), 'password');
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('LoginLoginBtnKey')), warnIfMissed: false);
    await tester.pump();

    expect(find.text('Cannot be empty'), findsOneWidget);
  });

  testWidgets('should show error if password is empty', (WidgetTester tester) async {

    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('LoginUNameKey')), 'username');
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('LoginLoginBtnKey')), warnIfMissed: false);
    await tester.pump();

    expect(find.text('Cannot be empty'), findsOneWidget);
  });
/*
  testWidgets('should show error if login fails', (WidgetTester tester) async {

    var username = 'username';
    var password = 'password';
    Map<String, dynamic> loginData = <String, dynamic>{
      "username": username,
      "password": password
    };

    when(apiClient.post<Map<String,dynamic>>('/login', loginData))
        .thenAnswer(
            (invocation) => Future<Map<String, dynamic>>.value(<String, dynamic>{"s":"b"})
    );

    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('LoginUNameKey')), username);
    await tester.pump();

    await tester.enterText(find.byKey(ValueKey('LoginPWordKey')), password);
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('LoginLoginBtnKey')), warnIfMissed: false);
    await tester.pump();

    expect(find.text('some error'), findsOneWidget);
  });
  */

}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
    providers: [
      InheritedProvider<CharismaRouterDelegate>(
          create: (ctx) => CharismaRouterDelegate(MockApiClient())
      )
    ],
    child: MaterialApp(
        home: Scaffold(
          body: this,
        )),
  );
}

extension on Widget {
  Widget wrapWithMaterialMockRouter(MockRouterDelegate routerDelegate) => MultiProvider(
    providers: [
      InheritedProvider<CharismaRouterDelegate>(
          create: (ctx) => routerDelegate
      )
    ],
    child: MaterialApp(
        home: Scaffold(
          body: this,
        )),
  );
}

class MockApiClient extends Mock implements ApiClient{}

class MockRouterDelegate extends Mock implements CharismaRouterDelegate{}