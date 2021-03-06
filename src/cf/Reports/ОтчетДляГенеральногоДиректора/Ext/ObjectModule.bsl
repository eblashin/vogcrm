
// ++ VOG Солодов В.В. 10.09.2021 CRM-1198
// Рефакторинг
// +
// Вместо формы отчета добавлены вызовы ОпределитьНастройкиФормы и ПриОпределенииПараметровВыбора

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - 
//   КлючВарианта - Строка, Неопределено - 
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - форма отчета.
//   СвойстваНастройки - Структура - описание настройки отчета, которая будет выведена в форме отчета.
//       * ОписаниеТипов - ОписаниеТипов - тип настройки.
//       * ЗначенияДляВыбора - СписокЗначений - объекты, которые будут предложены пользователю в списке
//           выбора. Дополняет список объектов, уже выбранных пользователем ранее.
//       * ЗапросЗначенийВыбора - Запрос - возвращает объекты, которыми необходимо дополнить ЗначенияДляВыбора.
//           Первой колонкой (с 0м индексом) должен выбираться объект,
//           который следует добавить в ЗначенияДляВыбора.Значение.
//           Для отключения автозаполнения
//           в свойство ЗапросЗначенийВыбора.Текст следует записать пустую строку.
//       * ОграничиватьВыборУказаннымиЗначениями - Булево - когда Истина, то выбор пользователя будет
//           ограничен значениями, указанными в ЗначенияДляВыбора (его конечным состоянием).
//
// См. также:
//   ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора().
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	
	Если ТипЗнч(СвойстваНастройки.ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		
		Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.вогСценарииПланирования"))
			И СвойстваНастройки.ПолеКД = Новый ПолеКомпоновкиДанных("ПараметрыДанных.СценарийМесяц") Тогда
			
			НастройкиОтчета 		= Неопределено;
			КлючТекущегоВарианта 	= Неопределено;
			
			Если ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения") Тогда
				НастройкиОтчета 		= Форма.НастройкиОтчета;
				КлючТекущегоВарианта 	= Форма.КлючТекущегоВарианта;
			КонецЕсли;
			
			Если НастройкиОтчета = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			СписокВыбора = Новый Массив;
			Если КлючТекущегоВарианта = "ПоКомпаниям"
				Или КлючТекущегоВарианта = "ПоБрендам"
				Или (НастройкиОтчета.ВариантСсылка <> Неопределено
					И НастройкиОтчета.ВариантСсылка.Родитель <> Неопределено 
					И НастройкиОтчета.ВариантСсылка.Родитель.КлючВарианта = "ПоКомпаниям") Тогда
				
				СписокВыбора.Добавить(Справочники.вогСценарииПланирования.ПланНаКварталПоБрендам);
				СписокВыбора.Добавить(Справочники.вогСценарииПланирования.ПланНаМесяц);
				
			ИначеЕсли КлючТекущегоВарианта = "ПоКлиентам" Или КлючТекущегоВарианта = "ПоКлиентамРуб" Тогда
				СписокВыбора.Добавить(Справочники.вогСценарииПланирования.ПланНаКвартал);
				СписокВыбора.Добавить(Справочники.вогСценарииПланирования.ПланНаМесяцПоКлиентам);
			ИначеЕсли КлючТекущегоВарианта = "ПоМенеджерам"
				Или КлючТекущегоВарианта = "ПоМенеджерамРуб"
				Или КлючТекущегоВарианта = "ПоКоординаторам"
				Или КлючТекущегоВарианта = "ПоКоординаторамРуб" Тогда
				СписокВыбора.Добавить(Справочники.вогСценарииПланирования.ПланНаКвартал);
				СписокВыбора.Добавить(Справочники.вогСценарииПланирования.ПланПоМенеджерамМесяц);
			КонецЕсли;
			
			ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТаблицаДанных.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.вогСценарииПланирования КАК ТаблицаДанных
			|ГДЕ
			|	ТаблицаДанных.Ссылка В (&Сценарии)";
			
			СвойстваНастройки.ЗапросЗначенийВыбора.Текст = ТекстЗапроса;
			СвойстваНастройки.ЗапросЗначенийВыбора.Параметры.Вставить("Сценарии", СписокВыбора);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(СвойстваНастройки.ЭлементКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		
		Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.CRM_ЗначенияКлассификаторов")) Тогда
			
			ИмяЗначенияКлассификатора 	= "";
			ИмяСтрокой 					= Строка(СвойстваНастройки.ЭлементКД.ЛевоеЗначение);
			
			Если СтрНайти(ИмяСтрокой, "[") > 0 Тогда
				
				ЗаменяемаяЧасть = Лев(ИмяСтрокой, СтрНайти(ИмяСтрокой, "["));
				ИмяЗначенияКлассификатора 	= СтрЗаменить(ИмяСтрокой, ЗаменяемаяЧасть, "");
				ИмяЗначенияКлассификатора 	= СтрЗаменить(ИмяЗначенияКлассификатора, "]", "");
				
			ИначеЕсли СтрНайти(ИмяСтрокой, "(") > 0 Тогда
				
				ЗаменяемаяЧасть = Лев(ИмяСтрокой, СтрНайти(ИмяСтрокой, "("));
				ИмяЗначенияКлассификатора 	= СтрЗаменить(ИмяСтрокой, ЗаменяемаяЧасть, "");
				ИмяЗначенияКлассификатора 	= СтрЗаменить(ИмяЗначенияКлассификатора, ")", "");
				
			Иначе
				
				ИмяЗначенияКлассификатора = ИмяСтрокой;
				
			КонецЕсли;
			
			Если Не ПустаяСтрока(ИмяЗначенияКлассификатора) Тогда
				
				СвойстваНастройки.ЗапросЗначенийВыбора.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	CRM_ЗначенияКлассификаторов.Ссылка КАК Объект
				|ИЗ
				|	Справочник.CRM_ЗначенияКлассификаторов КАК CRM_ЗначенияКлассификаторов
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
				|			CRM_Классификаторы.Ссылка КАК Ссылка
				|		ИЗ
				|			ПланВидовХарактеристик.CRM_Классификаторы КАК CRM_Классификаторы
				|		ГДЕ
				|			CRM_Классификаторы.Наименование = &Наименование) КАК ВложенныйЗапрос
				|		ПО (CRM_ЗначенияКлассификаторов.Владелец = ВложенныйЗапрос.Ссылка)
				|ГДЕ
				|	CRM_ЗначенияКлассификаторов.ПометкаУдаления = ЛОЖЬ";
				
				СвойстваНастройки.ЗапросЗначенийВыбора.Параметры.Вставить("Наименование", ИмяЗначенияКлассификатора);
				
			КонецЕсли;
			
		ИначеЕсли СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.СтруктураПредприятия")) Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	СтруктураПредприятия.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
			|ГДЕ
			|	СтруктураПредприятия.ОбособленноеПодразделение = ИСТИНА
			|	И СтруктураПредприятия.ПометкаУдаления = ЛОЖЬ
			|	И НЕ СтруктураПредприятия.Ссылка = &Основное";
			
			СвойстваНастройки.ЗапросЗначенийВыбора.Текст = ТекстЗапроса;
			СвойстваНастройки.ЗапросЗначенийВыбора.Параметры.Вставить("Основное", Справочники.СтруктураПредприятия.ОсновноеПодразделение);
			
		ИначеЕсли СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.НаправленияДеятельности")) Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТаблицаДанных.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.НаправленияДеятельности КАК ТаблицаДанных
			|ГДЕ
			|	ТаблицаДанных.ПометкаУдаления = ЛОЖЬ";
			
			СвойстваНастройки.ЗапросЗначенийВыбора.Текст = ТекстЗапроса;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// -- VOG Солодов В.В. 10.09.2021 CRM-1198

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Создание внешнего источника данных
	ПараметрФиксацияСлева = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ФиксацияСлева");
	ПараметрВерсияСценарийПланГод = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВерсияСценарияГод");
	ПараметрВерсияСценарийПланМесяц = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВерсияСценарияМесяц");
	ПараметрСценарийПланГод = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СценарийГод");
	ПараметрСценарийПланМесяц = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СценарийМесяц");
	Если НЕ ПараметрВерсияСценарийПланГод.Использование или НЕ ЗначениеЗаполнено(ПараметрВерсияСценарийПланГод.Значение) или ПараметрВерсияСценарийПланГод.Значение.Владелец <> ПараметрСценарийПланГод.Значение тогда
		ОсновнаяВерсия = Справочники.вогВерсииСценариевПланирования.НайтиПоНаименованию("Основная",,,ПараметрСценарийПланГод.Значение);
		Если НЕ ЗначениеЗаполнено(ОсновнаяВерсия) тогда
			Выборка = Справочники.вогВерсииСценариевПланирования.Выбрать(,ПараметрСценарийПланГод.Значение);	
			Если Выборка.Следующий() тогда
				ОсновнаяВерсия = Выборка.Ссылка;	
			КонецЕсли;
		КонецЕсли;
		ПараметрВерсияСценарийПланГод.Значение = ОсновнаяВерсия;
		ПараметрВерсияСценарийПланГод.Использование = Истина;
	КонецЕсли;
	Если НЕ ПараметрВерсияСценарийПланМесяц.Использование или НЕ ЗначениеЗаполнено(ПараметрВерсияСценарийПланМесяц.Значение) или ПараметрВерсияСценарийПланМесяц.Значение.Владелец <> ПараметрСценарийПланМесяц.Значение тогда
		ОсновнаяВерсия = Справочники.вогВерсииСценариевПланирования.НайтиПоНаименованию("Основная",,,ПараметрСценарийПланМесяц.Значение);
		Если НЕ ЗначениеЗаполнено(ОсновнаяВерсия) тогда
			Выборка = Справочники.вогВерсииСценариевПланирования.Выбрать(,ПараметрСценарийПланМесяц.Значение);	
			Если Выборка.Следующий() тогда
				ОсновнаяВерсия = Выборка.Ссылка;	
			КонецЕсли;
		КонецЕсли;
		ПараметрВерсияСценарийПланМесяц.Значение = ОсновнаяВерсия;
		ПараметрВерсияСценарийПланМесяц.Использование = Истина;
	КонецЕсли;
	
	// +++ VOG Кулаков П.Л. 20.04.2021 DEV-425
	ПараметрДатаОтчета	 = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	ПараметрВключатьВРасчетВыбранныйДень = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВключатьВРасчетВыбранныйДень");
	ПараметрГодСравнения = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ГодСравнения");
	ПараметрДатаОтчетаПрошлогоГодаСравнение = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчетаПрошлогоГодаСравнение");
	ГодДатыОтчета = Год(ПараметрГодСравнения.Значение);
	МесяцДатыОтчета = Месяц(?(ТипЗнч(ПараметрДатаОтчета.Значение) = Тип("СтандартнаяДатаНачала"), ПараметрДатаОтчета.Значение.Дата, ПараметрДатаОтчета.Значение));
	Если ПараметрВключатьВРасчетВыбранныйДень.Значение Тогда
		ДеньДатыОтчета = День(?(ТипЗнч(ПараметрДатаОтчета.Значение) = Тип("СтандартнаяДатаНачала"), ПараметрДатаОтчета.Значение.Дата, ПараметрДатаОтчета.Значение));
	Иначе
		ДеньДатыОтчета = День(?(ТипЗнч(ПараметрДатаОтчета.Значение) = Тип("СтандартнаяДатаНачала"), ПараметрДатаОтчета.Значение.Дата, ПараметрДатаОтчета.Значение)) - 1;
	КонецЕсли;
	ПараметрДатаОтчетаПрошлогоГодаСравнение.Значение = КонецДня(Дата(ГодДатыОтчета,МесяцДатыОтчета,ДеньДатыОтчета));
	// --- VOG Кулаков П.Л.
	
	СтандартнаяОбработка = Ложь; // отключаем стандартный вывод отчета - будем выводить программно 

	Настройки = КомпоновщикНастроек.ПолучитьНастройки() ;// Получаем настройки отчета 
	
	// ++ VOG Солодов В.В. 10.09.2021 CRM-1198
	Если ТипЗнч(ПараметрДатаОтчета.Значение) = Тип("СтандартнаяДатаНачала") Тогда
		ТекущийГод = Формат(ПараметрДатаОтчета.Значение.Дата, "ДФ=гггг");
	Иначе
		ТекущийГод = Формат(ПараметрДатаОтчета.Значение, "ДФ=гггг");
	КонецЕсли;
	
	Если ТипЗнч(ПараметрГодСравнения.Значение) = Тип("СтандартнаяДатаНачала") Тогда
		ПрошлыйГод = Формат(ПараметрГодСравнения.Значение.Дата, "ДФ=гггг");
	Иначе
		ПрошлыйГод = Формат(ПараметрГодСравнения.Значение, "ДФ=гггг");
	КонецЕсли;
	
	УстановитьЗаголовкиПолей(ТекущийГод, ПрошлыйГод);
	// До изменения
	// +++ VOG Кулаков П.Л. 22.04.2021 DEV-425
	//Если ПараметрСценарийПланМесяц.Значение = Справочники.вогСценарииПланирования.ПланНаКвартал ИЛИ ПараметрСценарийПланМесяц.Значение = Справочники.вогСценарииПланирования.ПланНаКварталПоБрендам Тогда
	//	Для Каждого СтруктураОтчета Из Настройки.Структура Цикл
	//		Для каждого СтрокаНастройки из СтруктураОтчета.Колонки цикл
	//			УстановитьЗаголовкиПолей(СтрокаНастройки);
	//		КонецЦикла;
	//	КонецЦикла;
	//КонецЕсли;
	// --- VOG Кулаков П.Л.
	// -- VOG Солодов В.В. 10.09.2021 CRM-1198
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 
	// Инициализируем макет компоновки используя схему компоновки данных 
	// и созданные ранее настройки и данные расшифровки
	// ++ VOG Солодов В.В. 10.09.2021 CRM-1198
	// До изменения
	//СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	// -- VOG Солодов В.В. 10.09.2021 CRM-1198
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	// Скомпонуем результат
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ДокументРезультат.ФиксацияСлева = ПараметрФиксацияСлева.Значение;
	
	// ++ VOG Солодов В.В. 22.09.2021 CRM-1225
	НовоеНазваниеГруппы = "";
	Если ПараметрСценарийПланМесяц.Значение = Справочники.вогСценарииПланирования.ПланНаКвартал
		Или ПараметрСценарийПланМесяц.Значение = Справочники.вогСценарииПланирования.ПланНаКварталПоБрендам Тогда
		НовоеНазваниеГруппы = "КВАРТАЛ";
	КонецЕсли;
	
	ОбъединитьГруппировки(ДокументРезультат, "МЕСЯЦ", НовоеНазваниеГруппы);
	ОбъединитьГруппировки(ДокументРезультат, "ГОД");
	// -- VOG Солодов В.В. 22.09.2021 CRM-1225
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// +++ VOG Кулаков П.Л. 22.04.2021 DEV-425
Процедура УстановитьЗаголовкиПолей(ТекущийГод, ПрошлыйГод)
	
	// ++ VOG Солодов В.В. 10.09.2021 CRM-1198
	Для Каждого Поле Из СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Поля Цикл
		
		Поле.Заголовок = СтрЗаменить(Поле.Заголовок, "%ТекущийГод%", ТекущийГод);
		Поле.Заголовок = СтрЗаменить(Поле.Заголовок, "%ПрошлыйГод%", ПрошлыйГод);
		
	КонецЦикла;
	
	Для Каждого Поле Из СхемаКомпоновкиДанных.ВычисляемыеПоля Цикл
		
		Поле.Заголовок = СтрЗаменить(Поле.Заголовок, "%ТекущийГод%", ТекущийГод);
		Поле.Заголовок = СтрЗаменить(Поле.Заголовок, "%ПрошлыйГод%", ПрошлыйГод);
		
	КонецЦикла;
	// До изменения
	//ЗаменаЗаголовковПолей(СтрокаНастройки.Выбор.Элементы);
	//
	//Для каждого ЭлСтрук из СтрокаНастройки.Структура цикл
	//	УстановитьЗаголовкиПолей(ЭлСтрук);
	//КонецЦикла;
	// -- VOG Солодов В.В. 10.09.2021 CRM-1198
	
КонецПроцедуры // --- VOG Кулаков П.Л.

// +++ VOG Кулаков П.Л. 22.04.2021 DEV-425
Процедура ЗаменаЗаголовковПолей(Поля)
	
	Для Каждого Поле Из Поля Цикл
		
		Если Поле.Заголовок = "План кол-во (мес.)" Тогда
			Поле.Заголовок = "План кол-во (кв.)";
		КонецЕсли;
		
		Если Поле.Заголовок = "План тыс.руб. (мес.)" Тогда
			Поле.Заголовок = "План тыс.руб. (кв.)";
		КонецЕсли;
		
		Если Поле.Заголовок = "Факт прошлый год (мес.)" Тогда
			Поле.Заголовок = "Факт прошлый год (кв.)";
		КонецЕсли;

		Если Поле.Заголовок = "Продажи кол-во (мес.)" Тогда
			Поле.Заголовок = "Продажи кол-во (кв.)";
		КонецЕсли;

		Если Поле.Заголовок = "Продажи тыс.руб. (мес.)" Тогда
			Поле.Заголовок = "Продажи тыс.руб. (кв.)";
		КонецЕсли;
		
		Если Поле.Заголовок = "Отставание мес." Тогда
			Поле.Заголовок = "Отставание кв.";
		КонецЕсли;
		
		Если Поле.Заголовок = "%, мес." Тогда
			Поле.Заголовок = "%, кв.";
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // --- VOG Кулаков П.Л.

// ++ VOG Солодов В.В. 22.09.2021 CRM-1225
Процедура ОбъединитьГруппировки(ДокументРезультат, ИмяГруппировки, НовоеИмяГруппировки = "")
	
	ПерваяЯчейкаГруппы = Неопределено;
	
	Для Индекс = 1 По 2 Цикл
		
		// найдем первую ячейку группы
		ПерваяЯчейкаГруппы = ДокументРезультат.НайтиТекст(ИмяГруппировки, ПерваяЯчейкаГруппы,, Истина, Истина);
		Если ПерваяЯчейкаГруппы = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		// определим количество колонок группы (используется особенность объединенных ячеек - одинаковый текст в них)
		КоличествоКолонокГруппы = 1;
		СледующаяОбласть 		= ДокументРезультат.Область(
			ПерваяЯчейкаГруппы.Верх, ПерваяЯчейкаГруппы.Лево + КоличествоКолонокГруппы);
			
		Пока ПерваяЯчейкаГруппы.Текст = СледующаяОбласть.Текст Цикл
			
			КоличествоКолонокГруппы = КоличествоКолонокГруппы + 1;
			СледующаяОбласть 		= ДокументРезультат.Область(
				ПерваяЯчейкаГруппы.Верх, ПерваяЯчейкаГруппы.Лево + КоличествоКолонокГруппы);
			
		КонецЦикла;
		
		Если КоличествоКолонокГруппы > 1 Тогда
			
			КолонкаНачалаСвертки 	= ПерваяЯчейкаГруппы.Лево;
			КолонкаКонцаСвертки 	= ПерваяЯчейкаГруппы.Лево + КоличествоКолонокГруппы - 1;
			
			// Объединим колонки группы
			ОбъединяемаяОбласть = ДокументРезультат.Область(
				ПерваяЯчейкаГруппы.Верх,
				КолонкаНачалаСвертки,
				ПерваяЯчейкаГруппы.Верх,
				КолонкаКонцаСвертки);
			
			ОбъединяемаяОбласть.Объединить();
			ОбъединяемаяОбласть.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
			ОбъединяемаяОбласть.Шрифт 					= Новый Шрифт(ОбъединяемаяОбласть.Шрифт,, 8);
			
			Если Не ПустаяСтрока(НовоеИмяГруппировки)
				И Не ОбъединяемаяОбласть.Текст = НовоеИмяГруппировки Тогда
				ОбъединяемаяОбласть.Текст = НовоеИмяГруппировки;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // -- VOG Солодов В.В. 22.09.2021 CRM-1225

#КонецОбласти

#КонецЕсли