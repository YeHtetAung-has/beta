import 'package:beta/core/dateutils.dart';
import 'package:beta/models/dailyprogress_model.dart';
import 'package:beta/models/goal_model.dart';
import 'package:beta/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHepler {
  static Database? db;

  //singleton pattern
  static final DBHepler _instance = DBHepler._init();
  DBHepler._init();

  //Get database instance
  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDB('beta.db');
    return db!;
  }

  //Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //Create database
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        completedAt TEXT
      )
    ''');

    // DAILY PROGRESS TABLE
    await db.execute('''
      CREATE TABLE daily_progress(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        completedTasks INTEGER NOT NULL
      )
    ''');
  }

  static Future<int> insertTask(Task task) async {
    final db = await _instance.database;
    return await db.insert('tasks', task.toMap());
  }

  // ==========================
  // GET ALL TASKS
  // ==========================

  Future<List<Task>> getTasks() async {
    final db = await database;

    final result = await db.query('tasks', orderBy: 'id DESC');

    return result.map((e) => Task.fromMap(e)).toList();
  }

  // ==========================
  // GET ALL TASKS BY COMPLETION STATUS
  // ==========================
  Future<List<Task>> getTasksByActiveStatus(bool isCompleted) async {
    final db = await database;

    final result = await db.query(
      'tasks',
      where: 'isCompleted = 0',
      orderBy: 'id DESC',
    );

    return result.map((e) => Task.fromMap(e)).toList();
  }

  // ==========================
  // UPDATE TASK
  // ==========================

  Future<int> updateTask(Task task) async {
    final db = await database;

    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // ==========================
  // COMPLETE TASK
  // ==========================

  Future<void> completeTask(Task task) async {
    final db = await database;

    Task completedTask = task.copyWith(
      isCompleted: true,
      completedAt: task.completedAt,
    );

    await db.update(
      'tasks',
      completedTask.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

    await updateDailyProgress();
  }

  // ==========================
  // DELETE TASK
  // ==========================

  Future<int> deleteTask(int id) async {
    final db = await database;

    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================
  // DAILY PROGRESS
  // ==========================
  Future<void> updateDailyProgress() async {
    final db = await database;

    final String today = DateUtilsHelper.todayDb();

    final int completedCount =
        Sqflite.firstIntValue(
          await db.rawQuery(
            '''
          SELECT COUNT(*)
          FROM tasks
          WHERE isCompleted = 1
          AND completedAt = ?
          ''',
            [today],
          ),
        ) ??
        0;

    final progress = DailyProgress(date: today, completedTasks: completedCount);

    await db.insert(
      'daily_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DailyProgress?> getTodayProgress() async {
    final db = await database;

    final result = await db.query(
      'daily_progress',
      where: 'date = ?',
      whereArgs: [DateUtilsHelper.todayDb()],
    );

    if (result.isEmpty) return null;

    return DailyProgress.fromMap(result.first);
  }

  Future<List<DailyProgress>> getDailyProgressHistory() async {
    final db = await database;

    final result = await db.query('daily_progress', orderBy: 'date DESC');

    return result.map((e) => DailyProgress.fromMap(e)).toList();
  }
}
