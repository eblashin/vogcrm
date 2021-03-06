
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Помещает во временное хранилище схему компоновки данных,
// настройки компоновки данных и возвращает их адреса
//
// Параметры:
//	ЭлементНастройки - Объект, ДанныеФормыСтруктура - настройка, для которой требуется получить адреса
//
// Возвращаемое значение:
//	Структура - структура, содержащая адреса
//				СхемаКомпоновкиДанных - Строка - адрес схемы компоновки данных
//				НастройкиКомпоновкиДанных - Строка - адрес настроек компоновки данных
//
Функция АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(ЭлементНастройки) Экспорт
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных");
	
	Если ТипЗнч(ЭлементНастройки) = Тип("ДанныеФормыСтруктура") Тогда
		ЭлементНастройкиСсылка = ЭлементНастройки.Ссылка;
	Иначе
		ЭлементНастройкиСсылка = ЭлементНастройки;
	КонецЕсли;
	
	// Получим схему компоновки данных
	Если ЗначениеЗаполнено(ЭлементНастройки.СхемаКомпоновкиДанных) 
		Или ЭлементНастройкиСсылка.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		
		СхемаИНастройки = ОписаниеИСхемаКомпоновкиДанныхНастройкиПоИмениМакета(ЭлементНастройкиСсылка, 
			ЭлементНастройки.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
		
	Иначе
		СхемаКомпоновкиДанных = ЭлементНастройкиСсылка.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Если СхемаКомпоновкиДанных = Неопределено И ПустаяСтрока(ЭлементНастройки.СхемаКомпоновкиДанных) Тогда
		
		СхемаКомпоновкиДанных = 
			Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.ПолучитьМакет("ШаблоннаяСхемаКомпоновкиДанных");
			
	ИначеЕсли СхемаКомпоновкиДанных = Неопределено 
		И Не ПустаяСтрока(ЭлементНастройки.СхемаКомпоновкиДанных) Тогда
			
		СхемаКомпоновкиДанных = 
			Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.ПолучитьМакет(ЭлементНастройки.СхемаКомпоновкиДанных);
		
	КонецЕсли;
	
	Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	
	Настройки = ЭлементНастройкиСсылка.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	Если ЗначениеЗаполнено(Настройки) Тогда
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор());
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

// Функция возвращает структуру с синонимом и схемой компоновки данных по имени макета
//
// Параметры:
//	КомандаСсылка - Ссылка, СправочникСсылка.вогНастройкиПроверкиЗаполненияРеквизитов - настройка, для которой требуется получить схему
//	ИмяМакета - Строка, Неопределено - имя получаемого макета схемы компоновки данных
//
// Возвращаемое значение:
//	Структура - Описание - Строка - синоним получаемого макета
//				СхемаКомпоновкиДанных - СхемаКомпоновкиДанных, Неопределено - найденная схема компоновки данных
//				НастройкиКомпоновкиДанных - НастройкиКомпоновкиДанных, Неопределено - найденные настройки компоновки данных
//
Функция ОписаниеИСхемаКомпоновкиДанныхНастройкиПоИмениМакета(НастройкаСсылка, ИмяМакета = Неопределено) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Описание",                  "");
	ВозвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",     Неопределено);
	ВозвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	вогНастройкиПроверкиЗаполненияРеквизитов.ХранилищеСхемыКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	вогНастройкиПроверкиЗаполненияРеквизитов.ХранилищеНастроекКомпоновкиДанных КАК ХранилищеНастроекКомпоновкиДанных 
	|ИЗ
	|	Справочник.вогНастройкиПроверкиЗаполненияРеквизитов КАК вогНастройкиПроверкиЗаполненияРеквизитов
	|ГДЕ
	|	вогНастройкиПроверкиЗаполненияРеквизитов.Ссылка = &НастройкаСсылка");
	
	Запрос.УстановитьПараметр("НастройкаСсылка", НастройкаСсылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Не ЗначениеЗаполнено(ИмяМакета) Тогда
		
		Если Выборка.Следующий() Тогда
			ВозвращаемоеЗначение.Описание 					= "Произвольная";
			ВозвращаемоеЗначение.СхемаКомпоновкиДанных 		= Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			ВозвращаемоеЗначение.НастройкиКомпоновкиДанных 	= Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
		КонецЕсли;
		
	Иначе
		
		Макет = Метаданные.НайтиПоТипу(ТипЗнч(НастройкаСсылка)).Макеты.Найти(ИмяМакета);
		
		Если Не Макет = Неопределено Тогда
			
			ВозвращаемоеЗначение.Описание 				= Макет.Синоним;
			ВозвращаемоеЗначение.СхемаКомпоновкиДанных 	= 
				Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.ПолучитьМакет(ИмяМакета);
				
			Если Выборка.Следующий() Тогда
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ШаблоныСхемыКомпоновкиДанных() Экспорт
	
	Шаблоны = Новый Массив;
	
	Для Каждого Макет Из Метаданные.Справочники.вогНастройкиПроверкиЗаполненияРеквизитов.Макеты Цикл
		
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			Продолжить;
		КонецЕсли;
		
		Шаблоны.Добавить(Новый Структура("Имя, Синоним", Макет.Имя, Макет.Синоним));
		
	КонецЦикла;
	
	Возврат Шаблоны;
	
КонецФункции

#КонецОбласти

#КонецЕсли