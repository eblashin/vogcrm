
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОпределитьПодсистемыИЗаголовок(Параметры);
	ДлительнаяОперация = ОбновитьПанельОтчетовНаСервере();
	
	вогНачальнаяСтраницаПользователяКлиетСервер.НачальнаяСтраницаПользователяПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьHTMLТекст()
	
	Виджет = Справочники.вогВиджетыРабочегоСтола.Отчеты;
	НастройкиВиджетаФона = Виджет.НастройкиВиджета.Получить();
	ОтчетыHTML = НастройкиВиджетаФона.КодЭлемента;
	КодФормирования = НастройкиВиджетаФона.КодФормирования;
	Попытка
		Выполнить(КодФормирования);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	
	
	Для Каждого Строка Из Виджет.Действия Цикл
		НоваяСтрока = ДействияВиджетов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		НоваяСтрока.Виджет = Виджет;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("УстановитьПунктМеню",0.1,Истина);
	
КонецПроцедуры

// +++ VOG Кулаков П.Л. 28.12.2020 DEV-48
&НаКлиенте
Процедура УстановитьПунктМеню()
	Если Элементы.МенюHTML.Документ <> Неопределено Тогда
		Если Элементы.МенюHTML.Документ.readyState = "complete" Тогда
			вогНачальнаяСтраницаПользователяКлиетСервер.НачальнаяСтраницаПользователяПриОткрытии(ЭтаФорма,"отчеты");
			//ОтключитьОбработчикОжидания("УстановитьПунктМеню");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // --- VOG Кулаков П.Л.

// +++ VOG Кулаков П.Л. 28.12.2020 DEV-48
&НаКлиенте
Процедура Подключаемый_МенюHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Element <> Неопределено Тогда
		вогНачальнаяСтраницаПользователяКлиетСервер.МенюHTMLПриНажатии(ЭтаФорма,"отчеты");
	КонецЕсли;
		
КонецПроцедуры // --- VOG Кулаков П.Л. 

