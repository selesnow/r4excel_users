# install.packages('ggplot2)
library(ggplot2)
library(readr)
library(dplyr)
library(forcats)

# чтение данных
sales_data <- 
 read_csv2('https://raw.githubusercontent.com/selesnow/r4excel_users/master/lesson_11/sales_data.csv')

# график количества продаж по месяцам
sales_data %>%
  mutate(month = as.Date(date, '%d.%m.%Y') %>% format('%Y-%m')) %>%
  group_by(month) %>%
  count() %>%
  qplot(data = .,
        x = month,
        y = n,
        fill = 'darkcyan',
        geom = 'col',
        main = 'Продажи по месяцам',
        xlab = 'месяц', ylab = 'к-во продаж') 
  
# задаём цвет колонок в зависимости от значений
# график количества продаж по месяцам
sales_data %>%
  mutate(month = as.Date(date, '%d.%m.%Y') %>% format('%Y-%m')) %>%
  group_by(month) %>%
  count() %>%
  qplot(data = .,
        x = month,
        y = n,
        fill = n,
        geom = 'col',
        main = 'Продажи по месяцам',
        xlab = 'месяц', ylab = 'к-во продаж') 

# проанализируем количество продаж по магазинам
sales_data %>%
  mutate(month = as.Date(date, '%d.%m.%Y') %>% format('%Y-%m')) %>%
  group_by(month, shop) %>%
  count() %>%
  qplot(data = .,
        x = month,
        y = n,
        fill = shop,
        geom = 'col',
        group = 'shop',
        main = 'Продажи по месяцам',
        xlab = 'месяц', ylab = 'к-во продаж') 

# пример с линейным графиком geom
# посмотрим продажи в разрезе менеджеров по месяцам 
sales_data %>%
  mutate(month = as.Date(date, '%d.%m.%Y') %>% format('%Y-%m')) %>%
  group_by(month, manager) %>%
  summarise(sales = sum(sum)) %>%
  qplot(data = .,
        x = month,
        y = sales,
        group = manager,
        colour = manager,
        geom = c('line', 'point'),
        main = 'Динамика продаж по менеджерам',
        xlab = 'месяц', ylab = 'к-во продаж')

# boxplot
# проанализирум стоимость проданных ноутбуков по брендам
sales_data %>%
  qplot(data = .,
        x = brand,
        y = price - discount,
        geom = 'boxplot',
        main = 'Анализ продаж по брендам',
        xlab = 'бренд', ylab = 'цены')

# изменим сортировку брендов
sales_data %>%
  qplot(data = .,
        x = fct_reorder(.f = brand, 
                        .x = price - discount, 
                        .fun = median, 
                        .desc = T),
        y = price - discount,
        geom = 'boxplot',
        main = 'Анализ продаж по брендам',
        xlab = 'бренд', ylab = 'цены')

# проанализируем скидки по магазинам
sales_data %>%
  filter(discount > 0) %>%
  mutate(discount_rate = discount / price) %>%
  qplot(data = .,
        x = fct_reorder(.f = brand, .x = discount_rate, .fun = median, .desc = T),
        y = discount_rate,
        geom = 'boxplot')

# разбиваем на несколько графиков
sales_data %>%
  qplot(data = .,
        x = sum, 
        geom = 'histogram',
        fill = 'darkcyan',
        bins = 30, 
        facets = shop~.)

# разбиваем график по менеджерам и магазинам
sales_data %>%
  mutate(month = as.Date(date, '%d.%m.%Y') %>% format('%Y-%m')) %>%
  group_by(month, manager, shop) %>%
  count() %>%
  qplot(data = .,
        x = month,
        y = n,
        fill = shop,
        geom = 'col',
        group = 'shop', 
        facets = manager~shop,
        main = 'Продажи по месяцам, менеджерам и магазинам',
        xlab = 'месяц', ylab = 'к-во продаж') 
