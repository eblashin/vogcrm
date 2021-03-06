
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ПолеКоллекция = новый ПолеКомпоновкиДанных("Коллекция");
	ПолеКоллекцияРасстановка= новый ПолеКомпоновкиДанных("КоллекцияРасстановка");
	ПолеХИТ = новый ПолеКомпоновкиДанных("Хит");
	ПолеНовинка = новый ПолеКомпоновкиДанных("НовинкаОтчет");
	ПолеНеликвид = новый ПолеКомпоновкиДанных("НеликвидОтчет");
	ПолеЗаказной = новый ПолеКомпоновкиДанных("ЗаказнойОтчет");
	// +++ VOG Кулаков П.Л. 15.03.2021 DEV-262
	ПолеНабор = Новый ПолеКомпоновкиДанных("НаборДляОтбора");
	// --- VOG Кулаков П.Л.
	
	// +++ VOG Кулаков П.Л. 08.06.2021 DEV-498
	ПолеПодразделение = Новый ПолеКомпоновкиДанных("ПодразделениеОтчёт");
	ПолеКомпания = Новый ПолеКомпоновкиДанных("Компания");
	// --- VOG Кулаков П.Л.
	
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторКлассификацияТТ",ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("b3d84c6b-7581-11ea-87ff-005056bc3fe8"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторСтатусТТ",ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("dcdbe20f-9a73-11e8-89fa-005056bc3fe8"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КатегорияA",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("ca87c1d0-75a5-11ea-87ff-005056bc3fe8"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КатегорияB",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("d35602c3-75a5-11ea-87ff-005056bc3fe8"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КатегорияC",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("d35602c5-75a5-11ea-87ff-005056bc3fe8"))); 
	// +++ VOG Кулаков П.Л. 27.04.2021 DEV-472
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КатегорияD",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("0929efff-490d-11eb-abef-005056bcd3e3"))); 
	// --- VOG Кулаков П.Л.
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КатегорияN",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("808e6fcd-160f-11eb-bf03-005056bcd3e3"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СтатусТТАКБ",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("f84779ae-9a73-11e8-89fa-005056bc3fe8"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СтатусТТНовая",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("047f780f-8b44-11e9-9b11-005056bcd3e3"))); 
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СтатусТТНАКБ",Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af2-9a74-11e8-89fa-005056bc3fe8"))); 
	ЭтоВариантПоТорговымТочкам = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЭтоВариантПоТорговымТочкам")).Значение;
	ФиксацияСверху = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ФиксацияСверху")).Значение;
	ФиксацияСлева = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ФиксацияСлева")).Значение;
	
	УстановленныеОтборы = Новый Структура("ОтборКоллекция,ОтборКоллекцияРасстановка,ОтборНабор,ОтборХит,ОтборНовинка,ОтборНеликвид,ОтборЗаказной,МассивТТ,МассивНоменклатур",Неопределено,Неопределено,Ложь,Неопределено,Неопределено,Неопределено,Неопределено,Неопределено,Неопределено);
	Если ЭтоВариантПоТорговымТочкам тогда
		Для каждого ЭлементОтбора из Настройки.Отбор.Элементы цикл
			// +++ VOG Кулаков П.Л. 10.03.2021 DEV-25
			Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			// --- VOG Кулаков П.Л.
			Если ЭлементОтбора.Использование тогда
				Если ЭлементОтбора.ЛевоеЗначение = ПолеКоллекция  тогда
					УстановленныеОтборы.ОтборКоллекция = ЭлементОтбора;	
				ИначеЕсли ЭлементОтбора.ЛевоеЗначение = ПолеХИТ тогда
					УстановленныеОтборы.ОтборХит = ЭлементОтбора;
				ИначеЕсли ЭлементОтбора.ЛевоеЗначение = ПолеКоллекцияРасстановка тогда
					УстановленныеОтборы.ОтборКоллекцияРасстановка = ЭлементОтбора;
				ИначеЕсли ЭлементОтбора.ЛевоеЗначение = ПолеНовинка  тогда 
					УстановленныеОтборы.ОтборНовинка = ЭлементОтбора;	
				ИначеЕсли ЭлементОтбора.ЛевоеЗначение = ПолеНеликвид тогда
					УстановленныеОтборы.ОтборНеликвид = ЭлементОтбора;	
				ИначеЕсли ЭлементОтбора.ЛевоеЗначение = ПолеНабор тогда
					УстановленныеОтборы.ОтборНабор = Истина;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	// +++ VOG Кулаков П.Л. 04.03.2021 CRM-25
	ОтборПоНабору = Неопределено;
	ОтборПоПодразделению = Неопределено;
	ОтборПоКомпании = Неопределено;
	Для каждого ЭлементОтбора из Настройки.Отбор.Элементы цикл
		Если ЭлементОтбора.ЛевоеЗначение = ПолеНабор тогда
			ОтборПоНабору = ЭлементОтбора;
		КонецЕсли;
		// +++ VOG Кулаков П.Л. 08.06.2021 DEV-498
		Если ЭлементОтбора.ЛевоеЗначение = ПолеПодразделение тогда
			ОтборПоПодразделению = ЭлементОтбора;
		КонецЕсли;
		Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпания Тогда
			ОтборПоКомпании = ЭлементОтбора;
		КонецЕсли;
		// --- VOG Кулаков П.Л.
	КонецЦикла;
	
	Если ОтборПоНабору <> Неопределено И ОтборПоНабору.Использование Тогда
		
		ОтборПоНабору.Использование = Ложь;
				
		ПараметрОтборПоНабору = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтборПоНабору"));
		ПараметрОтборПоНабору.Значение = Истина;
		ПараметрОтборПоНабору.Использование = Истина;
		
		СписокКоллекций = Новый СписокЗначений;
		
		Если ТипЗнч(ОтборПоНабору.ПравоеЗначение) = Тип("СправочникСсылка.вогНаборыКоллекций") Тогда
			МассивКоллекций = ОтборПоНабору.ПравоеЗначение.СоставНабора.ВыгрузитьКолонку("Коллекция");
			СписокКоллекций.ЗагрузитьЗначения(МассивКоллекций);
		ИначеЕсли ТипЗнч(ОтборПоНабору.ПравоеЗначение) = Тип("СписокЗначений") Тогда
			МассивКоллекций = Новый Массив;
			Для Каждого НаборКоллекции Из ОтборПоНабору.ПравоеЗначение Цикл
				МассивКоллекцийНабора = НаборКоллекции.Значение.СоставНабора.ВыгрузитьКолонку("Коллекция");
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивКоллекций,МассивКоллекцийНабора,Истина);
			КонецЦикла;
			СписокКоллекций.ЗагрузитьЗначения(МассивКоллекций);
		КонецЕсли;
		
		ПараметрСписокКоллекцийИзНабора = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СписокКоллекцийИзНабора"));
		ПараметрСписокКоллекцийИзНабора.Использование = Истина;
		ПараметрСписокКоллекцийИзНабора.Значение = СписокКоллекций;
		
	Иначе
		
		ПараметрОтборПоНабору = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтборПоНабору"));
		ПараметрОтборПоНабору.Значение = Ложь;
		ПараметрОтборПоНабору.Использование = Истина;
		
	КонецЕсли;
	// --- VOG Кулаков П.Л.
	
	// +++ VOG Кулаков П.Л. 08.06.2021 DEV-498
	Если ОтборПоПодразделению <> Неопределено И ОтборПоПодразделению.Использование Тогда
		ПараметрОтборПоПодразделению = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтборПоПодразделению"));
		ПараметрОтборПоПодразделению.Значение = Истина;
		ПараметрОтборПоПодразделению.Использование = Истина;
	Иначе
		ПараметрОтборПоПодразделению = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтборПоПодразделению"));
		ПараметрОтборПоПодразделению.Значение = Ложь;
		ПараметрОтборПоПодразделению.Использование = Истина;
	КонецЕсли;
	Если ОтборПоКомпании <> Неопределено И ОтборПоКомпании.Использование Тогда
		ПараметрОтборПоКомпании = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтборПоКомпании"));
		ПараметрОтборПоКомпании.Значение = Истина;
		ПараметрОтборПоКомпании.Использование = Истина;
	Иначе
		ПараметрОтборПоКомпании = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтборПоКомпании"));
		ПараметрОтборПоКомпании.Значение = Ложь;
		ПараметрОтборПоКомпании.Использование = Истина;
	КонецЕсли;
	// --- VOG Кулаков П.Л.
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	// Создание внешнего источника данных
	СтандартнаяОбработка = Ложь; // отключаем стандартный вывод отчета - будем выводить программно 
	
	Если УстановленныеОтборы.ОтборКоллекция<>Неопределено ИЛИ УстановленныеОтборы.ОтборКоллекцияРасстановка<>Неопределено ИЛИ УстановленныеОтборы.ОтборНабор или УстановленныеОтборы.ОтборХит<>Неопределено или 
		УстановленныеОтборы.ОтборНовинка<>Неопределено или УстановленныеОтборы.ОтборНеликвид<>Неопределено или 
		УстановленныеОтборы.ОтборЗаказной<>Неопределено тогда
		
		ГруппаНоменклатура = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ГруппаНоменклатура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ПолеГруппировки = ГруппаНоменклатура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Номенклатура");
		ПолеГруппировки.Использование = Истина;
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 
		СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
		ДокументРезультат.Очистить();
		
		ТЗ = Новый ТаблицаЗначений;
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(ТЗ);	
		ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		ТЗНом = ТЗ.Скопировать();
		ТЗНом.Свернуть("Номенклатура");
		ТЗ.Свернуть("ТорговаяТочка");
		МассивТТ = ТЗ.ВыгрузитьКолонку("ТорговаяТочка");
		МассивНоменклатур = ТЗНом.ВыгрузитьКолонку("Номенклатура");
		УстановленныеОтборы.МассивТТ = МассивТТ;
		УстановленныеОтборы.МассивНоменклатур = МассивНоменклатур;
		Попытка
			ПрименитьОтборПоПараметрам(Настройки.Структура[1],УстановленныеОтборы);
			Если УстановленныеОтборы.ОтборКоллекция<>Неопределено тогда
				УстановленныеОтборы.ОтборКоллекция.использование = Ложь;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборКоллекцияРасстановка<>Неопределено тогда
				УстановленныеОтборы.ОтборКоллекцияРасстановка.использование = Ложь;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборНабор тогда
				УстановленныеОтборы.ОтборНабор = Ложь;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборХит<>Неопределено тогда
				УстановленныеОтборы.ОтборХит.использование = Ложь;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборНовинка<>Неопределено тогда
				УстановленныеОтборы.ОтборНовинка.использование = Ложь;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборНеликвид<>Неопределено тогда
				УстановленныеОтборы.ОтборНеликвид.использование = Ложь;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборЗаказной<>Неопределено тогда
				УстановленныеОтборы.ОтборЗаказной.использование = Ложь;
			КонецЕсли;
			Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СписокТТДляРасчета",МассивТТ); 
			Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СписокНоменклатурыДляРасчета",МассивНоменклатур); 
			Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ИспользоватьСписокТТДляРасчета",Истина); 
		Исключение
		КонецПопытки;
		Настройки.Структура.Удалить(ГруппаНоменклатура);	
		
		// +++ VOG Кулаков П.Л. 16.03.2021
		ПараметрОтборПоНабору = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтборПоНабору"));
		ПараметрОтборПоНабору.Значение = Ложь;
		ПараметрОтборПоНабору.Использование = Истина;
		// --- VOG Кулаков П.Л.
		
	Иначе
		Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СписокТТДляРасчета",Новый Массив()); 
		Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ИспользоватьСписокТТДляРасчета",Ложь); 
	КонецЕсли;
	
	
	// Создание внешнего источника данных
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 
	// Инициализируем макет компоновки используя схему компоновки данных 
	// и созданные ранее настройки и данные расшифровки
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	//МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// Скомпонуем результат
	// +++ VOG Кулаков П.Л. 16.03.2021 DEV-
	ТЗ = Новый ТаблицаЗначений;
	// --- VOG Кулаков П.Л.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	ДокументРезультат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	//ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	//ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	Попытка
			Если УстановленныеОтборы.ОтборКоллекция<>Неопределено тогда
				УстановленныеОтборы.ОтборКоллекция.использование = Истина;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборХит<>Неопределено тогда
				УстановленныеОтборы.ОтборХит.использование = Истина;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборНовинка<>Неопределено тогда
				УстановленныеОтборы.ОтборНовинка.использование = Истина;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборНеликвид<>Неопределено тогда
				УстановленныеОтборы.ОтборНеликвид.использование = Истина;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборЗаказной<>Неопределено тогда
				УстановленныеОтборы.ОтборЗаказной.использование = Истина;
			КонецЕсли;
			Если УстановленныеОтборы.ОтборНабор<>Неопределено тогда
				УстановленныеОтборы.ОтборНабор = Истина;
			КонецЕсли;
	Исключение
	КонецПопытки;
	ДокументРезультат.ФиксацияСлева = ФиксацияСлева;
	ДокументРезультат.ФиксацияСверху = ФиксацияСверху;
	
	
	
