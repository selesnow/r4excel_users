# подключение пакетов
library(vroom)
library(dplyr)

# загрузка данных
ga_data <- vroom("https://raw.githubusercontent.com/selesnow/publications/master/code_example/from_excel_to_r/lesson_3/ga_nowember.csv")

# mutate
# добавл¤ем новый столбец
ga_data <- mutate(ga_data,
                  bounce_rate = bounces / sessions) #новый столбец = формула

ga_data <- mutate(ga_data,
                  bounce_rate = bounces / sessions,
                  br_group    = if_else(bounce_rate > 0.6, "high_br", "normal_br")) #такое же строение как функции в excel

# примен¤ем преобразование к уже существующим столбцам
ga_data %>% mutate_if(is.character, toupper) #меняет регистр данных в столбце

# преобразуем значени¤ существующих столбцов примен¤¤ регул¤рные выражени¤
ga_data %>% mutate_at(vars(matches("s$")), sqrt ) #заменяет данные в столбцах на их квадратный корень

# transemute
# убираем все столбцы кроме преобразованных
transmute(ga_data,
          bounce_rate = bounces / sessions,
          date        = format(date, "%d %B %Y"),
          source) #преобразования + убирание лишних столбцов

# преобразовываем столбцы по их признаку и удал¤ем все остальные
transmute_if(ga_data, 
             is.character, toupper)
