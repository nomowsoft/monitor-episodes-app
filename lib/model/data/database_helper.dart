import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static const databaseName = "maknoon.db";
  static const _databaseVersion = 1;

  static const tableEpisode = 'table_episode';
  // log
  static const logTableEpisode = 'log_table_episode';
  static const logTableStudentOfEpisode = 'log_table_student_of_episode';
  static const logTableStudentState = 'log_table_student_state';
  static const logTableStudentWork = 'log_table_student_work';

//================
  static const tableStudentOfEpisode = 'table_student_of_episode';
  static const tablePlanLines = 'table_planLines';
  static const tableListenLine = 'table_listenLine';
  static const tableEducationalPlan = 'table_educational_plan';
  static const tableStudentState = 'table_student_state';

  static const columnId = 'id';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    //Directory documentsDirectory = await getDatabasesPath();
    String path = p.join(await getDatabasesPath(), databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableEpisode (${EpisodeColumns.id.value} INTEGER PRIMARY KEY, ${EpisodeColumns.name.value} TEXT, ${EpisodeColumns.displayName.value} TEXT,${EpisodeColumns.typeEpisode.value} TEXT, ${EpisodeColumns.epsdType.value} TEXT '
        ', ${EpisodeColumns.epsdWork.value} TEXT)');
    await db.execute('CREATE TABLE $tableStudentOfEpisode ('
        '${StudentOfEpisodeColumns.id.value} INTEGER PRIMARY KEY,'
        '${StudentOfEpisodeColumns.age.value} INTEGER,'
        '${StudentOfEpisodeColumns.name.value} TEXT,'
        '${StudentOfEpisodeColumns.state.value} TEXT,'
        '${StudentOfEpisodeColumns.phone.value} TEXT,'
        '${StudentOfEpisodeColumns.address.value} TEXT,'
        '${StudentOfEpisodeColumns.gender.value} TEXT,'
        '${StudentOfEpisodeColumns.country.value} TEXT,'
        '${StudentOfEpisodeColumns.episodeId.value} INTEGER,'
        '${StudentOfEpisodeColumns.stateDate.value} TEXT,'
        'FOREIGN KEY (${StudentOfEpisodeColumns.episodeId.value}) REFERENCES $tableEpisode (${StudentOfEpisodeColumns.id.value}) ON DELETE NO ACTION ON UPDATE NO ACTION'
        ')');
    await db.execute('CREATE TABLE $tablePlanLines ('
        '${PlanLinesColumns.listen.value} TEXT,'
        '${PlanLinesColumns.reviewbig.value} TEXT,'
        '${PlanLinesColumns.reviewsmall.value} TEXT,'
        '${PlanLinesColumns.tlawa.value} TEXT,'
        '${PlanLinesColumns.studentId.value} INTEGER,'
        '${PlanLinesColumns.episodeId.value} INTEGER'
        ')');
    await db.execute('CREATE TABLE $tableStudentState ('
        'id INTEGER PRIMARY KEY,' 
        '${StudentStateColumns.studentId.value} INTEGER,'
        '${StudentStateColumns.state.value} TEXT,'
        '${StudentStateColumns.date.value} TEXT,'
        '${StudentStateColumns.episodeId.value} INTEGER'
        ')');
    await db.execute('CREATE TABLE $tableListenLine ('
        'id INTEGER PRIMARY KEY,'
        'student_id INTEGER,'
        '${ListenLineColumns.typeFollow.value} TEXT,'
        '${ListenLineColumns.actualDate.value} TEXT,'
        '${ListenLineColumns.fromSuraId.value} INTEGER,'
        '${ListenLineColumns.fromAya.value} INTEGER,'
        '${ListenLineColumns.toSuraId.value} INTEGER,'
        '${ListenLineColumns.toAya.value} INTEGER,'
        '${ListenLineColumns.totalMstkQty.value} INTEGER,'
        '${ListenLineColumns.totalMstkQlty.value} INTEGER,'
        '${ListenLineColumns.totalMstkRead.value} INTEGER'
        ')');
    await db.execute('CREATE TABLE $tableEducationalPlan ('
        '${EducationalPlanColumns.planListen.value} TEXT,'
        '${EducationalPlanColumns.planReviewbig.value} TEXT,'
        '${EducationalPlanColumns.planReviewSmall.value} TEXT,'
        '${EducationalPlanColumns.planTlawa.value} TEXT,'
        '${EducationalPlanColumns.studentId.value} INTEGER,'
        '${EducationalPlanColumns.episodeId.value} INTEGER'
        ')');

    // log tables
    await db.execute(
        'CREATE TABLE $logTableEpisode (IDs INTEGER PRIMARY KEY, ${EpisodeColumns.id.value} INTEGER, ${EpisodeColumns.name.value} TEXT, ${EpisodeColumns.typeEpisode.value} TEXT,${EpisodeColumns.operation.value} TEXT )');
    await db.execute(
        'CREATE TABLE $logTableStudentOfEpisode (IDs INTEGER PRIMARY KEY, ${EpisodeColumns.id.value} INTEGER, ${EpisodeColumns.name.value} TEXT, halaqa_id TEXT,mobile TEXT,country_id INTEGER,gender TEXT,is_hifz BOOLEAN,is_tilawa BOOLEAN,is_big_review BOOLEAN,is_small_review BOOLEAN,${EpisodeColumns.operation.value} TEXT )');

        await db.execute(
        'CREATE TABLE $logTableStudentState (id INTEGER PRIMARY KEY, student_id INTEGER, status TEXT, date_presence TEXT )');

        await db.execute(
        'CREATE TABLE $logTableStudentWork (id INTEGER PRIMARY KEY, student_id INTEGER, date_listen TEXT, type_work TEXT, from_sura INTEGER, to_sura INTEGER, from_aya INTEGER, to_aya INTEGER, nbr_error_hifz INTEGER, nbr_error_tajwed INTEGER)');
  }

  // Helper methods
  // Future<File> backup() async {
  // final dbFolder = await getApplicationSupportDirectory();
  // final dbLocation = p.join(await getDatabasesPath(), databaseName);
  // final File file = File(dbLocation);
  // return file;
  // await ShareExtend.share (file.path, "file");
  //  bool res = await FlutterShare.shareFile(
  //     title: "{$_databaseName}Backup.sqlite",
  //     //text: "free zone Backup Sql",
  //     filePath: file.path,
  //     //fileType: 'file'
  //   );
  // print(res);
  // }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int?> insert(tableName, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(tableName, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<Map<String, dynamic>?> queryRowByID(tableName, id) async {
    Database? db = await instance.database;
    var list =
        await db?.query(tableName, where: '$columnId = ?', whereArgs: [id]);
    return list?[0];
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>?> queryAllRows(
    tableName,
  ) async {
    Database? db = await instance.database;
    return await db?.query(tableName);
  }

  Future<List<Map<String, dynamic>>?> queryAllRowsWhere(
      tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return await db
        ?.query(tableName, where: '$nameColumn = ?', whereArgs: [value]);
  }

  Future<List<Map<String, dynamic>>?> queryAllRowsWhereTowColumns(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return await db?.query(tableName,
        where: '$column1 = ? AND $column2 = ?', whereArgs: [value1, value2]);
  }

  Future<List<Map<String, dynamic>>?> queryAllRowsWhereOR(
      tableName, column1, value1, value2) async {
    Database? db = await instance.database;
    return await db?.query(tableName,
        where: '$column1 = ? OR $column1 = ?', whereArgs: [value1, value2]);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount(tableName) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db?.rawQuery('SELECT COUNT(*) FROM $tableName') ?? []);
  }

  Future<int?> queryRowCountWhere(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            'SELECT COUNT(*) FROM $tableName WHERE $nameColumn = $value') ??
        []);
  }

  Future<int?> queryRowCountWhereString(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            "SELECT COUNT(*) FROM $tableName WHERE $nameColumn = '$value' ") ??
        []);
  }

  Future<int?> queryRowCountWhereNot(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            'SELECT COUNT(*) FROM $tableName WHERE $nameColumn != $value') ??
        []);
  }

  Future<int?> queryRowCountWhereAnd(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            "SELECT COUNT(*) FROM $tableName WHERE $column1 = $value1 AND $column2 = '$value2' ") ??
        []);
  }

  Future<int?> queryRowCountWhereAndInteger(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            "SELECT COUNT(*) FROM $tableName WHERE $column1 = $value1 AND $column2 = $value2 ") ??
        []);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int?> update(tableName, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db
        ?.update(tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> updateWhereAnd(tableName, Map<String, dynamic> row, column1,
      column2, value1, value2) async {
    Database? db = await instance.database;
    return await db?.update(tableName, row,
        where: '$column1 = ? AND $column2 = ?', whereArgs: [value1, value2]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int?> delete(tableName, int id) async {
    Database? db = await instance.database;
    return await db?.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> deleteAll(tableName) async {
    Database? db = await instance.database;
    return await db?.delete(tableName);
  }

  Future<int?> deleteAllWhere(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return await db
        ?.delete(tableName, where: '$nameColumn = ?', whereArgs: [value]);
  }

  Future<int?> deleteAllWhereAnd(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return await db?.delete(tableName,
        where: '$column1 = ? AND $column2 = ?', whereArgs: [value1, value2]);
  }
}