КонецПроцедуры



Процедура ПрименитьОтборПоПараметрам(ЭлементСтруктуры,Отборы)
	
	Для каждого Элемент из ЭлементСтруктуры.Отбор.Элементы цикл
		
		Если Элемент.Представление = "ОтборСписокТТ" тогда
			Элемент.Использование = Истина;
			Элемент.ПравоеЗначение = Отборы.МассивТТ;
			Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		КонецЕсли;
		Если Элемент.Представление = "ОтборНеСписокТТ" тогда
			Элемент.Использование = Истина;
			Элемент.ПравоеЗначение = Отборы.МассивТТ;
			Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		КонецЕсли;
		
		Если Элемент.Представление = "ОтборНоменклатура" тогда
			Элемент.Использование = Истина;
			Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Элемент.ПравоеЗначение = Отборы.МассивНоменклатур;	
		КонецЕсли;
		
		//Если Элемент.Представление = "ОтборКоллекция" и Отборы.ОтборКоллекция<>Неопределено тогда
		//	Элемент.Использование = Отборы.ОтборКоллекция.Использование;
		//	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		//	Элемент.ПравоеЗначение = Отборы.ОтборКоллекция.Значение;	
		//КонецЕсли;
		//
		//Если Элемент.Представление = "ОтборХит" и Отборы.ОтборХит<>Неопределено тогда
		//	Элемент.Использование = Отборы.ОтборХит.Использование;
		//	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		//	Элемент.ПравоеЗначение = Отборы.ОтборХит.Значение;	
		//КонецЕсли;
		//
		//Если Элемент.Представление = "ОтборНовинка" и Отборы.ОтборНовинка<>Неопределено тогда
		//	Элемент.Использование = Отборы.ОтборНовинка.Использование;
		//	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		//	Элемент.ПравоеЗначение = Отборы.ОтборНовинка.Значение;	
		//КонецЕсли;
		//
		//Если Элемент.Представление = "ОтборНеликвид" и Отборы.ОтборНеликвид<>Неопределено тогда
		//	Элемент.Использование = Отборы.ОтборНеликвид.Использование;
		//	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		//	Элемент.ПравоеЗначение = Отборы.ОтборНеликвид.Значение;	
		//КонецЕсли;
		//Если Элемент.Представление = "ОтборЗаказной" и Отборы.ОтборЗаказной<>Неопределено тогда
		//	Элемент.Использование = Отборы.ОтборЗаказной.Использование;
		//	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		//	Элемент.ПравоеЗначение = Отборы.ОтборЗаказной.Значение;	
		//КонецЕсли;
		
	КонецЦикла;
	Для каждого Элемент из ЭлементСтруктуры.Структура цикл
		ПрименитьОтборПоПараметрам(Элемент,Отборы);
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыОбновления) Экспорт
    
	//ПутьКДаннымПоля = ПутьКДаннымЭлементаФормыЗначенияОтбора("КатегорияТТ");
	
    Для Каждого Элемент Из Форма.Элементы Цикл
		
		Если Элемент.Имя = "КомпоновщикНастроекПользовательскиеНастройки" Тогда
			Элемент.ОтображатьЗаголовок = Истина;
			Элемент.Поведение = ПоведениеОбычнойГруппы.Свертываемая;
			Элемент.ЗаголовокСвернутогоОтображения = "Показать настройки";
			Элемент.Заголовок = "Скрыть настройки";
		КонецЕсли;
		
        Если СтрНачинаетсяС(Элемент.Имя, "КомпоновщикНастроекПользовательскиеНастройкиЭлемент") 
            И ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда
            
            Если Элемент.Заголовок = "Категория ТТ" Тогда
                
                Массив = Новый Массив; 
				
				КлассификаторКатегорияТТ = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("b3d84c6b-7581-11ea-87ff-005056bc3fe8"));
                Массив.Добавить(Новый ПараметрВыбора("Отбор.Владелец",КлассификаторКатегорияТТ)); 
                ПараметрыВыбора = Новый ФиксированныйМассив(Массив);
                Элемент.ПараметрыВыбора = ПараметрыВыбора;
				КатегорияA = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("ca87c1d0-75a5-11ea-87ff-005056bc3fe8")); 
				КатегорияB = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("d35602c3-75a5-11ea-87ff-005056bc3fe8")); 
				КатегорияC = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("d35602c5-75a5-11ea-87ff-005056bc3fe8")); 
				КатегорияN = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("808e6fcd-160f-11eb-bf03-005056bcd3e3")); 
				
                Элемент.СписокВыбора.Очистить();
				Элемент.СписокВыбора.Добавить(КатегорияA);
				Элемент.СписокВыбора.Добавить(КатегорияB);
				Элемент.СписокВыбора.Добавить(КатегорияC);
				Элемент.СписокВыбора.Добавить(КатегорияN);
				Элемент.КнопкаОчистки = Ложь;	
			КонецЕсли;
            
        КонецЕсли;
        
    КонецЦикла;
    
КонецПроцедуры


Функция ПутьКДаннымЭлементаФормыЗначенияОтбора(ИмяПоляКомпоновкиДанных)
    
    ПолеКомпоновкиДанных = Новый ПолеКомпоновкиДанных(ИмяПоляКомпоновкиДанных);
    
    Для Каждого Элемент Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
        Если Элемент.ЛевоеЗначение = ПолеКомпоновкиДанных Тогда
            ИдентификаторПользовательскойНастройки = Элемент.ИдентификаторПользовательскойНастройки;
            Прервать;
        КонецЕсли;
    КонецЦикла;
    
    Если ИдентификаторПользовательскойНастройки = Неопределено Тогда
        возврат Неопределено;
    КонецЕсли;
    
    ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
    Для Индекс = 0 По ПользовательскиеНастройки.Количество()-1 Цикл
        Если ПользовательскиеНастройки[Индекс].ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
            возврат "Отчет.КомпоновщикНастроек.ПользовательскиеНастройки["+Формат(Индекс, "ЧДЦ=0; ЧГ=")+"].Значение";
        КонецЕсли;
    КонецЦикла;
    
    возврат Неопределено;
    
КонецФункции

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
    
    Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек = Истина;
    
КонецПроцедуры
