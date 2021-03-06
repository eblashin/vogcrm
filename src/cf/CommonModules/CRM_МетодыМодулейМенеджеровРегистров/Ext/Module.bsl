// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.

// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.

#Область ОпределениеФормОбъектов

Процедура ОбработкаПолученияФормОбъектовCRM(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	#Область ПолученияФормПользовательскиеМакетыПечати
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийМенеджер.ПользовательскиеМакетыПечати") Тогда
	
		Если ВидФормы = "ФормаОбъекта" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "РегистрСведений.ПользовательскиеМакетыПечати.Форма.CRM_ФормаРедактированияЗаписи";
		ИначеЕсли ВидФормы = "ФормаСписка" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "РегистрСведений.ПользовательскиеМакетыПечати.Форма.CRM_МакетыПечатныхФорм";
		КонецЕсли;
	
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти // ОпределениеФормОбъектов


#Область СвязиМеждуПартнерами

// Получает Холдинг самого верхнего уровня
//
Функция ПолучитьГоловнойХолдинг(Партнер) Экспорт
	Если Не ЗначениеЗаполнено(Партнер) Или ТипЗнч(Партнер) <> Тип("СправочникСсылка.Партнеры") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ГоловнойХолдинг = Партнер;
	// если партнер сам является холдингом
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервыйПартнер КАК ПервыйПартнер
	|ИЗ
	|	РегистрСведений.СвязиМеждуПартнерами
	|ГДЕ
	|	ВторойПартнер = &Партнер И ВидСвязи = ЗНАЧЕНИЕ(Справочник.ВидыСвязейМеждуПартнерами.CRM_Холдинг)
	|");
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ГоловнойХолдинг = ПолучитьГоловнойХолдинг(Выборка.ПервыйПартнер);
	КонецЕсли;
	
	Возврат ГоловнойХолдинг;
	
КонецФункции

Функция ПолучитьХолдингПартнера(Партнер) Экспорт
	Если Не ЗначениеЗаполнено(Партнер) Или ТипЗнч(Партнер) <> Тип("СправочникСсылка.Партнеры") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// если партнер сам является холдингом
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервыйПартнер КАК ПервыйПартнер
	|ИЗ
	|	РегистрСведений.СвязиМеждуПартнерами
	|ГДЕ
	|	ПервыйПартнер = &Партнер И ВидСвязи = ЗНАЧЕНИЕ(Справочник.ВидыСвязейМеждуПартнерами.CRM_Холдинг)
	|");
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПервыйПартнер;
	КонецЕсли;
	
	ТаблицаСвязейПартнера = ПолучитьТаблицуСвязейПартнера(Партнер);
	НайденныеСтроки = ТаблицаСвязейПартнера.НайтиСтроки(Новый Структура("ВидСвязи", Справочники.ВидыСвязейМеждуПартнерами.CRM_Холдинг));
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат НайденныеСтроки[0].ПервыйПартнер;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьТаблицуСвязейПартнера(Партнер) Экспорт
	Таблица = Новый ТаблицаЗначений();
	Таблица.Колонки.Добавить("ПервыйПартнер",	Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
	Таблица.Колонки.Добавить("ВторойПартнер",	Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
	Таблица.Колонки.Добавить("ВидСвязи",	Новый ОписаниеТипов("СправочникСсылка.ВидыСвязейМеждуПартнерами"));
	Таблица.Колонки.Добавить("Комментарий",	Новый ОписаниеТипов("Строка"));
	
	Если Не ЗначениеЗаполнено(Партнер) Или ТипЗнч(Партнер) <> Тип("СправочникСсылка.Партнеры") Тогда
		Возврат Таблица;
	КонецЕсли;
	
	МассивПартнеры = Новый Массив();
	//МассивПартнеры.Добавить(Партнер);
	МассивПартнеры.Добавить(ПолучитьГоловнойХолдинг(Партнер));
	нИндекс = 0;
	
	Пока нИндекс < МассивПартнеры.Количество() Цикл
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПервыйПартнер	КАК ПервыйПартнер,
		|	ВторойПартнер	КАК ВторойПартнер,
		|	ВидСвязи	КАК ВидСвязи,
		|	ВЫРАЗИТЬ(Комментарий КАК СТРОКА(200)) КАК Комментарий
		|ИЗ
		|	РегистрСведений.СвязиМеждуПартнерами
		|ГДЕ
		|	ПервыйПартнер = &Партнер ИЛИ ВторойПартнер = &Партнер
		|");
		Запрос.УстановитьПараметр("Партнер", МассивПартнеры[нИндекс]);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			Если МассивПартнеры.Найти(Выборка.ПервыйПартнер) = Неопределено Тогда
				МассивПартнеры.Добавить(Выборка.ПервыйПартнер);
			КонецЕсли;
			Если МассивПартнеры.Найти(Выборка.ВторойПартнер) = Неопределено Тогда
				МассивПартнеры.Добавить(Выборка.ВторойПартнер);
			КонецЕсли;
		КонецЦикла;
		нИндекс = нИндекс + 1;
	КонецЦикла;
	
	Таблица.Свернуть("ПервыйПартнер,ВторойПартнер,ВидСвязи,Комментарий");
	Возврат Таблица;
КонецФункции

Процедура CRM_ПредметыПапкиВзаимодействийПриЗаписи(Источник, Отказ, Замещение) Экспорт
	Если ТипЗнч(Источник.Отбор.Взаимодействие.Значение) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Предмет", Неопределено);
		СтруктураЗаписи.Вставить("Папка", Справочники.ПапкиЭлектронныхПисем.ПустаяСсылка());
		СтруктураЗаписи.Вставить("Рассмотрено", Неопределено);
		//
		Если Источник.Отбор.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПредметыПапкиВзаимодействий.Предмет,
		|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма КАК Папка,
		|	ПредметыПапкиВзаимодействий.Рассмотрено
		|ИЗ
		|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|ГДЕ
		|	ПредметыПапкиВзаимодействий.Взаимодействие = &Взаимодействие";
		
		Запрос.УстановитьПараметр("Взаимодействие", Источник.Отбор.Взаимодействие.Значение);
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Выборка);
		
		Если СтруктураЗаписи.Папка.Наименование = "Обработанные" ИЛИ СтруктураЗаписи.Папка.Наименование = "Удаленные" ИЛИ СтруктураЗаписи.Папка.Наименование = "Нежелательная почта" Тогда
			
			Если ЗначениеЗаполнено(СтруктураЗаписи.Предмет) И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтруктураЗаписи.Предмет, "CRM_СкрытьВАРМ") Тогда
				
				ОбъектПисьмо = СтруктураЗаписи.Предмет.ПолучитьОбъект();
				ОбъектПисьмо.CRM_СкрытьВАРМ = Истина;
				ОбъектПисьмо.ОбменДанными.Загрузка = Истина;
				ОбъектПисьмо.Записать();
				
			КонецЕсли;
			
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

Процедура CRM_ЖурналДокументовПриЗаписиПриЗаписи(Источник, Отказ, Замещение) Экспорт
	Если ТипЗнч(Источник.Отбор.Объект.Значение) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
		Если Источник.ЭтотОбъект.Количество() > 0 Тогда
			Если НЕ Источник.ЭтотОбъект[0].CRM_Интерес.Пустая() Тогда
				ОбъектПисьмо = Источник.Отбор.Объект.Значение.ПолучитьОбъект();
				ОбъектПисьмо.CRM_СкрытьВАРМ = Истина;
				ОбъектПисьмо.ОбменДанными.Загрузка = Истина;
				ОбъектПисьмо.Записать();	
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти
