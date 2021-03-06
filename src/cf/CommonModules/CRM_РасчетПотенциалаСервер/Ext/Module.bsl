// Регламентное задание
Процедура РасчетПотенциалаКлиентов() Экспорт
	ЗаполнитьРегистрПотенциалов()
КонецПроцедуры




///////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, СВЯЗАННЫЕ С ИСПОЛЬЗОВАНИЕМ ФОРМУЛЫ РАСЧЕТА ЗНАЧЕНИЯ ПОКАЗАТЕЛЯ

Функция ПолучитьНаименованиеПоказателя(ИмяПоказателя) Экспорт
	Макет = РегистрыСведений.CRM_ВесаПоказателейПотенциала.ПолучитьМакет("Показатели");
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	ИмяПоказателяСокр = СокрЛП(ИмяПоказателя);
	
	Для Сч = 2 По ВысотаТаблицы Цикл // в первой строке - шапка
		Если СокрЛП(Макет.Область("R" + Сч + "C1").Текст) = ИмяПоказателяСокр Тогда
			Возврат СокрЛП(Макет.Область("R" + Сч + "C2").Текст);
		КонецЕсли;
	КонецЦикла;
	
	Возврат "<наименование не найдено>";
КонецФункции

Функция ПолучитьПоказательПоНаименованию(Наименование) Экспорт
	Макет = РегистрыСведений.CRM_ВесаПоказателейПотенциала.ПолучитьМакет("Показатели");
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	НаименованиеСокр = СокрЛП(Наименование);
	
	Для Сч = 2 По ВысотаТаблицы Цикл // в первой строке - шапка
		Если СокрЛП(Макет.Область("R" + Сч + "C2").Текст) = НаименованиеСокр Тогда
			Возврат СокрЛП(Макет.Область("R" + Сч + "C1").Текст);
		КонецЕсли;
	КонецЦикла;
	
	Возврат "<показатель не найден>";
КонецФункции

Функция ПолучитьИменаИНаименованияПоказателей(ВТаблицу = Ложь) Экспорт
	Если НЕ ВТаблицу Тогда
		ПереченьПоказателей = Новый Массив(); // Таблица удобнее, но проблемы будут с передачей на клиент.
		
		Макет = РегистрыСведений.CRM_ВесаПоказателейПотенциала.ПолучитьМакет("Показатели");
		ВысотаТаблицы = Макет.ВысотаТаблицы;
		
		Для Сч = 2 По ВысотаТаблицы Цикл // в первой строке - шапка
			СтруктураСтроки = Новый Структура("Имя, Наименование");
			СтруктураСтроки.Имя          = СокрЛП(Макет.Область("R" + Сч + "C1").Текст);
			СтруктураСтроки.Наименование = СокрЛП(Макет.Область("R" + Сч + "C2").Текст);
			
			ПереченьПоказателей.Добавить(СтруктураСтроки);
		КонецЦикла;
		
		Возврат ПереченьПоказателей;
	Иначе
		ПереченьПоказателей = Новый ТаблицаЗначений();
		ПереченьПоказателей.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
		ПереченьПоказателей.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
		Макет = РегистрыСведений.CRM_ВесаПоказателейПотенциала.ПолучитьМакет("Показатели");
		ВысотаТаблицы = Макет.ВысотаТаблицы;
		
		Для Сч = 2 По ВысотаТаблицы Цикл // в первой строке - шапка
			НоваяСтрока = ПереченьПоказателей.Добавить();
			НоваяСтрока.Имя          = СокрЛП(Макет.Область("R" + Сч + "C1").Текст);
			НоваяСтрока.Наименование = СокрЛП(Макет.Область("R" + Сч + "C2").Текст);
		КонецЦикла;
		
		Возврат ПереченьПоказателей;
		
	КонецЕсли;
КонецФункции

Функция ПолучитьМетаданныеПоказателя(ИмяПоказателя) Экспорт
	МетаданныеПартнера = Метаданные.Справочники.Партнеры;
	
	Попытка
		ТипРеквизита = МетаданныеПартнера.Реквизиты[ИмяПоказателя].Тип;
		Если ТипРеквизита.Типы()[0] = Тип("Булево") Тогда
			Возврат "Булево";
		КонецЕсли;

		ПустоеЗначениеРеквизита = ТипРеквизита.ПривестиЗначение(Неопределено);
		Возврат ПустоеЗначениеРеквизита.Метаданные();
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

Функция РассчитатьПотенциалКлиента(Клиент, Подразделение, Формула = Неопределено) Экспорт
	
	Если НЕ Формула = Неопределено Тогда
		Возврат ВычислитьПотенциалКлиента(Клиент, Подразделение, Формула);
	КонецЕсли;
	
	ТекПодразделение = Подразделение;
	ПредПодразделение = Подразделение;
	ТекФормула = "";
	Пока НЕ ТекПодразделение.Пустая() И ПустаяСтрока(ТекФормула) Цикл
		
		ТекФормула = ТекПодразделение.CRM_ФормулаРасчетаПотенциала;
		ПредПодразделение = ТекПодразделение;
		ТекПодразделение = ТекПодразделение.Родитель;
		
	КонецЦикла;
	
	Если ПустаяСтрока(ТекФормула) Тогда
		Возврат 0;
	Иначе
		Возврат ВычислитьПотенциалКлиента(Клиент, ПредПодразделение, ТекФормула);
	КонецЕсли;
	
КонецФункции

