#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьЭлементыОтбораРекурсивно(Форма, Знач Отбор, Знач Настройка, Родитель = Неопределено, Знач ДоступныеПоляОтбора = Неопределено) Экспорт
	
	Использование 		= Ложь;
	ИдентификаторСтроки = Неопределено;
	
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда
		
		Настройка 		= Отбор.Настройка;
		Использование 	= Отбор.Использование;
		Отбор 			= Отбор.ОтборКомпоновкиДанных;
		
		Если ДоступныеПоляОтбора = Неопределено Тогда
			ЗаполнитьДоступныеПоляОтбора(Форма, ДоступныеПоляОтбора, Настройка);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДоступныеПоляОтбора = Неопределено И ТипЗнч(Отбор) = Тип("ОтборКомпоновкиДанных") Тогда
		ДоступныеПоляОтбора = Отбор.ДоступныеПоляОтбора;
	КонецЕсли;
	
	Если Отбор.Элементы.Количество() > 0 И Родитель = Неопределено Тогда
		
		Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
			Если ЭлементОтбора.Использование Тогда
				Использование = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ЭлементыКорня = Форма.ДеревоОтборов.ПолучитьЭлементы();
		Родитель = ЭлементыКорня.Добавить();
		Родитель.Настройка 		= Настройка;
		Родитель.ЭтоНастройка 	= Истина;
		Родитель.Использование 	= Использование;
		
	КонецЕсли;
	
	Для Каждого ПолеОтбора Из Отбор.Элементы Цикл
		
		ЭлементыКорня 			= Родитель.ПолучитьЭлементы();
		НоваяСтрока 			= ЭлементыКорня.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПолеОтбора);
		НоваяСтрока.Настройка 	= Настройка;
		
		Если ТипЗнч(ПолеОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			НоваяСтрока.ЭтоГруппа 	= Истина;
			ДобавитьЭлементыОтбораРекурсивно(Форма, ПолеОтбора, Настройка, НоваяСтрока, ДоступныеПоляОтбора);
			
		Иначе
			
			Если Не ДоступныеПоляОтбора = Неопределено Тогда
				
				ПолеКомпоновки = ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора.ЛевоеЗначение);
				
				Если Не ПолеКомпоновки = Неопределено Тогда
					
					НоваяСтрока.ДоступныеВидыСравнения 	= ПолеКомпоновки.ДоступныеВидыСравнения;
					НоваяСтрока.ОписаниеТипа 			= ПолеКомпоновки.Тип;
					НоваяСтрока.ДоступныеЗначения 		= ПолеКомпоновки.ДоступныеЗначения;
					
					ДеревоОтборовВидСравненияПриИзменении(НоваяСтрока);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не Родитель = Неопределено Тогда
		ИдентификаторСтроки = Родитель.ПолучитьИдентификатор();
	КонецЕсли;
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДеревоОтборовВидСравненияПриИзменении(СтруктураСтроки) Экспорт
	
	Если ТипЗнч(СтруктураСтроки.ПравоеЗначение) = Тип("СписокЗначений")
		И (СтруктураСтроки.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
		Или СтруктураСтроки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно) Тогда
		
		Если СтруктураСтроки.ПравоеЗначение.Количество() > 0 Тогда
			
			СтруктураСтроки.ПравоеЗначение 	= СтруктураСтроки.ПравоеЗначение[0].Значение;
			
		Иначе
			
			ОписаниеТиповЗначения 			= СтруктураСтроки.ПравоеЗначение.ТипЗначения;
			СтруктураСтроки.ПравоеЗначение 	= ОписаниеТиповЗначения.ПривестиЗначение();
			СтруктураСтроки.ОписаниеТипа 	= ОписаниеТиповЗначения;
			
		КонецЕсли;
	
	ИначеЕсли ЗначениеЗаполнено(СтруктураСтроки.ПравоеЗначение)
		И (СтруктураСтроки.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено
		Или СтруктураСтроки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено) Тогда
		
		ТипПравогоЗначения = ТипЗнч(СтруктураСтроки.ПравоеЗначение);
		
		Если ТипПравогоЗначения = Тип("СписокЗначений") Тогда
			ОписаниеТиповЗначения = СтруктураСтроки.ПравоеЗначение.ТипЗначения;
		Иначе
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипПравогоЗначения);
			
			ОписаниеТиповЗначения = Новый ОписаниеТипов(МассивТипов);
			
		КонецЕсли;
		
		СтруктураСтроки.ПравоеЗначение = ОписаниеТиповЗначения.ПривестиЗначение();
		
	ИначеЕсли Не ТипЗнч(СтруктураСтроки.ПравоеЗначение) = Тип("СписокЗначений")
		И (СтруктураСтроки.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке
		Или СтруктураСтроки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке) Тогда
		
		Если Не СтруктураСтроки.ПравоеЗначение = Неопределено Тогда
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипЗнч(СтруктураСтроки.ПравоеЗначение));
			
			ОписаниеТиповЗначения = Новый ОписаниеТипов(МассивТипов);
			
		Иначе
			
			ОписаниеТиповЗначения = СтруктураСтроки.ОписаниеТипа;
			
		КонецЕсли;
		
		СписокПравоеЗначение = Новый СписокЗначений;
		СписокПравоеЗначение.ТипЗначения = ОписаниеТиповЗначения;
		
		Если Не СтруктураСтроки.ДоступныеЗначения = Неопределено
			И СтруктураСтроки.ДоступныеЗначения.Количество() > 0 Тогда
			
			СписокПравоеЗначение.ДоступныеЗначения = СтруктураСтроки.ДоступныеЗначения;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтруктураСтроки.ПравоеЗначение) Тогда
			СписокПравоеЗначение.Добавить(СтруктураСтроки.ПравоеЗначение);
		КонецЕсли;
		
		СтруктураСтроки.ПравоеЗначение 	= СписокПравоеЗначение;
		
	КонецЕсли;
	
	Если Не СтруктураСтроки.ПравоеЗначение = Неопределено Тогда
		
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(СтруктураСтроки.ПравоеЗначение));
		
		СтруктураСтроки.ОписаниеТипа 	= Новый ОписаниеТипов(МассивТипов);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДоступныеПоляОтбора(Форма, ДоступныеПоляОтбора, Настройка)
	
	ПараметрыОтбораСтрок = Новый Структура;
	ПараметрыОтбораСтрок.Вставить("Настройка", Настройка);
	
	СтрокиНастроек = Форма.ТаблицаВозможныхИсполнителей.НайтиСтроки(ПараметрыОтбораСтрок);
	
	Если СтрокиНастроек.Количество() > 0 Тогда
		
		СтрокаДанных = СтрокиНастроек[0];
		
		ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(
			СтрокаДанных.АдресСхемыКомпоновкиДанных);
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
		КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
		
		ДоступныеПоляОтбора = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли