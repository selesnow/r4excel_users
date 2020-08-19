# Загрузка данных в R
# Установка пакетов
install.packages("vroom")
install.packages("readxl")
install.packages("devtools")
devtools::install_github("tidyverse/googlesheets4") #подключаем пакет напрямую с гитхаба
 
# ###########################################
# подключение пакетов
library("vroom")


# ###########################################
# Чтение CSV, TSV и прочих текстовых файлов

## чтение локальных файлов и его загрузка в объект
ga_data <- vroom(file = "D:/materials/lesson_3/ga_nowember.csv", delim = "/t") #данные разделены табуляцией
## чтение файлов опубликованных в интернете (репозиторий на ГитХабе)
ga_data_i <- vroom("https://raw.githubusercontent.com/selesnow/publications/master/data_example/russian_text_in_r/ga_nowember.csv")

## чтение нескольких файлов в одну таблицу
files   <- dir(pattern = "\\.csv$") #создание вектора из имён файлов в папке
ga_full <- vroom(files) #создание объекта с данными, загруженными из вектора


# ###########################################
# Чтение Excel файлов
library(readxl)

## получить список листов из Excel файла
excel_sheets("D:/materials/lesson_3/ga_examples.xlsx") #в указанном документе excel

## считать данные с листа
xl_dec <- read_excel("D:/materials/lesson_3/ga_examples.xlsx", sheet = "dec") #(путь и лист) считываем и записываем в объект, МОЖНО ЛИ ДВА ЛИСТА???

# ###########################################
# Чтение Google Таблиц
library(googlesheets4)

## Авторизация
sheets_auth(email = "selesnow@gmail.com")
sheets_find()  #в () указаываем почту без кавычек или способ ниже
## Подклбчение к доксу
ss_id <- as_sheets_id("1xu_beKZVpJJTHTvAab_vN3ZiMB03BytKArGjJUO8cck") #ключ - ссылка до слеша на документ

## открыть докс в браузере
sheets_browse(ss)

## посмотреть список листов
sheets_sheet_names(ss)

## получить данные из листа
gs_ga_data <- sheets_read(ss = ss_id, 
                          sheet = "dec") #аргумент ссылки на файл, страница документа

## получить данные из диапазона на листе
gs_ga_data <- sheets_read(ss = ss, 
                          sheet = "dec", 
                          range = "A1:C10") 