Функция ВычислитьПотенциалКлиента(Клиент, Подразделение, Формула) Экспорт
	СписокПоказателей = ПолучитьИменаИНаименованияПоказателей(Истина);
	СписокПоказателей.Колонки.Добавить("Показатель", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	
	ТекстЗапроса = "";                    
	ИменаПоказателей = "";
	НадоПомещать = Истина;
	Сч = 1;
	Для Каждого СтрокаСписка Из СписокПоказателей Цикл
		
		МетаданныеРеквизита = ПолучитьМетаданныеПоказателя(СтрокаСписка.Имя);
		
		Если МетаданныеРеквизита <> Неопределено Тогда
			Иерархия = Ложь;
			
			Если МетаданныеРеквизита <> "Булево" Тогда
				Иерархия = МетаданныеРеквизита.Иерархический;
			КонецЕсли;
			
			ПолеИерархия = ?(Иерархия, "ИСТИНА", "ЛОЖЬ");
			
			Если НЕ НадоПомещать Тогда
				ТекстЗапроса = ТекстЗапроса + "
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|";
				
				ИменаПоказателей = ИменаПоказателей + "
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|";
			КонецЕсли;
			
			Если НадоПомещать Тогда
				ТекстЗапроса = ТекстЗапроса + "
				|ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	Партнеры." + СтрокаСписка.Имя + " КАК ЗначениеПоказателя,
				|	" + ПолеИерархия + " КАК Иерархический,
				|	" + Сч + " КАК Счетчик
				|ПОМЕСТИТЬ 
				|	ПортретКлиента
				|ИЗ
				|	Справочник.Партнеры КАК Партнеры
				|
				|ГДЕ
				|	Партнеры.Ссылка = &Клиент";
				
				ИменаПоказателей = ИменаПоказателей + "
				|ВЫБРАТЬ
				|	""" + СтрокаСписка.Имя + """ КАК ИмяПоказателя,
				|	" + ПолеИерархия + " КАК Иерархический,
				|	" + Сч + " КАК Счетчик
				|ПОМЕСТИТЬ 
				|	ИменаПоказателей";
				//|ИЗ
				//|	Справочник.Партнеры КАК Партнеры";
				
				НадоПомещать = Ложь;
			Иначе
				
				ТекстЗапроса = ТекстЗапроса + "
				|ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	Партнеры." + СтрокаСписка.Имя + ",
				|	" + ПолеИерархия + ",
				|	" + Сч + "
				|ИЗ
				|	Справочник.Партнеры КАК Партнеры
				|
				|ГДЕ
				|	Партнеры.Ссылка = &Клиент";
				
				ИменаПоказателей = ИменаПоказателей + "
				|ВЫБРАТЬ
				|	""" + СтрокаСписка.Имя + """,
				|	" + ПолеИерархия + ",
				|	" + Сч;
				//|ИЗ
				//|	Справочник.Партнеры КАК Партнеры";
			КонецЕсли;
			
		КонецЕсли;
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
	КонечныйТекст = ТекстЗапроса + "
	|;
	|" + ИменаПоказателей + "
	|;
	|
	|ВЫБРАТЬ
	|	ПортретКлиента.ЗначениеПоказателя,
	|	ПортретКлиента.Иерархический,
	|	ПортретКлиента.Счетчик,
	|	ИменаПоказателей.ИмяПоказателя
	|ИЗ
	|	ПортретКлиента КАК ПортретКлиента
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ИменаПоказателей КАК ИменаПоказателей
	|	ПО
	|		ПортретКлиента.Счетчик = ИменаПоказателей.Счетчик";
	
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = КонечныйТекст;
	
	Запрос.УстановитьПараметр("Клиент", Клиент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЗапросВесаПоказателя = Новый Запрос();
	
	ЗапросВесаПоказателя.Текст = "ВЫБРАТЬ
	               |	CRM_ВесаПоказателейПотенциала.Подразделение,
	               |	CRM_ВесаПоказателейПотенциала.ВесПоказателя
	               |ИЗ
	               |	РегистрСведений.CRM_ВесаПоказателейПотенциала КАК CRM_ВесаПоказателейПотенциала
	               |ГДЕ
	               |	CRM_ВесаПоказателейПотенциала.ИмяПоказателя ПОДОБНО &ИмяПоказателя
	               |	И CRM_ВесаПоказателейПотенциала.ЗначениеПоказателя = &ЗначениеПоказателя
	               |	И CRM_ВесаПоказателейПотенциала.Подразделение = &Подразделение";
	ЗапросВесаПоказателя.УстановитьПараметр("Подразделение", Подразделение);
	
	Пока Выборка.Следующий() Цикл
		
		ЗапросВесаПоказателя.УстановитьПараметр("ИмяПоказателя", Выборка.ИмяПоказателя);
		ЗапросВесаПоказателя.УстановитьПараметр("ЗначениеПоказателя", Выборка.ЗначениеПоказателя);
		
		ВыборкаВеса = ЗапросВесаПоказателя.Выполнить().Выбрать();
		
		Вес = 0;
		
		Если ВыборкаВеса.Следующий() Тогда
			Вес = ВыборкаВеса.ВесПоказателя;
			СписокПоказателей[Выборка.Счетчик - 1].Показатель = Вес;
			Продолжить;
		КонецЕсли;
		
		Если НЕ Выборка.Иерархический Тогда
			
			ЗапросВесаПоказателя.УстановитьПараметр("ИмяПоказателя", Выборка.ИмяПоказателя);
			ЗапросВесаПоказателя.УстановитьПараметр("ЗначениеПоказателя", Неопределено);
			
			ВыборкаВеса = ЗапросВесаПоказателя.Выполнить().Выбрать();
			Если ВыборкаВеса.Следующий() Тогда
				Вес = ВыборкаВеса.ВесПоказателя;
				СписокПоказателей[Выборка.Счетчик - 1].Показатель = Вес;
				Продолжить;
			КонецЕсли;
			
		Иначе 
			
			ТекЗначение = Выборка.ЗначениеПоказателя;
			
			ВесНайден = Ложь;
			
			Пока Вес = 0 И НЕ ТекЗначение.Пустая() Цикл
				ТекЗначение = ТекЗначение.Родитель;
				
				ЗапросВесаПоказателя.УстановитьПараметр("ИмяПоказателя", Выборка.ИмяПоказателя);
				ЗапросВесаПоказателя.УстановитьПараметр("ЗначениеПоказателя", ТекЗначение);
				
				ВыборкаВеса = ЗапросВесаПоказателя.Выполнить().Выбрать();
				Если ВыборкаВеса.Следующий() Тогда
					Вес = ВыборкаВеса.ВесПоказателя;
					ВесНайден = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Если Вес = 0 И НЕ ВесНайден Тогда
				ЗапросВесаПоказателя.УстановитьПараметр("ИмяПоказателя", Выборка.ИмяПоказателя);
				ЗапросВесаПоказателя.УстановитьПараметр("ЗначениеПоказателя", Неопределено);
				
				ВыборкаВеса = ЗапросВесаПоказателя.Выполнить().Выбрать();
				Если ВыборкаВеса.Следующий() Тогда
					Вес = ВыборкаВеса.ВесПоказателя;
					СписокПоказателей[Выборка.Счетчик - 1].Показатель = Вес;
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			СписокПоказателей[Выборка.Счетчик - 1].Показатель = Вес;
		КонецЕсли;
		
	КонецЦикла;
	
	// Непосредственно вычисление
	Возврат РассчитатьПоказатель(СписокПоказателей, Формула);
КонецФункции

Функция ПолучитьПотенциалКлиента(Клиент, Подразделение) Экспорт
	
	МассивСсылок = Новый Массив;
	
	ВыполнятьЦикл = Истина;
	ТекПодразделение = Подразделение;
	
	Пока НЕ ТекПодразделение.Пустая() Цикл
		
		МассивСсылок.Добавить(ТекПодразделение);
		ТекПодразделение = ТекПодразделение.Родитель;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктураПредприятия.Ссылка КАК Подразделение,
	|	&Партнер КАК Партнер
	|ПОМЕСТИТЬ ПартнерПодразделения
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	СтруктураПредприятия.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПартнерПодразделения.Партнер,
	|	ПартнерПодразделения.Подразделение,
	|	ЕСТЬNULL(CRM_Потенциалы.Потенциал, 0) КАК Потенциал
	|ИЗ
	|	ПартнерПодразделения КАК ПартнерПодразделения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRM_Потенциалы КАК CRM_Потенциалы
	|		ПО ПартнерПодразделения.Подразделение = CRM_Потенциалы.Подразделение
	|			И ПартнерПодразделения.Партнер = CRM_Потенциалы.Клиент
	|ГДЕ
	|	НЕ CRM_Потенциалы.Потенциал = 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПартнерПодразделения.Подразделение.Родитель УБЫВ";
	Запрос.УстановитьПараметр("МассивСсылок",МассивСсылок);
	Запрос.УстановитьПараметр("Партнер",Клиент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Потенциал;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция ЕстьДоступККлиенту(Клиент, Подразделение) Экспорт
	
	ТекПодразделение = Подразделение;
	
	Запрос = Новый Запрос();

	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_ДоступККонтактам.Клиент
	               |ИЗ
	               |	РегистрСведений.CRM_ДоступККонтактам КАК CRM_ДоступККонтактам
	               |ГДЕ
	               |	(CRM_ДоступККонтактам.Подразделение = &Подразделение
	               |			ИЛИ CRM_ДоступККонтактам.Офис = &Офис)
	               |	И CRM_ДоступККонтактам.Клиент = &Клиент";
	
	Запрос.УстановитьПараметр("Клиент", Клиент);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Офис", Подразделение.CRM_Офис);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Следующий();
	
КонецФункции

Процедура ЗаполнитьПотенциалыДляПодразделения(Подразделение, ОчищатьПотенциалы = Истина) Экспорт
	
	НачатьТранзакцию();
	
	Если ОчищатьПотенциалы Тогда
		Запрос = Новый Запрос();
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	CRM_Потенциалы.Клиент,
		               |	CRM_Потенциалы.Подразделение
		               |ИЗ
		               |	РегистрСведений.CRM_Потенциалы КАК CRM_Потенциалы
		               |ГДЕ
		               |	CRM_Потенциалы.Подразделение = &Подразделение";
		
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.CRM_Потенциалы.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Клиент = Выборка.Клиент;
			МенеджерЗаписи.Подразделение = Выборка.Подразделение;
			
		Попытка
			МенеджерЗаписи.Удалить();
		Исключение
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	
	Запрос = Новый Запрос();

	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_ДоступККонтактам.Клиент
	               |ИЗ
	               |	РегистрСведений.CRM_ДоступККонтактам КАК CRM_ДоступККонтактам
	               |ГДЕ
	               |	(CRM_ДоступККонтактам.Подразделение = &Подразделение
	               |			ИЛИ CRM_ДоступККонтактам.Офис = &Офис)";
	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Офис", Подразделение.CRM_Офис);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Потенциал = РассчитатьПотенциалКлиента(Выборка.Клиент, Подразделение);
		
		МенеджерЗаписи = РегистрыСведений.CRM_Потенциалы.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Клиент        = Выборка.Клиент;
		МенеджерЗаписи.Подразделение = Подразделение;
		МенеджерЗаписи.Потенциал     = Потенциал;
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки;
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
КонецПроцедуры

Процедура ЗаполнитьРегистрПотенциалов() Экспорт
	НачатьТранзакцию();
	
	// Очистим весь регистр
	
	НаборЗаписей = РегистрыСведений.CRM_Потенциалы.СоздатьНаборЗаписей();
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ОтменитьТранзакцию();
		Возврат;
	КонецПопытки;
	
	// Достаем все пары "клиент-подразделение".
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_ДоступККонтактам.Клиент,
	               |	ЕСТЬNULL(СтруктураПредприятия.Ссылка,ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) КАК Подразделение,
	               |	ВЫБОР
	               |		КОГДА CRM_ДоступККонтактам.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	               |			ТОГДА 1
	               |		ИНАЧЕ 2
	               |	КОНЕЦ КАК Сортировка
	               |ИЗ
	               |	РегистрСведений.CRM_ДоступККонтактам КАК CRM_ДоступККонтактам
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	               |		ПО CRM_ДоступККонтактам.Офис = СтруктураПредприятия.CRM_Офис
	               |			И (ВЫБОР
	               |				КОГДА CRM_ДоступККонтактам.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	               |					ТОГДА ИСТИНА
	               |				ИНАЧЕ CRM_ДоступККонтактам.Подразделение = СтруктураПредприятия.Ссылка
	               |			КОНЕЦ)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Сортировка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Выборка.Подразделение) Тогда Продолжить; КонецЕсли;
		
		Потенциал = РассчитатьПотенциалКлиента(Выборка.Клиент, Выборка.Подразделение);
		
		Если Потенциал = 0 Тогда Продолжить; КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.CRM_Потенциалы.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Клиент        = Выборка.Клиент;
		МенеджерЗаписи.Подразделение = Выборка.Подразделение;
		МенеджерЗаписи.Потенциал     = Потенциал;
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Возвращает позицию требуемого знака (символ) с конца формулы, исключая выражения в скобках.
//
// Параметры:
//	Формула - Строка, формула, в которой производится поиск знака.
//	Знак	- Строка, искомый знак-символ.
//
// Возвращаемое значение:
//	Число - позиция знака в формуле при просмотре с конца строки, исключая выражения в скобках.
//
Функция НайтиЗнакВнеСкобок(Формула, Знак)
	Вложенность = 0;
	ДлинаСтроки = СтрДлина(Формула);
	Для Счетчик = 1 По ДлинаСтроки Цикл
		Если Сред(Формула, ДлинаСтроки - Счетчик + 1, 1) = ")" Тогда
			Вложенность = Вложенность + 1;
		КонецЕсли;
		Если Сред(Формула, ДлинаСтроки - Счетчик + 1, 1) = "(" Тогда
			Вложенность = Вложенность - 1;
		КонецЕсли;
		Если Сред(Формула, ДлинаСтроки - Счетчик + 1, 1) = "]" Тогда
			Вложенность = Вложенность + 1;
		КонецЕсли;
		Если Сред(Формула, ДлинаСтроки - Счетчик + 1, 1) = "[" Тогда
			Вложенность = Вложенность - 1;
		КонецЕсли;
		Если (Сред(Формула, ДлинаСтроки - Счетчик + 1, 1) = Знак) И (Вложенность = 0) Тогда
			Возврат ДлинаСтроки - Счетчик + 1;
		КонецЕсли;
	КонецЦикла;
	Возврат 0;
КонецФункции	

// Проверяет, корректна ли формула расчета показателя (контроль только синтаксической корректности).
//
// Параметры:
//	Формула         - Строка, формула, проверяемая на корректность.
//	ИсходнаяФормула	- Булево, Истина - при вызове для исходной формулы, 
//					  Ложь - при рекурсивном вызове для части формулы.
//
// Возвращаемое значение:
//	Булево - корректность формулы.
//
Функция КорректнаФормулаРасчетаПоказателя(Формула, ИсходнаяФормула = Истина) Экспорт 
	Если (Формула = Неопределено) ИЛИ (ПустаяСтрока(Формула)) Тогда
		Возврат ИсходнаяФормула;
	КонецЕсли;	
	ТекФормула = СокрЛП(Формула);
	Если (Лев(ТекФормула, 1) = "+") ИЛИ (Лев(ТекФормула, 1) = "-") Тогда
		Возврат КорректнаФормулаРасчетаПоказателя("0" + ТекФормула, Ложь);
	КонецЕсли;
	// Разбиваем на части арифметическими операциями.
	Поз = НайтиЗнакВнеСкобок(ТекФормула, "/");
	Если Поз = 0 Тогда
		Поз = НайтиЗнакВнеСкобок(ТекФормула, "*");
	КонецЕсли;
	Если Поз = 0 Тогда
		Поз = НайтиЗнакВнеСкобок(ТекФормула, "+");
	КонецЕсли;
	Если Поз = 0 Тогда
		Поз = НайтиЗнакВнеСкобок(ТекФормула, "-");
	КонецЕсли;
	// Проверяем корректность частей, связанных арифметическими операциями.
	Если Поз > 0  Тогда
		Возврат КорректнаФормулаРасчетаПоказателя(Сред(ТекФормула, 1, Поз - 1), Ложь) И КорректнаФормулаРасчетаПоказателя(Сред(ТекФормула, Поз + 1, СтрДлина(ТекФормула) - Поз), Ложь);
	КонецЕсли;
	// А не в скобках ли выражение?
	Если (Лев(ТекФормула, 1) = "(") И (Прав(ТекФормула, 1) = ")") Тогда
		Возврат КорректнаФормулаРасчетаПоказателя(Сред(ТекФормула, 2, СтрДлина(ТекФормула) - 2), Ложь);
	КонецЕсли;
	// А может, это число?
	Попытка
		ВремПерем = Число(ТекФормула) - Число(СокрЛП(Число(ТекФормула)));
		ЭтоЧисло = (ВремПерем = 0);
	Исключение	
		ЭтоЧисло = Ложь;
	КонецПопытки;
	Если ЭтоЧисло Тогда
		Возврат Истина;
	КонецЕсли;
	// Остается только наименование показателя: проверим.
	Возврат (Лев(ТекФормула, 1) = "[") И (Найти(ТекФормула, "]") = СтрДлина(ТекФормула));
КонецФункции	

// Возвращает формулу, используемую системой 1С для вычисления посредством "Выполнить(...)" (в синтаксисе 1С).
//
// Параметры:
//	Формула - Строка, исходная формула.
//	Префикс	- Строка, имя переменной, являющейся структурой или соответствием, 
//			  которые содержат ключи-показатели и значения показателей.
//
// Возвращаемое значение:
//	Строка - преобразованная формула для расчета в системе 1С.
//
Функция ВставитьПрефиксВФормулуПоказателя(Формула, Префикс)
	ТекФормула = СокрЛП(Формула);
	Если (Лев(ТекФормула, 1) = "+") ИЛИ (Лев(ТекФормула, 1) = "-") Тогда
		Возврат ВставитьПрефиксВФормулуПоказателя("0" + ТекФормула, Префикс);
	КонецЕсли;
	// Разбиваем на части арифметическими операциями.
	Знак = "/";
	Поз = НайтиЗнакВнеСкобок(ТекФормула, Знак);
	Если Поз = 0 Тогда
		Знак = "*";
		Поз = НайтиЗнакВнеСкобок(ТекФормула, Знак);
	КонецЕсли;
	Если Поз = 0 Тогда
		Знак = "+";
		Поз = НайтиЗнакВнеСкобок(ТекФормула, Знак);
	КонецЕсли;
	Если Поз = 0 Тогда
		Знак = "-";
		Поз = НайтиЗнакВнеСкобок(ТекФормула, Знак);
	КонецЕсли;
	// Производим префиксацию частей, связанных арифметическими операциями.
	Если Поз > 0  Тогда
		 Возврат ВставитьПрефиксВФормулуПоказателя(Сред(ТекФормула, 1, Поз - 1), Префикс) + Знак + ВставитьПрефиксВФормулуПоказателя(Сред(ТекФормула, Поз + 1, СтрДлина(ТекФормула) - Поз), Префикс);
	КонецЕсли;
	// А не в скобках ли выражение?
	Если (Лев(ТекФормула, 1) = "(") И (Прав(ТекФормула, 1) = ")") Тогда
		Возврат "(" + ВставитьПрефиксВФормулуПоказателя(Сред(ТекФормула, 2, СтрДлина(ТекФормула) - 2), Префикс) + ")";
	КонецЕсли;
	// А может, это число?
	Попытка
		ВремПерем = Число(ТекФормула) - Число(СокрЛП(Число(ТекФормула)));
		ЭтоЧисло = (ВремПерем = 0);
	Исключение	
		ЭтоЧисло = Ложь;
	КонецПопытки;
	Если ЭтоЧисло Тогда
		Возврат СтрЗаменить(ТекФормула, ",", ".");
	КонецЕсли;
	// Остается только наименование показателя: делаем префиксацию и вызов.
	Возврат (Префикс + "[""" + Сред(ТекФормула, 2, СтрДлина(ТекФормула) - 2) + """]");
КонецФункции	

// Возвращает значение, рассчитанное по формуле расчета показателя.
//
// Параметры:           
//	ТаблицаПоказателей         - таблица со списком показателей и их значением.
//	Формула                    - Строка, расчетная формула.
//  ПроверенаКорректность      - Булево, если Ложь, то перед вычислением производится проверка 
//								 синтаксической корректности формулы.
// Возвращаемое значение:
//	Число - значение показателя, рассчитанное по формуле.
//
Функция РассчитатьПоказатель(ТаблицаПоказателей, Формула, ПроверенаКорректность = Ложь) Экспорт
	Перем Показатель;
	Перем Показатели;
	
	ТекФормула = Формула;
	
	// Рассчитаем формулу
	Если ТекФормула = "-" Тогда
		// Очистим формулу
		ТекФормула = "";
	КонецЕсли;
	
	// Если формула не проверена - проверим.
	Если НЕ ПроверенаКорректность Тогда
		// Если формула не верна, то вернем ноль.
		Если НЕ КорректнаФормулаРасчетаПоказателя(ТекФормула) Тогда
			Возврат 0;
		КонецЕсли;
	КонецЕсли;
	// Заполним значения показателей.
	Показатели = Новый Соответствие();
	Для Каждого ТекСтрока Из ТаблицаПоказателей Цикл
		Показатели.Вставить(ТекСтрока.Наименование, ТекСтрока.Показатель);
	КонецЦикла;
	
	// Теперь вычислим формулу
	ТекФормула = ВставитьПрефиксВФормулуПоказателя(ТекФормула, "Показатели");
	Попытка
		Выполнить("Показатель = " + ТекФормула);
		Возврат Показатель;
	Исключение
		Возврат 0;
	КонецПопытки;
КонецФункции	

// Возвращает список лексем формулы расчета показателя.
//
// Параметры:
//	Формула - Строка, формула расчета показателя.
//
// Возвращаемое значение:
//	Массив структур - массив лексем, заданных структурами с типом лексемы и индексом начала лексемы в формуле.
//
Функция ПолучитьСписокЛексем(Формула)
	ЕстьТочка = Ложь;
	НомерСимвола = 1;
	ТекущаяЛексема = "Неопределено";
	НачалоЛексемы = 1;
	// Список лексем - массив структур с типом лексем и индексом символа начала лексемы в формуле.
	СписокЛексем = Новый Массив();
	Пока НомерСимвола <= СтрДлина(Формула) Цикл
		ТекСимвол = Сред(Формула, НомерСимвола, 1);
		Если ТекущаяЛексема = "Неопределено" Тогда
			// Пробелы и табуляции нам не нужны.
			Если ПустаяСтрока(ТекСимвол) Тогда
				НомерСимвола = НомерСимвола + 1;
				Продолжить;
			КонецЕсли;
			// Проверим, что за лексема начинается с этого символа (либо сам символ и есть лексема).
			Если Найти("0123456789", ТекСимвол) > 0 Тогда
				// Начинается число
				ТекущаяЛексема = "Число";
				НачалоЛексемы = НомерСимвола;
				ЕстьТочка = Ложь;
				
			ИначеЕсли ТекСимвол = "[" Тогда
				// Начинается Показатель
				ТекущаяЛексема = "Показатель";
				НачалоЛексемы = НомерСимвола;
				
			ИначеЕсли ТекСимвол = "(" Тогда
				// Открывающая скобка
				СтруктураЛексемы = Новый Структура();
				СтруктураЛексемы.Вставить("Тип", "(");
				СтруктураЛексемы.Вставить("Начало", НомерСимвола);
				СписокЛексем.Добавить(СтруктураЛексемы);
				
				
			ИначеЕсли ТекСимвол = ")" Тогда
				// Закрывающая скобка
				СтруктураЛексемы = Новый Структура();
				СтруктураЛексемы.Вставить("Тип", ")");
				СтруктураЛексемы.Вставить("Начало", НомерСимвола);
				СписокЛексем.Добавить(СтруктураЛексемы);
				
			ИначеЕсли Найти("+-*/", ТекСимвол) > 0 Тогда
				// Знак операции
				СтруктураЛексемы = Новый Структура();
				СтруктураЛексемы.Вставить("Тип", ТекСимвол);
				СтруктураЛексемы.Вставить("Начало", НомерСимвола);
				СписокЛексем.Добавить(СтруктураЛексемы);
				
			Иначе
				// Странный символ... Не должен был он здесь встретиться...
				СтруктураЛексемы = Новый Структура();
				СтруктураЛексемы.Вставить("Тип", ТекущаяЛексема); // Здесь ТекущаяЛексема = "Неопределено"
				СтруктураЛексемы.Вставить("Начало", НомерСимвола);
				СписокЛексем.Добавить(СтруктураЛексемы);
				
			КонецЕсли;
			НомерСимвола = НомерСимвола + 1;
			
		Иначе
			Если ТекущаяЛексема = "Число" Тогда
				Если Найти("0123456789", ТекСимвол) > 0 Тогда
					// Цифра
					НомерСимвола = НомерСимвола + 1;
					
				ИначеЕсли (Найти(".,", ТекСимвол) > 0) И (НЕ ЕстьТочка) Тогда 
					// Десятичный разделитель
					ЕстьТочка = Истина;
					НомерСимвола = НомерСимвола + 1;
					
				Иначе
					// Число закончилось, приращение символа не делаем - это уже другая лексема.
					СтруктураЛексемы = Новый Структура();
					СтруктураЛексемы.Вставить("Тип", ТекущаяЛексема); // Здесь ТекущаяЛексема = "Число"
					СтруктураЛексемы.Вставить("Начало", НачалоЛексемы);
					СписокЛексем.Добавить(СтруктураЛексемы);
					ТекущаяЛексема = "Неопределено"; // Сбрасываем тип лексемы
					
				КонецЕсли;	
				
			ИначеЕсли ТекущаяЛексема = "Показатель" Тогда
				// Закончилась ли лексема "Показатель"?
				Если ТекСимвол = "]" Тогда
					СтруктураЛексемы = Новый Структура();
					СтруктураЛексемы.Вставить("Тип", ТекущаяЛексема); // Здесь ТекущаяЛексема = "Показатель"
					СтруктураЛексемы.Вставить("Начало", НачалоЛексемы);
					СписокЛексем.Добавить(СтруктураЛексемы);
					ТекущаяЛексема = "Неопределено"; // Сбрасываем тип лексемы
				КонецЕсли;
				НомерСимвола = НомерСимвола + 1;
					
			КонецЕсли;	
			
		КонецЕсли;
	КонецЦикла;
	// У нас, возможно, последним было число - его тоже нужно внести.
	Если ТекущаяЛексема = "Число" Тогда
		СтруктураЛексемы = Новый Структура();
		СтруктураЛексемы.Вставить("Тип", ТекущаяЛексема); // Здесь ТекущаяЛексема = "Число"
		СтруктураЛексемы.Вставить("Начало", НачалоЛексемы);
		СписокЛексем.Добавить(СтруктураЛексемы);
		
	ИначеЕсли ТекущаяЛексема <> "Неопределено" Тогда // Вообще-то, если не равно "Неопределено", то равно "Показатель". 
													 // Но сделаем более общую проверку (для возможности расширения).
		// А это - ошибка.
		СтруктураЛексемы = Новый Структура();
		СтруктураЛексемы.Вставить("Тип", "Неопределено"); // Поставим "Неопределено", чтобы обратить внимание.
		СтруктураЛексемы.Вставить("Начало", НачалоЛексемы);
		СписокЛексем.Добавить(СтруктураЛексемы);
		
	КонецЕсли;
	
	Возврат СписокЛексем;
КонецФункции

// Выполняет проверку правила грамматики <Формула> при анализе синтаксической корректности формулы расчета показателя.
//
// Параметры:
//	СписокЛексем           - Массив структур: массив лексем, заданных структурами с типом лексемы и 
//							 индексом начала лексемы в формуле.
//  НомерЛексемы           - Число, номер лексемы в списке лексем, с которой начинается проверка правила.
//  НомерОшибочногоСимвола - Число, получаемый номер символа в строке формулы, 
//							 где произошла ошибка (=0, если нет ошибки).
//	СообщениеОбОшибке      - Строка, получаемое сообщение об ошибке в случае некорректного правила грамматики <Формула>.
//
// Возвращаемое значение:
//	Булево - результат проверки правила грамматики.
//
Функция ГрамматикаФормула(СписокЛексем, НомерЛексемы, НомерОшибочногоСимвола, СообщениеОбОшибке)
	// Проверяется корректность правила.
	// <Формула> ::= "(" <Формула> ")" <Остаток> | <Терм> <Остаток>   {"(", "Число", "Показатель"}
	Если НомерОшибочногоСимвола <> 0 Тогда
		// Ошибка уже возникла - незачем дальше проверять.
		Возврат Ложь;
	КонецЕсли;
	Если НомерЛексемы >= СписокЛексем.Количество() Тогда
		// А нечего уже проверять...
		НомерОшибочногоСимвола = -1; // Условное обозначение для выхода за пределы формулы.
		СообщениеОбОшибке = "Ожидается число, показатель или выражение в скобках";
		Возврат Ложь;
	КонецЕсли;
	
	// Теперь проверяем, какая ветка правила сработала (по лексеме из фигурных скобок).
	Если СписокЛексем[НомерЛексемы].Тип = "(" Тогда
		// Ветка <Формула> ::= "(" <Формула> ")" <Остаток>
		// Скобку уже проверили, проверяем формулу.
		НомерЛексемы = НомерЛексемы + 1;
		Результат = ГрамматикаФормула(СписокЛексем, НомерЛексемы, НомерОшибочногоСимвола, СообщениеОбОшибке);
		Если Не Результат Тогда
			// Формула после скобки некорректна - радостно вылетаем.
			Возврат Ложь;
		КонецЕсли;
		// Теперь осталось проверить, стоит ли закрывающая скобка.
		Если НомерЛексемы >= СписокЛексем.Количество() Тогда
			// А нечего уже проверять...
			НомерОшибочногоСимвола = -1; // Условное обозначение для выхода за пределы формулы.
			СообщениеОбОшибке = "Отсутствует закрывающая скобка";
			Возврат Ложь;
		КонецЕсли;
		// Проверяем скобку
		Если СписокЛексем[НомерЛексемы].Тип = ")" Тогда
			НомерЛексемы = НомерЛексемы + 1;
			Возврат ГрамматикаОстаток(СписокЛексем, НомерЛексемы, НомерОшибочногоСимвола, СообщениеОбОшибке);
		Иначе
			// Ошибка - по правилу тут жестко должна скобка закрываться!
			НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
			СообщениеОбОшибке = "Отсутствует закрывающая скобка";
			Возврат Ложь;
		КонецЕсли;	
		
	ИначеЕсли (СписокЛексем[НомерЛексемы].Тип = "Число") ИЛИ (СписокЛексем[НомерЛексемы].Тип = "Показатель") Тогда
		// Ветка <Формула> ::= <Терм> <Остаток>
		// Терм уже проверили, проверяем остаток.
		НомерЛексемы = НомерЛексемы + 1;
		Возврат ГрамматикаОстаток(СписокЛексем, НомерЛексемы, НомерОшибочногоСимвола, СообщениеОбОшибке);
		
	ИначеЕсли СписокЛексем[НомерЛексемы].Тип = ")" Тогда
		// Ошибочная закрывающая скобка.
		НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
		СообщениеОбОшибке = "Ожидается число, показатель или выражение в скобках";
		Возврат Ложь;
		
	ИначеЕсли Найти("+-*/", СписокЛексем[НомерЛексемы].Тип) > 0 Тогда
		// Ошибочный знак операции
		НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
		СообщениеОбОшибке = "Ожидается число, показатель или выражение в скобках";
		Возврат Ложь;
		
	ИначеЕсли СписокЛексем[НомерЛексемы].Тип = "Неопределено" Тогда
		// А это вообще не понятно, что.
		НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
		СообщениеОбОшибке = "Недопустимый элемент выражения";
		Возврат Ложь;
		
	КонецЕсли;
	
	// До сюда мы не должны были дойти. Но мало ли, что...
	НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
	СообщениеОбОшибке = "Синтаксическая ошибка"; // Не будем диагностировать, просто засвидетельствуем.
	Возврат Ложь;
КонецФункции	

// Выполняет проверку правила грамматики <Остаток> при анализе синтаксической корректности формулы расчета показателя.
//
// Параметры:
//	СписокЛексем           - Массив структур: массив лексем, заданных структурами с типом лексемы и 
//							 индексом начала лексемы в формуле.
//  НомерЛексемы           - Число, номер лексемы в списке лексем, с которой начинается проверка правила.
//  НомерОшибочногоСимвола - Число, получаемый номер символа в строке формулы, 
//							 где произошла ошибка (=0, если нет ошибки).
//	СообщениеОбОшибке      - Строка, получаемое сообщение об ошибке в случае некорректного правила грамматики <Остаток>.
//
// Возвращаемое значение:
//	Булево - результат проверки правила грамматики.
//
Функция ГрамматикаОстаток(СписокЛексем, НомерЛексемы, НомерОшибочногоСимвола, СообщениеОбОшибке)
	// Проверяется корректность правила.
	// <Остаток> ::= <Знак> <Формула> | Е                   {"+", "-", "*", "/", Е}
	Если НомерОшибочногоСимвола <> 0 Тогда
		// Ошибка уже возникла - незачем дальше проверять.
		Возврат Ложь;
	КонецЕсли;
	Если НомерЛексемы >= СписокЛексем.Количество() Тогда
		// А нечего уже проверять...
		// Но у нас есть ветка правила <Остаток> ::= Е (т.е. пусто).
		// Это именно она
		Возврат Истина;
	КонецЕсли;
	
	// Теперь проверяем, что за ветка правила сработала.
	Если Найти("+-*/", СписокЛексем[НомерЛексемы].Тип) > 0 Тогда
		// Ветка <Остаток> ::= <Знак> <Формула>
		// Знак уже проверили, проверяем формулу.
		НомерЛексемы = НомерЛексемы + 1;
		Возврат ГрамматикаФормула(СписокЛексем, НомерЛексемы, НомерОшибочногоСимвола, СообщениеОбОшибке);
		
	ИначеЕсли (СписокЛексем[НомерЛексемы].Тип = "Число") ИЛИ (СписокЛексем[НомерЛексемы].Тип = "Показатель") Тогда
		// Вместо знака идет число или показатель: знак пропустили.
		НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
		СообщениеОбОшибке = "Пропущен знак операции";
		Возврат Ложь;
		
	ИначеЕсли СписокЛексем[НомерЛексемы].Тип = ")" Тогда
		// Ветка <Остаток> ::= Е
		// Не приращаем номер лексемы - она не из этого правила.
		Возврат Истина;
		
	ИначеЕсли СписокЛексем[НомерЛексемы].Тип = "(" Тогда
		// Вместо знака идет открывающая скобка: знак пропустили.
		НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
		СообщениеОбОшибке = "Пропущен знак операции";
		Возврат Ложь;
		
	ИначеЕсли СписокЛексем[НомерЛексемы].Тип = "Неопределено" Тогда
		// А это вообще не понятно, что.
		НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
		СообщениеОбОшибке = "Недопустимый элемент выражения";
		Возврат Ложь;
		
	КонецЕсли;
	
	// До сюда мы не должны были дойти. Но мало ли, что...
	// Так как есть ветка <Остаток> ::= Е, то ругаться не будем, а деликатно выйдем.
	// Не приращаем номер лексемы - она не из этого правила.
	Возврат Истина;
	
КонецФункции	

// Выполняет проверку синтаксической корректности формулы расчета показателя.
//
// Параметры:
//	Формула           - Строка, формула расчета показателя.
//	СообщениеОбОшибке - Строка, получаемое сообщение об ошибке в случае некорректной формулы.
//
// Возвращаемое значение:
//	Булево - результат проверки синтаксической корректности.
//
Функция СинтаксическийКонтрольФормулыПоказателя(Формула, СообщениеОбОшибке) Экспорт
	// Синтаксический контроль осуществляется по грамматике, заданной правилами:
	// <Формула> ::= "(" <Формула> ")" <Остаток> | <Терм> <Остаток>   {"(", "Число", "Показатель"}
	// <Остаток> ::= <Знак> <Формула> | Е                   {"+", "-", "*", "/", Е}
	// <Знак> ::= "+" | "-" | "*" | "/"                     {"+", "-", "*", "/"}
	// <Терм> ::= "Число" | "Показатель"                    {"Число", "Показатель"}
	// Здесь в угловых скобках указан нетерминал, вызываемый функцией вида "дпГрамматика...".
	// Ввиду простой структуры нетерминалов <Знак> и <Терм>, для них не будем вводить отдельную функцию.
	// В двойных кавычках указаны лексемы (терминалы), передаваемые из функции дпПолучитьСписокЛексем(...).
	// Е - пустое правило
	// В фигурных скобках указаны терминалы, с одного из которых должно начинаться правило.
	// 
	СписокЛексем = ПолучитьСписокЛексем(Формула);
	НомерЛексемы = 0;
	НомерОшибочногоСимвола = 0;
	СообщениеОбОшибке = "";
	Результат = ГрамматикаФормула(СписокЛексем, НомерЛексемы, НомерОшибочногоСимвола, СообщениеОбОшибке);
	Если Результат И (НомерЛексемы <= СписокЛексем.Количество() - 1) Тогда
		// Формула проверена, но лексемы остались. Значит, есть ошибка. Проверим.
		Если СписокЛексем[НомерЛексемы].Тип = ")" Тогда
			// Лишняя закрывающая скобка
			СообщениеОбОшибке = "Лишняя закрывающая скобка";
		Иначе
			// Пропущен знак операции
			СообщениеОбОшибке = "Пропущен знак операции";
		КонецЕсли; 
		НомерОшибочногоСимвола = СписокЛексем[НомерЛексемы].Начало;
		Результат = Ложь;
	КонецЕсли;
	Если Не Результат Тогда
		Если НомерОшибочногоСимвола = -1 Тогда
			// Это выход за пределы формулы.
			НомерОшибочногоСимвола = СтрДлина(Формула) + 1;
		КонецЕсли;
		ДоОшибки = Лев(Формула, НомерОшибочногоСимвола - 1);
		ПослеОшибки = "";
		// Ошибка может появиться и после формулы (например, нет закрывающей скобки):
		Если НомерОшибочногоСимвола <= СтрДлина(Формула) Тогда
			ПослеОшибки = Прав(Формула, СтрДлина(Формула) - НомерОшибочногоСимвола + 1);
		КонецЕсли;	
		СообщениеОбОшибке = СообщениеОбОшибке + ": """ + СокрЛП(ДоОшибки) + " <<?>> " + СокрЛП(ПослеОшибки) + """!";
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции	




