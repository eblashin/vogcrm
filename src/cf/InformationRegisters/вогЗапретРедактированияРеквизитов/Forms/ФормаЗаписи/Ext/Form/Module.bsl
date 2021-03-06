
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокОбъектовНаСервере();
	Элементы.Реквизит.СписокВыбора.Добавить(Запись.Реквизит);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИмяОбъекта 	= СписокОбъектов.НайтиПоЗначению(Запись.Объект);
	
	Если ИмяОбъекта <> Неопределено
		И ЗначениеЗаполнено(ИмяОбъекта.Представление) Тогда
		ТекущийОбъект.ИмяОбъекта = ИмяОбъекта.Представление;
	КонецЕсли;
	
	ИмяРеквизита = СписокРеквизитов.НайтиПоЗначению(Запись.Реквизит);
	
	Если ИмяРеквизита <> Неопределено
		И ЗначениеЗаполнено(ИмяРеквизита.Представление) Тогда
		ТекущийОбъект.ИмяРеквизита = ИмяРеквизита.Представление;
	Иначе
		ТекущийОбъект.ИмяРеквизита = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбъектПриИзменении(Элемент)
	
	Элементы.Реквизит.СписокВыбора.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.Объект) Тогда
		
		Элементы.Реквизит.СписокВыбора.Очистить();
		ЗаполнитьСписокРеквизитовНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокОбъектовНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИдентификаторыОбъектовМетаданных.Имя КАК Имя,
		|	ИдентификаторыОбъектовМетаданных.Синоним КАК Синоним
		|ИЗ
		|	Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
		|ГДЕ
		|	ИдентификаторыОбъектовМетаданных.Родитель.Имя = ""Справочники""
		|	И ИдентификаторыОбъектовМетаданных.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Синоним";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СписокОбъектов.Добавить(ВыборкаДетальныеЗаписи.Синоним, ВыборкаДетальныеЗаписи.Имя);
		Элементы.Объект.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Синоним);
				
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитовНаСервере()
	
	ИмяОбъекта = СписокОбъектов.НайтиПоЗначению(Запись.Объект);
	
	Если ИмяОбъекта <> Неопределено Тогда
		
		Для Каждого СтрокаРеквизит Из Метаданные.Справочники[ИмяОбъекта.Представление].Реквизиты Цикл
			
			СписокРеквизитов.Добавить(СтрокаРеквизит.Синоним, СтрокаРеквизит.Имя);
			Элементы.Реквизит.СписокВыбора.Добавить(СтрокаРеквизит.Синоним);
			
		КонецЦикла;
		
		ЗаполнитьСписокРеквизитовКИНаСервере(ИмяОбъекта);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитовКИНаСервере(ИмяОбъекта)
	
	ИмяПредопределенныхДанных = "Справочник" + ИмяОбъекта;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Родитель.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных
		|	И ВидыКонтактнойИнформации.ЭтоГруппа = ЛОЖЬ
		|	И ВидыКонтактнойИнформации.ПометкаУдаления = ЛОЖЬ
		|	И ВидыКонтактнойИнформации.CRM_Основной = ИСТИНА";
	
	Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", ИмяПредопределенныхДанных);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокРеквизитов.Добавить(ВыборкаДетальныеЗаписи.Наименование);
		Элементы.Реквизит.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Наименование);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
