
&НаСервереБезКонтекста
Функция ПолучитьИДРасшифровки(ИмяОбласти,Адрес)
	Попытка
		ТЗ = ПолучитьИзВременногоХранилища(Адрес);
		Поиск = Новый Структура("ИмяОбласти",ИмяОбласти);
		СтрокиРасшифроки = ТЗ.НайтиСтроки(Поиск);
		Если СтрокиРасшифроки.Количество()>0 тогда
			Возврат СтрокиРасшифроки[0].ИдРасшифровки;		
		КонецЕсли;
	Исключение
	КонецПопытки;
	Возврат 0;
КонецФункции


&НаСервере
Процедура ЗаполнитьТаблицуНаСервере()
	
	Схема = ПолучитьИзВременногоХранилища(АдресСхемы);
	Настройки = Компоновщик.ПолучитьНастройки();	
	ТекущаяДата = ДобавитьМесяц(ТекущаяДата(),0);
	ОбъектКомпоновки = ДанныеФормыВЗначение(Объект,Тип("ОбработкаОбъект.АРМ_ПланированиеПродаж"));
	МакетОформления = ОбъектКомпоновки.ПолучитьМакет("МакетОформления");
	                                                                         
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоМесяца",НачалоМесяца(ДобавитьМесяц(ТекущаяДата,-1)));
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонецМесяца",КонецМесяца(ДобавитьМесяц(ТекущаяДата,-1)));
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПродаж",НачалоГода(ДобавитьМесяц(ТекущаяДата,-1)));
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонецПродаж",КонецМесяца(ДобавитьМесяц(ТекущаяДата,-1))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПродажПрошлыйГод",НачалоГода(ДобавитьМесяц(ТекущаяДата,-12)));
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонецПродажПрошлыйГод",КонецГода(ДобавитьМесяц(ТекущаяДата,-12))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПродаж4мес",НачалоМесяца(ДобавитьМесяц(ТекущаяДата,-4))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Направление",Справочники.НаправленияДеятельности.Плитка); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПринадлежностьБренда",Перечисления.вогПринадлежностьБренда.ТоварныйПортфельВОГ); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторФорматТРТ",ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("47b0ee76-ada2-11e7-80ce-08606e7382bc"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторСтатусТТ",ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("dcdbe20f-9a73-11e8-89fa-005056bc3fe8"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторКлассификацияТТ",ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("b3d84c6b-7581-11ea-87ff-005056bc3fe8"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторПлощадьОтдела",ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("aa8de7b3-1aec-11e8-92c3-005056bcf152"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ФорматDIY",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("4fc40649-ada2-11e7-80ce-08606e7382bc"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СтатусТТЗакрыта",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af3-9a74-11e8-89fa-005056bc3fe8"))); 
		
	КомпоновщикМакета 		= Новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	МакетКомпоновкиДанных 	= КомпоновщикМакета.Выполнить(Схема,Настройки,ДанныеРасшифровки,МакетОформления,Тип("ГенераторМакетаКомпоновкиДанных"));
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных,,ДанныеРасшифровки,Истина,Истина);
	
	ТабДок.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	АдресДанныхРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки,УникальныйИдентификатор);
	
	СохраненныеРасшифровкиЯчеек = Новый ТаблицаЗначений;
	СохраненныеРасшифровкиЯчеек.Колонки.Добавить("ИмяОбласти");
	СохраненныеРасшифровкиЯчеек.Колонки.Добавить("ИДРасшифровки");
	Для НомерСтроки = 1 по ТабДок.ВысотаТаблицы цикл
		Для НомерСтолбца = 1 по ТабДок.ШиринаТаблицы цикл
			ИмяОбласти = "R"+Формат(НомерСтроки,"ЧГ=0")+"C"+Формат(НомерСтолбца,"ЧГ=0");
			СтрокаД = СохраненныеРасшифровкиЯчеек.Добавить();
			СтрокаД.ИДРасшифровки = ТабДок.Область(ИмяОбласти).Расшифровка;
			СтрокаД.ИмяОбласти = ИмяОбласти;
		КонецЦикла;
	КонецЦикла;
	СохраненныеРасшифровкиЯчеек.Индексы.Добавить("ИмяОБласти");
	АдресСохраненныхРасшифровокЯчеек = ПоместитьВоВременноеХранилище(СохраненныеРасшифровкиЯчеек,УникальныйИдентификатор);
	
	ТабДок.ФиксацияСлева = 1;
	ТабДок.ФиксацияСверху = 4;
	
	

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицу(Команда)
	ЗаполнитьТаблицуНаСервере();
	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбъектКомпоновки = ДанныеФормыВЗначение(Объект,Тип("ОбработкаОбъект.АРМ_ПланированиеПродаж"));
	Схема = ОбъектКомпоновки.ПолучитьМакет("СхемаПлитка");
	АдресСхемы = ПоместитьВоВременноеХранилище(Схема,УникальныйИдентификатор);
	НастройкиСКД= Схема.НастройкиПоУмолчанию;
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	Компоновщик.Инициализировать(Источник);
	Компоновщик.ЗагрузитьНастройки(НастройкиСКД);
	
	// ++ VOG Солодов В.В. 14.10.2021 CRM-1246
	ГодПланирования = вогОбщегоНазначенияКлиентСервер.ПолучитьГодПланирования();
	// До изменения
	//ГодПланирования = Константы.ГодПланированияПлитка.Получить();;
	// -- VOG Солодов В.В. 14.10.2021 CRM-1246
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КоэффициентыПереводаКоличестваВО_в_КоличествоМСрезПоследних.Комплект КАК Комплект,
	               |	КоэффициентыПереводаКоличестваВО_в_КоличествоМСрезПоследних.Коэффициент КАК К
	               |ИЗ
	               |	РегистрСведений.КоэффициентыПереводаКоличестваВО_в_КоличествоМ.СрезПоследних КАК КоэффициентыПереводаКоличестваВО_в_КоличествоМСрезПоследних";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() цикл
		Строка = КоэффициентыПересчёта.Добавить();
		ЗаполнитьЗначенияСвойств(Строка,Выборка);
	КонецЦикла;
	УжеЕсть = Ложь;	

	ПолеКомп = Новый ПолеКомпоновкиДанных("СтатусТТ");
	Для каждого Элемент из Компоновщик.Настройки.Отбор.Элементы цикл
		Если ТипЗнч(Элемент) = Тип("ЭлементОтбораКомпоновкиДанных") тогда
			Если Элемент.ЛевоеЗначение = ПолеКомп тогда
				Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
				Элемент.ПравоеЗначение = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af2-9a74-11e8-89fa-005056bc3fe8"));
				Элемент.Использование = Истина;
				УжеЕсть = Истина;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если не УжеЕсть тогда
		Элемент = Компоновщик.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение = ПолеКомп;
		Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		Элемент.ПравоеЗначение = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af2-9a74-11e8-89fa-005056bc3fe8"));
		Элемент.Использование = Истина;
	КонецЕсли;
	
	ТабДок.ФиксацияСлева = 1;
	
КонецПроцедуры

&НаСервере
Процедура ТабДокПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ТабДокПриИзменении(Элемент)
	ТабДокПриИзмененииНаСервере();
КонецПроцедуры



&НаСервереБезКонтекста
Функция КоличествоМесяцевДоКонцаГодаПоКварталу(Квартал)
	
	Если ЗначениеЗаполнено(Квартал) тогда
		Попытка
			// ++ VOG Солодов В.В. 14.10.2021 CRM-1246
			ГодПланирования = вогОбщегоНазначенияКлиентСервер.ПолучитьГодПланирования();
			// До изменения
			//ГодПланирования = Константы.ГодПланированияПлитка.Получить();
			// -- VOG Солодов В.В. 14.10.2021 CRM-1246
			
			КварталЧисло = Число(Лев(Квартал,1));
			ГодЧисло = Число(Прав(Квартал,4));
			Возврат ((ГодПланирования - ГодЧисло)*4 + 4-КварталЧисло)*3; 
		Исключение
			Возврат Неопределено;
		КонецПопытки;
	Иначе
		Возврат Неопределено;	
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция  КатегорияТТ(ТорговаяТочка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_ОбъектыЗначенийКлассификаторов.ЗначениеКлассификатора КАК ЗначениеКлассификатора
	               |ИЗ
	               |	РегистрСведений.CRM_ОбъектыЗначенийКлассификаторов КАК CRM_ОбъектыЗначенийКлассификаторов
	               |ГДЕ
	               |	CRM_ОбъектыЗначенийКлассификаторов.Объект = &Объект
	               |	И CRM_ОбъектыЗначенийКлассификаторов.ЗначениеКлассификатора.Владелец = &Владелец
	               |	И CRM_ОбъектыЗначенийКлассификаторов.Аналитика = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Плитка)";
	Запрос.УстановитьПараметр("Владелец",ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("b3d84c6b-7581-11ea-87ff-005056bc3fe8")));
	Запрос.УстановитьПараметр("Объект",ТорговаяТочка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() тогда
		Возврат Строка(Выборка.ЗначениеКлассификатора);
	Иначе
		Возврат "";
	КонецЕсли;
	
	
	
КонецФункции

&НаСервере
Процедура ТабДокПриИзмененииСодержимогоОбластиНаСервере(Значение,ИДРасшифровки,ИмяОбласти)
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки);
	Попытка
		ДанныеРасшифровкиОбласти = ДанныеРасшифровки.Элементы[ИДРасшифровки];
		ПоляРасшифровки = ДанныеРасшифровкиОбласти.ПолучитьПоля(); 
		ЗначениеПоля = 	Число(Значение);
	Исключение
		ЗначениеПоля = Неопределено;
	КонецПопытки;
	ПоискСтруктура = Новый Структура;
	СредниеПродажи = 0;
	КоличествоВО = 0;
	Для каждого ПолеР из ПоляРасшифровки цикл
		Если ПолеР.Поле = "ТорговаяТочка" тогда
			ПоискСтруктура.Вставить("ТорговаяТочка",ПолеР.Значение);
		ИначеЕсли ПолеР.Поле = "Бренд" тогда
			ПоискСтруктура.Вставить("Бренд",ПолеР.Значение);
		ИначеЕсли ПолеР.Поле = "КомплектПанелей" тогда
			ПоискСтруктура.Вставить("КомплектПанелей",ПолеР.Значение);
		ИначеЕсли ПолеР.Поле = "СредниеПродажи4_Расшифровка" тогда
			СредниеПродажи = ПолеР.Значение;
		ИначеЕсли ПолеР.Поле = "КоличествоВО_Факт" тогда
			КоличествоВО = ПолеР.Значение;
		ИначеЕсли ПолеР.Поле = "Комментарий" или  Найти(ПолеР.Поле,"Дата")>0 тогда
			ЗначениеПоля = Значение;
			Реквизит = ПолеР.Поле;
		ИначеЕсли ПолеР.Поле <> "ВозможноРедактирование" тогда
			Реквизит = ПолеР.Поле;
		КонецЕсли;	
	КонецЦикла;
	Если ЗначениеПоля<>Неопределено тогда
		Значение = Строка(ЗначениеПоля);
	Иначе
		Значение = "";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(КоличествоВО) тогда
		КоличествоВО = 0;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(СредниеПродажи) тогда
		СредниеПродажи = 0;
	КонецЕсли;
	
	СредниеПродажи = СредниеПродажи / 4;
	
	НайденныеСтроки = Данные.НайтиСтроки(ПоискСтруктура);
	Если НайденныеСтроки.Количество()=0 тогда
		Строка = Данные.Добавить();
		ЗаполнитьЗначенияСвойств(Строка,ПоискСтруктура);
		Зпрс = Новый Запрос;
		Зпрс.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		             |	ДанныеПланированияПродаж.Автор КАК Автор,
		             |	ДанныеПланированияПродаж.ДатаИзменения КАК ДатаИзменения
		             |ИЗ
		             |	РегистрСведений.ДанныеПланированияПродаж КАК ДанныеПланированияПродаж
		             |ГДЕ
		             |	ДанныеПланированияПродаж.Направление = &Направление
		             |	И ДанныеПланированияПродаж.ТорговаяТочка = &ТорговаяТочка
		             |	И ДанныеПланированияПродаж.Бренд = &Бренд
		             |	И ДанныеПланированияПродаж.КомплектПанелей = &КомплектПанелей";
		Зпрс.УстановитьПараметр("Направление",Справочники.НаправленияДеятельности.Плитка);
		Зпрс.УстановитьПараметр("ТорговаяТочка",ПоискСтруктура.ТорговаяТочка);
		Зпрс.УстановитьПараметр("Бренд",ПоискСтруктура.Бренд);
		Зпрс.УстановитьПараметр("КомплектПанелей",ПоискСтруктура.КомплектПанелей);
		Выборка = Зпрс.Выполнить().Выбрать();
		Если Выборка.Следующий() тогда
			Строка.АвторВРегистре = Выборка.Автор;
			Строка.ДатаИзмененияВРегистре = Выборка.ДатаИзменения;
		КонецЕсли;
	Иначе
		Строка = НайденныеСтроки[0];
	КонецЕсли;
	Строка[Реквизит] = Значение;
	Заголовок = "Планирование продаж (плитка) " + Формат(ГодПланирования,"ЧГ=0") + " (изменено)";
	
	
	//Расчет
	Если Реквизит = "КоличествоВОПотенциал" или Реквизит = "ДатаВыставленияВОПотенциал"  тогда		
		ПоискК = Новый Структура;
		ПоискК.Вставить("Комплект",ПоискСтруктура.КомплектПанелей);
		СтрокиК = КоэффициентыПересчёта.НайтиСтроки(ПоискК);
		Если СтрокиК.Количество()>0 тогда
			К = СтрокиК[0].К;
		Иначе
			К=0;
		КонецЕсли;
		
		Если ПоискСтруктура.КомплектПанелей.ВидВО = Перечисления.вогВидыОборудования.DIYПолка  или  
				К < (СредниеПродажи / ?(КоличествоВО=0,1,КоличествоВО))	тогда
			К= СредниеПродажи / ?(КоличествоВО=0,1,КоличествоВО);
		КонецЕсли;
		Если Реквизит = "КоличествоВОПотенциал" тогда
			Смещение = 2;
			ИмяОбластиКоличествоВОПотенциал = ИмяОбласти;
			ИмяОбластиКвартал = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+1,"ЧГ=0");
		Иначе
			Смещение = 1;
			ИмяОбластиКвартал = ИмяОбласти;
			ИмяОбластиКоличествоВОПотенциал = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))-1,"ЧГ=0");
		КонецЕсли;
		Попытка
			Строка.КоличествоВОПотенциал = Число(ТабДок.Область(ИмяОбластиКоличествоВОПотенциал).Текст);
		Исключение
			Строка.КоличествоВОПотенциал = 0;
		КонецПопытки;
			
		КолвоМесяцев = КоличествоМесяцевДоКонцаГодаПоКварталу(Строка.ДатаВыставленияВОПотенциал); 
		Если КолвоМесяцев <> Неопределено тогда
			Строка.КоличествоПотенциал = Строка.КоличествоВОПотенциал * К * КоличествоМесяцевДоКонцаГодаПоКварталу(Строка.ДатаВыставленияВОПотенциал);
		Иначе
			Строка.КоличествоПотенциал = 0;
			Строка.ДатаВыставленияВОПотенциал = "";	
		КонецЕсли;
		
		Если Найти(ИмяОбласти,":")>0 тогда
			ИмяОбласти = Лев(ИмяОбласти,Найти(ИмяОбласти,":")-1);	
		КонецЕсли;
		ИмяОбластиКоличество = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+Смещение,"ЧГ=0");
		ИмяОбластиКоличество2 = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+2),"ЧГ=0");
		ОбластьКвартал = ТабДок.Область(ИмяОбластиКвартал);
		ОбластьКвартал.Текст = Строка.ДатаВыставленияВОПотенциал;
		ОбластьКоличество = ТабДок.Область(ИмяОбластиКоличество);
		ОбластьКоличество.Текст = Формат(Строка.КоличествоПотенциал,"ЧГ=0");	
		
		ИмяОбластиК = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+1),"ЧГ=0");
		Строка.ПоправочныйКоэффициентПотенциал = Число(ТабДок.Область(ИмяОбластиК).Текст);
		Строка.КоличествоПотенциалПоправочное = Строка.ПоправочныйКоэффициентПотенциал * Строка.КоличествоПотенциал;
		ОбластьКоличество = ТабДок.Область(ИмяОбластиКоличество2);
		ОбластьКоличество.Текст = Формат(Строка.КоличествоПотенциалПоправочное,"ЧГ=0");	
		
		Строка.КоличествоВОПлан = Строка.КоличествоВОПотенциал;
		Строка.КоличествоПлан = Строка.КоличествоВОПлан;
		Строка.ДатаВыставленияВОПлан = Строка.ДатаВыставленияВОПотенциал;
		Строка.КоличествоПланПоправочное = Строка.КоличествоПотенциалПоправочное;
		Строка.ПоправочныйКоэффициентПлан = Строка.ПоправочныйКоэффициентПотенциал;
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+3),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.КоличествоВОПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+4),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.ДатаВыставленияВОПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+5),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.КоличествоПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+6),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.ПоправочныйКоэффициентПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+7),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.КоличествоПланПоправочное,"ЧГ=0");
	КонецЕсли;
	
	Если Реквизит = "КоличествоПотенциал" тогда		
		ИмяОбластиК = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+1,"ЧГ=0");
		ИмяОбластиКоличество2 = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+2,"ЧГ=0");
		Строка.ПоправочныйКоэффициентПотенциал = Число(ТабДок.Область(ИмяОбластиК).Текст);
		Строка.КоличествоПотенциалПоправочное = Строка.ПоправочныйКоэффициентПотенциал * Строка.КоличествоПотенциал;
		ОбластьКоличество = ТабДок.Область(ИмяОбластиКоличество2);
		ОбластьКоличество.Текст = Формат(Строка.КоличествоПотенциалПоправочное,"ЧГ=0");	
		
		Строка.КоличествоВОПлан = Строка.КоличествоВОПотенциал;
		Строка.КоличествоПлан = Строка.КоличествоВОПлан;
		Строка.ДатаВыставленияВОПлан = Строка.ДатаВыставленияВОПотенциал;
		Строка.КоличествоПланПоправочное = Строка.КоличествоПотенциалПоправочное;
		Строка.ПоправочныйКоэффициентПлан = Строка.ПоправочныйКоэффициентПотенциал;
	КонецЕсли;
	
	
	
	Если Реквизит = "КоличествоВОПлан" или 	Реквизит = "ДатаВыставленияВОПлан" тогда 
		
		ПоискК = Новый Структура;
		ПоискК.Вставить("Комплект",ПоискСтруктура.КомплектПанелей);
		СтрокиК = КоэффициентыПересчёта.НайтиСтроки(ПоискК);
		Если СтрокиК.Количество()>0 тогда
			К = СтрокиК[0].К;
		Иначе
			К=0;
		КонецЕсли;
		Если ПоискСтруктура.КомплектПанелей.ВидВО = Перечисления.вогВидыОборудования.DIYПолка тогда
			К= СредниеПродажи / ?(КоличествоВО=0,1,КоличествоВО);
		КонецЕсли;
		
		Строка.КоличествоПлан = Строка.КоличествоВОПлан * К * КоличествоМесяцевДоКонцаГодаПоКварталу(Строка.ДатаВыставленияВОПлан);
		Если Реквизит = "КоличествоВОПлан" тогда
			Смещение = 2;
		Иначе
			Смещение = 1;
			
		КонецЕсли;
		Если Найти(ИмяОбласти,":")>0 тогда
			ИмяОбласти = Лев(ИмяОбласти,Найти(ИмяОбласти,":")-1);	
		КонецЕсли;
		
		ИмяОбластиКоличество = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+Смещение,"ЧГ=0");
		ИмяОбластиКоличество2 = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+2),"ЧГ=0");
		ИмяОбластиК = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+1),"ЧГ=0");
		ОбластьКоличество = ТабДок.Область(ИмяОбластиКоличество);
		ОбластьКоличество.Текст = Формат(Строка.КоличествоПлан,"ЧГ=0");	
		
		ИмяОбластиК = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+1),"ЧГ=0");
		Строка.ПоправочныйКоэффициентПлан = Число(ТабДок.Область(ИмяОбластиК).Текст);
		Строка.КоличествоПланПоправочное = Строка.ПоправочныйКоэффициентПлан * Строка.КоличествоПлан;
		ОбластьКоличество = ТабДок.Область(ИмяОбластиКоличество2);
		ОбластьКоличество.Текст = Формат(Строка.КоличествоПланПоправочное,"ЧГ=0");	
		
	КонецЕсли;
	
	
	Если Реквизит = "ПоправочныйКоэффициентПотенциал" тогда		
		Строка.КоличествоПотенциалПоправочное = Строка.ПоправочныйКоэффициентПотенциал * Строка.КоличествоПотенциал;
		Смещение = 1;
		Если Найти(ИмяОбласти,":")>0 тогда
			ИмяОбласти = Лев(ИмяОбласти,Найти(ИмяОбласти,":")-1);	
		КонецЕсли;
		ИмяОбластиКоличество = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+Смещение,"ЧГ=0");
		ОбластьКоличество = ТабДок.Область(ИмяОбластиКоличество);
		ОбластьКоличество.Текст = Формат(Строка.КоличествоПотенциалПоправочное,"ЧГ=0");	
		Строка.КоличествоВОПлан = Строка.КоличествоВОПотенциал;
		Строка.КоличествоПлан = Строка.КоличествоВОПлан;
		Строка.ДатаВыставленияВОПлан = Строка.ДатаВыставленияВОПотенциал;
		Строка.КоличествоПланПоправочное = Строка.КоличествоПотенциалПоправочное;
		Строка.ПоправочныйКоэффициентПлан = Строка.ПоправочныйКоэффициентПотенциал;
		
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+1),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.КоличествоВОПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+2),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.ДатаВыставленияВОПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+3),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.КоличествоПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+4),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.ПоправочныйКоэффициентПлан,"ЧГ=0");
		ИмяОбластиПлан = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+(Смещение+5),"ЧГ=0");
		ОбластьПлан = ТабДок.Область(ИмяОбластиПлан);
		ОбластьПлан.Текст = Формат(Строка.КоличествоПланПоправочное,"ЧГ=0");
		
		
	КонецЕсли;
	
	Если Реквизит = "ПоправочныйКоэффициентПлан" тогда 
		
		Строка.КоличествоПланПоправочное = Строка.ПоправочныйКоэффициентПлан * Строка.КоличествоПлан;
		Смещение = 1;
		Если Найти(ИмяОбласти,":")>0 тогда
			ИмяОбласти = Лев(ИмяОбласти,Найти(ИмяОбласти,":")-1);	
		КонецЕсли;
		
		ИмяОбластиКоличество = Сред(ИмяОбласти,1,Найти(ИмяОбласти,"C")-1)+"C"+Формат(Число(Сред(ИмяОбласти,Найти(ИмяОбласти,"C")+1))+Смещение,"ЧГ=0");
		ОбластьКоличество = ТабДок.Область(ИмяОбластиКоличество);
		ОбластьКоличество.Текст = Формат(Строка.КоличествоПланПоправочное,"ЧГ=0");	
		
	КонецЕсли;
	
	
	
