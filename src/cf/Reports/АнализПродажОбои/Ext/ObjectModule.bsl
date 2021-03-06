
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	КлассификаторКоличествоСтендов = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("1714096b-b20e-11e9-9b11-005056bcd3e3"));
	КлассификаторФорматТРТ = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("47b0ee76-ada2-11e7-80ce-08606e7382bc"));
	КлассификаторСтатусТРТ = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("dcdbe20f-9a73-11e8-89fa-005056bc3fe8"));
	КлассифкаторКоличествоSKU = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("5af63fbb-d6c6-11e8-a684-005056bc3fe8"));	
	КлассифкаторКоличествоSKUВОГ = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("db18bcf8-c743-11ea-8f2a-005056bcd3e3"));	
	Значение053 = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("227ad8da-c744-11ea-8f2a-005056bcd3e3"));
	Значение106 = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("1346f0b9-c744-11ea-8f2a-005056bcd3e3"));
	Размер_106 = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("768685fc-d6c6-11e8-a684-005056bc3fe8"));
	Размер_053 = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("bfec323c-d6c6-11e8-a684-005056bc3fe8"));
	СтатусТТЗакрыта = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af3-9a74-11e8-89fa-005056bc3fe8"));
	КатегорияТТКлассификатор = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("ca87c1d0-75a5-11ea-87ff-005056bc3fe8")).Владелец;
	
	ПараметрМест = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолучитьСсылку(Новый УникальныйИдентификатор("4767d0c1-b28c-11e9-9b11-005056bcd3e3"));
	ПараметрРазмер = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолучитьСсылку(Новый УникальныйИдентификатор("2e0ee1db-b28c-11e9-9b11-005056bcd3e3"));
	ПараметрРоссия = Справочники.вогНаселенныеПункты.ПолучитьСсылку(Новый УникальныйИдентификатор("9f590895-f596-11e9-8661-005056bcd3e3"));
	
	// +++ VOG Кулаков П.Л. 30.10.2020
	DIY = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("4fc40649-ada2-11e7-80ce-08606e7382bc"));
	FDIY = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("64a60c68-06d3-11eb-8f2a-005056bcd3e3"));
	RDIY = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("6cac4f07-06d3-11eb-8f2a-005056bcd3e3"));
	// --- VOG Кулаков П.Л.
	
	ПараметрСпец = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("5d36cbb9-ada2-11e7-80ce-08606e7382bc"));
	ПараметрУнив = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("125c5f18-d29b-11e8-a684-005056bc3fe8"));
	
	
	СтатусАКБ = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("f84779ae-9a73-11e8-89fa-005056bc3fe8")); 
	СтатусНАКБ = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af2-9a74-11e8-89fa-005056bc3fe8")); 
	СтатусНовая = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("047f780f-8b44-11e9-9b11-005056bcd3e3")); 
	СтатусЗакрыт = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af3-9a74-11e8-89fa-005056bc3fe8")); 
	
	ВариантыОпросов = Новый Массив;
	ВариантыОпросов.Добавить(ПланыВидовХарактеристик.вогВариантыОпросов.ПолучитьСсылку(Новый УникальныйИдентификатор("e6f9dcee-5153-11ea-87ff-005056bc3fe8")));
	ВариантыОпросов.Добавить(ПланыВидовХарактеристик.вогВариантыОпросов.ПолучитьСсылку(Новый УникальныйИдентификатор("00a82227-cd9b-11ea-8f2a-005056bcd3e3")));
	ВариантыОпросов.Добавить(ПланыВидовХарактеристик.вогВариантыОпросов.ПолучитьСсылку(Новый УникальныйИдентификатор("a060ef76-b28b-11e9-9b11-005056bcd3e3")));
	ВариантыОпросов.Добавить(ПланыВидовХарактеристик.вогВариантыОпросов.ПолучитьСсылку(Новый УникальныйИдентификатор("f5022f7e-b81e-11e8-a684-005056bc3fe8")));
	
	ВариантОпросаСписокSKU = ПланыВидовХарактеристик.вогВариантыОпросов.ПолучитьСсылку(Новый УникальныйИдентификатор("4305c4d7-c743-11ea-8f2a-005056bcd3e3"));
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторКоличествоСтендов", КлассификаторКоличествоСтендов);
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КолвоМест", ПараметрМест);
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Размер", ПараметрРазмер);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Россия", ПараметрРоссия);
	// +++ VOG Кулаков П.Л. 30.10.2020
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("DIY", DIY);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("FDIY", FDIY);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("RDIY", RDIY);
	// --- VOG Кулаков П.Л.
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Спец", ПараметрСпец);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Унив", ПараметрУнив);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторФорматТРТ", КлассификаторФорматТРТ);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассификаторСтатусТТ", КлассификаторСтатусТРТ);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассифкаторКоличествоSKU", КлассифкаторКоличествоSKU);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КлассифкаторКоличествоSKU_ВОГ", КлассифкаторКоличествоSKUВОГ);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Значение053", Значение053);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Значение106", Значение106);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Размер_053", Размер_053);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Размер_106", Размер_106);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СтатусТТЗакрыта",СтатусТТЗакрыта );
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВариантОпросаSKUСписком", ВариантОпросаСписокSKU);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВариантыОпросаSKU", ВариантыОпросов);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КатегорияТТКлассификатор", КатегорияТТКлассификатор);
	
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	
	// Создание внешнего источника данных
	ПараметрФиксацияСлева = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ФиксацияСлева");
	СтандартнаяОбработка = Ложь; // отключаем стандартный вывод отчета - будем выводить программно 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 
	// Инициализируем макет компоновки используя схему компоновки данных 
	// и созданные ранее настройки и данные расшифровки
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
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
	
	
	
	
	
КонецПроцедуры

Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыОбновления) Экспорт
    
    ПутьКДаннымПоля = ПутьКДаннымЭлементаФормыЗначенияОтбора("СтатусТТ");
    
    Для Каждого Элемент Из Форма.Элементы Цикл
        
        Если СтрНачинаетсяС(Элемент.Имя, "КомпоновщикНастроекПользовательскиеНастройкиЭлемент") 
            И ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда
            
            Если Элемент.ПутьКДанным = ПутьКДаннымПоля Тогда
                
                Массив = Новый Массив;
				КлассификаторСтатусТРТ = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("dcdbe20f-9a73-11e8-89fa-005056bc3fe8"));
                Массив.Добавить(Новый ПараметрВыбора("Отбор.Владелец",КлассификаторСтатусТРТ)); 
                ПараметрыВыбора = Новый ФиксированныйМассив(Массив);
                Элемент.ПараметрыВыбора = ПараметрыВыбора;
				СтатусАКБ = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("f84779ae-9a73-11e8-89fa-005056bc3fe8")); 
				СтатусНАКБ = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af2-9a74-11e8-89fa-005056bc3fe8")); 
				СтатусНовая = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("047f780f-8b44-11e9-9b11-005056bcd3e3")); 
				СтатусЗакрыт = Справочники.CRM_ЗначенияКлассификаторов.ПолучитьСсылку(Новый УникальныйИдентификатор("005e9af3-9a74-11e8-89fa-005056bc3fe8")); 
				
                Элемент.СписокВыбора.Очистить();
				Элемент.СписокВыбора.Добавить(СтатусАКБ);
				Элемент.СписокВыбора.Добавить(СтатусНАКБ);
				Элемент.СписокВыбора.Добавить(СтатусНовая);
				Элемент.СписокВыбора.Добавить(СтатусЗакрыт);
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