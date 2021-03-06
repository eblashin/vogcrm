// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.

// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.

#Область РегистрСведений_ПользовательскиеМакетыПечати_МакетыПечатныхФорм

// Процедура добавляет записи в регистр сведений "НазначениеДополнительныхОбработок".
//
// Параметры:
//	ВладелецМакета	- Строка	- Владелец макета.
//
Процедура ДобавитьЗаписьНазначениеДополнительныхОбработок(ВладелецМакета) Экспорт
	ОбъектНазначения = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя", ВладелецМакета);
	
	МенеджерЗаписи = РегистрыСведений.НазначениеДополнительныхОбработок.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОбъектНазначения				= ОбъектНазначения;
	МенеджерЗаписи.ТипФормы						= "ФормаОбъекта";
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.ОбъектНазначения				= ОбъектНазначения;
	МенеджерЗаписи.ТипФормы						= "ФормаОбъекта";
	МенеджерЗаписи.УдалитьТипОбъекта			= "";
	МенеджерЗаписи.Записать(Истина);
	
	МенеджерЗаписи = РегистрыСведений.НазначениеДополнительныхОбработок.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОбъектНазначения				= ОбъектНазначения;
	МенеджерЗаписи.ТипФормы						= "ФормаСписка";
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.ОбъектНазначения				= ОбъектНазначения;
	МенеджерЗаписи.ТипФормы						= "ФормаСписка";
	МенеджерЗаписи.УдалитьТипОбъекта			= "";
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры // ДобавитьЗаписьНазначениеДополнительныхОбработок()

// Процедура сохраняет пользовательский макет печати в информационной базе.
//
// Параметры:
//	ИмяОбъектаМетаданныхМакета		- Строка	- Имя владельца макета.
//	АдресМакетаВоВременномХранилище	- Строка	- Адрес макета во временном хранилище.
//	ПредставлениеМакета				- Строка	- Представление макета.
//
Процедура ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище, ПредставлениеМакета) Экспорт
	
	Макет = ПолучитьИзВременногоХранилища(АдресМакетаВоВременномХранилище);
	
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяОбъектаМетаданныхМакета, ".");
	ИмяМакета = ЧастиИмени[ЧастиИмени.ВГраница()];
	ИмяВладельца = "";
	
	Для НомерЧасти = 0 По ЧастиИмени.ВГраница()-1 Цикл
		Если НЕ ПустаяСтрока(ИмяВладельца) Тогда
			ИмяВладельца = ИмяВладельца + ".";
		КонецЕсли;
		ИмяВладельца = ИмяВладельца + ЧастиИмени[НомерЧасти];
	КонецЦикла;
	
	Запись = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
	Запись.Объект				= ИмяВладельца;
	Запись.ИмяМакета			= ИмяМакета;
	Запись.Использование		= Истина;
	Запись.CRM_ВнешнийМакет		= Истина;	
	Запись.CRM_Представление	= ПредставлениеМакета;	
	Запись.Макет				= Новый ХранилищеЗначения(Макет, Новый СжатиеДанных(9));
	Запись.Записать();
	
КонецПроцедуры // ЗаписатьМакет()

#КонецОбласти