&НаСервере
Функция ПолучитьМассивОтчетовНаСервере(СтрокаПоиска);
	
	СтруктураВозврата = Новый Структура("МассивОтчетов, МассивРазделов");
	
	МассивОтчетов = Новый Массив;
	МассивРазделов = Новый Массив;
	
	Для Каждого Строка Из ТаблицаОтчетов Цикл
		СтруктураОтчета = Новый Структура("ИдОтчета, Видимость, Раздел");
		СтруктураОтчета.ИДОтчета = Строка.ИДОтчета;
		СтруктураОтчета.Раздел = ?(Строка.Раздел="","<Не указан>",Строка.Раздел);
		Если СтрНайти(НРег(Строка.НаименованиеОтчета),НРег(СтрокаПоиска)) > 0 ИЛИ СтрокаПоиска = "" Тогда
			СтруктураОтчета.Видимость = Истина;
		Иначе
			СтруктураОтчета.Видимость = Ложь;
		КонецЕсли;
		МассивОтчетов.Добавить(СтруктураОтчета);
	КонецЦикла;
	
	СтруктураВозврата.МассивОтчетов = МассивОтчетов;
	
	Для Каждого СтрокаРаздел Из ТаблицаРазделов Цикл
		СтруктураРаздела = Новый Структура("ИдРаздела, Видимость");
		СтруктураРаздела.ИДРаздела = СтрокаРаздел.ИДРаздела;
		ВидимостьРаздела = Ложь;
		Для Каждого СтрокаОтчета Из МассивОтчетов Цикл
			Если СтрокаОтчета.Раздел = СтрокаРаздел.Раздел 
						И СтрокаОтчета.Видимость = Истина Тогда
				ВидимостьРаздела = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		СтруктураРаздела.Видимость = ВидимостьРаздела;
		
		МассивРазделов.Добавить(СтруктураРаздела);
	КонецЦикла;
	
	СтруктураВозврата.МассивРазделов = МассивРазделов;
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура ОтчетыHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрЧислоВхождений(ДанныеСобытия.Href, "Open_Form") > 0 Тогда	
		
		НайденноеДействие = ДействиеПоСобытию(ДанныеСобытия.Href);
		
		Если Не НайденноеДействие.Количество() = 0 Тогда		
			
			ПараметрыОткрытия = ВыполнитьПроизвольныйКодНаСервере(НайденноеДействие[0].ВыполняемыйКод, ДанныеСобытия.Href);
			
			Если ПараметрыОткрытия = Неопределено Тогда Возврат КонецЕсли;
			
			ОписаниеОповещения = Неопределено;
			Если Не ПараметрыОткрытия.ОписаниеОповещения = Неопределено Тогда
				ОписаниеОповещения = Новый ОписаниеОповещения(ПараметрыОткрытия.ОписаниеОповещения, ЭтотОбъект, ПараметрыОткрытия.ПараметрыОповещения)	
			КонецЕсли;
			
			ОткрытьФорму(ПараметрыОткрытия.НазваниеФормы, ПараметрыОткрытия.Параметры, ЭтаФорма, УникальныйИдентификатор,,, ОписаниеОповещения);
			
		КонецЕсли;	
		
	ИначеЕсли СтрЧислоВхождений(ДанныеСобытия.Href, "Change") > 0 Тогда	
		
		НайденноеДействие = ДействиеПоСобытию(ДанныеСобытия.Href);
		
		Если Не НайденноеДействие.Количество() = 0 Тогда		
			
			ДанныеВыбора = ВыполнитьПроизвольныйКодНаСервере(НайденноеДействие[0].ВыполняемыйКод, ДанныеСобытия.Href);
			
			Если ДанныеВыбора <> Неопределено Тогда
				
				ОписаниеОповещения = Неопределено;
				Если Не ДанныеВыбора.ОписаниеОповещения = Неопределено Тогда
					ОписаниеОповещения = Новый ОписаниеОповещения(ДанныеВыбора.ОписаниеОповещения, ЭтотОбъект, ДанныеВыбора.ПараметрыОповещения)	
				КонецЕсли;
			
				ПоказатьВыборИзСписка(ОписаниеОповещения, ДанныеВыбора.СписокДанных,Элемент);
							
			КонецЕсли;
			
		КонецЕсли;
		          
	ИначеЕсли СтрЧислоВхождений(ДанныеСобытия.Href, "Execute_Client") > 0 Тогда
		
		НайденноеДействие = ДействиеПоСобытию(ДанныеСобытия.Href);
		
		Если Не НайденноеДействие.Количество() = 0 Тогда		
			
			РезультатВыполнения = ВыполнитьПроизвольныйКодНаКлиенте(НайденноеДействие[0].ВыполняемыйКод, ДанныеСобытия.Href);
			
			Если НЕ РезультатВыполнения Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось выполнить запрос. Обратитесь к администратору");
			КонецЕсли;
			
		КонецЕсли;
	ИначеЕсли СтрЧислоВхождений(ДанныеСобытия.Href, "Execute_Server") > 0 Тогда
		
		НайденноеДействие = ДействиеПоСобытию(ДанныеСобытия.Href);
		
		Если Не НайденноеДействие.Количество() = 0 Тогда		
			
			РезультатВыполнения = ВыполнитьПроизвольныйКодНаСервере(НайденноеДействие[0].ВыполняемыйКод, ДанныеСобытия.Href);
			
			Если НЕ РезультатВыполнения Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось выполнить запрос. Обратитесь к администратору");
			КонецЕсли;
			
		КонецЕсли;
	ИначеЕсли СтрЧислоВхождений(ДанныеСобытия.Href, "View_Option") > 0 Тогда
		
		НайденноеДействие = ДействиеПоСобытию(ДанныеСобытия.Href);
		
		Если Не НайденноеДействие.Количество() = 0 Тогда		
			
			РезультатВыполнения = ВыполнитьПроизвольныйКодНаСервере(НайденноеДействие[0].ВыполняемыйКод, ДанныеСобытия.Href);
			
			Если НЕ РезультатВыполнения Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось выполнить запрос. Обратитесь к администратору");
			КонецЕсли;
			
		КонецЕсли;
		
	// +++ VOG Кулаков П.Л. 07.04.2021
	ИначеЕсли ДанныеСобытия.element.id = "findreport" Тогда
		СтрокаПоиска = Элементы.ОтчетыHTML.Документ.document.getElementById("textsearch").Value;
		СтруктураОтчетов = ПолучитьМассивОтчетовНаСервере(СокрЛП(СтрокаПоиска));
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON,СтруктураОтчетов.МассивОтчетов);
		СериализованнаяСтрока = ЗаписьJSON.Закрыть();
		Элементы.ОтчетыHTML.Документ.defaultView.FindReport(СериализованнаяСтрока);
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON,СтруктураОтчетов.МассивРазделов);
		СериализованнаяСтрока = ЗаписьJSON.Закрыть();
		Элементы.ОтчетыHTML.Документ.defaultView.FindCategory(СериализованнаяСтрока);
	// --- VOG Кулаков П.Л.	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДействиеПоСобытию(ИмяСобытия)
	
	Если СтрНайти(ИмяСобытия, "Open_Form_Credit_Control") Тогда
		
		Действие = "Open_Form_Credit_Control";
		
	Иначе
		
		НомерСимвола = СтрНайти(ИмяСобытия, "/", НаправлениеПоиска.СКонца);
			
		Действие = Сред(ИмяСобытия, НомерСимвола + 1, СтрДлина(ИмяСобытия));	
		
		Если СтрНайти(Действие, "_ID_") Тогда		
			Действие = Сред(Действие, 0, СтрНайти(Действие, "_", НаправлениеПоиска.СКонца) - 1)	
		КонецЕсли;
		
	КонецЕсли;	
	
	Возврат ДействияВиджетов.НайтиСтроки(Новый Структура("Действие", Действие));
	
