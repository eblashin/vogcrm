
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьСКД();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(Объект.СхемаКомпоновкиДанных) Тогда
		
		Если Не ПустаяСтрока(АдресСхемыКомпоновкиДанных) Тогда
			
			ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = 
				Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных));
				
		Иначе
			
			ТекстСообщения = НСтр("ru = 'Необходимо настроить схему компоновки данных.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, 
				Объект.Ссылка,
				"Объект.СхемаКомпоновкиДанных",
				,
				Отказ);
				
		КонецЕсли;
		
	Иначе
		ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
	Если Не ПустаяСтрока(АдресНастроекКомпоновкиДанных) Тогда
		ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = 
			Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных));
	Иначе
		ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СхемаКомпоновкиДанныхПриИзменении(Элемент)
	
	СхемаКомпоновкиДанныхПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаКомпоновкиДанныхОчистка(Элемент, СтандартнаяОбработка)
	
	СоздатьНовыйМакет = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанных(Команда)
	
	ПараметрыФормы 					= Новый Структура;
	ОписаниеОповещенияЗавершения 	= Новый ОписаниеОповещения("РедактироватьСхемуКомпоновкиДанныхЗавершение", ЭтотОбъект);
	
	ИмяФормыРедактирования 				= "ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных";
	ШаблонЗаголовка 					= НСтр("ru = 'Настройка схемы компоновки данных ""%1""'");
	ЗаголовокФормыРедактированияМакета 	= СтрЗаменить(ШаблонЗаголовка, "%1", Объект.Наименование);
	
	Если СоздатьНовыйМакет Тогда
		АдресСхемыКомпоновкиДанных 		= ПоместитьШаблоннуюСхемуКомпоновкиВоВременноеХранилище();
	КонецЕсли;
	
	ПараметрыФормы.Вставить("НеПомещатьНастройкиВСхемуКомпоновкиДанных", 	Истина);
	ПараметрыФормы.Вставить("НеРедактироватьСхемуКомпоновкиДанных", 		Ложь);
	ПараметрыФормы.Вставить("НеНастраиватьУсловноеОформление", 				Истина);
	ПараметрыФормы.Вставить("НеНастраиватьВыбор", 							Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПорядок", 						Ложь);
	ПараметрыФормы.Вставить("УникальныйИдентификатор", 						УникальныйИдентификатор);
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных", 					АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("АдресНастроекКомпоновкиДанных", 				АдресНастроекКомпоновкиДанных);
	ПараметрыФормы.Вставить("Заголовок", 									ЗаголовокФормыРедактированияМакета);
	ПараметрыФормы.Вставить("ИсточникШаблонов", 							Объект.Ссылка);
	ПараметрыФормы.Вставить("ИмяШаблонаСКД", 								Объект.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("ВозвращатьИмяТекущегоШаблонаСКД", 				Истина);
	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		ПараметрыФормы,
		,
		,
		,
		,
		ОписаниеОповещенияЗавершения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Если Результат.Свойство("АдресМакета") Тогда
			
			АдресСхемыКомпоновкиДанных 		= Результат.АдресМакета;
			Объект.СхемаКомпоновкиДанных 	= "";
			
		Иначе
			
			Если ПустаяСтрока(Результат.ИмяТекущегоШаблонаСКД) 
				И Элементы.СхемаКомпоновкиДанных.СписокВыбора.НайтиПоЗначению("") = Неопределено Тогда
				
				Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольный'"));
				
			КонецЕсли;
			
			Объект.СхемаКомпоновкиДанных = Результат.ИмяТекущегоШаблонаСКД;
			
			Если Результат.Свойство("АдресХранилищаНастройкиКомпоновщика") Тогда
				АдресНастроекКомпоновкиДанных = Результат.АдресХранилищаНастройкиКомпоновщика;
			КонецЕсли;
		
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СхемаКомпоновкиДанныхПриИзмененииСервер()
	
	Адреса = Справочники.вогНастройкиОбменаУС.АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(Объект);
	
	АдресСхемыКомпоновкиДанных 		= Адреса.СхемаКомпоновкиДанных;
	АдресНастроекКомпоновкиДанных 	= Адреса.НастройкиКомпоновкиДанных;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСКД()
	
	ПризнакПредопределенногоМакета 			= Врег("Предопределенный");
	ДлинаПризнакаПредопределенногоМакета 	= СтрДлина(ПризнакПредопределенногоМакета);
	
	Для Каждого Макет Из Метаданные.НайтиПоТипу(ТипЗнч(Объект.Ссылка)).Макеты Цикл
		
		Если Макет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Если ВРег(Прав(Макет.Имя, ДлинаПризнакаПредопределенногоМакета)) = ПризнакПредопределенногоМакета Тогда
				Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольная'"));
	
	Если Параметры.ЗначениеКопирования.Пустая() Тогда
		
		СхемаИНастройки = Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.ОписаниеИСхемаКомпоновкиДанныхНастройкиПоИмениМакета(
			Объект.Ссылка, Объект.СхемаКомпоновкиДанных);
			
		Если СхемаИНастройки.СхемаКомпоновкиДанных = Неопределено Тогда
			СоздатьНовыйМакет = Истина;
		КонецЕсли;
		
	Иначе
		СхемаИНастройки = Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.ОписаниеИСхемаКомпоновкиДанныхНастройкиПоИмениМакета(
			Параметры.ЗначениеКопирования, Параметры.ЗначениеКопирования.СхемаКомпоновкиДанных);
	КонецЕсли;
	
	Если ПустаяСтрока(СхемаИНастройки.Описание) Тогда
		Объект.СхемаКомпоновкиДанных = "";
	КонецЕсли;
	
	СхемаКомпоновкиДанныхПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСКДСервер()
	
	Адреса = Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(
		Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.ПустаяСсылка());
	
	АдресСхемыКомпоновкиДанных 		= Адреса.СхемаКомпоновкиДанных;
	АдресНастроекКомпоновкиДанных 	= Адреса.НастройкиКомпоновкиДанных;
	Объект.СхемаКомпоновкиДанных 	= "";
	
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Очистить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПоместитьШаблоннуюСхемуКомпоновкиВоВременноеХранилище()
	
	Макет = Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.ПолучитьМакет("ШаблоннаяСхемаКомпоновкиДанных");
	
	Возврат ПоместитьВоВременноеХранилище(Макет, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти