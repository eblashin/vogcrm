
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
// Процедура заполняет параметры формы.
//
Процедура ПолучитьЗначенияПараметровФормы()
	
	// Вид цены.
	Если Параметры.Свойство("ВидЦен") Тогда
		
		// Вид цены.
		ВидЦен = Параметры.ВидЦен;
		ВидЦенПриОткрытии = Параметры.ВидЦен;
		ВидЦенЕстьРеквизит = Истина;
		
	Иначе
		
		// Доступность вида цены.
		Элементы.ВидЦен.Видимость = Ложь;
		ВидЦенЕстьРеквизит = Ложь;
		
		Элементы.ВидСкидки.Видимость = Ложь;
		ВидСкидкиЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Флаг - перезаполнить цены.
	Если НЕ ВидЦенЕстьРеквизит Тогда
		
		Элементы.ПерезаполнитьЦены.Видимость = Ложь;
		
	КонецЕсли; 
	
	// Скидки.
	Если Параметры.Свойство("ВидСкидки") Тогда
		
		ВидСкидки = Параметры.ВидСкидки;
		ВидСкидкиПриОткрытии = Параметры.ВидСкидки;
		ВидСкидкиЕстьРеквизит = Истина;
		
	Иначе
		
		Элементы.ВидСкидки.Видимость = Ложь;
		ВидСкидкиЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Валюта документа.
	Если Параметры.Свойство("Валюта") Тогда
		
		ВалютаДокумента = Параметры.Валюта;
		ВалютаДокументаПриОткрытии = Параметры.Валюта;
		ВалютаДокументаЕстьРеквизит = Истина;
		
	Иначе
		
		Элементы.ВалютаДокумента.Видимость = Ложь;
		Элементы.Курс.Видимость = Ложь;
		Элементы.Кратность.Видимость = Ложь;
		Элементы.ПересчитатьЦены.Видимость = Ложь;
		ВалютаДокументаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Сумма включает НДС.
	Если Параметры.Свойство("ЦенаВключаетНДС") Тогда
		
		СуммаВключаетНДС = Параметры.ЦенаВключаетНДС;
		СуммаВключаетНДСПриОткрытии = Параметры.ЦенаВключаетНДС;
		СуммаВключаетНДСЕстьРеквизит = Истина;
		
	Иначе
		
		Элементы.СуммаВключаетНДС.Видимость = Ложь;
		СуммаВключаетНДСЕстьРеквизит = Ложь;
		
	КонецЕсли;	
	
	// Валюта расчетов.
	Если Параметры.Свойство("Договор") Тогда
		
		ВалютаРасчетов	  = Параметры.Договор.ВалютаРасчетов;
		РасчетыВУЕ		  = Параметры.Договор.РасчетыВУсловныхЕдиницах;
		КурсРасчетов 	  = Параметры.Курс;
		КратностьРасчетов = Параметры.Кратность;
		
		КурсРасчетовПриОткрытии 	 = Параметры.Курс;
		КратностьРасчетовПриОткрытии = Параметры.Кратность;
		
		ДоговорЕстьРеквизит = Истина;
		
	Иначе
		
		Элементы.ВалютаРасчетов.Видимость = Ложь;
		Элементы.КурсРасчетов.Видимость = Ложь;
		Элементы.КратностьРасчетов.Видимость = Ложь;
		
		ДоговорЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	ПересчитатьЦены = Параметры.ПересчитатьЦены;
		
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		Если ВалютаДокумента = ВалютаРасчетов
		   И КурсРасчетов <> 0
		   И КратностьРасчетов <> 0 Тогда
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
		Иначе
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
			Иначе
				Курс = 0;
				Кратность = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПолучитьЗначенияПараметровФормы()

&НаСервере
// Процедура заполняет таблицу курсов валют.
//
Процедура ЗаполнитьТаблицуКурсовВалют()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", Параметры.ДатаДокумента);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта,
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, ) КАК КурсыВалютСрезПоследних";
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	КурсыВалют.Загрузить(ТаблицаРезультатаЗапроса);
	
КонецПроцедуры // ЗаполнитьТаблицуКурсовВалют()

