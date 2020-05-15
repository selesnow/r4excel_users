#install.packages('devtools')
#devtools::install_github('cttobin/ggthemr')
library(ggplot2)
library(ggthemes)
library(ggthemr)
library(dplyr)
library(readr)

# чтение данных
data <- read_tsv('https://raw.githubusercontent.com/selesnow/r4excel_users/master/lesson_13/sales.csv')

# график
plot <- 
  # продажи по месяцам, столбчатая диаграмма
  data %>%
  mutate(month = format(date, "%Y-%m")) %>%
  group_by(month) %>%
  summarise(transactions = n_distinct(id)) %>%
  ggplot( aes(x = month, y = transactions) ) +  # основной слой
  geom_col( aes( fill = transactions) ) +      # слой столбцатой диаграммы
  labs(title = "Количество продаж за 2019 год", # заголовок
       subtitle = "по месяцам")  +              # подзаголовок
  xlab("Месяц") +                               # подпись X
  ylab("Количество продаж")                     # подпись y

# дабавим анотации
plot +
  annotate("text", x = '2019-05', y = 110, 
           label = "Top Sales", 
           colour = "red", 
           size = 4, 
           fontface = "bold") 

# применяем готовые темы
plot + theme_stata()
plot + theme_excel()
plot + theme_economist()
plot + theme_calc()

# темы из пакета ggthemr
ggthemr('flat dark')
plot

ggthemr('flat')
plot

ggthemr('camoflauge')
plot

ggthemr('solarized')
plot

ggthemr_reset() # сброс темы

# управление элементами дайджеста, слой theme
plot + 
  theme(
        legend.position = 'none',                           # убираем легенду
        title = element_text(colour = 'royalblue4',         # заголовок
                             face = 'bold'), 
        plot.subtitle = element_text(colour = 'royalblue3', # подзаголовок
                                     face = 'italic', ),
        axis.title = element_text(colour = 'gray28',        # названия осей
                                  face = 'bold.italic'), 
        axis.text.y = element_text(face = 'italic',         # значения оси y
                                   size = 7), 
        axis.text.x = element_text(angle = 90,              # поворачиваем подпись X
                                   hjust = 1, 
                                   vjust = 0.5, 
                                   size = 9), 
        panel.background = element_rect(fill = 'skyblue1'), # фон диаграммы 
        panel.border = element_rect(colour = 'dodgerblue4', # обводка диаграммы
                                     fill = NA),
        panel.grid = element_line(color = "skyblue4",       # сетка диаграммы
                                  size = 0.1, 
                                  linetype = 'dotted'), 
        plot.background = element_rect(fill = 'powderblue') # общий фон графика
        )

# сохраняем созданную тему
theme_custom_blue <- 
  theme(
    legend.position = 'none',                           # убираем легенду
    title = element_text(colour = 'royalblue4',         # заголовок
                         face = 'bold'), 
    plot.subtitle = element_text(colour = 'royalblue3', # подзаголовок
                                 face = 'italic', ),
    axis.title = element_text(colour = 'gray28',        # названия осей
                              face = 'bold.italic'), 
    axis.text.y = element_text(face = 'italic',         # значения оси y
                               size = 7), 
    axis.text.x = element_text(angle = 90,              # поворачиваем подпись X
                               hjust = 1, 
                               vjust = 0.5, 
                               size = 9), 
    panel.background = element_rect(fill = 'skyblue1'), # фон диаграммы 
    panel.border = element_rect(colour = 'dodgerblue4', # обводка диаграммы
                                fill = NA),
    panel.grid = element_line(color = "skyblue4",       # сетка диаграммы
                              size = 0.1, 
                              linetype = 'dotted'), 
    plot.background = element_rect(fill = 'powderblue') # общий фон графика
  )


# создаём новый график 
plot2 <- 
  data %>%
  mutate(month = format(date, "%Y-%m")) %>%
  group_by(month, manager_id) %>%
  summarise(sales_sum = sum(summ)) %>%
  ggplot( aes(x = month, 
              y = sales_sum, 
              group = manager_id,
              colour = manager_id) ) + 
  geom_line( size = 1 ) +
  geom_point( size = 1.7 ) +
  labs(title = "Продажи за 2019 год", subtitle = "В разрезе менеджеров")

# применяем созданную тему
plot2 + theme_custom_blue
