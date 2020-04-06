library(tidyr)
library(dplyr)
library(readxl)
library(readr)

# скачиваем файл
# скачиваем файл из интернета
download.file("https://github.com/selesnow/r4excel_users/blob/master/lesson_9/sales.xlsx?raw=true", 
              destfile = "sales.xlsx", 
              mode = "wb")

# загрузка данных
data <- read_excel('sales.xlsx', 
                   sheet = 'data')

# ==================
# Задача: сравнить среднемесячные продажи между регионами
# в первом квартале 2019 и 2020 года
# ==================

# заполняем стобец region
data <- fill(data, region, .direction = 'down')

# приводим таблицу в правильный вид
data <- pivot_longer(
              data, 
              cols = `january 2019`:`march 2020`, 
              names_to  = 'month', 
              values_to = 'sales')

# разделим столбец month на год и месяц
data <- separate(data, 
                 col = 'month', 
                 into = c('month', 'year'), 
                 remove = TRUE, sep = " ")

# финальные рассчёты
data <-
  data %>%
    filter(month %in% c('january', 'february', 'march')) %>%
    group_by(region, year) %>%
    summarise(sales = mean(sales))

# расширяем таблицу
data %>%
  pivot_wider(names_from = year, 
              values_from  = sales) %>%
  mutate(grow = (`2020` - `2019`) / `2020` * 100) %>%
  arrange(desc(grow))

# запишем всё через пайплайны
read_excel('sales.xlsx', 
           sheet = 'data') %>%
  fill(region, 
           .direction = 'down') %>%
  pivot_longer(
           cols = `january 2019`:`march 2020`, 
           names_to  = 'month', 
           values_to = 'sales') %>%
  separate(col = 'month', 
           into = c('month', 'year'), 
           remove = TRUE, sep = " ") %>%
  filter(month %in% c('january', 'february', 'march')) %>%
  group_by(region, year) %>%
  summarise(sales = mean(sales)) %>%
  pivot_wider(names_from = year, 
              values_from  = sales) %>%
  mutate(grow = (`2020` - `2019`) / `2020` * 100) %>%
  arrange(desc(grow))


# ###############################
# Спецификации
# Задача: посчитать % возвратов от суммы продажи
# ###############################
shop_data_2019 <- read_delim(
                    'https://raw.githubusercontent.com/selesnow/r4excel_users/master/lesson_9/shop_data_2019.csv',
                    delim = ';', locale = locale(decimal_mark = ",") )

# строим спецификацию
wild_spec <- build_wider_spec(shop_data_2019, 
                              names_from = 'key', 
                              values_from = 'value')

# применяем спецификацию
pivot_wider_spec(shop_data_2019, spec = wild_spec) %>%
  mutate(refund_rate = refund / ( sale + upsale )) %>%
  arrange(desc(refund_rate))

# читаем данные аналогичой структуры
shop_data_2020 <- read_delim(
                    'https://raw.githubusercontent.com/selesnow/r4excel_users/master/lesson_9/shop_data_2020.csv',
                    delim = ';', locale = locale(decimal_mark = ","))

# применяем спецификацию
shop_data_2020 %>%
  pivot_wider_spec(spec = wild_spec) %>%
  mutate(refund_rate = refund / ( sale + upsale )) %>%
  arrange(desc(refund_rate))

# сохранить спецификацию
saveRDS(object = wild_spec, file = 'spec.rds')

# загрузить спецификацию
new_wild_spec <- readRDS('spec.rds')

# применяем
pivot_wider_spec(shop_data_2019, spec = new_wild_spec) %>%
  mutate(refund_rate = refund / ( sale + upsale )) %>%
  arrange(desc(refund_rate))
