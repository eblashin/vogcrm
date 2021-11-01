﻿
#Область ПрограммныйИнтерфейс

Функция GetObjectsList()
	
	Результат = Новый СписокЗначений;
	
	ПринадлежностьКлассификаторов = CRM_КлассификаторыПовтИсп.ПринадлежностьКлассификаторов();
	Для Каждого ЭлементПринадлежность Из ПринадлежностьКлассификаторов Цикл
		МассивПринадлежность = СтрРазделить(ЭлементПринадлежность.Значение, ".");
		
		Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1_%2'"), 
			МассивПринадлежность[0], МассивПринадлежность[МассивПринадлежность.ВГраница()]);	
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 ""%2""'"), 
			МассивПринадлежность[0], ЭлементПринадлежность.Представление);		
			
		Результат.Добавить(Значение, Представление);
		
	КонецЦикла;
	
	Возврат вогОбщегоНазначения.СериализоватьОбъект(Результат);
	
КонецФункции

Функция GetClassifiersValueTree(ObjectsList)
	
	Дерево = Новый ДеревоЗначений;
	
	Дерево.Колонки.Добавить("Принадлежность"			 		   , ОбщегоНазначения.ОписаниеТипаСтрока(1024));
	Дерево.Колонки.Добавить("ТипУровня"				   			   , ОбщегоНазначения.ОписаниеТипаСтрока(50));
	
	Дерево.Колонки.Добавить("КлассификаторИдентификатор"		   , ОбщегоНазначения.ОписаниеТипаСтрока(36));
	Дерево.Колонки.Добавить("КлассификаторПредставление"		   , Новый ОписаниеТипов("Строка"));
	
	Дерево.Колонки.Добавить("ЗначениеИдентификатор"				   , ОбщегоНазначения.ОписаниеТипаСтрока(36));
	Дерево.Колонки.Добавить("ЗначениеПредставление"				   , Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("ЭтоДополнительныйРеквизит"			   , Новый ОписаниеТипов("Булево"));
	
	Дерево.Колонки.Добавить("ИндексКартинки"					   , ОбщегоНазначения.ОписаниеТипаЧисло(2));
	Дерево.Колонки.Добавить("Принадлежность_Классификатор_Значение", Новый ОписаниеТипов("Строка"));
		
	ПринадлежностьКлассификаторов = вогОбщегоНазначения.ДесериализоватьОбъект(ObjectsList);
	Для каждого ЭлементПринадлежность Из ПринадлежностьКлассификаторов Цикл
		Принадлежность 				 = ЭлементПринадлежность.Значение;
		ПринадлежностьПредставление  = ЭлементПринадлежность.Представление;
						
		//Строки классификаторов
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТаблицаКлассификаторов", CRM_КлассификаторыВызовСервера.ТаблицаКлассификаторов(Принадлежность));
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТаблицаКлассификаторов.Классификатор КАК Классификатор
			|ПОМЕСТИТЬ втТаблицаКлассификаторов
			|ИЗ
			|	&ТаблицаКлассификаторов КАК ТаблицаКлассификаторов
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Классификатор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	CRM_ЗначенияКлассификаторов.Владелец КАК Классификатор,
			|	CRM_ЗначенияКлассификаторов.Владелец.Представление КАК КлассификаторПредставление,
			|	CRM_ЗначенияКлассификаторов.Ссылка КАК Значение,
			|	CRM_ЗначенияКлассификаторов.Представление КАК ЗначениеПредставление,
			|	CRM_ЗначенияКлассификаторов.ДополнительныйРеквизит КАК ДополнительныйРеквизит
			|ИЗ
			|	Справочник.CRM_ЗначенияКлассификаторов КАК CRM_ЗначенияКлассификаторов
			|ГДЕ
			|	CRM_ЗначенияКлассификаторов.Владелец В
			|			(ВЫБРАТЬ
			|				втТаблицаКлассификаторов.Классификатор
			|			ИЗ
			|				втТаблицаКлассификаторов КАК втТаблицаКлассификаторов)
			|ИТОГИ ПО
			|	Классификатор";
		
		
		ВыборкаКлассификатор = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Если ВыборкаКлассификатор.Количество() = 0 Тогда
			Продолжить;		
		КонецЕсли;
		
		Принадлежность = СтрЗаменить(Принадлежность, ".", "_");
		
		СтрокаУзел1 = Дерево.Строки.Добавить();
		
		СтрокаУзел1.ТипУровня 						 	  = "Принадлежность";
		СтрокаУзел1.ИндексКартинки						  = 2;
		СтрокаУзел1.Принадлежность 						  = Принадлежность;
		СтрокаУзел1.Принадлежность_Классификатор_Значение = ПринадлежностьПредставление;
		
		Пока ВыборкаКлассификатор.Следующий() Цикл
			СтрокаУзел2 = СтрокаУзел1.Строки.Добавить();
			
			СтрокаУзел2.ТипУровня 						 	  = "Классификатор";
			СтрокаУзел2.ИндексКартинки 						  = 25;
			СтрокаУзел2.Принадлежность 						  = Принадлежность;
			
			СтрокаУзел2.КлассификаторИдентификатор 			  = XMLСтрока(ВыборкаКлассификатор.Классификатор);
			СтрокаУзел2.КлассификаторПредставление 			  = ВыборкаКлассификатор.КлассификаторПредставление;
			СтрокаУзел2.Принадлежность_Классификатор_Значение = ВыборкаКлассификатор.КлассификаторПредставление;
						
			//Значения классификаторов
			ВыборкаЗаписи = ВыборкаКлассификатор.Выбрать();
			Пока ВыборкаЗаписи.Следующий() Цикл
				СтрокаУзел3 = СтрокаУзел2.Строки.Добавить();
				
				СтрокаУзел3.ТипУровня 						 	  = "Значение";
				СтрокаУзел3.ИндексКартинки 			   			  = 5;
				СтрокаУзел3.Принадлежность 			  			  = Принадлежность;
				СтрокаУзел3.КлассификаторИдентификатор 			  = СтрокаУзел2.КлассификаторИдентификатор;
				СтрокаУзел3.КлассификаторПредставление 			  = СтрокаУзел2.КлассификаторПредставление;
				СтрокаУзел3.ЗначениеИдентификатор 			  	  = XMLСтрока(ВыборкаЗаписи.Значение);
				СтрокаУзел3.ЗначениеПредставление 			 	  = ВыборкаЗаписи.ЗначениеПредставление;
				СтрокаУзел3.ЭтоДополнительныйРеквизит 			  = ЗначениеЗаполнено(ВыборкаЗаписи.ДополнительныйРеквизит);
				СтрокаУзел3.Принадлежность_Классификатор_Значение = ВыборкаЗаписи.ЗначениеПредставление;
				
				
				
			КонецЦикла;			
			
		КонецЦикла;
			
	КонецЦикла;	
	
	Возврат вогОбщегоНазначения.СериализоватьОбъект(Дерево);
	
КонецФункции

Функция PutClassifiersValueTable(ClassifiersValueTable)

	ТаблицаРезультат = Новый ТаблицаЗначений;
	ТаблицаРезультат.Колонки.Добавить("Принадлежность"            , ОбщегоНазначения.ОписаниеТипаСтрока("1024"));
	ТаблицаРезультат.Колонки.Добавить("КлассификаторИдентификатор", ОбщегоНазначения.ОписаниеТипаСтрока("36"));
	ТаблицаРезультат.Колонки.Добавить("ЗначениеИдентификатор"     , ОбщегоНазначения.ОписаниеТипаСтрока("36"));
	ТаблицаРезультат.Колонки.Добавить("РеквизитИдентификатор"	  , Новый ОписаниеТипов("Строка"));
	ТаблицаРезультат.Колонки.Добавить("ИмяМенеджераЗначения" 	  , ОбщегоНазначения.ОписаниеТипаСтрока("1024"));
		
	МенеджерЗначений  	    = Справочники.CRM_ЗначенияКлассификаторов;
	МенеджерКлассификаторов = ПланыВидовХарактеристик.CRM_Классификаторы;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОбъектыКлассификаторов", вогОбщегоНазначения.ДесериализоватьОбъект(ClassifiersValueTable));
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаОбъектыКлассификаторов.Принадлежность,
		|	ТаблицаОбъектыКлассификаторов.ОбъектИдентификатор,
		|	ТаблицаОбъектыКлассификаторов.КлассификаторИдентификатор,
		|	ТаблицаОбъектыКлассификаторов.ЗначениеИдентификатор,
		|	ТаблицаОбъектыКлассификаторов.ЗначениеПредставление,
		|	ТаблицаОбъектыКлассификаторов.РеквизитИдентификатор,
		|	ТаблицаОбъектыКлассификаторов.ИмяМенеджераЗначения
		|ПОМЕСТИТЬ втТаблицаОбъектыКлассификаторов
		|ИЗ
		|	&ТаблицаОбъектыКлассификаторов КАК ТаблицаОбъектыКлассификаторов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втТаблицаОбъектыКлассификаторов.Принадлежность,
		|	втТаблицаОбъектыКлассификаторов.ОбъектИдентификатор,
		|	втТаблицаОбъектыКлассификаторов.КлассификаторИдентификатор,
		|	втТаблицаОбъектыКлассификаторов.ЗначениеИдентификатор,
		|	втТаблицаОбъектыКлассификаторов.ЗначениеПредставление,
		|	втТаблицаОбъектыКлассификаторов.РеквизитИдентификатор,
		|	втТаблицаОбъектыКлассификаторов.ИмяМенеджераЗначения
		|ИЗ
		|	втТаблицаОбъектыКлассификаторов КАК втТаблицаОбъектыКлассификаторов
		|ИТОГИ ПО
		|	втТаблицаОбъектыКлассификаторов.Принадлежность,
		|	втТаблицаОбъектыКлассификаторов.ОбъектИдентификатор,
		|	втТаблицаОбъектыКлассификаторов.КлассификаторИдентификатор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПринадлежность = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПринадлежность.Следующий() Цикл
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ВыборкаПринадлежность.Принадлежность);
				
		ВыборкаОбъектИдентификатор = ВыборкаПринадлежность.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОбъектИдентификатор.Следующий() Цикл
			
			НачатьТранзакцию();
			
			//Объект
			ОбъектСсылка = МенеджерОбъекта.ПолучитьСсылку(
				Новый УникальныйИдентификатор(ВыборкаОбъектИдентификатор.ОбъектИдентификатор));
			Если СтрНайти(Строка(ОбъектСсылка), "Объект не найден") > 0 Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не найден объект метаданных ""%1"" по ссылке ""%2"".'"), 
					ВыборкаПринадлежность.Принадлежность, ВыборкаОбъектИдентификатор.ОбъектИдентификатор);
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Синхронизация классификаторов объектов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,,
					ТекстОшибки);
					
				Продолжить;
			
			КонецЕсли;
			
			ВыборкаКлассификаторИдентификатор = ВыборкаОбъектИдентификатор.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаКлассификаторИдентификатор.Следующий() Цикл
				//Классификатор
				КлассификаторСсылка = МенеджерКлассификаторов.ПолучитьСсылку(
					Новый УникальныйИдентификатор(ВыборкаКлассификаторИдентификатор.КлассификаторИдентификатор));
				
				ТаблицаОписанияКлассификатора = СформироватьТаблицуОписанияКлассификатора(ОбъектСсылка, КлассификаторСсылка);
				
				ВыборкаЗаписи = ВыборкаКлассификаторИдентификатор.Выбрать();
				Пока ВыборкаЗаписи.Следующий() Цикл
					//Значение
					Если ЗначениеЗаполнено(ВыборкаЗаписи.ЗначениеИдентификатор) Тогда
						ЗначениеСсылка = МенеджерЗначений.ПолучитьСсылку(
							Новый УникальныйИдентификатор(ВыборкаЗаписи.ЗначениеИдентификатор));
					Иначе
						ЗначенияЗаполнения = Новый Структура;
						ЗначенияЗаполнения.Вставить("Наименование" , ВыборкаЗаписи.ЗначениеПредставление);
						
						//Возможен идентификатор перечисления (ИмяЗначенияПеречисления)
						Если СтрНайти(ВыборкаЗаписи.РеквизитИдентификатор, "-") > 0 Тогда
							ЗначенияЗаполнения.Вставить("Идентификатор", ВыборкаЗаписи.РеквизитИдентификатор);
						КонецЕсли;
						
						ЗначениеСсылка = CRM_КлассификаторыВызовСервера.СформироватьЗначениеКлассификатора(КлассификаторСсылка, ЗначенияЗаполнения, МенеджерЗначений);	
						
						СтрокаРезультат = ТаблицаРезультат.Добавить();
						СтрокаРезультат.Принадлежность 			   = ВыборкаЗаписи.Принадлежность;
						СтрокаРезультат.КлассификаторИдентификатор = ВыборкаЗаписи.КлассификаторИдентификатор;
						СтрокаРезультат.ЗначениеИдентификатор 	   = XMLСтрока(ЗначениеСсылка);
						СтрокаРезультат.РеквизитИдентификатор 	   = ВыборкаЗаписи.РеквизитИдентификатор;
						СтрокаРезультат.ИмяМенеджераЗначения 	   = ВыборкаЗаписи.ИмяМенеджераЗначения;
						
					КонецЕсли;
					
					СтрукутраРеквизитовЗначения = Новый Структура;
					СтрукутраРеквизитовЗначения.Вставить("ДополнительныйРеквизит");
					СтрукутраРеквизитовЗначения.Вставить("ТипЗначения", "ДополнительныйРеквизит.ТипЗначения");
					
					РеквизитыЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗначениеСсылка, СтрукутраРеквизитовЗначения);
					Если ВыборкаЗаписи.РеквизитИдентификатор = "true"
					  ИЛИ ВыборкаЗаписи.РеквизитИдентификатор = "false" Тогда
						Включить = Булево(ВыборкаЗаписи.РеквизитИдентификатор);
					ИначеЕсли ВыборкаЗаписи.РеквизитИдентификатор = "00000000-0000-0000-0000-000000000000" Тогда
						Включить = Ложь;
					Иначе	
						Включить = ЗначениеЗаполнено(ВыборкаЗаписи.РеквизитИдентификатор);
					КонецЕсли;
					
					СтруктураСтрокиКлассификатора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КлассификаторСсылка, "ВидОтображения, ХранитьИсториюИзменения");
					СтруктураСтрокиКлассификатора.Вставить("Ссылка"   		  , ЗначениеСсылка);
					СтруктураСтрокиКлассификатора.Вставить("Аналитика"		  , Неопределено);
					СтруктураСтрокиКлассификатора.Вставить("ЗначениеРеквизита", ПривестиЗначениеРеквизита(РеквизитыЗначения, ВыборкаЗаписи.РеквизитИдентификатор));
					
					ИзменитьКлассификатор(ОбъектСсылка, СтруктураСтрокиКлассификатора, ТаблицаОписанияКлассификатора, Включить, Истина);	
					
				КонецЦикла;
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		КонецЦикла;
				
	КонецЦикла;
		
	СтрокаСвертки = "";
	Для каждого КолонкаРезультата Из ТаблицаРезультат.Колонки Цикл
		Если ЗначениеЗаполнено(СтрокаСвертки) Тогда
			СтрокаСвертки = СтрокаСвертки + ",";
		
		КонецЕсли;	
		
		СтрокаСвертки = СтрокаСвертки + КолонкаРезультата.Имя;
		
	КонецЦикла;
	
	ТаблицаРезультат.Свернуть(СтрокаСвертки);	
	
	Возврат вогОбщегоНазначения.СериализоватьОбъект(ТаблицаРезультат);
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция СформироватьТаблицуОписанияКлассификатора(ОбъектСсылка, Классификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	CRM_ОбъектыЗначенийКлассификаторов.ЗначениеКлассификатора КАК Ссылка,
		|	CRM_ОбъектыЗначенийКлассификаторов.Аналитика,
		|	CRM_ОбъектыЗначенийКлассификаторов.ЗначениеРеквизита,
		|	CRM_ОбъектыЗначенийКлассификаторов.ЗначениеКлассификатора.Владелец.ХранитьИсториюИзменения КАК ХранитьИсториюИзменения,
		|	CRM_ОбъектыЗначенийКлассификаторов.ЗначениеКлассификатора.Владелец.ВидОтображения КАК ВидОтображения
		|ИЗ
		|	РегистрСведений.CRM_ОбъектыЗначенийКлассификаторов КАК CRM_ОбъектыЗначенийКлассификаторов
		|ГДЕ
		|	CRM_ОбъектыЗначенийКлассификаторов.Объект = &ОбъектСсылка
		|	И CRM_ОбъектыЗначенийКлассификаторов.ЗначениеКлассификатора.Владелец = &Классификатор";
	
	Запрос.УстановитьПараметр("ОбъектСсылка" , ОбъектСсылка);
	Запрос.УстановитьПараметр("Классификатор", Классификатор);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // СформироватьТаблицаОписанияКлассификатора()

Процедура ИзменитьКлассификатор(ОбъектСсылка, СтрокаКлассификатора, ТаблицаОписанияКлассификатора, Включить, Рекурсивно = Ложь)
	
	Если Не ОбщегоНазначения.СсылкаСуществует(ОбъектСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаАналитик = СформироватьТаблицуАналитики(ОбъектСсылка, СтрокаКлассификатора);
	
	// + VOG Солодов // Добавил цикл из таблицы аналитики
	Для Каждого СтрокаАналитики Из ТаблицаАналитик Цикл
		
		НаборЗаписей = РегистрыСведений.CRM_ОбъектыЗначенийКлассификаторов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(ОбъектСсылка);
		//НаборЗаписей.Отбор.Аналитика.Установить(СтрокаКлассификатора.Аналитика);
		НаборЗаписей.Отбор.Аналитика.Установить(СтрокаАналитики.Аналитика);
		НаборЗаписей.Отбор.ЗначениеКлассификатора.Установить(СтрокаКлассификатора.Ссылка);
		НаборЗаписей.Прочитать();
		
		НаборЗаписей.Очистить();
		Если Включить Тогда
			Запись = НаборЗаписей.Добавить();
			
			Запись.Объект  				   = ОбъектСсылка;
			//Запись.Аналитика			   = СтрокаКлассификатора.Аналитика;
			Запись.Аналитика			   = СтрокаАналитики.Аналитика;
			Запись.ЗначениеКлассификатора  = СтрокаКлассификатора.Ссылка;
			Запись.ЗначениеРеквизита  	   = СтрокаКлассификатора.ЗначениеРеквизита;
			Запись.ДатаВключения		   = ТекущаяДата();
			Запись.ХранитьИсториюИзменения = СтрокаКлассификатора.ХранитьИсториюИзменения;
			
		КонецЕсли;	
		
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов", Истина);
		
		Попытка
			НаборЗаписей.Записать();
		Исключение
			
		КонецПопытки;
		
		Если Рекурсивно И СтрокаКлассификатора.ВидОтображения = Перечисления.CRM_ВидыОтображенияКлассификаторов.ОдиночноеЗначение Тогда
			Для каждого СтрокаОписания Из ТаблицаОписанияКлассификатора Цикл
				Если СтрокаОписания.Ссылка = СтрокаКлассификатора.Ссылка Тогда
					Продолжить;
					
				КонецЕсли;
				
				ИзменитьКлассификатор(ОбъектСсылка, СтрокаОписания, ТаблицаОписанияКлассификатора, Ложь);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // ИзменитьКлассификатор()

Функция ПривестиЗначениеРеквизита(РеквизитыЗначения, ЗначениеРеквизитаСтрокой)
	
	Если ЗначениеЗаполнено(РеквизитыЗначения.ДополнительныйРеквизит) Тогда
		Возврат РеквизитыЗначения.ДополнительныйРеквизит.ТипЗначения.ПривестиЗначение(ЗначениеРеквизитаСтрокой);		
	Иначе
		Возврат Неопределено;
	
	КонецЕсли;

КонецФункции // ПривестиЗначениеРеквизита()

Функция СформироватьТаблицуАналитики(ОбъектСсылка, СтрокаКлассификатора)
	
	Если ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.вогТорговыеТочки")
		И СтрокаКлассификатора.Ссылка.Владелец.ИспользуемаяАналитика 
			<> ПланыВидовХарактеристик.CRM_АналитикаКлассификаторов.ПустаяСсылка()
		И СтрокаКлассификатора.Ссылка.Владелец.ИспользуемаяАналитика.ТипЗначения 
			= Новый ОписаниеТипов("СправочникСсылка.НаправленияДеятельности")
		И ОбъектСсылка.Направления.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаНаправления.Направление КАК Направление
		|ПОМЕСТИТЬ ВТ_Направления
		|ИЗ
		|	&ТаблицаНаправления КАК ТаблицаНаправления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_Направления.Направление КАК Аналитика
		|ИЗ
		|	ВТ_Направления КАК ВТ_Направления";
		
		Запрос.УстановитьПараметр("ТаблицаНаправления", ОбъектСсылка.Направления.Выгрузить());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ТаблицаАналитик = РезультатЗапроса.Выгрузить();
		
	Иначе
		
		Массив = Новый Массив;
		Массив.Добавить(Тип("ПланВидовХарактеристикСсылка.CRM_АналитикаКлассификаторов"));
		
		ТаблицаАналитик = Новый ТаблицаЗначений;
		ТаблицаАналитик.Колонки.Добавить("Аналитика", Новый ОписаниеТипов(Массив));
		
		НоваяСтрокаТЗ = ТаблицаАналитик.Добавить();
		НоваяСтрокаТЗ.Аналитика = СтрокаКлассификатора.Аналитика;	
		
	КонецЕсли;
	
	Возврат ТаблицаАналитик;
	
КонецФункции

#КонецОбласти