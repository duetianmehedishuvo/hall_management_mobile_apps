const String tableStudent = 'tableStudent';
const String tableRoom = 'tableRoom';
const String tableRequestPhoneNo = 'tableRequestPhoneNo';
const String columnID = 'id';
const String columnBloodGroup = 'bloodGroup';
const String columnUserRoll = 'userRoll';
const String columnStudentID = 'studentID';
const String columnPassword = 'password';
const String columnName = 'name';
const String columnImage = 'image';
const String columnDepartment = 'department';
const String columnPhoneNo = 'phoneNo';
const String columnAddress = 'address';
const String columnJobPosition = 'jobPosition';
const String columnAdmissionDate = 'admissionDate';
const String columnAboutMe = 'aboutMe';
const String columnUserRequestStatus = 'userRequestStatus';
const String columnRequestUserID = 'requestUserID';
const String columnRoomID = 'roomID';
const String columnYear = 'year';
const String columnStudent1 = 'student1';
const String columnStudent2 = 'student2';
const String columnStudent3 = 'student3';
const String columnStudent4 = 'student4';
const String columnStudent5 = 'student5';
const String columnStudent6 = 'student6';
const String columnExtraStudent = 'extraStudent';
const String columnTotalStudents = 'totalStudents';
const String columnFloorID = 'floorID';

const String createTableRoom = '''
      CREATE TABLE $tableRoom(
      $columnID INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnRoomID INTEGER, 
      $columnYear INTEGER, 
      $columnStudent1 TEXT, 
      $columnStudent2 TEXT, 
      $columnStudent3 TEXT, 
      $columnStudent4 TEXT, 
      $columnStudent5 TEXT, 
      $columnStudent6 TEXT, 
      $columnExtraStudent TEXT, 
      $columnTotalStudents INTEGER, 
      $columnFloorID INTEGER)
      ''';

const String createTableStudent = '''
      CREATE TABLE $tableStudent(
      $columnID INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnUserRoll INTEGER, 
      $columnStudentID INTEGER, 
      $columnImage TEXT, 
      $columnBloodGroup TEXT, 
      $columnDepartment TEXT, 
      $columnName TEXT, 
      $columnPassword TEXT, 
      $columnPhoneNo TEXT, 
      $columnAddress TEXT, 
      $columnJobPosition TEXT, 
      $columnAdmissionDate TEXT, 
      $columnAboutMe TEXT)
      ''';

const String createTableRequestPhoneNo = '''
      CREATE TABLE $tableRequestPhoneNo(
      $columnID INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnStudentID INTEGER, 
      $columnRequestUserID INTEGER, 
      $columnUserRequestStatus INTEGER)
      ''';
