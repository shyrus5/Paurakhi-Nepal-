part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}
class SearchInitialEvent extends SearchEvent{}

class SearchStartEvent extends SearchEvent{}