
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
	
	ПолеКомпоновкиПериод = Новый ПараметрКомпоновкиДанных("Период");
	
	ДатаНачала = Дата('00010101');
	ДатаОкончания = Дата('00010101');
	Компания = "";
	
	ПолеКомпоновкиКомпания = Новый ПолеКомпоновкиДанных("НаименованиеПодразделенияДляОтбора");
	
	Для Каждого ЭлементНастройки Из НастройкиКомпоновки.Отбор.Элементы Цикл
		Если ЭлементНастройки.ЛевоеЗначение = ПолеКомпоновкиКомпания И ЭлементНастройки.Использование Тогда	
			Компания = ЭлементНастройки.ПравоеЗначение;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Настройка Из ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Настройка) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Настройка.Параметр = ПолеКомпоновкиПериод И Настройка.Использование Тогда	
				ДатаНачала = Настройка.Значение.ДатаНачала;
				ДатаОкончания = Настройка.Значение.ДатаОкончания;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	РезультатыВыполненияЗадач = ПолучитьРезультаты(ДатаНачала,ДатаОкончания,Компания);
		
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,НастройкиКомпоновки,ДанныеРасшифровки,,Тип("ГенераторМакетаКомпоновкиДанных"));
	
	ВнешнийНаборДанных = Новый Структура("вт_Результат", РезультатыВыполненияЗадач);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент; 
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КоличествоТаблиц = 0;
	ВысотаШапки = 0;
	ВерхОбластиДанных = 1;
	
	Для Каждого ЭлементТела из МакетКомпоновки.Тело Цикл
		
		ТипЭлементаТела = ТипЗнч(ЭлементТела);
		
		Если ТипЭлементаТела = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ВысотаШапки = МакетКомпоновки.Макеты[ЭлементТела.МакетШапки].Макет.Количество();
		КонецЕсли;
		
	КонецЦикла;
	
	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(ВерхОбластиДанных,,ВысотаШапки,);
	
КонецПроцедуры