КонецПроцедуры



&НаКлиенте
Процедура ТабДокПриИзмененииСодержимогоОбласти(Элемент, Область)
	
	Если Найти(Область.Имя,":")>0 тогда
		МассивОбластей = СтрРазделить(Область.Имя,":",Ложь);		
		ПерваяЯчейка= СтрРазделить(Сред(МассивОбластей[0],2),"C",Ложь);
		ПоследняяЧейка= СтрРазделить(Сред(МассивОбластей[1],2),"C",Ложь);
		Для  НомерСтроки = Число(ПерваяЯчейка[0]) по Число(ПоследняяЧейка[0]) цикл
			Для  НомерКолонки = Число(ПерваяЯчейка[1]) по Число(ПоследняяЧейка[1]) цикл
				ОбластьТабДок = ТабДок.Область("R"+Формат(НомерСтроки,"ЧГ=0")+"C"+Формат(НомерКолонки,"ЧГ=0"));
				Если ЕстьВозможностьРедактировать(АдресДанныхРасшифровки,ПолучитьИДРасшифровки(ОбластьТабДок.Имя,АдресСохраненныхРасшифровокЯчеек)) тогда
					ТабДокПриИзмененииСодержимогоОбластиНаСервере(ОбластьТабДок.Текст,ПолучитьИДРасшифровки(ОбластьТабДок.Имя,АдресСохраненныхРасшифровокЯчеек),ОбластьТабДок.Имя);
				КонецЕсли;	
			КонецЦикла;
		КонецЦикла;
	Иначе	
		Если ЕстьВозможностьРедактировать(АдресДанныхРасшифровки,ПолучитьИДРасшифровки(Область.Имя,АдресСохраненныхРасшифровокЯчеек)) тогда
			ТабДокПриИзмененииСодержимогоОбластиНаСервере(Область.Текст,ПолучитьИДРасшифровки(Область.Имя,АдресСохраненныхРасшифровокЯчеек),Область.Имя);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ЕстьВозможностьРедактировать(АдресРасшифровки,ИДРасшифровки)
	
	Попытка
		ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресРасшифровки);
		ДанныеРасшифровкиОбласти = ДанныеРасшифровки.Элементы[ИДРасшифровки];
		ПоляРасшифровки = ДанныеРасшифровкиОбласти.ПолучитьПоля(); 
		КолВоПолей=0;
		Если ПоляРасшифровки.Найти("КоличествоПотенциал") <> Неопределено или
			ПоляРасшифровки.Найти("КоличествоПлан") <>Неопределено тогда
			ПолеР = ПоляРасшифровки.Найти("СредниеПродажи4_Расшифровка");
			Если ПолеР.Поле = "СредниеПродажи4_Расшифровка" и Не ЗначениеЗаполнено(ПолеР.Значение) тогда
				ПолеР = ПоляРасшифровки.Найти("КомплектПанелей");
				Если ПолеР.Значение.ВидВО = Перечисления.вогВидыОборудования.DIYПолка тогда
					Возврат Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Для каждого ПолеР из ПоляРасшифровки цикл
			Если ПолеР.Поле = "ВозможноРедактирование" тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		Возврат Ложь;	
	Исключение
		возврат Ложь;	
	КонецПопытки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОткрытьЗначение(АдресРасшифровки,ИДРасшифровки)
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресРасшифровки);
	Попытка
		ДанныеРасшифровкиОбласти = ДанныеРасшифровки.Элементы[ИДРасшифровки];
		ПоляРасшифровки = ДанныеРасшифровкиОбласти.ПолучитьПоля(); 
		КолВо=0;
		Значение = Неопределено;
		Для каждого ПолеР из ПоляРасшифровки цикл
			Если ТипЗнч(ПолеР.Значение) = Тип("СправочникСсылка.вогТорговыеТочки") тогда
				Значение = ПолеР.Значение;	
			КонецЕсли;
			КолВо=КолВо+1;	
		КонецЦикла;
		Если КолВо>1 тогда
			Значение = Неопределено;
		КонецЕслИ;
		Возврат Значение;	
	Исключение	
	КонецПопытки;
	Возврат Неопределено;
