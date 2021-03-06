
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
		
	// Заполнение списка схем компоновки данных
	ПризнакПредопределенногоМакета = Врег("Предопределенный");
	ДлинаПризнакаПредопределенногоМакета = СтрДлина(ПризнакПредопределенногоМакета);
	Для каждого Макет из Метаданные.НайтиПоТипу(ТипЗнч(Объект.Ссылка)).Макеты Цикл
		Если Макет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			Если ВРег(Прав(Макет.Имя, ДлинаПризнакаПредопределенногоМакета)) = ПризнакПредопределенногоМакета Тогда
				Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольная'"));
	
	Если Параметры.ЗначениеКопирования.Пустая() Тогда
		СхемаИНастройки = Справочники.вогНастройкиЗанятости.ОписаниеИСхемаКомпоновкиДанныхНастройкиПоИмениМакета(Объект.Ссылка, Объект.СхемаКомпоновкиДанных);
	Иначе
		СхемаИНастройки = Справочники.вогНастройкиЗанятости.ОписаниеИСхемаКомпоновкиДанныхНастройкиПоИмениМакета(Параметры.ЗначениеКопирования, Параметры.ЗначениеКопирования.СхемаКомпоновкиДанных);
	КонецЕсли;
	
	Если ПустаяСтрока(СхемаИНастройки.Описание) Тогда
		Объект.СхемаКомпоновкиДанных = "";
	КонецЕсли;
	
	Адреса = АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище();
	
	АдресСхемыКомпоновкиДанных = Адреса.СхемаКомпоновкиДанных;
	АдресНастроекКомпоновкиДанных = Адреса.НастройкиКомпоновкиДанных;	
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если Не ЗначениеЗаполнено(Объект.СхемаКомпоновкиДанных) Тогда
		Если НЕ ПустаяСтрока(АдресСхемыКомпоновкиДанных) Тогда
			ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных));
		Иначе
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо настроить схему компоновки данных.'"), Объект.Ссылка, "Объект.СхемаКомпоновкиДанных",,Отказ);
		КонецЕсли;
		
	Иначе
		ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(АдресНастроекКомпоновкиДанных) Тогда
		ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных));
	Иначе
		ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПараметрыВПределахДняПриИзменении(Элемент)
	СформироватьНаименованияГраниц();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВПределахДняПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
		СформироватьНаименованияГраниц();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанных(Команда)
	
	// Открыть редактор настроек схемы компоновки данных
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройка схемы компоновки данных ""%1""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%1", Объект.Наименование);
	
	АдресаНастроек = Неопределено;

	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		Новый Структура(
						"НеПомещатьНастройкиВСхемуКомпоновкиДанных,
						|НеРедактироватьСхемуКомпоновкиДанных,
						|НеНастраиватьУсловноеОформление,
						|НеНастраиватьВыбор,
						|НеНастраиватьПорядок,
						|УникальныйИдентификатор,
						|АдресСхемыКомпоновкиДанных,
						|АдресНастроекКомпоновкиДанных,
						|Заголовок,
						|ИсточникШаблонов,
						|ИмяШаблонаСКД,
						|ВозвращатьИмяТекущегоШаблонаСКД",
						Истина,
						Ложь,
						Истина,
						Истина,
						Ложь,
						УникальныйИдентификатор,
						АдресСхемыКомпоновкиДанных,
						АдресНастроекКомпоновкиДанных,
						ЗаголовокФормыНастройкиСхемыКомпоновкиДанных,
						Объект.Ссылка,
						Объект.СхемаКомпоновкиДанных,
						Истина),,,,, Новый ОписаниеОповещения("РедактироватьСхемуКомпоновкиДанныхЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    АдресаНастроек = Результат;
    
    Если ЗначениеЗаполнено(АдресаНастроек) Тогда
        Если ПустаяСтрока(АдресаНастроек.ИмяТекущегоШаблонаСКД) 
            И Элементы.СхемаКомпоновкиДанных.СписокВыбора.НайтиПоЗначению("") = Неопределено Тогда
            Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольный'"));
            
        КонецЕсли;
        
        Объект.СхемаКомпоновкиДанных = АдресаНастроек.ИмяТекущегоШаблонаСКД;
        
        Если АдресаНастроек.Свойство("АдресХранилищаНастройкиКомпоновщика") Тогда
            АдресНастроекКомпоновкиДанных = АдресаНастроек.АдресХранилищаНастройкиКомпоновщика;
        КонецЕсли;
        
    КонецЕсли;
    
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура СформироватьНаименованияГраниц()
	
	Интервалы = Объект.ПараметрыВПределахДня;
	КоличествоИнтервалов = Интервалы.Количество();
	НаименованиеИнтервалаСвыше = НСтр("ru='Свыше %НижняяГраницаИнтервала% %'");
	НаименованиеИнтервалаОтДо  = НСтр("ru='От %НижняяГраницаИнтервала% до %ВерхняяГраницаИнтервала% %'");
	ВерхняяГраницаИнтервала    = 100;
	
	Для ТекИндекс = 1 По КоличествоИнтервалов-1 Цикл
		ПредыдущийЭтап = Интервалы[ТекИндекс-1];
		ЭтотЭтап = Интервалы[ТекИндекс];
		Если ЭтотЭтап.НижняяГраницаИнтервала = 0 Тогда
			ЭтотЭтап.НижняяГраницаИнтервала = ПредыдущийЭтап.НижняяГраницаИнтервала + 1;
		КонецЕсли;
		Пока (ТекИндекс - 1 >= 0) И ЭтотЭтап.НижняяГраницаИнтервала < Интервалы[ТекИндекс-1].НижняяГраницаИнтервала Цикл
			Интервалы.Сдвинуть(ТекИндекс,-1);
			ТекИндекс = ТекИндекс - 1;
		КонецЦикла;
	КонецЦикла;

	Если КоличествоИнтервалов = 1 Тогда
		
		Интервалы[0].НижняяГраницаИнтервала = 0;
		Интервалы[0].ВерхняяГраницаИнтервала = ВерхняяГраницаИнтервала;
		Интервалы[0].НаименованиеИнтервала = СтрЗаменить(НаименованиеИнтервалаСвыше, "%НижняяГраницаИнтервала%", Интервалы[0].НижняяГраницаИнтервала);
		
	ИначеЕсли КоличествоИнтервалов > 1 Тогда
		
		Интервалы[0].НижняяГраницаИнтервала = 0;
		
		Для ТекИндекс = 1 По КоличествоИнтервалов-1 Цикл
			
			ПредыдущийЭтап = Интервалы[ТекИндекс-1];
			
			ЭтотЭтап = Интервалы[ТекИндекс];
			
			Если ЭтотЭтап.НижняяГраницаИнтервала = ПредыдущийЭтап.НижняяГраницаИнтервала Тогда
				ЭтотЭтап.НижняяГраницаИнтервала = ПредыдущийЭтап.НижняяГраницаИнтервала + 1;
			КонецЕсли;
			
			Если ТекИндекс < КоличествоИнтервалов Тогда
				
				ПредыдущийЭтап.ВерхняяГраницаИнтервала = Интервалы[ТекИндекс].НижняяГраницаИнтервала-1;
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДо, "%НижняяГраницаИнтервала%", ПредыдущийЭтап.НижняяГраницаИнтервала);
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДоПредставление, "%ВерхняяГраницаИнтервала%", ПредыдущийЭтап.ВерхняяГраницаИнтервала);
				ПредыдущийЭтап.НаименованиеИнтервала = НаименованиеИнтервалаОтДоПредставление;
				
			КонецЕсли;
			
			Интервалы[КоличествоИнтервалов-1].ВерхняяГраницаИнтервала = ВерхняяГраницаИнтервала;
			Интервалы[КоличествоИнтервалов-1].НаименованиеИнтервала = СтрЗаменить(НаименованиеИнтервалаСвыше, "%НижняяГраницаИнтервала%", Интервалы[КоличествоИнтервалов-1].НижняяГраницаИнтервала);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Функция АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище()
	
	Возврат Справочники.вогНастройкиЗанятости.АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(Объект);
	
КонецФункции

#КонецОбласти

#КонецОбласти
