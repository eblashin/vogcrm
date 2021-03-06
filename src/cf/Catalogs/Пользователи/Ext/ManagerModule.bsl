#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Служебный");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяСервиса");
	НеРедактируемыеРеквизиты.Добавить("СвойстваПользователяИБ");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
//START Кайдашов 27/08/19 595	
	Если НЕ Параметры.Отбор.Свойство("ПометкаУдаления") Тогда
		Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	КонецЕсли;
//END Кайдашов
	Если НЕ Параметры.Отбор.Свойство("Служебный") Тогда
		Параметры.Отбор.Вставить("Служебный", Ложь);
	КонецЕсли;
	
	// ++ VOG Солодов В.В. 16.11.2020 CRM-992
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
	Если Параметры.Свойство("ПодразделенияФилиала")
		И Параметры.ПодразделенияФилиала = Истина Тогда
		
		МассивПодразделений = Новый Массив;
		
		ТекущийПользователь 		= Пользователи.ТекущийПользователь();
		ПодразделениеПользователя 	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийПользователь, "Подразделение");
		ОбособленноеПодразделение
			= Справочники.СтруктураПредприятия.ПолучитьОбособленноеПодразделение(ПодразделениеПользователя);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СтруктураПредприятия.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.ПометкаУдаления = ЛОЖЬ
		|	И СтруктураПредприятия.Ссылка В ИЕРАРХИИ(&ОбособленноеПодразделение)";
		
		Запрос.УстановитьПараметр("ОбособленноеПодразделение", ОбособленноеПодразделение);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			МассивПодразделений.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		
		Параметры.Отбор.Вставить("Подразделение", МассивПодразделений);
		
	КонецЕсли;
	
	#КонецЕсли
	// -- VOG Солодов В.В. 16.11.2020 CRM-992
	
КонецПроцедуры

#КонецОбласти
