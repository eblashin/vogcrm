&НаКлиенте
Перем КэшированныеЗначения;// Используется механизмом обработки изменения реквизитов ТЧ.

#Область ОбработчикиСобытийФормы

&НаСервереБезКонтекста
// Функция возвращает значение реквизита, прочитанного из информационной базы по ссылке на объект.
// 
// Параметры:
//  СсылкаНаОбъект	- Ссылка на объект, - элемент справочника, документ, ...
//  ИмяРеквизита	- Строка, например, "Код".
// 
// Возвращаемое значение:
//  Произвольный    - зависит от типа значения прочитанного реквизита.
// 
Функция ПолучитьЗначениеРеквизита(СсылкаНаОбъект, ИмяРеквизита)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОбъект, ИмяРеквизита);
КонецФункции // ПолучитьЗначениеРеквизита()

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Характеристика);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Характеристика);
	// +CRM
	//СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	//ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);
	// -CRM
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураСтроки);
	// +CRM
	//ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	ХарактеристикиИспользуются = ПолучитьЗначениеРеквизита(Номенклатура, "ИспользоватьХарактеристики");
	// -CRM
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	Если Номенклатура.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru= 'Не указана номенклатура.'"),
		                                                  ,
		                                                  "Номенклатура");
		Возврат;
	КонецЕсли;
	
	Если ХарактеристикиИспользуются И Характеристика.Пустая() Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru= 'Не указана характеристика.'"),
		                                                  ,
		                                                  "Характеристика");
		Возврат;
	
	КонецЕсли;
	
	Закрыть(Новый Структура("Номенклатура, Характеристика", Номенклатура, Характеристика));

КонецПроцедуры

#КонецОбласти
