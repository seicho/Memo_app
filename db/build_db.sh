#!/bin/bash

sudo -u postgres psql -c 'create database memo_app'
psql -h localhost -p 5432 -d memo_app -U postgres -f ./db/postgres.sql
