import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_state.dart';

enum AdminPage {
  allProduct,
  addAdmin,
}

class NavigationCubit extends Cubit<AdminPage> {
  NavigationCubit() : super(AdminPage.allProduct);

  void goTo(AdminPage page) => emit(page);
}
