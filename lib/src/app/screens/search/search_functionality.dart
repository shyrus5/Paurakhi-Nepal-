import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paurakhi/main.dart';
import 'package:paurakhi/src/app/screens/search/search_dialog.dart';
import 'package:paurakhi/src/core/utils/searchwidget.dart';

import 'bloc/search_bloc.dart';
import 'domain/search_value.dart';
import 'search_widget.dart';

class SearchFunctionality extends StatelessWidget {
  const SearchFunctionality({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
          child: Column(children: [
        // --------------------------------------------------------------------- Search Widget
        searchFilterWidget(context, scaffoldKey),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    showOptionsDialog(context);
                  },
                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.green),
                  child: const Row(children: [Text("Filter"), Icon(Icons.arrow_drop_down_rounded)])),
              const SizedBox(width: 20),
            ],
          ),
        ),

        const SizedBox(child: Text("Search your desire product !")),

        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchStartState) {
              return SearchWidget(name: SearchValue.searchValue);
            }
            return const Text("dasdasdasd");
          },
        )
      ])),
    );
  }
}
