class MyListModel {
  String title1 = 'Chapters';
  String title2 = 'Exams';
  String title3 = 'Test Scheme';

  List<Map<String, String>> chapterList = [
    {'title': 'Chapter 1', 'listType': 'questions'},
    {'title': 'Chapter 2', 'listType': 'questions'},
    {'title': 'Chapter 3', 'listType': 'questions'},
    {'title': 'Chapter 4', 'listType': 'questions'},
    {'title': 'Chapter 5', 'listType': 'questions'},
    {'title': 'Chapter 6', 'listType': 'questions'},
  ];
  List<Map<String, String>> examList = [
    {'title': 'Winter-2017', 'listType': 'questions'},
    {'title': 'Summer-2018', 'listType': 'questions'},
    {'title': 'Winter-2018', 'listType': 'questions'},
    {'title': 'Summer-2019', 'listType': 'questions'},
    {'title': 'Winter-2019', 'listType': 'questions'},
  ];
  List<Map<String, String>> testSchemeList = [
    {
      'title': '10 M.C.Q.\'s 15 Minutes',
      'hours': '0',
      'minutes': '15',
      'seconds': '0',
      'listType': 'test'
    },
    {
      'title': '20 M.C.Q.\'s 30 Minutes',
      'hours': '0',
      'minutes': '30',
      'seconds': '0',
      'listType': 'test'
    },
    {
      'title': '30 M.C.Q.\'s 45 Minutes',
      'hours': '0',
      'minutes': '45',
      'seconds': '0',
      'listType': 'test'
    },
  ];
}
