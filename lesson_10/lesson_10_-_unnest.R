library(tidyr)
library(dplyr)

# #################
# задача 1:
# имеется json файл со списком сотрудников
# 1. необходимо получить сотрудников у которых предусмотренны бонусы
# 2. посчитать среднюю зарплату по отделам

# читаем json файл
staff_dict <- read_json('D:\\Google Диск\\Курс 20 шагов от Excel до языка R\\materials\\lesson_10\\simple.json')

# преобразуем json в tibble frame
staff_dict <- tibble(employee = staff_dict)

# разворачиваем каждый json узел в виде отдельной строки
# фильтруем таблицу оставляя только тех сотрудников у которых есть бонусы
staff_dict %>%
  unnest_wider(employee) %>%
  filter(bonus > 0)

# считаем среднюю зарплату по отделам
staff_dict %>%
  unnest_wider(employee) %>%
  group_by(department) %>%
  summarise(average_salary = mean(salary))


# ##########################
# задача 2:
# имеется json файл со списком сотрудников
# вывести список сотрудников с их зоной ответвенности
staff_dict <- read_json('D:\\Google Диск\\Курс 20 шагов от Excel до языка R\\materials\\lesson_10\\hard_data.json')

# преобразуем json в tibble frame
staff_dict <- tibble(employee = staff_dict)

## вариант решения #1
staff_dict %>%
  unnest_wider(employee) %>%
  select(name, department, salary, skills) %>%
  unnest_wider(skills) %>%
  select(name, department, salary, practics) %>% 
  unnest_longer(practics) %>%
  group_by(name, department, salary) %>%
  summarise(practics = paste(practics, collapse = ", "))

## вариант решения #2 
staff_dict %>%
  hoist(employee, 
        name = "name",
        department = "department",
        salary = "salary",
        practics = c("skills", "practics")) %>%
  select(-employee) %>%
  group_by(name, department, salary) %>%
  mutate(practics = paste(unlist(practics), collapse = ", "))

# ##########################
# задача 3:
# имеется json файл со списком сотрудников
# поднять на 20% зарплату сотрудникам владеющим языком R
staff_dict %>%
  hoist(employee, 
        name = "name",
        salary = "salary",
        langs = c("skills", "lang")) %>% 
  select(-employee) %>%
  unnest_longer(langs) %>%
  filter(langs == 'R') %>%
  mutate(new_salary = salary * 1.2)

# задача:
# имеется json файл со списком сотрудников
# поднять на 30% зарплату сотрудникам владеющим более чем одним языком программирования
staff_dict %>%
  hoist(employee, 
        name = "name",
        salary = "salary",
        langs = c("skills", "lang")) %>% 
  select(-employee) %>%
  group_by(name) %>%
  unnest_longer(langs) %>%
  filter( ! is.na(langs) ) %>%
  group_by( name, salary ) %>%
  summarise( langs_num = length(langs) ) %>%
  filter(langs_num > 1) %>%
  mutate( new_salary =  salary * 1.3 )

          