КонецФункции


&НаСервереБезКонтекста
Функция ЭтоПолеВводаКвартала(АдресРасшифровки,ИДРасшифровки)
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресРасшифровки);
	Попытка
		ДанныеРасшифровкиОбласти = ДанныеРасшифровки.Элементы[ИДРасшифровки];
		ПоляРасшифровки = ДанныеРасшифровкиОбласти.ПолучитьПоля(); 
		КолВоПолей=0;
		Для каждого ПолеР из ПоляРасшифровки цикл
			Если Найти(ПолеР.Поле,"Дата")>0 тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		Возврат Ложь;	
	Исключение
		возврат Ложь;	
	КонецПопытки;
	
КонецФункции


&НаКлиенте
Процедура ТабДокВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если ЕстьВозможностьРедактировать(АдресДанныхРасшифровки, ПолучитьИДРасшифровки(Область.Имя,АдресСохраненныхРасшифровокЯчеек)) тогда
		Если ЭтоПолеВводаКвартала(АдресДанныхРасшифровки,ПолучитьИДРасшифровки(Область.Имя,АдресСохраненныхРасшифровокЯчеек)) тогда
			СпЗ = Новый СписокЗначений;
			СпЗ.Добавить("1","4 кв "+Формат((ГодПланирования-1),"ЧГ=0"));
			СпЗ.Добавить("2","1 кв "+Формат(ГодПланирования,"ЧГ=0"));
			СпЗ.Добавить("3","2 кв "+Формат(ГодПланирования,"ЧГ=0"));
			СпЗ.Добавить("4","3 кв "+Формат(ГодПланирования,"ЧГ=0"));
			СпЗ.Добавить("5","4 кв "+Формат(ГодПланирования,"ЧГ=0"));
			Выбор = ВыбратьИзСписка(СпЗ);
			Область.Текст = Выбор;
		КонецЕсли;
	Иначе
		СтандартнаяОбработка = Ложь;
		Область.Защита = Истина;
		Значение = ОткрытьЗначение(АдресДанныхРасшифровки,ПолучитьИДРасшифровки(Область.Имя,АдресСохраненныхРасшифровокЯчеек));
		Если ЗначениеЗаполнено(Значение) и ТипЗнч(Значение) = Тип("СправочникСсылка.вогТорговыеТочки") тогда
			ОткрытьФорму("Справочник.вогТорговыеТочки.Форма.ФормаЭлемента",Новый Структура("Ключ",Значение));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Заголовок = "Планирование продаж (плитка) " + Формат(ГодПланирования,"ЧГ=0");
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеНаСервере()
	
	Автор = Пользователи.ТекущийПользователь();
	ДатаИзменения = ТекущаяДата();
	
	Для каждого Строка из Данные цикл
		Зпрс = Новый Запрос;
		Зпрс.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		             |	ДанныеПланированияПродаж.Автор КАК Автор,
		             |	ДанныеПланированияПродаж.ДатаИзменения КАК ДатаИзменения
		             |ИЗ
		             |	РегистрСведений.ДанныеПланированияПродаж КАК ДанныеПланированияПродаж
		             |ГДЕ
		             |	ДанныеПланированияПродаж.Направление = &Направление
		             |	И ДанныеПланированияПродаж.ТорговаяТочка = &ТорговаяТочка
		             |	И ДанныеПланированияПродаж.Бренд = &Бренд
		             |	И ДанныеПланированияПродаж.КомплектПанелей = &КомплектПанелей";
		Зпрс.УстановитьПараметр("Направление",Справочники.НаправленияДеятельности.Плитка);
		Зпрс.УстановитьПараметр("ТорговаяТочка",Строка.ТорговаяТочка);
		Зпрс.УстановитьПараметр("Бренд",Строка.Бренд);
		Зпрс.УстановитьПараметр("КомплектПанелей",Строка.КомплектПанелей);
		Выборка = Зпрс.Выполнить().Выбрать();
		Если Выборка.Следующий() тогда
			Если Строка.ДатаИзмененияВРегистре > Выборка.ДатаИзменения тогда
				Сообщить("Данные были изменены в базе другим пользователем");
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		МЗ = РегистрыСведений.ДанныеПланированияПродаж.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МЗ,Строка);
		МЗ.Автор = Автор;
		МЗ.ДатаИзменения = ДатаИзменения;
		МЗ.Направление = Справочники.НаправленияДеятельности.Плитка;
		МЗ.Записать();
		
		
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные(Команда)
	ЗаписатьДанныеНаСервере();
	ЗаполнитьТаблицуНаСервере();
	Заголовок = "Планирование продаж (плитка) "  + Формат(ГодПланирования,"ЧГ=0");
