library(ggplot2)
library(dplyr)
library(readr)
library(forcats)

# чтение данных
data <- read_tsv('https://raw.githubusercontent.com/selesnow/r4excel_users/master/lesson_12/sales.csv')

# структура данных
data
str(data)

# продажи по месяцам, столбчатая диаграмма
data %>%
  mutate(month = format(date, "%Y-%m")) %>%
  group_by(month) %>%
  summarise(transactions = n_distinct(id)) %>%
  ggplot( aes(x = month, y = transactions) ) +  # основной слой
    geom_col( aes( fill = transactions ),       # слой столбцатой диаграммы
              show.legend = FALSE) +
    labs(title = "Количество продаж за 2019 год", # заголовок
         subtitle = "по месяцам")  +              # подзаголовок
    xlab("Месяц") +                               # подпись X
    ylab("Количество продаж") +                   # подпись y
  scale_fill_gradient2(low = "red",             # цвет заливки, минимального значения
                       mid = "gray",            #               средние значения
                       midpoint = 81.5,         #               что считать средним значением
                       high = "limegreen")      #               максимальные значения

# Динамика продаж по менеджерам
# задаём все настройки через главный слой
data %>%
  mutate(month = format(date, "%Y-%m")) %>%
  group_by(month, manager_id) %>%
  summarise(sales_sum = sum(summ)) %>%
  ggplot( aes(x = month, 
              y = sales_sum, 
              group = manager_id,
              colour = manager_id) ) + 
    geom_line( size = 0.1 ) +
    geom_point( size = 1  ) 

# переносим настройки в отдельные слои
data %>%
  mutate(month = format(date, "%Y-%m")) %>%
  group_by(month, manager_id) %>%
  summarise(sales_sum = sum(summ)) %>%
  ggplot( aes(x = month, 
              y = sales_sum) ) + 
  geom_line( aes(group = manager_id, 
                 colour = manager_id) ) +
  geom_point( aes(group = manager_id, 
                  colour = manager_id) ) 

# разбиваем на графики
data %>%
  group_by( id, shop ) %>%
  summarise( count = sum(count) ) %>%
  ggplot( aes(x = count) ) +
    geom_histogram(fill = "cyan3", color = "cyan4") +
    facet_grid( ~shop )

# переворачиваем график
data %>%
  group_by(id, manager_id) %>%
  summarise(transaction_summ = sum(summ)) %>%
  group_by(manager_id) %>%
  summarise(avg_summ = mean(transaction_summ)) %>%
  ggplot( aes(x = fct_reorder(.f = manager_id,
                              .x = avg_summ, 
                              .fun = median), 
              y = avg_summ) ) +
    geom_bar(aes(fill = avg_summ), 
             show.legend = FALSE,
             stat = "identity") +
    coord_flip() + # переворачиваем график
    scale_fill_gradient(low = "coral1", high = "limegreen") +
    xlab("Менеджер") +
    ylab("Средний чек") +
    labs(title = "Средний чек за 2019 год", # заголовок
         subtitle = "по менеджерам")