КонецФункции

&НаКлиенте
Функция ВыполнитьПроизвольныйКодНаКлиенте(ВыполняемыйКод, ИмяСобытия)
	
	Результат = Неопределено;
	
	Выполнить(ВыполняемыйКод);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВыполнитьПроизвольныйКодНаСервере(ВыполняемыйКод, ИмяСобытия)
	
	Результат = Неопределено;
	
	Выполнить(ВыполняемыйКод);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОпределитьПодсистемыИЗаголовок(Параметры)
	
	Если Параметры.ПутьКПодсистеме = ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы() Тогда
		ТекущийРазделПолноеИмя = Параметры.ПутьКПодсистеме;
	Иначе
		ТекущийРазделПолноеИмя = "Подсистема." + СтрЗаменить(Параметры.ПутьКПодсистеме, ".", ".Подсистема.");
	КонецЕсли;
	
	ПодсистемыПрограммы.Очистить();
	ВсеПодсистемы = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя();
	ВсеРазделы = ВсеПодсистемы.Строки[0].Строки;
	ПодсистемыПоСсылке = Новый Соответствие;
	
	Для Каждого СтрокаРаздел Из ВсеРазделы Цикл
		СтрокаТаблицы = ПодсистемыПрограммы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаРаздел);
		СтрокаТаблицы.ИмяЭлемента    = СтрЗаменить(СтрокаРаздел.ПолноеИмя, ".", "_");
		СтрокаТаблицы.НомерЭлемента  = 0;
		СтрокаТаблицы.РазделСсылка   = СтрокаРаздел.Ссылка;
		
		ПодсистемыПоСсылке[СтрокаТаблицы.Ссылка] = СтрокаТаблицы.ПолучитьИдентификатор();
		
		Если СтрокаРаздел.ПолноеИмя = ТекущийРазделПолноеИмя Тогда
			ТекущийРазделСсылка = СтрокаРаздел.Ссылка;
		КонецЕсли;
		
		Найденные = СтрокаРаздел.Строки.НайтиСтроки(Новый Структура("РазделСсылка", СтрокаРаздел.Ссылка), Истина);
		Для Каждого СтрокаДерева Из Найденные Цикл
			СтрокаТаблицы = ПодсистемыПрограммы.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаДерева);
			СтрокаТаблицы.ИмяЭлемента    = СтрЗаменить(СтрокаТаблицы.ПолноеИмя, ".", "_");
			СтрокаТаблицы.НомерЭлемента  = 0;
			СтрокаТаблицы.РодительСсылка = СтрокаДерева.Родитель.Ссылка;
			СтрокаТаблицы.РазделСсылка   = СтрокаРаздел.Ссылка;
			
			ПодсистемыПоСсылке[СтрокаТаблицы.Ссылка] = СтрокаТаблицы.ПолучитьИдентификатор();
			Если СтрокаДерева.ПолноеИмя = ТекущийРазделПолноеИмя Тогда
				ТекущийРазделСсылка = СтрокаДерева.Ссылка;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ТекущийРазделСсылка = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для панели отчетов указан несуществующий раздел ""%1"" (см. ВариантыОтчетовПереопределяемый.ОпределитьРазделыСВариантамиОтчетов).'"),
			Параметры.ПутьКПодсистеме);
	КонецЕсли;
	
	КлючНазначенияИспользования = "Раздел_" + Строка(ТекущийРазделСсылка.УникальныйИдентификатор());
	ПодсистемаПоСсылке = Новый ФиксированноеСоответствие(ПодсистемыПоСсылке);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьПанельОтчетовНаСервере(Знач Событие = "")
	
	Если ЗначениеЗаполнено(Событие) И ДлительнаяОперация <> Неопределено И ДлительнаяОперация.Статус = "Выполняется" Тогда 
		Возврат Неопределено;
	КонецЕсли;
				
	// Сброс номера последнего добавленного элемента.
	Для Каждого СтрокаТаблицы Из ПодсистемыПрограммы Цикл
		СтрокаТаблицы.НомерЭлемента = 0;
		СтрокаТаблицы.ВидимыхВариантов = 0;
	КонецЦикла;
	
	// Заполнение панели отчетов
	Возврат ЗаполнитьПанельОтчетовВФоне();
КонецФункции

&НаСервере
Функция ЗаполнитьПанельОтчетовВФоне()
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("РежимНастройки", Ложь);
	ПараметрыПоиска.Вставить("СтрокаПоиска", "");
	ПараметрыПоиска.Вставить("ИскатьВоВсехРазделах", Истина);
	ПараметрыПоиска.Вставить("ТекущийРазделСсылка", ТекущийРазделСсылка);
	
	ТаблицаПодсистем = ПодсистемыПрограммы.Выгрузить(Новый Структура("РазделСсылка", ТекущийРазделСсылка));
	ПараметрыПоиска.Вставить("ПодсистемыПрограммы", ТаблицаПодсистем);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьНеВФоне = (ВариантыОтчетов.ПредставленияЗаполнены() = "Заполнены");
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне("ВариантыОтчетов.НайтиВариантыОтчетовДляВывода", ПараметрыПоиска, ПараметрыВыполнения);
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	КонецЕсли;	
	Если ДлительнаяОперация.Статус <> "Выполнено" Тогда
		Возврат ДлительнаяОперация;
	КонецЕсли;	
	
	ЗаполнитьПанельОтчетов(ДлительнаяОперация.АдресРезультата);
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПанельОтчетов(ПараметрыЗаполненияВременноеХранилище)
	
	Виджет = Справочники.вогВиджетыРабочегоСтола.Отчеты;
	НастройкиВиджетаФона = Виджет.НастройкиВиджета.Получить();
	ОтчетыHTML = НастройкиВиджетаФона.КодЭлемента;
	
	Для Каждого Строка Из Виджет.Действия Цикл
		НоваяСтрока = ДействияВиджетов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		НоваяСтрока.Виджет = Виджет;
	КонецЦикла;
	
	ПараметрыЗаполнения = ПолучитьИзВременногоХранилища(ПараметрыЗаполненияВременноеХранилище);
	УдалитьИзВременногоХранилища(ПараметрыЗаполненияВременноеХранилище);
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("Варианты") И ПараметрыЗаполнения.Варианты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВариантов = ПараметрыЗаполнения.Варианты;
	
	МассивСтрокВариантов = ТаблицаВариантов.Скопировать(Новый Структура("ВерхнийУровень",Истина));
	
	МассивСтрокВариантовБезРодителя = ТаблицаВариантов.Скопировать(Новый Структура("ВерхнийУровень",Ложь));
	Для Каждого Строка Из МассивСтрокВариантовБезРодителя Цикл
		СписокВариантов = ТаблицаВариантов.НайтиСтроки(Новый Структура("Ссылка",Строка.Родитель));
		Если СписокВариантов.Количество() = 0 Тогда 
			НоваяСтрока = МассивСтрокВариантов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		КонецЕсли;
	КонецЦикла;

	
	ТаблицаКартинокОтчетов = ПолучитьТаблицуКартинокОтчетов();
	
	ТекстHTML = "";
	ТекстСтилей = "";
	ТаблицаОтчетовHTML = Новый ТаблицаЗначений;
	ТаблицаОтчетовHTML.Колонки.Добавить("Раздел");
	ТаблицаОтчетовHTML.Колонки.Добавить("Отчет");
	ТаблицаОтчетовHTML.Колонки.Добавить("Порядок");
	ТаблицаОтчетовHTML.Индексы.Добавить("Раздел");
	
	ТаблицаОтчетов.Очистить();
	ТаблицаРазделов.Очистить();
	
	СтрокаКартинкиИзбранное 	= Base64Строка(БиблиотекаКартинок.вогЗвездаЗаполненная.ПолучитьДвоичныеДанные());
	СтрокаКартинкиНеИзбранное 	= Base64Строка(БиблиотекаКартинок.вогЗвездаПустая.ПолучитьДвоичныеДанные());
	
	Для Каждого СтрокаВарианта Из МассивСтрокВариантов Цикл
	
		ТекстВариантовОтчетов = "<ul>";		
		Раздел = "";
		ТекстСпискаОтчетов = "";
		Описание = "";
		Наименование = "";
		СписокВыведен = Ложь;
		ДвоичныеДанныеКартинки = "";

		СписокВариантов = ТаблицаВариантов.НайтиСтроки(Новый Структура("Родитель",СтрокаВарианта.Ссылка));
		
		КоличествоОтчетов = СписокВариантов.Количество();
		
		НоваяСтрока = ТаблицаОтчетов.Добавить();
		НоваяСтрока.ВариантОтчета 	  = СтрокаВарианта.Ссылка;
		НоваяСтрока.БыстрыйДоступ 	  = СтрокаВарианта.БыстрыйДоступ;
		НоваяСтрока.НаименованиеОтчета = СтрокаВарианта.Наименование;
		
		ИндексОтчета = Формат(ТаблицаОтчетов.Индекс(НоваяСтрока), "ЧН=0; ЧГ=0");
		
		НоваяСтрока.ИДОтчета	  	  = "report_" + ИндексОтчета;
		
		Если КоличествоОтчетов = 0 Тогда
			ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС +  "<li class='reports__list__item' id='report_" + ИндексОтчета + "'>";
		Иначе
			ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС +  "<li class='reports__list__item large' id='report_" + ИндексОтчета + "'><div class='value'>";
		КонецЕсли;
		
		ТекстКартинки = СтрокаКартинкиНеИзбранное;
		ПодсказкаВвода = "Добавить в избранное";
		
		Если СтрокаВарианта.БыстрыйДоступ Тогда
			Раздел = Справочники.вогРазделыОтчетовНачальнойСтраницы.Избранное;
			ТекстКартинки = СтрокаКартинкиИзбранное;
			ПодсказкаВвода = "Удалить из избранного";
		ИначеЕсли НЕ СтрокаВарианта.Ссылка.вогРазделНачальнойСтраницы.Пустая() Тогда
			Раздел = СтрокаВарианта.Ссылка.вогРазделНачальнойСтраницы;
		КонецЕсли;
		
		НоваяСтрока.Раздел = Строка(Раздел);
		
		ТекстКартинкиИзбранное = "<a title='" + ПодсказкаВвода + "' href='Execute_Client_Favorites_ID_" + ИндексОтчета + "'><img class=""imgFavorites"" src='data:image/png;base64," + ТекстКартинки + "'/></a>";
		//ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС + ТекстКартинкиИзбранное;
		
		Для Каждого Вариант Из СписокВариантов Цикл
			
			НоваяСтрока = ТаблицаОтчетов.Добавить();
			НоваяСтрока.ВариантОтчета = Вариант.Ссылка;
		
			Индекс = Формат(ТаблицаОтчетов.Индекс(НоваяСтрока), "ЧН=0; ЧГ=0");
			
			НоваяСтрока.НаименованиеОтчета = Вариант.Наименование;
			НоваяСтрока.ИДОтчета	  	  = "report_" + Индекс;
			НоваяСтрока.Раздел = Строка(Раздел);
			
			Если Не СписокВыведен Тогда
				ТекстСтилей = ТекстСтилей + Символы.ПС + ".report.отчет" + ИндексОтчета + ":before{
						//| background-image: url('data:image/png;base64,<!--КартинкаОтчета-->');
						| background-image: url(<!--КартинкаОтчета-->);
						| }";
				Наименование = Строка(СтрокаВарианта.Наименование);
				ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС + "<div style='position: relative'><a class='report large отчет" + ИндексОтчета + "' href='Execute_Client_OpenReport_ID_" + ИндексОтчета + "'><b>" + Наименование + "</b></a>" + ТекстКартинкиИзбранное + "</div>";
				СписокВыведен = Истина;
			КонецЕсли;
			
			Наименование = Вариант.Наименование;
			ТекстВариантовОтчетов = ТекстВариантовОтчетов + Символы.ПС + "<li class='report_value' id='report_" + Индекс + "'><a href='Execute_Client_OpenReport_ID_" + Индекс + "'>" + Наименование + "</a></li>";

		КонецЦикла;
		
		СписокКартинок = ТаблицаКартинокОтчетов.НайтиСтроки(Новый Структура("Вариант",СтрокаВарианта.Ссылка));
		//Если СписокКартинок.Количество() > 0 И ЗначениеЗаполнено(СписокКартинок[0].Образец) Тогда
		//	Картинка = СписокКартинок[0].Образец.Получить();
		//	Если Картинка <> Неопределено Тогда
		//		ДвоичныеДанныеКартинки = Картинка.ПолучитьДвоичныеДанные();
		//	КонецЕсли;
		//КонецЕсли;
		СтрокаКартинки = "";
		Если СписокКартинок.Количество() > 0 И ЗначениеЗаполнено(СписокКартинок[0].АдресКартинки) Тогда
			Картинка = СписокКартинок[0].АдресКартинки;
			СтрокаКартинки = Картинка;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаВарианта.Описание) Тогда
			Описание = СтрокаВарианта.Описание;
		КонецЕсли;

		Если НЕ СписокВыведен Тогда
			Наименование = СтрокаВарианта.Наименование;
			ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС + "<div style='position: relative'><a class='report отчет" + ИндексОтчета + " ' href='Execute_Client_OpenReport_ID_" + ИндексОтчета + "'><b>" + Наименование + "</b></a>" + ТекстКартинкиИзбранное + "</div>";
			ТекстСтилей = ТекстСтилей + Символы.ПС + ".report.отчет" + ИндексОтчета + ":before{
						//| background-image: url('data:image/png;base64,<!--КартинкаОтчета-->');
						| background-image: url(<!--КартинкаОтчета-->);
						| }";
			НомерПоследнегоЭлемента = СтрНайти(ТекстВариантовОтчетов,"<li class='report_value'>",НаправлениеПоиска.СКонца);
			ТекстВариантовОтчетов = Лев(ТекстВариантовОтчетов,НомерПоследнегоЭлемента - 1);
		КонецЕсли;
			
		ТекстВариантовОтчетов = ТекстВариантовОтчетов + Символы.ПС + "</ul>";
		ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС + "<div class='description'>" + Описание + "</div>";
		Если КоличествоОтчетов > 0 Тогда
			ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС + "</div>" + Символы.ПС + ТекстВариантовОтчетов;
		КонецЕсли;
		ТекстСпискаОтчетов = ТекстСпискаОтчетов + Символы.ПС + "</li>";
		
		//Если НЕ ЗначениеЗаполнено(ДвоичныеДанныеКартинки) Тогда
		//	ДвоичныеДанныеКартинки = БиблиотекаКартинок.вогПросмотрНедоступен.ПолучитьДвоичныеДанные();
		//КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Картинка) Тогда
			СтрокаКартинки = Картинка;
		КонецЕсли;
		
		//СтрокаКартинки = Base64Строка(ДвоичныеДанныеКартинки);
		//СтрокаКартинки = СтрЗаменить(СтрокаКартинки,Символы.ВК,"");
		//СтрокаКартинки = СтрЗаменить(СтрокаКартинки,Символы.ПС,"");	
		ТекстСтилей = СтрЗаменить(ТекстСтилей,"<!--КартинкаОтчета-->",СтрокаКартинки);
		
		Если Раздел = Справочники.вогРазделыОтчетовНачальнойСтраницы.Избранное Тогда
			Порядок = 1;
		ИначеЕсли Раздел = "" Тогда
			Раздел = "<Не указан>";
			Порядок = 3;
		Иначе
			Порядок = 2;
		КонецЕсли;		

		НоваяСтрокаОтчета = ТаблицаОтчетовHTML.Добавить();
		НоваяСтрокаОтчета.Раздел = Строка(Раздел);
		НоваяСтрокаОтчета.Отчет = ТекстСпискаОтчетов;
		НоваяСтрокаОтчета.Порядок = Порядок;
		
	КонецЦикла;
	
	ТаблицаОтчетовHTML.Сортировать("Порядок, Раздел");
	МассивРазделов = ТаблицаОтчетовHTML.ВыгрузитьКолонку("Раздел");
	МассивРазделов = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивРазделов);
	Для Каждого Раздел Из МассивРазделов Цикл
		
		// +++ VOG Кулаков П.Л. 07.04.2021
		НоваяСтрокаРаздела = ТаблицаРазделов.Добавить();
		Индекс = Формат(ТаблицаРазделов.Индекс(НоваяСтрокаРаздела), "ЧН=0; ЧГ=0");
		НоваяСтрокаРаздела.Раздел = Раздел;
		НоваяСтрокаРаздела.ИДРаздела = "category_" + Индекс;
		// --- VOG Кулаков П.Л.
		
		ТекстHTML = ТекстHTML + Символы.ПС + "<h2 class='reports_category h2' id='category_" + Индекс + "'>" + Раздел + "</h2>
				| <ul class='report_list'>";
		НайденныеОтчеты = ТаблицаОтчетовHTML.НайтиСтроки(Новый Структура("Раздел",Раздел));
		Для Каждого СтрокаОтчет Из НайденныеОтчеты Цикл
			ТекстHTML = ТекстHTML + Символы.ПС + СтрокаОтчет.Отчет;
		КонецЦикла;
		ТекстHTML = ТекстHTML + Символы.ПС + "</ul>";
	КонецЦикла;

	ОтчетыHTML = СтрЗаменить(ОтчетыHTML,"<!--ТекстСтилей-->",ТекстСтилей);
	ОтчетыHTML = СтрЗаменить(ОтчетыHTML,"<!--СписокОтчетов-->",ТекстHTML);

	ДвоичныеДанныеКартинки = БиблиотекаКартинок.Обновить.ПолучитьДвоичныеДанные();
	СтрокаКартинки = Base64Строка(ДвоичныеДанныеКартинки);
	ОтчетыHTML = СтрЗаменить(ОтчетыHTML,"<!--КартинкаОбновить-->",СтрокаКартинки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьПользовательскиеНастройки(Вариант, Подсистема, Видимость, БыстрыйДоступ)
	ПакетНастроек = Новый ТаблицаЗначений;
	ПакетНастроек.Добавить();
	Измерения = Новый Структура;
	Измерения.Вставить("Пользователь", Пользователи.АвторизованныйПользователь());
	Измерения.Вставить("Вариант", Вариант);
	Измерения.Вставить("Подсистема", Подсистема);
	Ресурсы = Новый Структура;
	Ресурсы.Вставить("Видимость", Видимость);
	Ресурсы.Вставить("БыстрыйДоступ", БыстрыйДоступ);
	РегистрыСведений.НастройкиВариантовОтчетов.ЗаписатьПакетНастроек(ПакетНастроек, Измерения, Ресурсы, Истина);
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуКартинокОтчетов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вогНастройкиОтображенияОтчетов.Вариант КАК Вариант,
		|	вогНастройкиОтображенияОтчетов.Образец КАК Образец,
		|	вогНастройкиОтображенияОтчетов.АдресКартинки КАК АдресКартинки
		|ИЗ
		|	РегистрСведений.вогНастройкиОтображенияОтчетов КАК вогНастройкиОтображенияОтчетов";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции
	
