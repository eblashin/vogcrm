
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("МассивОписанийОбъектов") Тогда
		ВызватьИсключение НСтр("ru = 'Форма не предназначена для непосредственного использования. '");
	КонецЕсли;
	
	Если Параметры.Свойство("СоздатьРынок") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"СоздатьРынок","Видимость",Параметры.СоздатьРынок);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ИзменитьАдрес","Видимость",Параметры.ИзменитьАдрес);
	
	//Структура действий
	СтруктураДействий = Новый Структура;
	Если Параметры.Свойство("СтруктураДействий") Тогда
		СтруктураДействий = Параметры.СтруктураДействий;	
		Если СтруктураДействий.Свойство("Продолжить") Тогда
			ПараметрыДействия = СтруктураДействий.Продолжить;
			Если ПараметрыДействия.Свойство("КартаМаршрута") Тогда
				Элементы.ПродолжитьВводНового.Заголовок = НСтр("ru = 'Согласовать ввод нового'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ЭлементыДерева = ДеревоНайдено.ПолучитьЭлементы();
	Для каждого ОписаниеОбъекта Из Параметры.МассивОписанийОбъектов Цикл
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ОписаниеОбъекта.ПолноеИмя);
		Если МетаданныеОбъекта = Неопределено Тогда
			Продолжить;
			
		КонецЕсли;
		
		//  + Тищенко В.В.
		
		// ++ Харченко Д.И. №  - 13.09.2018 / 
		Если Метаданные.Справочники.вогТорговыеТочки = МетаданныеОбъекта Тогда
			
			Если ЗначениеЗаполнено(Параметры.ВидТорговойТочки) И Параметры.ВидТорговойТочки = Справочники.вогВидыТорговыхТочек.ТорговаяТочка 
				ИЛИ Параметры.ВидТорговойТочки = Справочники.вогВидыТорговыхТочек.РазовыйПокупатель ИЛИ Параметры.ВидТорговойТочки = Справочники.вогВидыТорговыхТочек.Дизайнер 
				ИЛИ Параметры.ВидТорговойТочки = Справочники.вогВидыТорговыхТочек.ТРТД Тогда // VOG Солодов В.В. 26.08.2019 task 577 // Добавлено условие
				Элементы.СогласоватьДубль.Видимость = Истина;
				Элементы.СогласоватьДубль.КнопкаПоУмолчанию = Истина;	
			КонецЕсли;
			
		КонецЕсли;
		// -- Харченко Д.И. №  - 13.09.2018
		
		// - Тищенко В.В.
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОписаниеОбъекта.ПолноеИмя);
		
		НоваяСтрока = ЭлементыДерева.Добавить();
		НоваяСтрока.Представление = МетаданныеОбъекта.Представление();
		НоваяСтрока.Объект	      = МенеджерОбъекта.ПустаяСсылка();
		НоваяСтрока.Доступен	  = ПравоДоступа("Чтение", МетаданныеОбъекта);
		
		ЭлементыНайденных = НоваяСтрока.ПолучитьЭлементы();
		
		Если ОписаниеОбъекта.Свойство("ТочноеСоответствие") Тогда
			ТочноеСоответствие = ОписаниеОбъекта.ТочноеСоответствие;
		Иначе	
			ТочноеСоответствие = Ложь;
		КонецЕсли;
		
		// ++ Тищенко В.В. 20.05.2019
		// ТРТ проверка только по виду и месторасполжение
		Если ТипЗнч(ОписаниеОбъекта.Объект.Ссылка) = Тип("СправочникСсылка.вогТорговыеТочки") И ЗначениеЗаполнено(Параметры.ВидТорговойТочки) Тогда	
			ДополнительныеПараметры = Новый Структура; 
			ДополнительныеПараметры.Вставить("Адрес",Параметры.ВидТорговойТочки.ВидАдресаТорговойТочки);
			МассивНайденных = вогОбщегоНазначения.НайтиДубли(ОписаниеОбъекта.Объект, ОписаниеОбъекта.СтруктураПоиска, ОписаниеОбъекта.СтруктураОбъекта, ТочноеСоответствие,ДополнительныеПараметры);
		Иначе	
			МассивНайденных = вогОбщегоНазначения.НайтиДубли(ОписаниеОбъекта.Объект, ОписаниеОбъекта.СтруктураПоиска, ОписаниеОбъекта.СтруктураОбъекта, ТочноеСоответствие);
		КонецЕсли;
			
		// -- Тищенко В.В. 
		
		// ++ Тищенко В.В. 11.02.2019
		// Исключение текущего объекта если вызов из 
		// документа вогАнкета
		Если Параметры.Свойство("ТекущаяСсылка") Тогда
			ИсключаемяСсылка = Параметры.ТекущаяСсылка;
			Для Индекс = 0 По МассивНайденных.Количество() - 1 Цикл
				Если МассивНайденных[Индекс].Ссылка = ИсключаемяСсылка Тогда
					МассивНайденных.удалить(Индекс);
					Прервать;
				КонецЕсли;
			КонецЦикла; 
		КонецЕсли;
		// -- Тищенко В.В. 
		
		ПроверкаДобавленных = Новый Массив;
		Для каждого ЭлементНайденных Из МассивНайденных Цикл
			
			Если ПроверкаДобавленных.Найти(ЭлементНайденных.Ссылка) = Неопределено Тогда
				НоваяСтрокаНайденных = ЭлементыНайденных.Добавить();
				НоваяСтрокаНайденных.Объект	       = ЭлементНайденных.Ссылка;
				НоваяСтрокаНайденных.Представление = ЭлементНайденных.Представление;
				НоваяСтрокаНайденных.Доступен	   = (Найти(Строка(ЭлементНайденных.Ссылка), "<Объект не найден>") = 0);
				ПроверкаДобавленных.Добавить(ЭлементНайденных.Ссылка);
			КонецЕсли; 
			
			Строка = ТаблицаРасшифровкаНайдено.Добавить();
			Строка.Объект 				  = ЭлементНайденных.Ссылка;
			Строка.ПредставлениеНайденоПо = СтрЗаменить(ЭлементНайденных.ИмяРеквизита,"CRM_","") + " - " + Строка(ЭлементНайденных.Реквизит);
			
		КонецЦикла;
		
	КонецЦикла;
	
	// ++ Тищенко В.В. 30.01.2019
	ДоступКТТ = Параметры.ДоступКТТ;
	// -- Тищенко В.В. 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Создан новый партнер" 
		И ТипЗнч(Параметр) = Тип("СправочникСсылка.Партнеры") 
		И ТипЗнч(Источник) = Тип("УправляемаяФорма") 
		И Источник.ВладелецФормы = ЭтотОбъект Тогда
		ПараметрыДействия = Новый Структура;
		ПараметрыДействия.Вставить("Партнер"				  , Параметр);
		ПараметрыДействия.Вставить("ПараметрыСозданияПартнера", ПараметрыСозданияПартнера);
		
		Закрыть(Новый Структура("Результат, ПараметрыДействия", "Продолжить", ПараметрыДействия));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоНайдено

&НаКлиенте
Процедура ДеревоНайденоПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаРасшифровкаНайдено.ОтборСтрок = Новый ФиксированнаяСтруктура("Объект", ТекущиеДанные.Объект);
	
	// ++ Тищенко В.В. 30.01.2019 
	Если ДоступКТТ Тогда
		Элементы.ДекорацияДоступ.Видимость			= Не ТекущиеДанные.Доступен;
		Элементы.ПерейтиКНайденному.Доступность		= ТекущиеДанные.Доступен;
		Элементы.ФормаЗапроситьДоступКТТ.Видимость 	= Не ТекущиеДанные.Доступен;
	КонецЕсли;
	// -- Тищенко В.В.
	
	// + Тищенко В.В.
	// Очистка дополнительной информации
	ДополнительнаяИнформация.Очистить();
	
	Если ТипЗнч(ТекущиеДанные.Объект) = Тип("СправочникСсылка.вогТорговыеТочки") 
		И ТекущиеДанные.Объект <> ПредопределенноеЗначение("Справочник.вогТорговыеТочки.ПустаяСсылка") Тогда
		//ПолучитьСписокТорговыхТочек(ТекущиеДанные.Объект);
		ПолучитьДополнительнуюИнформацию(ТекущиеДанные.Объект);
	КонецЕсли;
	// - Тищенко В.В.
	
	// Видимость кнопки отнести к рынку
	// Если есть найденные точки рынки тогда видимость ИСТИНА
	//ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ОтнестиКРынку","Видимость",(ДополнительнаяИнформация.Количество() <> 0))
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНайденоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.Доступен 
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Объект) Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Объект);
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьВводНового(Команда)
	
	Перем ПараметрыДействия;
	
	Действие = "Продолжить";
	СтруктураДействий.Свойство(Действие, ПараметрыДействия);
	
	Закрыть(Новый Структура("Результат, ПараметрыДействия", Действие, ПараметрыДействия));
	
