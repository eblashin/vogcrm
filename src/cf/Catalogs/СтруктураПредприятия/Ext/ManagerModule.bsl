#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//+вог
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;			
//START Кайдашов 27/08/19 595	
	CRM_Офис = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Данные.Ссылка,"CRM_Офис",Истина);
	Если ЗначениеЗаполнено(CRM_Офис) Тогда
		ОфисПредставление = CRM_Офис; 
	Иначе
		ОфисПредставление = НСтр("ru = 'не указан'");
	КонецЕсли;
//END Кайдашов	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)", Данные.Наименование, ОфисПредставление);
	
КонецПроцедуры

#КонецОбласти
//-вог	
	
#Область ПрограммныйИнтерфейс
	
// Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов.
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значание:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОрганизацияПоПодразделению

Функция ПолучитьОрганизациюПоПодразделению(Подразделение) Экспорт
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Возврат ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	КонецЕсли;
	
	Если Подразделение.ОбособленноеПодразделение И ЗначениеЗаполнено(Подразделение.Организация) Тогда
		
		Возврат Подразделение.Организация;
		
	Иначе 
		
		Возврат ПолучитьОрганизациюПоПодразделению(Подразделение.Родитель);
		
	КонецЕсли;
	
		
КонецФункции

Функция ПолучитьОбособленноеПодразделение(Подразделение) Экспорт
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Возврат ПредопределенноеЗначение("Справочник.СтруктураПредприятия.ПустаяСсылка");
	КонецЕсли;
	
	Если Подразделение.ОбособленноеПодразделение И ЗначениеЗаполнено(Подразделение.Организация) Тогда
		
		Возврат Подразделение;
		
	Иначе 
		
		Возврат ПолучитьОбособленноеПодразделение(Подразделение.Родитель);
		
	КонецЕсли;
		
КонецФункции
	

#КонецОбласти

#КонецЕсли