КонецПроцедуры

&НаКлиенте
Процедура ТабДокПриАктивизации(Элемент)
	
	Область = ТабДок.ТекущаяОбласть;
	Редактирование = Истина;
	Если Найти(Область.Имя,":")>0 тогда
		МассивОбластей = СтрРазделить(Область.Имя,":",Ложь);		
		ПерваяЯчейка= СтрРазделить(Сред(МассивОбластей[0],2),"C",Ложь);
		ПоследняяЧейка= СтрРазделить(Сред(МассивОбластей[1],2),"C",Ложь);
		Попытка
			Для  НомерСтроки = Число(ПерваяЯчейка[0]) по Число(ПоследняяЧейка[0]) цикл
				Для  НомерКолонки = Число(ПерваяЯчейка[1]) по Число(ПоследняяЧейка[1]) цикл
					ОбластьТабДок = ТабДок.Область("R"+Формат(НомерСтроки,"ЧГ=0")+"C"+Формат(НомерКолонки,"ЧГ=0"));
					Если НЕ ЕстьВозможностьРедактировать(АдресДанныхРасшифровки,ПолучитьИДРасшифровки(ОбластьТабДок.Имя,АдресСохраненныхРасшифровокЯчеек)) тогда
						Редактирование = Ложь;
						Прервать;	
					КонецЕсли;
					
				КонецЦикла;
				Если Редактирование = Ложь тогда Прервать; КонецЕсли;	
			КонецЦикла;
		Исключение
		КонецПопытки;
	Иначе	
		Если НЕ ЕстьВозможностьРедактировать(АдресДанныхРасшифровки,ПолучитьИДРасшифровки(Область.Имя,АдресСохраненныхРасшифровокЯчеек)) тогда
				Редактирование = Ложь;
		КонецЕсли;
	КонецЕсли;
	Элементы.ТабДок.Редактирование = Редактирование;
	
КонецПроцедуры