Функция ПолучитьРезультаты(ДатаНачала,ДатаОкончания,Компания) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	ТаблицаРезультат.Колонки.Добавить("ЗадачаСсылка");
	ТаблицаРезультат.Колонки.Добавить("Цель");
	ТаблицаРезультат.Колонки.Добавить("Результат");
	ТаблицаРезультат.Колонки.Добавить("Предмет");
	ТаблицаРезультат.Колонки.Добавить("Идентификатор");
	ТаблицаРезультат.Колонки.Добавить("ИдентификаторЗадачи");
	ТаблицаРезультат.Колонки.Добавить("КоличествоОжидаемыхРезультатов");
	ТаблицаРезультат.Колонки.Добавить("КоличествоВыполненныхРезультатов");
	
	ТаблицаРезультат.Индексы.Добавить("ЗадачаСсылка,Цель,Предмет");
	
	Если НЕ ЗначениеЗаполнено(ДатаНачала) ИЛИ Не ЗначениеЗаполнено(ДатаОкончания) Тогда 
		Возврат ТаблицаРезультат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вогКомандировкаЗадачи.Задача КАК ЗадачаСсылка,
		|	ЕСТЬNULL(CRM_МероприятиевогПротокол.ПунктПротокола.Решили, """") КАК Результат,
		|	"""" КАК Идентификатор,
		|	"""" КАК ИдентификаторЗадачи,
		|	0 КАК КоличествоОжидаемыхРезультатов,
		|	0 КАК КоличествоВыполненныхРезультатов,
		|	НЕОПРЕДЕЛЕНО КАК Предмет,
		|	ЕСТЬNULL(CRM_МероприятиевогПротокол.ПунктПротокола.Слушали, """") КАК Цель
		|ИЗ
		|	Документ.вогКомандировка.Задачи КАК вогКомандировкаЗадачи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.CRM_Мероприятие.вогПротокол КАК CRM_МероприятиевогПротокол
		|		ПО вогКомандировкаЗадачи.Задача = CRM_МероприятиевогПротокол.Ссылка
		|ГДЕ
		|	вогКомандировкаЗадачи.Ссылка.ВремяНачала МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И вогКомандировкаЗадачи.Задача ССЫЛКА Документ.CRM_Мероприятие
		|	И вогКомандировкаЗадачи.Сотрудник.Подразделение.Организация.НазваниеДляОтчетаГенеральномуДиректору = &НазваниеДляОтчетаГенеральномуДиректору
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	вогКомандировкаЗадачи.Задача,
		|	вогКомандировкаЗадачи.Задача.РезультатВыполнения,
		|	"""",
		|	"""",
		|	0,
		|	0,
		|	НЕОПРЕДЕЛЕНО,
		|	вогКомандировкаЗадачи.Задача.Описание
		|ИЗ
		|	Документ.вогКомандировка.Задачи КАК вогКомандировкаЗадачи
		|ГДЕ
		|	вогКомандировкаЗадачи.Ссылка.ВремяНачала МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И вогКомандировкаЗадачи.Задача ССЫЛКА Задача.ЗадачаИсполнителя
		|	И вогКомандировкаЗадачи.Задача.БизнесПроцесс.КартаМаршрута <> ЗНАЧЕНИЕ(Справочник.CRM_КартыМаршрутов.ПоручениеНовое)
		|	И вогКомандировкаЗадачи.Сотрудник.Подразделение.Организация.НазваниеДляОтчетаГенеральномуДиректору = &НазваниеДляОтчетаГенеральномуДиректору
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вогЗадачиПоручений.Результат КАК Результат,
		|	вогКомандировкаЗадачи.Задача КАК Задача,
		|	вогЗадачиПоручений.Идентификатор КАК Идентификатор,
		|	вогЗадачиПоручений.ИдентификаторЗадачи КАК ИдентификаторЗадачи,
		|	вогЗадачиПоручений.Предмет КАК Предмет,
		|	вогЗадачиПоручений.Порядок КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_ЗадачиПоручений
		|ИЗ
		|	Документ.вогКомандировка.Задачи КАК вогКомандировкаЗадачи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.вогЗадачиПоручений КАК вогЗадачиПоручений
		|		ПО вогКомандировкаЗадачи.Задача = вогЗадачиПоручений.Объект
		|ГДЕ
		|	вогКомандировкаЗадачи.Ссылка.ВремяНачала МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И вогКомандировкаЗадачи.Сотрудник.Подразделение.Организация.НазваниеДляОтчетаГенеральномуДиректору = &НазваниеДляОтчетаГенеральномуДиректору
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вогРезультатыВыполненияЗадачПоручений.Результат КАК Результат,
		|	вогКомандировкаЗадачи.Задача КАК Задача,
		|	вогРезультатыВыполненияЗадачПоручений.Идентификатор КАК Идентификатор,
		|	вогРезультатыВыполненияЗадачПоручений.ИдентификаторЗадачи КАК ИдентификаторЗадачи,
		|	вогРезультатыВыполненияЗадачПоручений.Предмет КАК Предмет,
		|	вогРезультатыВыполненияЗадачПоручений.Порядок КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_Выполнение
		|ИЗ
		|	Документ.вогКомандировка.Задачи КАК вогКомандировкаЗадачи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.вогРезультатыВыполненияЗадачПоручений КАК вогРезультатыВыполненияЗадачПоручений
		|		ПО вогКомандировкаЗадачи.Задача = вогРезультатыВыполненияЗадачПоручений.Объект
		|ГДЕ
		|	вогКомандировкаЗадачи.Сотрудник.Подразделение.Организация.НазваниеДляОтчетаГенеральномуДиректору = &НазваниеДляОтчетаГенеральномуДиректору
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(ВТ_ЗадачиПоручений.Результат, НЕОПРЕДЕЛЕНО) КАК Результат,
		|	ЕСТЬNULL(ВТ_ЗадачиПоручений.Задача, ВТ_Выполнение.Задача) КАК Задача,
		|	ЕСТЬNULL(ВТ_ЗадачиПоручений.Идентификатор, ВТ_Выполнение.Идентификатор) КАК Идентификатор,
		|	ЕСТЬNULL(ВТ_ЗадачиПоручений.ИдентификаторЗадачи, ВТ_Выполнение.ИдентификаторЗадачи) КАК ИдентификаторЗадачи,
		|	ЕСТЬNULL(ВТ_Выполнение.Результат, НЕОПРЕДЕЛЕНО) КАК РезультатИсполнитель,
		|	ЕСТЬNULL(ВТ_ЗадачиПоручений.Предмет, ВТ_Выполнение.Предмет) КАК Предмет,
		|	ВЫБОР
		|		КОГДА ВТ_ЗадачиПоручений.НомерСтроки ЕСТЬ NULL
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ДобавленИзЗадачи
		|ИЗ
		|	ВТ_ЗадачиПоручений КАК ВТ_ЗадачиПоручений
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Выполнение КАК ВТ_Выполнение
		|		ПО ВТ_ЗадачиПоручений.Идентификатор = ВТ_Выполнение.Идентификатор
		|			И ВТ_ЗадачиПоручений.ИдентификаторЗадачи = ВТ_Выполнение.ИдентификаторЗадачи
		|			И ВТ_ЗадачиПоручений.Предмет = ВТ_Выполнение.Предмет";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Если Компания = "" Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"вогКомандировкаЗадачи.Сотрудник.Подразделение.Организация.НазваниеДляОтчетаГенеральномуДиректору = &НазваниеДляОтчетаГенеральномуДиректору","");
	Иначе
		Запрос.УстановитьПараметр("НазваниеДляОтчетаГенеральномуДиректору",Компания);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса[3].Выбрать();
	
	// +++ VOG Кулаков П.Л. 02.12.2020
	ЗапросАнкеты = Новый Запрос;
	ЗапросАнкеты.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вогАнкета.Ссылка КАК Ссылка,
		|	вогАнкета.ВариантОпроса КАК ВариантОпроса,
		|	вогАнкета.Респондент КАК Респондент,
		|	вогАнкета.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	Документ.вогАнкета КАК вогАнкета
		|ГДЕ
		|	вогАнкета.ПометкаУдаления = ЛОЖЬ";
				
	СписокАнкет = ЗапросАнкеты.Выполнить().Выгрузить();
	СписокАнкет.Индексы.Добавить("ВариантОпроса,Респондент,ДокументОснование");
	// --- VOG Кулаков П.Л.
	
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
		тРезультат 				= ВыборкаДетальныеЗаписи.Результат;
		тРезультатИсполнитель 	= ВыборкаДетальныеЗаписи.РезультатИсполнитель;
		
		// Ожидаемый результат
		Если тРезультатИсполнитель = Неопределено
			И Не тРезультат = Неопределено Тогда
			
			Если ТипЗнч(тРезультат) = Тип("ХранилищеЗначения") Тогда
				Результат = тРезультат.Получить();
			Иначе
				Результат = тРезультат;
			КонецЕсли;
			
			Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
				СписокРезультат = Результат;
			Иначе
				
				СписокРезультат = Новый СписокЗначений;
				
				Если Не Результат = Неопределено Тогда
					
					Для Каждого СтрокаТабличнойЧасти Из Результат Цикл
						СписокРезультат.Добавить(СтрокаТабличнойЧасти.Приложение, СтрокаТабличнойЧасти.ТипПриложения);
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
			РезультатАвтор = СформироватьСписокРезультат(ВыборкаДетальныеЗаписи.Предмет, СписокРезультат, Ложь, Ложь, ВыборкаДетальныеЗаписи.Задача, СписокАнкет);
			
			Для Каждого СтрокаСписка Из РезультатАвтор Цикл
				
				НоваяСтрока = ТаблицаРезультат.Добавить();
				НоваяСтрока.ЗадачаСсылка = ВыборкаДетальныеЗаписи.Задача;
				НоваяСтрока.Предмет = ВыборкаДетальныеЗаписи.Предмет;
				НоваяСтрока.Идентификатор = ВыборкаДетальныеЗаписи.Идентификатор;
				НоваяСтрока.ИдентификаторЗадачи = ВыборкаДетальныеЗаписи.ИдентификаторЗадачи;
				Если ЗначениеЗаполнено(СтрокаСписка.Представление) Тогда
					НоваяСтрока.Цель = СтрокаСписка.Представление;
				Иначе
					НоваяСтрока.Цель = СтрокаСписка.Значение;
				КонецЕсли;
				НоваяСтрока.Результат = "";
				НоваяСтрока.КоличествоОжидаемыхРезультатов = 1;
				
			КонецЦикла;
			
		КонецЕсли;
		
		// Выполнение
		Если тРезультатИсполнитель = Неопределено
			Или ТипЗнч(тРезультатИсполнитель) = Тип("СписокЗначений") Тогда
			
			Если тРезультатИсполнитель = Неопределено Тогда
				
				СписокРезультат = Новый СписокЗначений;
				Если Не Результат = Неопределено Тогда
					СписокРезультат.ЗагрузитьЗначения(Результат.ВыгрузитьКолонку("Приложение"));
				КонецЕсли;
				
				РезультатИсполнитель = СформироватьСписокРезультат(ВыборкаДетальныеЗаписи.Предмет, СписокРезультат, Истина, Истина, ВыборкаДетальныеЗаписи.Задача, СписокАнкет);
				
			Иначе
				РезультатИсполнитель = тРезультатИсполнитель;
			КонецЕсли;
			
			Для Каждого СтрокаСписка Из РезультатИсполнитель Цикл
				
				Если Не ВыборкаДетальныеЗаписи.ДобавленИзЗадачи Тогда
					
					ИндексСтрокиСписка = РезультатИсполнитель.Индекс(СтрокаСписка);
					
					Если ИндексСтрокиСписка > ТаблицаРезультат.Количество() - 1 Тогда
						Продолжить;
					КонецЕсли;
					
					СтрокаРезультат = ТаблицаРезультат.Получить(ИндексСтрокиСписка);
					
				Иначе
					
					ПараметрыОтбораСтрок = Новый Структура;
					ПараметрыОтбораСтрок.Вставить("Цель", СтрокаСписка.Значение);
					
					НайденныеСтроки = ТаблицаРезультат.НайтиСтроки(ПараметрыОтбораСтрок);
					
					Если НайденныеСтроки.Количество() = 0 Тогда
						
						Если ТаблицаРезультат.Количество() > 0 Тогда
							
							ИндексСтрокиСписка = РезультатИсполнитель.Индекс(СтрокаСписка);
							
							Если ИндексСтрокиСписка > ТаблицаРезультат.Количество() - 1 Тогда
								СтрокаРезультат = ТаблицаРезультат.Добавить();
							Иначе
								СтрокаРезультат = ТаблицаРезультат[ИндексСтрокиСписка];
							КонецЕсли;
							
						Иначе
							СтрокаРезультат = ТаблицаРезультат.Добавить();
						КонецЕсли;
					Иначе
						СтрокаРезультат = НайденныеСтроки[0];
					КонецЕсли;
					
				КонецЕсли;
				
				СтрокаРезультат.Результат = СтрокаСписка.Значение;
				Если СтрокаРезультат.Результат = Неопределено Тогда 
					СтрокаРезультат.Результат = "";
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			
			СписокРезультат = тРезультатИсполнитель.Получить();
			Для Каждого Строка Из СписокРезультат Цикл
				
				НайденныеСтроки = ТаблицаРезультат.НайтиСтроки(Новый Структура("ЗадачаСсылка,Цель,Предмет",ВыборкаДетальныеЗаписи.Задача,Строка.ЗначениеАвтор,ВыборкаДетальныеЗаписи.Предмет));
				Если НайденныеСтроки.Количество() > 0 Тогда
					Если НайденныеСтроки[0].Результат = "" И Строка.ЗначениеИсполнитель <> "" Тогда
						НайденныеСтроки[0].Результат = Строка.ЗначениеИсполнитель;
						НайденныеСтроки[0].КоличествоВыполненныхРезультатов = 1;
					КонецЕсли;
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = ТаблицаРезультат.Добавить();
				НоваяСтрока.ЗадачаСсылка = ВыборкаДетальныеЗаписи.Задача;
				НоваяСтрока.Предмет = ВыборкаДетальныеЗаписи.Предмет;
				НоваяСтрока.Идентификатор = ВыборкаДетальныеЗаписи.Идентификатор;
				НоваяСтрока.ИдентификаторЗадачи = ВыборкаДетальныеЗаписи.ИдентификаторЗадачи;
				НоваяСтрока.Цель = Строка.ЗначениеАвтор;
				НоваяСтрока.Результат = Строка.ЗначениеИсполнитель;
				Если НоваяСтрока.Результат = Неопределено Тогда 
					НоваяСтрока.Результат = "";
				КонецЕсли;
				НоваяСтрока.КоличествоОжидаемыхРезультатов = 1;
				
				Если НЕ ПустаяСтрока(НоваяСтрока.Результат) Тогда
					НоваяСтрока.КоличествоВыполненныхРезультатов = 1;
				КонецЕсли;
								
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатЗапроса[0].Выгрузить(),ТаблицаРезультат);
	
	Возврат ТаблицаРезультат;
	
