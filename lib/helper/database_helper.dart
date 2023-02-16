import 'package:duetstahall/data/model/response/request_phone_model.dart';
import 'package:duetstahall/data/model/response/room_model.dart';
import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/helper/database/table_column.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();

  factory DatabaseHelper() => _databaseService;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'duetStaDatabase.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {STUDENT} TABLE statement on the database.
    await db.execute(createTableStudent);
    // Run the CREATE {ROOM} TABLE statement on the database.
    await db.execute(createTableRoom);
    // Run the CREATE {REQUEST PHONE NO} TABLE statement on the database.
    await db.execute(createTableRequestPhoneNo);
  }

  // // Define a function that inserts Student into the database
  // Future<int> insertStudent(StudentModel studentModel) async {
  //   // Get a reference to the database.
  //   final db = await _databaseService.database;
  //
  //   // Insert the Breed into the correct table. You might also specify the
  //   // `conflictAlgorithm` to use in case the same breed is inserted twice.
  //   //
  //   // In this case, replace any previous data.
  //   return await db.insert(tableStudent, studentModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  Future<int> insertRoom(RoomModel roomModel) async {
    final db = await _databaseService.database;
    return await db.insert(tableRoom, roomModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertRequestPhone(RequestPhoneModel requestPhoneModel) async {
    final db = await _databaseService.database;
    await db.insert(tableRequestPhoneNo, requestPhoneModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // A method that retrieves all the Students from the breeds table.
  Future<List<StudentModel>> allStudents() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the StudentModel.
    final List<Map<String, dynamic>> maps = await db.query(tableStudent);

    // Convert the List<Map<String, dynamic> into a List<StudentModel>.
    return List.generate(maps.length, (index) => StudentModel.fromMap(maps[index]));
  }

  Future<List<String>> selectItems(String studentID) async {
    final db = await _databaseService.database;
    String query = """SELECT $columnStudentID from $tableStudent where $columnStudentID like '$studentID%'""";

    final usersData = await db.rawQuery(query);
    return usersData.map((Map<String, dynamic> row) {
      return row[columnStudentID].toString();
    }).toList();
  }

  Future<StudentModel> studentByID(int studentID) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableStudent, where: '$columnStudentID = ?', whereArgs: [studentID]);
    return StudentModel.fromMap(maps[0]);
  }

  Future<List<RoomModel>> allRooms() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableRoom);
    return List.generate(maps.length, (index) => RoomModel.fromMap(maps[index]));
  }

  allRoomSummeryByYearFloor(int year, int floor) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableRoom,
        where: '$columnYear = ? AND $columnFloorID = ?', whereArgs: [year, floor], columns: [columnID, columnRoomID, columnTotalStudents]);
    print(maps);
    // return List.generate(maps.length, (index) => RoomModel.fromMap(maps[index]));
  }

  void getRoomStudentInformation(int roomNo) async {
    final db = await _databaseService.database;
    String query =
        """SELECT std.$columnStudentID, std.$columnName, std.$columnDepartment FROM $tableStudent as std INNER JOIN $tableRoom as room
    ON std.$columnUserRoll==room.$columnStudent1 OR std.$columnUserRoll==room.$columnStudent2 OR std.$columnUserRoll==room.$columnStudent3 
    OR std.$columnUserRoll==room.$columnStudent4 OR std.$columnUserRoll==room.$columnStudent5 OR std.$columnUserRoll==room.$columnStudent6 
    OR std.$columnUserRoll==room.$columnExtraStudent where room.$columnRoomID==$roomNo""";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    // return List.generate(maps.length, (index) => RoomModel.fromMap(maps[index]));
    print(maps);
  }
}
