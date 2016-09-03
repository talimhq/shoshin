# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160902223636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ability_items", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "position"
    t.integer  "ability_set_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["ability_set_id"], name: "index_ability_items_on_ability_set_id", using: :btree
  end

  create_table "ability_sets", force: :cascade do |t|
    t.integer  "ability_items_count", default: 0, null: false
    t.string   "name",                            null: false
    t.integer  "position"
    t.integer  "teaching_cycle_id",               null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["teaching_cycle_id"], name: "index_ability_sets_on_teaching_cycle_id", using: :btree
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "user_type"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_accounts_on_unlock_token", unique: true, using: :btree
    t.index ["user_type", "user_id"], name: "index_accounts_on_user_type_and_user_id", unique: true, using: :btree
  end

  create_table "answers_associations", force: :cascade do |t|
    t.string   "left",        null: false
    t.string   "right",       null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_answers_associations_on_question_id", using: :btree
  end

  create_table "answers_categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_answers_categories_on_question_id", using: :btree
  end

  create_table "answers_category_items", force: :cascade do |t|
    t.string   "content",             null: false
    t.integer  "answers_category_id", null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["answers_category_id"], name: "index_answers_category_items_on_answers_category_id", using: :btree
  end

  create_table "answers_file_uploads", force: :cascade do |t|
    t.string   "file_format", null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_answers_file_uploads_on_question_id", using: :btree
  end

  create_table "answers_inputs", force: :cascade do |t|
    t.string   "content",     null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_answers_inputs_on_question_id", using: :btree
  end

  create_table "answers_multiple_choices", force: :cascade do |t|
    t.string   "content",                     null: false
    t.boolean  "correct",     default: false, null: false
    t.integer  "question_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["question_id"], name: "index_answers_multiple_choices_on_question_id", using: :btree
  end

  create_table "answers_single_choices", force: :cascade do |t|
    t.string   "content",                     null: false
    t.boolean  "correct",     default: false, null: false
    t.integer  "question_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["question_id"], name: "index_answers_single_choices_on_question_id", using: :btree
  end

  create_table "authorships", force: :cascade do |t|
    t.integer  "teacher_id",    null: false
    t.string   "editable_type", null: false
    t.integer  "editable_id",   null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["editable_id", "teacher_id", "editable_type"], name: "index_authorships_on_teacher_and_editable", unique: true, using: :btree
    t.index ["editable_type", "editable_id"], name: "index_authorships_on_editable_type_and_editable_id", using: :btree
    t.index ["teacher_id"], name: "index_authorships_on_teacher_id", using: :btree
  end

  create_table "chapter_exercises", force: :cascade do |t|
    t.integer  "chapter_id",              null: false
    t.integer  "exercise_id",             null: false
    t.integer  "position"
    t.integer  "max_tries",   default: 0, null: false
    t.datetime "due_date"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["chapter_id"], name: "index_chapter_exercises_on_chapter_id", using: :btree
    t.index ["exercise_id", "chapter_id"], name: "index_chapter_exercises_on_exercise_id_and_chapter_id", unique: true, using: :btree
    t.index ["exercise_id"], name: "index_chapter_exercises_on_exercise_id", using: :btree
  end

  create_table "chapter_lessons", force: :cascade do |t|
    t.integer  "chapter_id", null: false
    t.integer  "lesson_id",  null: false
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_chapter_lessons_on_chapter_id", using: :btree
    t.index ["lesson_id", "chapter_id"], name: "index_chapter_lessons_on_lesson_id_and_chapter_id", unique: true, using: :btree
    t.index ["lesson_id"], name: "index_chapter_lessons_on_lesson_id", using: :btree
  end

  create_table "chapters", force: :cascade do |t|
    t.integer  "group_id",                    null: false
    t.string   "name",                        null: false
    t.integer  "position"
    t.integer  "lessons_count",   default: 0, null: false
    t.integer  "exercises_count", default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["group_id"], name: "index_chapters_on_group_id", using: :btree
  end

  create_table "classrooms", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "level_id",                   null: false
    t.integer  "school_id",                  null: false
    t.integer  "students_count", default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["level_id"], name: "index_classrooms_on_level_id", using: :btree
    t.index ["school_id", "name"], name: "index_classrooms_on_school_id_and_name", unique: true, using: :btree
    t.index ["school_id"], name: "index_classrooms_on_school_id", using: :btree
  end

  create_table "core_components", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cycles", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "editable_levels", force: :cascade do |t|
    t.string   "editable_type", null: false
    t.integer  "editable_id",   null: false
    t.integer  "level_id",      null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["editable_id", "editable_type", "level_id"], name: "index_editable_levels_on_editable_and_level", unique: true, using: :btree
    t.index ["editable_type", "editable_id"], name: "index_editable_levels_on_editable_type_and_editable_id", using: :btree
    t.index ["level_id"], name: "index_editable_levels_on_level_id", using: :btree
  end

  create_table "exercises", force: :cascade do |t|
    t.string   "name",                              null: false
    t.text     "statement"
    t.integer  "time",              default: 10,    null: false
    t.integer  "popularity",        default: 0,     null: false
    t.integer  "authorships_count", default: 0,     null: false
    t.boolean  "exam",              default: false, null: false
    t.integer  "original_id"
    t.integer  "difficulty",        default: 2,     null: false
    t.boolean  "shared",            default: true,  null: false
    t.integer  "teaching_id",                       null: false
    t.integer  "questions_count",   default: 0,     null: false
    t.integer  "old_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["old_id"], name: "index_exercises_on_old_id", using: :btree
    t.index ["teaching_id"], name: "index_exercises_on_teaching_id", using: :btree
  end

  create_table "expectations", force: :cascade do |t|
    t.string   "name",                              null: false
    t.integer  "theme_id",                          null: false
    t.integer  "knowledge_items_count", default: 0, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["theme_id"], name: "index_expectations_on_theme_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "teaching_id", null: false
    t.integer  "level_id",    null: false
    t.integer  "teacher_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["level_id"], name: "index_groups_on_level_id", using: :btree
    t.index ["teacher_id"], name: "index_groups_on_teacher_id", using: :btree
    t.index ["teaching_id"], name: "index_groups_on_teaching_id", using: :btree
  end

  create_table "knowledge_items", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "expectation_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["expectation_id"], name: "index_knowledge_items_on_expectation_id", using: :btree
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name",                             null: false
    t.integer  "old_id"
    t.integer  "original_id"
    t.integer  "popularity",        default: 0,    null: false
    t.boolean  "shared",            default: true, null: false
    t.integer  "steps_count",       default: 0,    null: false
    t.integer  "authorships_count", default: 0,    null: false
    t.integer  "teaching_id",                      null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["old_id"], name: "index_lessons_on_old_id", using: :btree
    t.index ["original_id"], name: "index_lessons_on_original_id", using: :btree
    t.index ["teaching_id"], name: "index_lessons_on_teaching_id", using: :btree
  end

  create_table "levels", force: :cascade do |t|
    t.integer  "cycle_id",   null: false
    t.integer  "position"
    t.string   "name",       null: false
    t.string   "short_name", null: false
    t.string   "level_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cycle_id"], name: "index_levels_on_cycle_id", using: :btree
  end

  create_table "parents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "exercise_id", null: false
    t.integer  "position"
    t.string   "type",        null: false
    t.text     "content",     null: false
    t.text     "help"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["exercise_id"], name: "index_questions_on_exercise_id", using: :btree
  end

  create_table "school_teachers", force: :cascade do |t|
    t.integer  "school_id",                  null: false
    t.integer  "teacher_id",                 null: false
    t.boolean  "approved",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["school_id"], name: "index_school_teachers_on_school_id", using: :btree
    t.index ["teacher_id"], name: "index_school_teachers_on_teacher_id", unique: true, using: :btree
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "identifier",                 null: false
    t.string   "country",                    null: false
    t.string   "state",                      null: false
    t.string   "city",                       null: false
    t.string   "website"
    t.string   "email"
    t.integer  "teachers_count", default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["city", "state", "country"], name: "index_schools_on_city_and_state_and_country", using: :btree
    t.index ["country"], name: "index_schools_on_country", using: :btree
    t.index ["identifier"], name: "index_schools_on_identifier", unique: true, using: :btree
    t.index ["state", "country"], name: "index_schools_on_state_and_country", using: :btree
  end

  create_table "steps", force: :cascade do |t|
    t.integer  "lesson_id",  null: false
    t.string   "title"
    t.text     "content",    null: false
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_steps_on_lesson_id", using: :btree
  end

  create_table "student_groups", force: :cascade do |t|
    t.integer  "student_id", null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "student_id"], name: "index_student_groups_on_group_id_and_student_id", unique: true, using: :btree
    t.index ["group_id"], name: "index_student_groups_on_group_id", using: :btree
    t.index ["student_id"], name: "index_student_groups_on_student_id", using: :btree
  end

  create_table "students", force: :cascade do |t|
    t.integer  "classroom_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_students_on_classroom_id", using: :btree
  end

  create_table "teacher_teaching_cycles", force: :cascade do |t|
    t.integer  "teacher_id",        null: false
    t.integer  "teaching_cycle_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["teacher_id", "teaching_cycle_id"], name: "index_teacher_teaching_cycles_on_teacher_and_teaching_cycle", unique: true, using: :btree
    t.index ["teacher_id"], name: "index_teacher_teaching_cycles_on_teacher_id", using: :btree
    t.index ["teaching_cycle_id"], name: "index_teacher_teaching_cycles_on_teaching_cycle_id", using: :btree
  end

  create_table "teachers", force: :cascade do |t|
    t.boolean  "approved",   default: false, null: false
    t.boolean  "admin",      default: false, null: false
    t.integer  "old_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["old_id"], name: "index_teachers_on_old_id", using: :btree
  end

  create_table "teaching_cycles", force: :cascade do |t|
    t.integer  "teaching_id", null: false
    t.integer  "cycle_id",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["cycle_id"], name: "index_teaching_cycles_on_cycle_id", using: :btree
    t.index ["teaching_id", "cycle_id"], name: "index_teaching_cycles_on_teaching_id_and_cycle_id", unique: true, using: :btree
    t.index ["teaching_id"], name: "index_teaching_cycles_on_teaching_id", using: :btree
  end

  create_table "teachings", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "short_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "theme_levels", force: :cascade do |t|
    t.integer  "theme_id",   null: false
    t.integer  "level_id",   null: false
    t.string   "kind",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level_id"], name: "index_theme_levels_on_level_id", using: :btree
    t.index ["theme_id"], name: "index_theme_levels_on_theme_id", using: :btree
  end

  create_table "themes", force: :cascade do |t|
    t.string   "name",                           null: false
    t.integer  "position"
    t.integer  "expectations_count", default: 0, null: false
    t.integer  "teaching_cycle_id",              null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["teaching_cycle_id"], name: "index_themes_on_teaching_cycle_id", using: :btree
  end

  create_table "user_exercise_forms", force: :cascade do |t|
    t.string   "user_type",                null: false
    t.integer  "user_id",                  null: false
    t.integer  "exercise_id",              null: false
    t.jsonb    "answers",     default: {}, null: false
    t.jsonb    "results",     default: {}, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["answers"], name: "index_user_exercise_forms_on_answers", using: :gin
    t.index ["exercise_id"], name: "index_user_exercise_forms_on_exercise_id", using: :btree
    t.index ["results"], name: "index_user_exercise_forms_on_results", using: :gin
    t.index ["user_type", "user_id"], name: "index_user_exercise_forms_on_user_type_and_user_id", using: :btree
  end

  add_foreign_key "ability_items", "ability_sets"
  add_foreign_key "ability_sets", "teaching_cycles"
  add_foreign_key "answers_associations", "questions"
  add_foreign_key "answers_categories", "questions"
  add_foreign_key "answers_category_items", "answers_categories"
  add_foreign_key "answers_file_uploads", "questions"
  add_foreign_key "answers_inputs", "questions"
  add_foreign_key "answers_multiple_choices", "questions"
  add_foreign_key "answers_single_choices", "questions"
  add_foreign_key "authorships", "teachers"
  add_foreign_key "chapter_exercises", "chapters"
  add_foreign_key "chapter_exercises", "exercises"
  add_foreign_key "chapter_lessons", "chapters"
  add_foreign_key "chapter_lessons", "lessons"
  add_foreign_key "chapters", "groups"
  add_foreign_key "classrooms", "levels"
  add_foreign_key "classrooms", "schools"
  add_foreign_key "editable_levels", "levels"
  add_foreign_key "exercises", "teachings"
  add_foreign_key "expectations", "themes"
  add_foreign_key "groups", "levels"
  add_foreign_key "groups", "teachers"
  add_foreign_key "groups", "teachings"
  add_foreign_key "knowledge_items", "expectations"
  add_foreign_key "lessons", "teachings"
  add_foreign_key "levels", "cycles"
  add_foreign_key "questions", "exercises"
  add_foreign_key "school_teachers", "schools"
  add_foreign_key "school_teachers", "teachers"
  add_foreign_key "steps", "lessons"
  add_foreign_key "student_groups", "groups"
  add_foreign_key "student_groups", "students"
  add_foreign_key "students", "classrooms"
  add_foreign_key "teacher_teaching_cycles", "teachers"
  add_foreign_key "teacher_teaching_cycles", "teaching_cycles"
  add_foreign_key "teaching_cycles", "cycles"
  add_foreign_key "teaching_cycles", "teachings"
  add_foreign_key "theme_levels", "levels"
  add_foreign_key "theme_levels", "themes"
  add_foreign_key "themes", "teaching_cycles"
  add_foreign_key "user_exercise_forms", "exercises"
end