КонецФункции

Функция СформироватьСписокРезультат(Предмет, Результат, Исполнитель = Ложь, ЭтоОжидаемыйРезультат, Задача, СписокАнкет)
	
	СписокРезультат = Новый СписокЗначений;
	
	Для Каждого СтрокаСписка Из Результат Цикл
		
		Если ТипЗнч(СтрокаСписка.Значение) = Тип("ПланВидовХарактеристикСсылка.вогВариантыОпросов") Тогда
			
			Если Исполнитель Тогда
				
				Отбор = Новый Структура("ВариантОпроса,ДокументОснование,Респондент",СтрокаСписка.Значение,Задача,Предмет);
				НайденныеСтроки = СписокАнкет.НайтиСтроки(Отбор);
				Если НайденныеСтроки.Количество() > 0 Тогда
					
					СписокРезультат.Добавить(НайденныеСтроки[0].Ссылка,, Истина);
					
				ИначеЕсли СтрокаСписка.Значение.ТипЗначения.СодержитТип(ТипЗнч(Предмет)) Тогда
					
					ПредставлениеРезультата = СтрШаблон(НСтр("ru = 'Создайте анкету %1'"), СтрокаСписка.Представление);
					СписокРезультат.Добавить(СтрокаСписка.Значение, ПредставлениеРезультата);
					
				КонецЕсли;
				
			ИначеЕсли СтрокаСписка.Значение.ТипЗначения.СодержитТип(ТипЗнч(Предмет)) Тогда
				
				СписокРезультат.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(СтрокаСписка.Значение) = Тип("Строка") Тогда
			
			Если Исполнитель Тогда
				
				Если Не ПустаяСтрока(СтрокаСписка.Значение)
					И Не ЭтоОжидаемыйРезультат Тогда
					СписокРезультат.Добавить(СтрокаСписка.Значение,, Истина);
				Иначе
					СписокРезультат.Добавить("", НСтр("ru = 'Введите результат выполнения'"));
				КонецЕсли;
				
			Иначе
				СписокРезультат.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(СтрокаСписка.Значение) = Тип("ДокументСсылка.CRM_Мероприятие") Тогда
			
			Если Исполнитель Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	CRM_МероприятиеСторонниеЛица.Ссылка КАК Ссылка
				|ИЗ
				|	Документ.CRM_Мероприятие.СторонниеЛица КАК CRM_МероприятиеСторонниеЛица
				|ГДЕ
				|	CRM_МероприятиеСторонниеЛица.Ссылка.ПометкаУдаления = ЛОЖЬ
				|	И CRM_МероприятиеСторонниеЛица.Ссылка.ДокументОснование = &ДокументОснование
				|	И ВЫБОР
				|			КОГДА &ИспользоватьКлиенты
				|				ТОГДА CRM_МероприятиеСторонниеЛица.Партнер = &Предмет
				|			КОГДА &ИспользоватьТорговыеТочки
				|				ТОГДА CRM_МероприятиеСторонниеЛица.вогТорговаяТочка = &Предмет
				|			ИНАЧЕ ЛОЖЬ
				|		КОНЕЦ";
				
				Запрос.УстановитьПараметр("ИспользоватьКлиенты", 		ТипЗнч(Предмет) = Тип("СправочникСсылка.Партнеры"));
				Запрос.УстановитьПараметр("ИспользоватьТорговыеТочки", 	ТипЗнч(Предмет) = Тип("СправочникСсылка.вогТорговыеТочки"));
				Запрос.УстановитьПараметр("Предмет", 					Предмет);
				Запрос.УстановитьПараметр("ДокументОснование", 			Задача);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				Если Не РезультатЗапроса.Пустой() Тогда
					
					ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
					
					Если ВыборкаДетальныеЗаписи.Следующий() Тогда
						СписокРезультат.Добавить(ВыборкаДетальныеЗаписи.Ссылка,, Истина);
					КонецЕсли;
					
				Иначе
					СписокРезультат.Добавить(СтрокаСписка.Значение, НСтр("ru = 'Создайте мероприятие'"));
				КонецЕсли;
				
			Иначе
				СписокРезультат.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(СтрокаСписка.Значение) = Тип("ДокументСсылка.вогКомандировка") Тогда
			
			Если Исполнитель Тогда
				СписокРезультат.Добавить(СтрокаСписка.Значение, НСтр("ru = 'Создайте командировку'"));
			Иначе
				СписокРезультат.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(СтрокаСписка.Значение) = Тип("СправочникСсылка.вогВидыПрисоединенныхФайлов") Тогда
			
			Если Исполнитель Тогда
				ПредставлениеРезультата = СтрШаблон(НСтр("ru = 'Добавьте фото типа %1'"), СтрокаСписка.Значение);
				СписокРезультат.Добавить(СтрокаСписка.Значение, ПредставлениеРезультата);
			Иначе
				СписокРезультат.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
			КонецЕсли;
			
		Иначе
			
			СписокРезультат.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокРезультат
	
КонецФункции
