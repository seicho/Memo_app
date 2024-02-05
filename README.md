# Memo_app 
This is a simple memo app with postgresql.
## Getting Started
1. $bundle install
2. $sudo chmod u+x ./db/build_db.sh
3. Start postgresql server.
4. $./db/build_db.sh
    * sudo and postgres password required.
    * This script will create database and table as an user(:postgres).
5. $ruby memo_app.rb
4. access http://localhost:4567/
5. login with username.
   * Password isn't required.
   ![image](https://github.com/seicho/Memo_app/assets/16710992/ca7dff61-44c9-4e5d-aae2-a8461a170616)