&НаКлиенте
// Процедура проверяет правильность заполнения реквизитов формы.
//
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ)
    	
	// Проверка заполненности реквизитов.
	
	// Вид цен.
	Если ПерезаполнитьЦены И ВидЦенЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не выбран вид цены для заполнения!'");
			Сообщение.Поле = "ВидЦен";
			Сообщение.Сообщить();
  			Отказ = Истина;
    	КонецЕсли;
	КонецЕсли;
	
	// Валюта документа.
	Если ВалютаДокументаЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
            Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена валюта документа!'");
			Сообщение.Поле = "Валюта";
			Сообщение.Сообщить();
			Отказ = Истина;
   		КонецЕсли;
	КонецЕсли;
	
	// Расчеты.
	Если ДоговорЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(КурсРасчетов) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты расчетов!'");
			Сообщение.Поле = "КурсРасчетов";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(КратностьРасчетов) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Обнаружена нулевая кратность курса валюты расчетов!'");
			Сообщение.Поле = "КратностьРасчетов";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры // ПроверитьЗаполнениеРеквизитовФормы()

&НаКлиенте
// Процедура проверяет модифицированность формы.
//
Процедура ПроверитьМодифицированностьФормы()

	БылиВнесеныИзменения = Ложь;
	
	ИзмененияВидЦен 				= ?(ВидЦенЕстьРеквизит, ВидЦенПриОткрытии <> ВидЦен, Ложь);
	ИзмененияВидСкидки 				= ?(ВидСкидкиЕстьРеквизит, ВидСкидкиПриОткрытии <> ВидСкидки, Ложь);
	ИзмененияВалютаДокумента 		= ?(ВалютаДокументаЕстьРеквизит, ВалютаДокументаПриОткрытии <> ВалютаДокумента, Ложь);
	ИзмененияСуммаВключаетНДС 		= ?(СуммаВключаетНДСЕстьРеквизит, СуммаВключаетНДСПриОткрытии <> СуммаВключаетНДС, Ложь);
    ИзмененияКурсРасчетов 			= ?(ДоговорЕстьРеквизит, КурсРасчетовПриОткрытии <> КурсРасчетов, Ложь);
    ИзмененияКратностьРасчетов 		= ?(ДоговорЕстьРеквизит, КратностьРасчетовПриОткрытии <> КратностьРасчетов, Ложь);
    
	Если ПерезаполнитьЦены
	 ИЛИ ПересчитатьЦены
	 ИЛИ ИзмененияВалютаДокумента
     ИЛИ ИзмененияСуммаВключаетНДС
	 ИЛИ ИзмененияКурсРасчетов
	 ИЛИ ИзмененияКратностьРасчетов
	 ИЛИ ИзмененияВидЦен
	 ИЛИ ИзмененияВидСкидки Тогда	

		БылиВнесеныИзменения = Истина;

	КонецЕсли;
	
КонецПроцедуры // ПроверитьМодифицированностьФормы()

&НаКлиенте
// Процедура заполнения курса и кратности валюты документа.
//
Процедура ЗаполнитьКурсКратностьВалютыДокумента()
	
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		Если ВалютаДокумента = ВалютаРасчетов
		   И КурсРасчетов <> 0
		   И КратностьРасчетов <> 0 Тогда
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
		Иначе
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
			Иначе
				Курс = 0;
				Кратность = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьКурсКратностьВалютыДокумента()

&НаСервере
Функция ПолучитьВалюты()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты";
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
// В процедуре осуществляется
// - инициализация параметров формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаУправленческогоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ЗаполнитьТаблицуКурсовВалют();
	ПолучитьЗначенияПараметровФормы();
	
	Если ДоговорЕстьРеквизит Тогда	
		НовыйМассив = Новый Массив();
		Если РасчетыВУЕ
		   И ВалютаУправленческогоУчета <> ВалютаРасчетов Тогда
			НовыйМассив.Добавить(ВалютаУправленческогоУчета);
		КонецЕсли;
		НовыйМассив.Добавить(ВалютаРасчетов);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(НовыйМассив));
		НовыйМассив2 = Новый Массив();
		НовыйМассив2.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив2);
		Элементы.Валюта.ПараметрыВыбора = НовыеПараметры;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#Область ПроцедурыДействияКомандныхПанелейФормы