КонецПроцедуры 

// ++ Харченко Д.И. №  - 10.09.2018 / 

&НаКлиенте
Процедура СогласоватьДубль(Команда)
	
	Перем ПараметрыДействия;
	
	Действие = "СогласоватьДубль";
	СтруктураДействий.Свойство(Действие, ПараметрыДействия);
	
	Закрыть(Новый Структура("Результат, ПараметрыДействия", Действие, ПараметрыДействия));
	
КонецПроцедуры
// -- Харченко Д.И. №  - 10.09.2018

&НаКлиенте
Процедура ПерейтиКНайденному(Команда)
	
	Если Элементы.ДеревоНайдено.ТекущиеДанные.Доступен
		И ЗначениеЗаполнено(Элементы.ДеревоНайдено.ТекущиеДанные.Объект) Тогда
		
		Закрыть(Новый Структура("Результат, Объект", "Перейти", Элементы.ДеревоНайдено.ТекущиеДанные.Объект));
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОтнестиКРынку(Команда)
	
	Если ДополнительнаяИнформация.Количество() <> 0 Тогда
		ТекущийОбъект 	= ДополнительнаяИнформация[0].Информация;
		ТекущийРынок 	= вогОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(ТекущийОбъект,"Рынок",Истина);
		Закрыть(Новый Структура("Результат, Объект", "ОтнестиКРынку", ТекущийРынок));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРынок(Команда)
	
	НаименованиеРынка = "";
	Оповещение = Новый ОписаниеОповещения("СоздатьРынокЗавершение", ЭтаФорма,Неопределено);
	ПоказатьВводСтроки(Оповещение,НаименованиеРынка,"Имя рынка",,Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьДоступКТТ(Команда)
	
	Если Элементы.ДеревоНайдено.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Стр из Элементы.ДеревоНайдено.ВыделенныеСтроки Цикл 
		
		НайденнаяСтрока = ДеревоНайдено.НайтиПоИдентификатору(Стр);
		
		// + Тищенко В.В.
		
		// ++ Тищенко В.В. 08.04.2019
		// Задача 000000288
		//
		//Если ПроверитьДоступНаСогласование(Стр) Тогда
		//	ТекстСообщения = НСтр("ru = 'У данного объекта имеется ответственный менеджер/координатор из вашего подразделения.
		//	|Для доступа к данной ТРТ обратитесь к вашему руководителю. '");
		//	ПоказатьПредупреждение(Неопределено,ТекстСообщения);
		//	Возврат;
		//КонецЕсли;
		// -- Тищенко В.В. 
		
		// - Тищенко В.В.
		
		// ++ Тищенко В.В. 04.03.2019
		// Добавленны менеджер и координатор
		// ВладелецФормы.ОтветственныйМенеджер
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Менеджер"		, ВладелецФормы.ОтветственныйМенеджер);
		ДополнительныеПараметры.Вставить("Координатор"	, ВладелецФормы.ОтветственныйКоординатор);
		ВыполнитьЗапускПроцессаПолученияДоступаПоТТ(Стр	, ДополнительныеПараметры);
		// -- Тищенко В.В.
		
		ТекстИнформации = СтрШаблон("Запрос доступа к ТТ %1 отправлен.", НайденнаяСтрока.Представление);
		
		ПоказатьОповещениеПользователя(ТекстИнформации, , "Создан бизнес-процесс для согласования доступа. После утверждения доступ будет предоставлен"); 
	КонецЦикла;	
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		
		Если ВладелецФормы.Открыта() Тогда
			ВладелецФормы.Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
	Если Открыта() Тогда
		Закрыть(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗапускПроцессаПолученияДоступаПоТТ(ИДСтроки, ДополнительныеПараметры)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НайденнаяСтрока = ДеревоНайдено.НайтиПоИдентификатору(ИДСтроки);
	
	Если НЕ ТипЗнч(НайденнаяСтрока.Объект) = Тип("СправочникСсылка.вогТорговыеТочки") Тогда
		Возврат;	
	КонецЕсли;
	
	БПОбъект 		= БизнесПроцессы.CRM_БизнесПроцесс.СоздатьБизнесПроцесс();
	
	БПОбъект.Автор 	= ПараметрыСеанса.ТекущийПользователь;
	БПОбъект.Дата 	= ТекущаяДата();
	
	БПОбъект.Предмет = НайденнаяСтрока.Объект;
	БПОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
	БПОбъект.КартаМаршрута = ПредопределенноеЗначение("Справочник.CRM_КартыМаршрутов.ЗапросНаДоступКТорговойТочке");
	
	СписокТочекСтарта = CRM_БизнесПроцессыЭкспортныеМетоды.ПолучитьВариантыСтарта(БПОбъект.КартаМаршрута);
	
	Для Каждого ЭлементСписка Из СписокТочекСтарта Цикл
		БПОбъект.ТочкаСтарта = СписокТочекСтарта[0].Значение;
	КонецЦикла;
	
	БПОбъект.ДатаСтарта = ТекущаяДата();
	БПОбъект.НомерВерсииКартыМаршрута	= БПОбъект.КартаМаршрута.НомерВерсии;
	БПОбъект.Наименование = СтрШаблон("%1 (%2)", БПОбъект.КартаМаршрута, НайденнаяСтрока.Представление);
	БПОбъект.вогДолжностнаяПозиция = БПОбъект.Автор.CRM_ДолжностнаяПозиция;
	
	НачатьТранзакцию();
	
	Попытка
		
		БПОбъект.Записать();
		БПОбъект.Старт();
		
		Если ТранзакцияАктивна() Тогда
			
			ЗафиксироватьТранзакцию();
			
		КонецЕсли;
		
	Исключение
		
		Сообщить(ОписаниеОшибки());
		
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
	КонецПопытки;
	
	Если ТранзакцияАктивна() Тогда
		
		ЗафиксироватьТранзакцию();
		
	КонецЕсли;
	
	// ++ Тищенко В.В. 04.03.2019
	// Добавленны менеджер и координатор при согласовании
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.Менеджер) Тогда
		МенеджерЗаписи 			= РегистрыСведений.вогОбъектыДляПроцесса.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Процесс 	= БПОбъект.Ссылка;
		МенеджерЗаписи.Объект 	= ДополнительныеПараметры.Менеджер;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.Координатор) Тогда
		МенеджерЗаписи 			= РегистрыСведений.вогОбъектыДляПроцесса.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Процесс 	= БПОбъект.Ссылка;
		МенеджерЗаписи.Объект 	= ДополнительныеПараметры.Координатор;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
	// -- Тищенко В.В. 
	