&НаКлиенте
// Процедура - обработчик события нажатия кнопки ОК.
//
Процедура КомандаОК(Команда)
	
	Отказ = Ложь;

	ПроверитьЗаполнениеРеквизитовФормы(Отказ);
	ПроверитьМодифицированностьФормы();
    
	Если НЕ Отказ Тогда

		СтруктураРеквизитовФормы = Новый Структура;

        СтруктураРеквизитовФормы.Вставить("БылиВнесеныИзменения", 			БылиВнесеныИзменения);

        СтруктураРеквизитовФормы.Вставить("ВидЦен", 						ВидЦен);
		СтруктураРеквизитовФормы.Вставить("ВидСкидки",  					ВидСкидки);

		СтруктураРеквизитовФормы.Вставить("Валюта",			 				ВалютаДокумента);
		СтруктураРеквизитовФормы.Вставить("ЦенаВключаетНДС", 				СуммаВключаетНДС);

		СтруктураРеквизитовФормы.Вставить("ВалютаРасчетов", 				ВалютаРасчетов);
		СтруктураРеквизитовФормы.Вставить("Курс", 							Курс);
		СтруктураРеквизитовФормы.Вставить("КурсРасчетов", 					КурсРасчетов);
		СтруктураРеквизитовФормы.Вставить("Кратность", 						Кратность);
        СтруктураРеквизитовФормы.Вставить("КратностьРасчетов", 				КратностьРасчетов);
                         
		СтруктураРеквизитовФормы.Вставить("ПредВалютаДокумента", 			ВалютаДокументаПриОткрытии);
		СтруктураРеквизитовФормы.Вставить("ПредЦенаВключаетНДС", 			СуммаВключаетНДСПриОткрытии);

        СтруктураРеквизитовФормы.Вставить("ПерезаполнитьЦены", 				ПерезаполнитьЦены);
        СтруктураРеквизитовФормы.Вставить("ПересчитатьЦены", 				ПересчитатьЦены);

		СтруктураРеквизитовФормы.Вставить("ИмяФормы", 						"ОбщаяФорма.ФормаВалюта");

		Закрыть(СтруктураРеквизитовФормы);

	КонецЕсли;
	
КонецПроцедуры // КомандаОК()

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийРеквизитовФормы

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВидЦен.
//
Процедура ВидЦеныПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидЦен) Тогда
                        
        Если ВидЦенПриОткрытии <> ВидЦен Тогда
			
			ПерезаполнитьЦены = Истина;

		КонецЕсли;
        
	КонецЕсли;
	
КонецПроцедуры // ВидЦеныПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВидСкидки.
//
Процедура ВидСкидкиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидСкидки)
		
		И ВидСкидкиПриОткрытии <> ВидСкидки Тогда
		ПерезаполнитьЦены = Истина;
		
	КонецЕсли;
	
КонецПроцедуры // ВидСкидкиПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Валюта.
//
Процедура ВалютаПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

	Если ЗначениеЗаполнено(ВалютаДокумента)
		
	   И ВалютаДокументаПриОткрытии <> ВалютаДокумента Тогда
  		ПересчитатьЦены = Истина;
		
  	КонецЕсли;

КонецПроцедуры // ВалютаПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВалютаРасчетов.
//
Процедура ВалютаРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры // ВалютаРасчетовПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода КурсРасчетов.
//
Процедура КурсРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры // КурсРасчетовПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода КратностьРасчетов.
//
Процедура КратностьРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры // КратностьРасчетовПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ПерезаполнитьЦены.
//
Процедура ПерезаполнитьЦеныПриИзменении(Элемент)
	
	Если ВидЦенЕстьРеквизит Тогда
		
		Если ПерезаполнитьЦены Тогда
			Элементы.ВидЦен.АвтоОтметкаНезаполненного = Истина;
		Иначе	
			Элементы.ВидЦен.АвтоОтметкаНезаполненного = Ложь;
			ОтключитьОтметкуНезаполненного();
		КонецЕсли;		
	
	КонецЕсли;
	
КонецПроцедуры // ПерезаполнитьЦеныПриИзменении()

&НаКлиенте
Процедура ВалютаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь; 
	мВалюты = ПолучитьВалюты();
	СписокВыбора = Новый СписокЗначений;
	Для Каждого пВалюта Из мВалюты Цикл
		
		СписокВыбора.Добавить(пВалюта.Ссылка);
		
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВалютаНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокВыбора,Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаНачалоВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		
		ВалютаДокумента = ВыбранноеЗначение.Значение;
		
	КонецЕсли;
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