КонецПроцедуры

// + Тищенко В.В.

&НаКлиенте
Процедура ИзменитьАдрес(Команда)
	
	Перем ПараметрыДействия;
	
	Действие = "ОткрытьКарту";
	СтруктураДействий.Свойство(Действие, ПараметрыДействия);
	
	Закрыть(Новый Структура("Результат, ПараметрыДействия", Действие, ПараметрыДействия));
	
КонецПроцедуры

// - Тищенко В.В.

#КонецОбласти

#Область ВспомогательныеПроцедурыФункции

&НаСервере
Функция ПолучитьСписокТорговыхТочек(Параметр)
	
	//ДополнительнаяИнформация.Очистить();
	//
	//Запрос = Новый Запрос("ВЫБРАТЬ
	//|	вогТорговыеТочки.Ссылка КАК Информация
	//|ИЗ
	//|	Справочник.вогТорговыеТочки КАК вогТорговыеТочки
	//|ГДЕ
	//|	вогТорговыеТочки.Рынок = &Рынок");
	//Запрос.УстановитьПараметр("Рынок",Параметр);
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//Если НЕ РезультатЗапроса.Пустой() Тогда
	//	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выгрузить();
	//	ДополнительнаяИнформация.Загрузить(ВыборкаИзРезультатаЗапроса);
	//КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СоздатьРынокСервер(НаименованиеРынка,АдресРынка,ДобавленныйРынок)
	
	НовыйРынок = Справочники.вогРынки.СоздатьЭлемент();
	НовыйРынок.Наименование = НаименованиеРынка;
	
	УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(НовыйРынок,АдресРынка, Справочники.ВидыКонтактнойИнформации.АдресРынка);
	НовыйРынок.Записать();
	ДобавленныйРынок = НовыйРынок.Ссылка;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДополнительнуюИнформацию(ТорговаяТочка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДополнительнаяИнформация.Очистить();
	
	СтрокаДобавления 				= ДополнительнаяИнформация.Добавить();
	СтрокаДобавления.Информация 	= "Наименование: " + ТорговаяТочка.Наименование;
	
	СтрокаДобавления 				= ДополнительнаяИнформация.Добавить();
	СтрокаДобавления.Информация 	= "Вывеска: " + ТорговаяТочка.Вывеска;
	
	СтрокаДобавления = ДополнительнаяИнформация.Добавить();
	
	ПредставлениеНаправлениедеятельности = "";
	
	Для каждого Стр Из ТорговаяТочка.Направления Цикл
		ПредставлениеНаправлениедеятельности = ПредставлениеНаправлениедеятельности + Стр.Направление + " ";
	КонецЦикла;
	
	СтрокаДобавления.Информация 	= "Направление деятельности: " + ПредставлениеНаправлениедеятельности;
	
	СтрокаДобавления 				= ДополнительнаяИнформация.Добавить();
	СтрокаДобавления.Информация 	= "Грузополучатель: " + Формат(ТорговаяТочка.Грузополучатель,"БЛ=Нет; БИ=Да");
	
	// Классификатор Формат ТТ
	// Времменно для отладки
	ВидКлассификаора = ПланыВидовХарактеристик.CRM_Классификаторы.НайтиПоНаименованию("Формат ТТ");
	
	Если ВидКлассификаора <> Неопределено Тогда
		
		Запрос = Новый Запрос("Выбрать ПЕРВЫЕ 1 РАЗРЕШЕННЫЕ ЗначениеКлассификатора ИЗ РегистрСведений.CRM_ОбъектыЗначенийКлассификаторов КАК РГ 
		|Где Объект = &Объект И ЗначениеКлассификатора.Владелец = &Владелец ");
		Запрос.УстановитьПараметр("Объект",ТорговаяТочка);
		Запрос.УстановитьПараметр("Владелец",ВидКлассификаора);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				СтрокаДобавления 				= ДополнительнаяИнформация.Добавить();
				СтрокаДобавления.Информация 	= ВидКлассификаора.Наименование +": "+ Выборка.ЗначениеКлассификатора;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// Менеджеры
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МенеджерыОбъектов.Менеджер КАК Менеджер,
	|	МенеджерыОбъектов.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.вогМенеджерыОбъектов КАК МенеджерыОбъектов
	|ГДЕ
	|	МенеджерыОбъектов.Владелец = &Владелец
	|	И МенеджерыОбъектов.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)");
	Запрос.УстановитьПараметр("Владелец",ТорговаяТочка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтрокаДобавления 				= ДополнительнаяИнформация.Добавить();
			СтрокаДобавления.Информация 	= "Менеджер: " + Выборка.Менеджер + "; Подразделение: " + Выборка.Подразделение;
		КонецЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#Область Оповещения

&НаКлиенте
Процедура СоздатьРынокЗавершение(ИмяРынка,ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ИмяРынка) И ТаблицаРасшифровкаНайдено.Количество() <> 0 Тогда
		НаименованиеРынка 		= ИмяРынка;
		АдресРынка			 	= Элементы.ТаблицаРасшифровкаНайдено.ТекущиеДанные.ПредставлениеНайденоПо;
		Если СтрНайти(АдресРынка,"Адрес") <> 0 Тогда;
			СоздатьРынокСервер(НаименованиеРынка,АдресРынка,ДобавленныйРынок);
			Закрыть(Новый Структура("Результат, Объект", "ОтнестиКРынку", ДобавленныйРынок));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// + Тищенко В.В.

&НаСервере
Функция ПроверитьДоступНаСогласование(УникальныйИдентификаторСтроки)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущиеПодразделение 	= Справочники.СтруктураПредприятия.ПолучитьОбособленноеПодразделение(Пользователи.ТекущийПользователь().Подразделение);
	НайденнаяСтрока 		= ДеревоНайдено.НайтиПоИдентификатору(УникальныйИдентификаторСтроки);
	
	Если НЕ ТипЗнч(НайденнаяСтрока.Объект) = Тип("СправочникСсылка.вогТорговыеТочки") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МенеджерыОбъектов.Менеджер КАК Менеджер
	|ИЗ
	|	РегистрСведений.вогМенеджерыОбъектов КАК МенеджерыОбъектов
	|ГДЕ
	|	МенеджерыОбъектов.Владелец = &Объект
	|	И МенеджерыОбъектов.Подразделение = &Подразделение");
	
	Запрос.УстановитьПараметр("Объект",НайденнаяСтрока.Объект);
	Запрос.УстановитьПараметр("Подразделение",ТекущиеПодразделение);
	РезультатЗапроса = запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

// - Тищенко В.В.

#КонецОбласти
